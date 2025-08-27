import 'package:flutter/material.dart';
import 'package:flutter_app/views/search/result/search_result.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../db/entity/SearchHistoryEntity.dart';
import '../../db/manager/SearchHistoryDatabaseHelper.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/hot_keyWord_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../style/layout.dart';
import '../../utils/color.dart';
import '../../utils/video.dart';
import '../home/home.dart';
import '../video_detail/detail.dart';

class VideoSearch extends StatefulWidget {
  const VideoSearch({super.key});

  @override
  VideoSearchState createState() => VideoSearchState();
}

class VideoSearchState extends State<VideoSearch>
    with SingleTickerProviderStateMixin {
  String inputText = '';
  List<VideoPageDataList> videoPageData = [];
  //定义猜你喜欢数据
  List<VideoPageDataList> videoPageDataList = [];
  final searchHistory = SearchHistoryDatabaseHelper();
  Iterable<SearchHistoryEntity> searchHistoryList = [];
  List<DictDataDataVideoCategory> category = [];
  List<DictDataDataSearchType> searchType = [];
  List<List<VideoPageDataList>> searchTypeVideoPageDataList = [];

  List<List<HotKeyWordDataList>> hotKeyWordList = [];

  List<TDTab> tabs = [];
  late TabController _tabController;
  var _futureBuilderFuture;

  //生产十个 热门影视剧名字的数组

  Future<String> init() async {
    try {
      await Future.wait([
        getDictCategoryInfoPages(),
        getSearchHistoryEntity(),
        getDictSearchTypeInfoPages(),
      ]);
      _tabController = TabController(length: tabs.length, vsync: this);
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
      return "init success";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  Future<void> getDictCategoryInfoPages() async {
    try {
      category =
          ((await Api.getDictData({
                    "types": ["video_category"],
                  })).data
                  as DictDataData)
              .videoCategory!;
      category = category.where((element) => element.parentId == null).toList();

      tabs.clear();
      for (var element in category) {
        tabs.add(TDTab(text: element.name));
        await videoHotKeyWord(element.id ?? 0);
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getDictCategoryInfoPages failed: $e');
    }
  }

  Future<void> getDictSearchTypeInfoPages() async {
    try {
      searchType =
          ((await Api.getDictData({
                    "types": ["search_type"],
                  })).data
                  as DictDataData)
              .searchType!;
      for (var element in searchType) {
        await searchTypeVideoPageDataListGet(element.id ?? 0);
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getDictTagInfoPages failed: $e');
    }
  }

  Future<void> videoHotKeyWord(int categoryId) async {
    try {
      List<HotKeyWordDataList> list =
          (await Api.getHostKeyWord({
            "page": 1,
            "size": 8,
            "category_id": categoryId,
          })).data?.list ??
          [] as List<HotKeyWordDataList>;
      hotKeyWordList.add(list);
      //改成并发
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getSearchHistoryEntity() async {
    try {
      searchHistoryList = searchHistory.getSearchHistoryByPage(1, 4);
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> searchTypeVideoPageDataListGet(int searchRecommendType) async {
    try {
      List<VideoPageDataList> list =
          (await Api.getVideoPages({
            "page": 1,
            "size": 7,
            "searchRecommendType": searchRecommendType,
          })).data?.list ??
          [] as List<VideoPageDataList>;
      searchTypeVideoPageDataList.add(list);
      //改成并发
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization searchTypeVideoPageDataListGet failed: $e');
    }
  }

  goToSearchResult() {
    FocusScope.of(context).unfocus(); // 移除焦点
    if (inputText.isNotEmpty) {
      searchHistory.insertSearchHistory(
        SearchHistoryEntity(query: inputText, timestamp: DateTime.now()),
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchResult(keyWord: inputText)),
    );
  }

  Widget _buildDefaultSearchBar() {
    return TDNavBar(
      useDefaultBack: true,
      height: 36,
      screenAdaptation: false,

      titleMargin: 5,
      centerTitle: false,
      padding: EdgeInsets.only(left: 0, right: 0),
      titleWidget: TDSearchBar(
        backgroundColor: Colors.transparent,
        placeHolder: '请输入剧名',
        action: "搜索",
        style: TDSearchStyle.round,
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
        onTextChanged: (String text) {
          setState(() {
            inputText = text.trim();
          });
        },
        onActionClick: (contexts) {
          goToSearchResult();
        },
      ),
    );
  }

  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
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
                        SingleChildScrollView(
                          //水平滚动
                          scrollDirection: Axis.horizontal,
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
            return PageLoading();
        }
      },
    );
  }

  List<Widget> _buildPageViewContentList() {
    List<Widget> list = [];
    //改成能拿到index的形式
    for (int i = 0; i < searchType.length; i++) {
      list.add(
        PagviewContent(
          searchType[i].name ?? "",
          HexColor(searchType[i].color ?? "#77A1D3"),
          searchTypeVideoPageDataList[i],
        ),
      );
    }
    return list;
  }

  //tabs组件
  Widget _buildTabs() {
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          height: 35,
          child: TabBar(
            controller: _tabController, // 使用 controller
            isScrollable: true,
            tabAlignment: TabAlignment.center,

            dividerHeight: 0,
            indicator: GradientTabIndicator(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(9, 128, 253, 1), // 完全不透明的橙色
                  Color.fromRGBO(9, 128, 253, 0), // 完全透明（alpha=0）
                ],
              ),
              height: 3.0, // 指示器高度
              radius: 4.0, // 圆角
            ),
            //选中的字体颜色
            labelColor: const Color.fromRGBO(252, 119, 66, 1),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelColor: Colors.black87,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
            tabs: tabs,
            onTap: (index) {},
          ),
        ),
        // 修复 TabBarView 不显示的问题，给它一个固定高度
        SizedBox(
          height: 130, // 设置一个合适的高度
          child: TabBarView(
            controller: _tabController, // 添加 controller
            children: List.generate(tabs.length, (index) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 24,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: hotKeyWordList[index].length,
                itemBuilder: (context, keyWordIndex) {
                  return Container(
                    padding: EdgeInsets.only(
                      left: Layout.paddingL,
                      right: Layout.paddingL,
                    ),
                    child: Row(
                      // 改用更可控的Row布局替代ListTile
                      children: [
                        Text(
                          '${keyWordIndex + 1}',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: GestureDetector(
                            child: Row(
                              children: [
                                Flexible(
                                  // 使用 Flexible 而不是 Expanded 来包裹文本
                                  child: Text(
                                    hotKeyWordList[index][keyWordIndex]
                                            .keyWord ??
                                        "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    // 限制文本长度，例如最多显示8个字符
                                    // 方法1: 使用 substring 截断
                                    // text: (hotKeyWordList[index][keyWordIndex].keyWord ?? "").length > 8
                                    //   ? "${(hotKeyWordList[index][keyWordIndex].keyWord ?? "").substring(0, 8)}..."
                                    //   : hotKeyWordList[index][keyWordIndex].keyWord ?? "",
                                  ),
                                ),
                                SizedBox(width: 4),
                                Visibility(
                                  visible:
                                      (hotKeyWordList[index][keyWordIndex]
                                                  .tag ??
                                              "")
                                          .isNotEmpty,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: HexColor(
                                        hotKeyWordList[index][keyWordIndex]
                                                .bgColor ??
                                            "#77A1D3",
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        hotKeyWordList[index][keyWordIndex]
                                                .tag ??
                                            "",
                                        style: TextStyle(
                                          color: HexColor(
                                            hotKeyWordList[index][keyWordIndex]
                                                    .fontColor ??
                                                "#77A1D3",
                                          ),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => SearchResult(
                                        keyWord:
                                            hotKeyWordList[index][keyWordIndex]
                                                .keyWord ??
                                            "",
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget PagviewContent(
    String title,
    Color color,
    List<VideoPageDataList> list,
  ) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      //宽度是60%
      width: MediaQuery.of(context).size.width * 0.75,
      //渐变色背景
      decoration: BoxDecoration(
        //圆角
        borderRadius: BorderRadius.circular(8),
        //边框色
        border: Border.all(color: Color.fromRGBO(243, 241, 240, 1)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            color.withAlpha(0),
            color.withAlpha(0),
            color.withAlpha(0),
            color.withAlpha(0),
          ],
        ),
      ),
      child: Column(
        children: [
          SectionWithMore(
            title: title, // 传入标题
            onMorePressed: () {},
          ),
          //根据 videoPageData
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            //间距
            itemExtent: 84,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _getColor(index),
                        ),
                        child: Center(
                          // 方式1：使用Center组件包裹
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.0, // 方式2：设置行高系数（关键参数）
                            ),
                            textAlign: TextAlign.center, // 多行文本时需要
                          ),
                        ),
                      ),
                      TDImage(
                        fit: BoxFit.cover,
                        width: 120,
                        height: 75,
                        imgUrl: list[index].surfacePlot ?? "",
                        errorWidget: const TDImage(
                          width: 120,
                          height: 75,
                          assetUrl: 'assets/images/loading.gif',
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              list[index].title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              VideoUtil.extractPlainText(
                                list[index].introduce ?? "",
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(153, 153, 153, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Video_Detail(
                            key: ValueKey(
                              list[index].id ?? 0,
                            ), // 不同 id 对应不同 Key
                            id: list[index].id ?? 0,
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  //根据传入的index 返回color
  Color _getColor(int index) {
    switch (index) {
      case 0:
        return Color.fromRGBO(255, 62, 63, 1);
      case 1:
        return Color.fromRGBO(254, 151, 58, 1);
      case 2:
        return Color.fromRGBO(254, 209, 53, 1);
      default:
        return Color.fromRGBO(178, 188, 198, 1);
    }
  }

  //历史搜索记录
  Widget _buildSearchHistory() {
    if (searchHistoryList.isEmpty) {
      return Container();
    }
    return Column(children: [SearchItem()]);
  }

  // 区块标题组件
  Widget SectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // 搜索历史项组件
  Widget SearchItem() {
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
                flex: 1,
                child: SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: searchHistoryList.length,
                    separatorBuilder: (context, index) => SizedBox(width: 5),
                    itemBuilder: (context, index) {
                      final entity = searchHistoryList.elementAt(index);
                      return GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(239, 239, 239, 1),
                            //设置圆角
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5,
                            children: [
                              Text(entity.query),
                              GestureDetector(
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Color.fromRGBO(151, 151, 151, 1),
                                ),
                                onTap: () {
                                  searchHistory.deleteSearchHistoryById(
                                    entity.id ?? 0,
                                  );
                                  searchHistoryList =
                                      searchHistory.getAllSearchHistory();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          inputText = entity.query;
                          goToSearchResult();
                        },
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

  // 推荐项组件
  Widget RecommendItem(String keyword, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(keyword, style: const TextStyle(fontSize: 16, color: Colors.blue)),
        Text(info, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // 热搜项组件
  Widget HotItem(String title, double heat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Text(
          '${heat}万热搜值',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        automaticallyImplyLeading: false, //设置为false
      ),
      resizeToAvoidBottomInset: false,
      body: _buildContent(),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await getSearchHistoryEntity();
    setState(() {});
  }
}
