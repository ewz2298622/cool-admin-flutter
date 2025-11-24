import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../db/entity/SearchHistoryEntity.dart';
import '../../db/manager/SearchHistoryDatabaseHelper.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/hot_keyWord_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../entity/video_rank_entity.dart';
import '../../style/layout.dart';
import '../../utils/color.dart';
import '../../utils/video.dart';

/// 渐变标签指示器
class GradientTabIndicator extends Decoration {
  final Gradient gradient;
  final double height;
  final double radius;

  const GradientTabIndicator({
    required this.gradient,
    this.height = 2.0,
    this.radius = 2.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientPainter(this, onChanged);
  }
}

class _GradientPainter extends BoxPainter {
  final GradientTabIndicator decoration;

  _GradientPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = Offset(offset.dx, configuration.size!.height - decoration.height) &
        Size(configuration.size!.width, decoration.height);

    final paint = Paint()
      ..shader = decoration.gradient.createShader(rect)
      ..isAntiAlias = true;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(decoration.radius)),
      paint,
    );
  }
}

/// 视频搜索页面
class VideoSearch extends StatefulWidget {
  const VideoSearch({super.key});

  @override
  VideoSearchState createState() => VideoSearchState();
}

class VideoSearchState extends State<VideoSearch>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String inputText = '';
  final searchHistory = SearchHistoryDatabaseHelper();
  Iterable<SearchHistoryEntity> searchHistoryList = [];
  List<DictDataDataVideoCategory> category = [];
  List<VideoRankDataList> searchType = [];
  List<List<VideoRankDataListList>> searchTypeVideoPageDataList = [];
  List<List<HotKeyWordDataList>> hotKeyWordList = [];
  List<TDTab> tabs = [];
  late TabController _tabController;
  late Future<String> _futureBuilderFuture;

  // 常量定义
  static const double _tabBarHeight = 35.0;
  static const double _tabBarViewHeight = 130.0;
  static const double _pageViewWidthRatio = 0.75;
  static const double _itemExtent = 84.0;
  static const double _rankIconSize = 20.0;
  static const double _imageWidth = 120.0;
  static const double _imageHeight = 75.0;
  static const int _searchHistoryPageSize = 4;
  static const int _hotKeyWordPageSize = 8;
  static const int _searchTypeVideoPageSize = 7;

  // 颜色常量
  static const Color _selectedTabColor = Color.fromRGBO(252, 119, 66, 1);
  static const Color _indicatorStartColor = Color.fromRGBO(9, 128, 253, 1);
  static const Color _indicatorEndColor = Color.fromRGBO(9, 128, 253, 0);
  static const Color _rankColor1 = Color.fromRGBO(255, 62, 63, 1);
  static const Color _rankColor2 = Color.fromRGBO(254, 151, 58, 1);
  static const Color _rankColor3 = Color.fromRGBO(254, 209, 53, 1);
  static const Color _rankColorDefault = Color.fromRGBO(178, 188, 198, 1);
  static const Color _textGreyColor = Color.fromRGBO(153, 153, 153, 1);
  static const Color _borderColor = Color.fromRGBO(243, 241, 240, 1);
  static const Color _darkBackgroundColor = Color.fromRGBO(51, 51, 51, 1);
  static const Color _lightBackgroundColor = Color.fromRGBO(239, 239, 239, 1);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 初始化数据
  Future<String> init() async {
    try {
      // 并发执行所有初始化任务
      await Future.wait([
        getDictCategoryInfoPages(),
        getSearchHistoryEntity(),
        getDictSearchTypeInfoPages(),
      ]);

      // 容错处理：确保 tabs 不为空
      final tabLength = tabs.isEmpty ? 1 : tabs.length;
      _tabController = TabController(length: tabLength, vsync: this);
      return "init success";
    } catch (e) {
      debugPrint('Initialization failed: $e');
      // 即使失败也创建 TabController，避免崩溃
      if (tabs.isEmpty) {
        tabs = [const TDTab(text: '默认')];
      }
      _tabController = TabController(length: tabs.length, vsync: this);
      return "init success";
    }
  }

  /// 获取分类信息并加载热门关键词（并发执行）
  Future<void> getDictCategoryInfoPages() async {
    try {
      category = ((await Api.getDictData({
                "types": ["video_category"],
              })).data as DictDataData)
          .videoCategory ?? [];
      category = category.where((element) => element.parentId == null).toList();

      tabs.clear();
      hotKeyWordList.clear();

      // 并发加载所有分类的热门关键词
      if (category.isNotEmpty) {
        final futures = category.map((element) async {
          tabs.add(TDTab(text: element.name ?? '分类'));
          return videoHotKeyWord(element.id ?? 0);
        }).toList();

        await Future.wait(futures);
      }
    } catch (e) {
      debugPrint('getDictCategoryInfoPages failed: $e');
    }
  }

  /// 获取搜索类型信息并加载视频数据（使用排名数据）
  Future<void> getDictSearchTypeInfoPages() async {
    try {
      final rankEntity = await Api.getSearchVideoRank({});
      searchType = rankEntity.data?.list ?? [];
      searchTypeVideoPageDataList.clear();

      // 加载所有搜索类型的视频数据
      if (searchType.isNotEmpty) {
        for (var element in searchType) {
          final list = element.list ?? <VideoRankDataListList>[];
          // 限制数量为 _searchTypeVideoPageSize
          final limitedList = list.length > _searchTypeVideoPageSize
              ? list.sublist(0, _searchTypeVideoPageSize)
              : list;
          searchTypeVideoPageDataList.add(limitedList);
        }
      }
    } catch (e) {
      debugPrint('getDictSearchTypeInfoPages failed: $e');
      // 添加空列表，保持索引一致性
      if (searchType.isNotEmpty) {
        for (var i = 0; i < searchType.length; i++) {
          if (i >= searchTypeVideoPageDataList.length) {
            searchTypeVideoPageDataList.add(<VideoRankDataListList>[]);
          }
        }
      }
    }
  }

  /// 获取热门关键词
  Future<void> videoHotKeyWord(int categoryId) async {
    try {
      final list = (await Api.getHostKeyWord({
            "page": 1,
            "size": _hotKeyWordPageSize,
            "category_id": categoryId,
          })).data?.list ??
          <HotKeyWordDataList>[];
      hotKeyWordList.add(list);
    } catch (e) {
      debugPrint('videoHotKeyWord failed: $e');
      // 添加空列表，保持索引一致性
      hotKeyWordList.add(<HotKeyWordDataList>[]);
    }
  }

  /// 获取搜索历史
  Future<void> getSearchHistoryEntity() async {
    try {
      searchHistoryList = searchHistory.getSearchHistoryByPage(1, _searchHistoryPageSize);
    } catch (e) {
      debugPrint('getSearchHistoryEntity failed: $e');
      searchHistoryList = [];
    }
  }


  /// 跳转到搜索结果页
  void goToSearchResult() {
    FocusScope.of(context).unfocus();
    if (inputText.isNotEmpty) {
      searchHistory.insertSearchHistory(
        SearchHistoryEntity(query: inputText, timestamp: DateTime.now()),
      );
      // 更新搜索历史列表
      getSearchHistoryEntity().then((_) {
        if (mounted) setState(() {});
      });
    }
    Get.toNamed("/search_result", arguments: {"keyWord": inputText});
  }

  /// 构建搜索栏
  Widget _buildDefaultSearchBar() {
    return TDNavBar(
      useDefaultBack: true,
      screenAdaptation: false,
      backgroundColor: Colors.transparent,
      titleMargin: 5,
      height: 45,
      centerTitle: false,
      padding: const EdgeInsets.only(left: 0, right: 0),
      titleWidget: TDSearchBar(
        backgroundColor: Colors.transparent,
        placeHolder: '',
        action: "搜索",
        style: TDSearchStyle.round,
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 2, top: 2),
        onTextChanged: (String text) {
          if (mounted) {
            setState(() {
              inputText = text;
            });
          }
        },
        onActionClick: (contexts) => goToSearchResult(),
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildDefaultSearchBar(),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: Layout.paddingB,
                      top: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSearchHistory(),
                        _buildTabs(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: Layout.paddingL,
                              right: Layout.paddingR,
                              top: Layout.paddingT,
                            ),
                            child: Row(
                              spacing: 10,
                              children: _buildPageViewContentList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          default:
            return const PageLoading();
        }
      },
    );
  }

  /// 构建页面视图内容列表（缓存结果）
  List<Widget> _buildPageViewContentList() {
    if (searchType.isEmpty) return [];
    
    return List.generate(searchType.length, (i) {
      // 容错处理：检查索引是否有效
      if (i >= searchTypeVideoPageDataList.length) {
        return const SizedBox.shrink();
      }
      
      final searchTypeItem = searchType[i];
      final color = HexColor(
        (Theme.of(context).brightness == Brightness.dark
                ? "#242424"
                : searchTypeItem.color) ??
            "#77A1D3",
      );
      
      return RepaintBoundary(
        child: _buildPageViewContent(
          searchTypeItem.name ?? "",
          color,
          searchTypeVideoPageDataList[i],
        ),
      );
    });
  }

  /// 构建标签页组件
  Widget _buildTabs() {
    if (tabs.isEmpty) return const SizedBox.shrink();
    
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          height: _tabBarHeight,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            dividerHeight: 0,
            indicator: GradientTabIndicator(
              gradient: const LinearGradient(
                colors: [_indicatorStartColor, _indicatorEndColor],
              ),
              height: 3.0,
              radius: 4.0,
            ),
            labelColor: _selectedTabColor,
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
            tabs: tabs,
          ),
        ),
        SizedBox(
          height: _tabBarViewHeight,
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: List.generate(tabs.length, (index) {
              // 容错处理：检查索引是否有效
              if (index >= hotKeyWordList.length || hotKeyWordList[index].isEmpty) {
                return const Center(child: Text('暂无数据'));
              }
              
              return RepaintBoundary(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  cacheExtent: 200,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 24,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: hotKeyWordList[index].length,
                  itemBuilder: (context, keyWordIndex) {
                    final item = hotKeyWordList[index][keyWordIndex];
                    return _buildHotKeyWordItem(item, index, keyWordIndex);
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// 构建热门关键词项
  Widget _buildHotKeyWordItem(
    HotKeyWordDataList item,
    int tabIndex,
    int keyWordIndex,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingL,
      ),
      child: Row(
        children: [
          Text(
            '${keyWordIndex + 1}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      item.keyWord ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if ((item.tag ?? "").isNotEmpty)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: HexColor(item.bgColor ?? "#77A1D3"),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          item.tag ?? "",
                          style: TextStyle(
                            color: HexColor(item.fontColor ?? "#77A1D3"),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () => Get.toNamed(
                "/search_result",
                arguments: {"keyWord": item.keyWord},
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建页面内容组件
  Widget _buildPageViewContent(
    String title,
    Color color,
    List<VideoRankDataListList> list,
  ) {
    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      width: MediaQuery.of(context).size.width * _pageViewWidthRatio,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * _pageViewWidthRatio,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : _borderColor,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            color.withAlpha(
              Theme.of(context).brightness == Brightness.dark ? 1 : 0,
            ),
            color.withAlpha(
              Theme.of(context).brightness == Brightness.dark ? 1 : 0,
            ),
            color.withAlpha(
              Theme.of(context).brightness == Brightness.dark ? 1 : 0,
            ),
            color.withAlpha(
              Theme.of(context).brightness == Brightness.dark ? 1 : 0,
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          SectionWithMore(
            title: title,
            onMorePressed: () {},
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemExtent: _itemExtent,
            cacheExtent: 200,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: _buildVideoItem(list[index], index),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建视频项
  Widget _buildVideoItem(VideoRankDataListList item, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _rankIconSize,
              height: _rankIconSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _getColor(index),
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TDImage(
              fit: BoxFit.cover,
              width: _imageWidth,
              height: _imageHeight,
              imgUrl: item.surfacePlot ?? "",
              errorWidget: const TDImage(
                width: _imageWidth,
                height: _imageHeight,
                assetUrl: 'assets/images/loading.gif',
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  Text(
                    VideoUtil.extractPlainText(item.introduce ?? ""),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : _textGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => Get.toNamed(
        "/video_detail",
        arguments: {"id": item.id},
      ),
    );
  }

  /// 根据索引返回排名颜色
  Color _getColor(int index) {
    switch (index) {
      case 0:
        return _rankColor1;
      case 1:
        return _rankColor2;
      case 2:
        return _rankColor3;
      default:
        return _rankColorDefault;
    }
  }

  /// 构建搜索历史
  Widget _buildSearchHistory() {
    if (searchHistoryList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(children: [_buildSearchItem()]);
  }

  /// 构建搜索历史项组件
  Widget _buildSearchItem() {
    return Column(
      spacing: 10,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: Layout.paddingR,
            right: Layout.paddingR,
          ),
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.access_time, size: 24, color: Colors.grey[400]),
              Flexible(
                child: SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    cacheExtent: 200,
                    itemCount: searchHistoryList.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 5),
                    itemBuilder: (context, index) {
                      final entity = searchHistoryList.elementAt(index);
                      return RepaintBoundary(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? _darkBackgroundColor
                                  : _lightBackgroundColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 5,
                              children: [
                                Text(
                                  entity.query,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                  ),
                                  onTap: () {
                                    searchHistory.deleteSearchHistoryById(
                                      entity.id ?? 0,
                                    );
                                    getSearchHistoryEntity().then((_) {
                                      if (mounted) setState(() {});
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            inputText = entity.query;
                            goToSearchResult();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用，因为使用了AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: _buildContent(),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // 只在首次加载时获取搜索历史，避免不必要的重建
    if (searchHistoryList.isEmpty) {
      await getSearchHistoryEntity();
      if (mounted) {
        setState(() {});
      }
    }
  }
}
