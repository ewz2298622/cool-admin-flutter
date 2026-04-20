import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/section_with_more.dart';
import '../../db/entity/SearchHistoryEntity.dart';
import '../../db/manager/search_history_database_helper.dart';
import '../../entity/video_hot_words_entity.dart';
import '../../entity/video_rank_entity.dart';
import '../../style/layout.dart';
import '../../utils/color.dart';
import '../../utils/routes.dart';
import '../../utils/video.dart';

/// 渐变标签指示器
class GradientTabIndicator extends Decoration {
  static const double _defaultHeight = 2.0;
  static const double _defaultRadius = 2.0;

  final Gradient gradient;
  final double height;
  final double radius;

  const GradientTabIndicator({
    required this.gradient,
    this.height = _defaultHeight,
    this.radius = _defaultRadius,
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
    final rect =
        Offset(offset.dx, configuration.size!.height - decoration.height) &
        Size(configuration.size!.width, decoration.height);

    final paint =
        Paint()
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
  List<VideoRankDataList> searchType = [];
  List<List<VideoRankDataListList>> searchTypeVideoPageDataList = [];
  List<List<VideoHotWordsDataListList>> hotKeyWordList = [];
  List<TDTab> tabs = [];
  TabController? _tabController;
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
  static const String _defaultTabText = '默认';
  static const String _defaultColor = '#77A1D3';
  static const String _darkColor = '#242424';
  static const String _noDataText = '暂无数据';
  static const double _indicatorHeight = 3.0;
  static const double _indicatorRadius = 4.0;
  static const double _tabFontSize = 16.0;
  static const double _hotKeyWordFontSize = 14.0;
  static const double _hotKeyWordTagFontSize = 12.0;
  static const double _rankFontSize = 16.0;
  static const double _videoTitleFontSize = 16.0;
  static const double _videoIntroFontSize = 12.0;
  static const double _searchHistoryHeight = 30.0;
  static const double _searchHistorySpacing = 5.0;
  static const double _searchHistoryPadding = 12.0;
  static const double _searchHistoryBorderRadius = 15.0;
  static const double _searchHistoryIconSize = 24.0;
  static const double _searchHistoryCloseIconSize = 14.0;
  static const double _searchHistoryDividerHeight = 1.0;
  static const double _pageViewHorizontalPadding = 8.0;
  static const double _pageViewVerticalPadding = 10.0;
  static const double _pageViewBorderRadius = 8.0;
  static const double _videoItemHorizontalPadding = 4.0;
  static const double _videoItemSpacing = 8.0;
  static const double _videoItemImageBorderRadius = 3.0;
  static const double _videoItemImageShadowBlurRadius = 4.0;
  static const Offset _videoItemImageShadowOffset = Offset(0, 2);
  static const double _videoItemTitleSpacing = 5.0;
  static const int _initializationTimeout = 15;
  static const int _apiTimeout = 10;

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
  static const Color _searchHistoryCloseIconColor = Color.fromRGBO(151, 151, 151, 1);
  static const Color _hotKeyWordNumberColor = Colors.grey;
  static const Color _videoItemImageShadowColor = Colors.black;
  static const double _videoItemImageShadowOpacity = 0.1;

  // 布局常量
  static const EdgeInsets _searchBarPadding = EdgeInsets.only(left: 0, right: 0, bottom: 2, top: 2);
  static const EdgeInsets _pageViewPadding = EdgeInsets.symmetric(horizontal: _pageViewHorizontalPadding, vertical: _pageViewVerticalPadding);
  static const EdgeInsets _videoItemPadding = EdgeInsets.symmetric(horizontal: _videoItemHorizontalPadding);
  static const EdgeInsets _hotKeyWordItemPadding = EdgeInsets.symmetric(horizontal: 4);
  static const SizedBox _hotKeyWordNumberSpacing = SizedBox(width: 4);
  static const SizedBox _hotKeyWordTagSpacing = SizedBox(width: 4);
  static const SliverGridDelegateWithFixedCrossAxisCount _hotKeyWordGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisExtent: 24,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  /// 初始化数据
  Future<String> init() async {
    try {
      // 并发执行所有初始化任务，添加超时保护
      try {
        await Future.wait([
          getDictCategoryInfoPages(),
          getSearchHistoryEntity(),
          getDictSearchTypeInfoPages(),
        ]).timeout(const Duration(seconds: _initializationTimeout));
      } on TimeoutException {
        debugPrint('Initialization timeout');
        // 超时后继续执行，使用默认值
      }

      // 容错处理：确保 tabs 不为空
      _ensureDefaultTab();

      // 确保 TabController 长度与 tabs 一致
      _ensureTabController();

      return "init success";
    } catch (e) {
      debugPrint('Initialization failed: $e');
      // 即使失败也创建 TabController，避免崩溃
      _ensureDefaultTab();
      _ensureTabController();
      return "init success";
    }
  }

  /// 确保至少有一个默认 tab
  void _ensureDefaultTab() {
    if (tabs.isEmpty) {
      tabs = [const TDTab(text: _defaultTabText)];
      hotKeyWordList.add(<VideoHotWordsDataListList>[]);
    }
  }

  /// 确保 TabController 长度与 tabs 一致
  void _ensureTabController() {
    final tabLength = tabs.length;
    if (_tabController == null || _tabController!.length != tabLength) {
      _tabController?.dispose();
      _tabController = TabController(length: tabLength, vsync: this);
    }
  }

  /// 获取分类信息并加载热门关键词（使用 getSearchHotKeyWord）
  Future<void> getDictCategoryInfoPages() async {
    try {
      final hotWordsEntity = await Api.getSearchHotKeyWord(
        {},
      ).timeout(const Duration(seconds: _apiTimeout));
      final hotWordsList = hotWordsEntity.data?.list ?? [];

      tabs.clear();
      hotKeyWordList.clear();

      // 遍历热词分类数据，构建 tabs 和热词列表
      for (var element in hotWordsList) {
        final name = element.name ?? '分类';
        tabs.add(TDTab(text: name));

        // 获取该分类下的热词列表，限制数量为 _hotKeyWordPageSize
        final keywordList = element.list ?? <VideoHotWordsDataListList>[];
        final limitedList =
            keywordList.length > _hotKeyWordPageSize
                ? keywordList.sublist(0, _hotKeyWordPageSize)
                : keywordList;
        hotKeyWordList.add(limitedList);
      }
    } catch (e) {
      debugPrint('getDictCategoryInfoPages failed: $e');
      // 容错处理：确保至少有一个默认 tab
      _ensureDefaultTab();
    }
  }

  /// 获取搜索类型信息并加载视频数据（使用排名数据）
  Future<void> getDictSearchTypeInfoPages() async {
    try {
      final rankEntity = await Api.getSearchVideoRank(
        {},
      ).timeout(const Duration(seconds: _apiTimeout));
      searchType = rankEntity.data?.list ?? [];
      searchTypeVideoPageDataList.clear();

      // 加载所有搜索类型的视频数据
      if (searchType.isNotEmpty) {
        for (var element in searchType) {
          final list = element.list ?? <VideoRankDataListList>[];
          // 限制数量为 _searchTypeVideoPageSize
          final limitedList =
              list.length > _searchTypeVideoPageSize
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

  /// 获取搜索历史
  Future<void> getSearchHistoryEntity() async {
    try {
      searchHistoryList = searchHistory.getSearchHistoryByPage(
        1,
        _searchHistoryPageSize,
      );
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
    Get.toNamed(AppRoutes.searchResult, arguments: {"keyWord": inputText});
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
        padding: _searchBarPadding,
        onTextChanged: (String text) {
          setState(() {
            inputText = text;
          });
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
                    padding: EdgeInsets.only(bottom: Layout.paddingB, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSearchHistory(),
                        _buildTabs(),
                        _buildHorizontalScrollView(),
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

  /// 构建水平滚动视图
  Widget _buildHorizontalScrollView() {
    return SingleChildScrollView(
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
                ? _darkColor
                : searchTypeItem.color) ??
            _defaultColor,
      );

      return _buildPageViewContent(
        searchTypeItem.name ?? "",
        color,
        searchTypeVideoPageDataList[i],
      );
    });
  }

  /// 构建标签页组件
  Widget _buildTabs() {
    if (tabs.isEmpty || _tabController == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final tabCount = tabs.length;
    // 计算每个tab的最小宽度，假设每个tab至少需要80像素
    const double minTabWidth = 80.0;
    // 计算当所有tab平均分布时需要的最小屏幕宽度
    final double requiredWidth = tabCount * minTabWidth;
    
    // 判断是否需要平均分布
    final bool shouldDistributeEvenly = screenWidth >= requiredWidth;

    return Column(
      spacing: 10,
      children: [
        SizedBox(
          height: _tabBarHeight,
          child: TabBar(
            controller: _tabController!,
            isScrollable: !shouldDistributeEvenly,
            tabAlignment: shouldDistributeEvenly ? TabAlignment.fill : TabAlignment.center,
            dividerHeight: 0,
            indicator: GradientTabIndicator(
              gradient: const LinearGradient(
                colors: [_indicatorStartColor, _indicatorEndColor],
              ),
              height: _indicatorHeight,
              radius: _indicatorRadius,
            ),
            labelColor: _selectedTabColor,
            unselectedLabelStyle: const TextStyle(
              fontSize: _tabFontSize,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
            labelStyle: const TextStyle(
              fontSize: _tabFontSize,
              fontWeight: FontWeight.w800,
            ),
            tabs: tabs,
          ),
        ),
        SizedBox(
          height: _tabBarViewHeight,
          child: TabBarView(
            controller: _tabController!,
            physics: const BouncingScrollPhysics(),
            children: List.generate(tabs.length, (index) {
              // 容错处理：检查索引是否有效
              if (index >= hotKeyWordList.length ||
                  hotKeyWordList[index].isEmpty) {
                return const Center(child: Text(_noDataText));
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                cacheExtent: 200,
                gridDelegate: _hotKeyWordGridDelegate,
                itemCount: hotKeyWordList[index].length,
                itemBuilder: (context, keyWordIndex) {
                  final item = hotKeyWordList[index][keyWordIndex];
                  return _buildHotKeyWordItem(item, index, keyWordIndex);
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  /// 构建热门关键词项
  Widget _buildHotKeyWordItem(
    VideoHotWordsDataListList item,
    int tabIndex,
    int keyWordIndex,
  ) {
    return Container(
      padding: EdgeInsets.only(left: Layout.paddingL, right: Layout.paddingL),
      child: Row(
        children: [
          Text(
            '${keyWordIndex + 1}',
            style: const TextStyle(color: _hotKeyWordNumberColor, fontSize: _hotKeyWordFontSize),
          ),
          _hotKeyWordNumberSpacing,
          Expanded(
            child: GestureDetector(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      item.keyWord ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: _hotKeyWordFontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _hotKeyWordTagSpacing,
                  if ((item.tag ?? "").isNotEmpty)
                    _buildHotKeyWordTag(item),
                ],
              ),
              onTap:
                  () => Get.toNamed(
                    "/search_result",
                    arguments: {"keyWord": item.keyWord},
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建热门关键词标签
  Widget _buildHotKeyWordTag(VideoHotWordsDataListList item) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: HexColor(item.bgColor ?? _defaultColor),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: _hotKeyWordItemPadding,
        child: Text(
          item.tag ?? "",
          style: TextStyle(
            color: HexColor(item.fontColor ?? _defaultColor),
            fontWeight: FontWeight.w500,
            fontSize: _hotKeyWordTagFontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
      padding: _pageViewPadding,
      width: MediaQuery.of(context).size.width * _pageViewWidthRatio,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * _pageViewWidthRatio,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_pageViewBorderRadius),
        border: Border.all(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : _borderColor,
        ),
        gradient: _buildPageViewGradient(color),
      ),
      child: Column(
        children: [
          SectionWithMore(title: title, onMorePressed: () {}),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemExtent: _itemExtent,
            cacheExtent: 200,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildVideoItem(list[index], index);
            },
          ),
        ],
      ),
    );
  }

  /// 构建页面视图渐变
  LinearGradient _buildPageViewGradient(Color color) {
    return LinearGradient(
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
    );
  }

  /// 构建视频项
  Widget _buildVideoItem(VideoRankDataListList item, int index) {
    return GestureDetector(
      child: Padding(
        padding: _videoItemPadding,
        child: Row(
          spacing: _videoItemSpacing,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildRankIcon(index),
            _buildVideoImage(item),
            _buildVideoInfo(item),
          ],
        ),
      ),
      onTap: () => Get.toNamed(AppRoutes.videoDetail, arguments: {"id": item.id}),
    );
  }

  /// 构建排名图标
  Widget _buildRankIcon(int index) {
    return Container(
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
            fontSize: _rankFontSize,
            color: Colors.white,
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 构建视频图片
  Widget _buildVideoImage(VideoRankDataListList item) {
    return Container(
      width: _imageWidth,
      height: _imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_videoItemImageBorderRadius),
        boxShadow: [
          BoxShadow(
            color: _videoItemImageShadowColor.withValues(alpha: _videoItemImageShadowOpacity),
            blurRadius: _videoItemImageShadowBlurRadius,
            offset: _videoItemImageShadowOffset,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_videoItemImageBorderRadius),
        child: TDImage(
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
      ),
    );
  }

  /// 构建视频信息
  Widget _buildVideoInfo(VideoRankDataListList item) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _videoItemTitleSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: _videoTitleFontSize,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          Text(
            VideoUtil.extractPlainText(item.introduce ?? ""),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: _videoIntroFontSize,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : _textGreyColor,
            ),
          ),
        ],
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
              Icon(Icons.access_time, size: _searchHistoryIconSize, color: Colors.grey[400]),
              _buildSearchHistoryList(),
              _buildClearButton(),
            ],
          ),
        ),
        Divider(height: _searchHistoryDividerHeight, color: Colors.grey[300]),
      ],
    );
  }

  /// 构建搜索历史列表
  Widget _buildSearchHistoryList() {
    return Flexible(
      child: SizedBox(
        height: _searchHistoryHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          cacheExtent: 200,
          itemCount: searchHistoryList.length,
          separatorBuilder:
              (context, index) => const SizedBox(width: _searchHistorySpacing),
          itemBuilder: (context, index) {
            final entity = searchHistoryList.elementAt(index);
            return _buildSearchHistoryItem(entity);
          },
        ),
      ),
    );
  }

  /// 构建搜索历史项
  Widget _buildSearchHistoryItem(SearchHistoryEntity entity) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: _searchHistoryPadding),
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? _darkBackgroundColor
                  : _lightBackgroundColor,
          borderRadius: BorderRadius.circular(_searchHistoryBorderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: _searchHistorySpacing,
          children: [
            Text(
              entity.query,
              style: TextStyle(
                color:
                    Theme.of(context).brightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
            _buildSearchHistoryCloseButton(entity),
          ],
        ),
      ),
      onTap: () {
        inputText = entity.query;
        goToSearchResult();
      },
    );
  }

  /// 构建搜索历史关闭按钮
  Widget _buildSearchHistoryCloseButton(SearchHistoryEntity entity) {
    return GestureDetector(
      child: const Icon(
        Icons.close,
        size: _searchHistoryCloseIconSize,
        color: _searchHistoryCloseIconColor,
      ),
      onTap: () {
        searchHistory.deleteSearchHistoryById(
          entity.id ?? 0,
        );
        getSearchHistoryEntity().then((_) {
          if (mounted) setState(() {});
        });
      },
    );
  }

  /// 构建清除按钮
  Widget _buildClearButton() {
    return GestureDetector(
      child: SvgPicture.asset(
        'assets/images/clear.svg',
        width: _searchHistoryIconSize,
        height: _searchHistoryIconSize,
      ),
      onTap: () {
        searchHistory.deleteAll();
        getSearchHistoryEntity().then((_) {
          if (mounted) setState(() {});
        });
      },
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
      // 设置为false，让系统自动处理键盘弹起时的布局调整，避免不必要的重建
      resizeToAvoidBottomInset: false,
      body: _buildContent(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 仅在首次加载或需要强制刷新时才重新初始化
    // 避免因输入框聚焦等常规操作触发不必要的刷新
  }
}
