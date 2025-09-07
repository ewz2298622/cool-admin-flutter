import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../components/video_three.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../style/layout.dart';
import '../search/search.dart';

String TAG = "VideoFilter";

class VideoFilter extends StatefulWidget {
  //接受路由传递过来的props id
  const VideoFilter({super.key});

  @override
  VideoFilterState createState() => VideoFilterState();
}

class VideoFilterState extends State<VideoFilter>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提取常量

  final ScrollController _scrollController = ScrollController();
  //定义currentPage
  int currentPage = 1;
  bool showBackTop = false;
  TDBackTopStyle style = TDBackTopStyle.circle;
  var _futureBuilderFuture;
  var inputText = "";
  List<DictDataDataVideoCategory> categoryData = [];
  List<DictDataDataVideoTag> tagData = [];
  List<VideoPageDataList> videoPageData = [];
  //实现一个从今年到15年前的list
  List<int> years = List.generate(20, (index) => DateTime.now().year - index);
  final ValueNotifier<int> categoryCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> tagCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> yearCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> regionCurrent = ValueNotifier<int>(0);
  bool disposed = false;
  List<DictInfoListData> categoryDictList = [];
  List<DictInfoListData> areaDictList = [];
  List<DictInfoListData> categoryOriginalDictList = [];
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  Future<void> getVideoPages() async {
    try {
      Map<String, dynamic>? data = {"page": currentPage};
      data = {
        "page": currentPage,
        "category_pid":
            categoryCurrent.value == 0 ? null : categoryCurrent.value,
        "video_tag":
            tagCurrent.value == 0
                ? null
                : tagData
                    .where((element) => element.id == tagCurrent.value)
                    .toList()[0]
                    .name,
        "year": yearCurrent.value == 0 ? null : yearCurrent.value,
        "region": regionCurrent.value == 0 ? null : regionCurrent.value,
      };

      List<VideoPageDataList> list =
          (await Api.getVideoPages(data)).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageData = [...videoPageData, ...list];
      setState(() {});
    } catch (e) {
      debugPrint('Initialization getVideoPages failed: $e');
    }
  }

  Future<void> getVideoCategoryPages() async {
    try {
      categoryData =
          ((await Api.getDictData({
                    "types": ["video_category"],
                  })).data
                  as DictDataData)
              .videoCategory!;
      categoryData =
          categoryData.where((element) => element.parentId == null).toList();
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoListByCategoryIds failed: $e');
    }
  }

  Future<void> getVideoTagPages() async {
    try {
      tagData =
          ((await Api.getDictData({
                    "types": ["video_tag"],
                  })).data
                  as DictDataData)
              .videoTag!;
      debugPrint(
        'Initialization getVideoTagPages success ${tagData[tagCurrent.value]}',
      );
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoTagPages failed: $e');
    }
  }

  Future<void> getVideoAreaPages() async {
    try {
      areaDictList =
          (await Api.getDictInfoPages({
                "order": "orderNum",
                "sort": "desc",
                "typeId": 39,
              })).data
              as List<DictInfoListData>;
      //返回parentId :  null 的数据
      areaDictList =
          areaDictList.where((element) => element.parentId == null).toList();
    } catch (e) {
      // 捕获并处理异常
    }
  }

  Future<String> init() async {
    try {
      await Future.wait([
        getVideoPages(),
        getVideoCategoryPages(),
        getVideoAreaPages(),
        getVideoTagPages(),
      ]);
      _scrollControllerAdd();
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      return "init success";
    }
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    disposed = true;
    super.dispose();
  }

  Widget _buildDefaultSearchBar() {
    return TDSearchBar(
      placeHolder: '',
      backgroundColor: Colors.transparent,
      readOnly: true,
      style: TDSearchStyle.round,
      onInputClick: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VideoSearch()),
        );
      },
    );
  }

  Future<void> _category_change(DictDataDataVideoCategory? item) async {
    if (item != null) {
      categoryCurrent.value = item.id ?? 0;
    } else {
      categoryCurrent.value = 0;
    }
    videoPageData.clear();
    currentPage = 1;
    await getVideoPages();
    setState(() {});
    _year_change(0);
    _area_change(null);
  }

  Future<void> _tag_change(DictDataDataVideoTag? item) async {
    if (item != null) {
      tagCurrent.value = item.id ?? 0;
    } else {
      tagCurrent.value = 0;
    }
    videoPageData.clear();
    currentPage = 1;
    await getVideoPages();
    setState(() {});
    _year_change(0);
    _area_change(null);
  }

  Future<void> _year_change(int item) async {
    yearCurrent.value = item;
    videoPageData.clear();
    currentPage = 1;

    await getVideoPages();
    setState(() {});
  }

  Future<void> _area_change(DictInfoListData? item) async {
    if (item != null) {
      regionCurrent.value = item.id ?? 0;
    } else {
      regionCurrent.value = 0;
    }
    videoPageData.clear();
    currentPage = 1;
    await getVideoPages();
    setState(() {});
  }

  Widget _buildCategoryRow(
    String title,
    List<DictDataDataVideoCategory> items,
  ) {
    if (items.isEmpty) {
      return Container();
    } else {
      return ValueListenableBuilder<int>(
        valueListenable: categoryCurrent,
        builder: (context, key, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  child: TDTag(
                    title,
                    shape: TDTagShape.round,
                    isLight: true,
                    size: TDTagSize.large,
                    textColor:
                        categoryCurrent.value == 0
                            ? const Color.fromRGBO(255, 122, 27, 1)
                            : Theme.of(context).textTheme.titleLarge?.color,
                    backgroundColor:
                        categoryCurrent.value == 0
                            ? const Color.fromRGBO(244, 244, 244, 1)
                            : Colors.transparent,
                    isOutline: true,
                    style: TDTagStyle(
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () {
                    _category_change(null);
                  },
                ),

                ...(items).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      child: TDTag(
                        item.name ?? "",
                        shape: TDTagShape.round,
                        isLight: true,
                        size: TDTagSize.large,
                        textColor:
                            key == item.id
                                ? const Color.fromRGBO(255, 122, 27, 1)
                                : Theme.of(context).textTheme.titleLarge?.color,
                        backgroundColor:
                            key == item.id
                                ? const Color.fromRGBO(244, 244, 244, 1)
                                : Colors.transparent,
                        isOutline: true,
                        style: TDTagStyle(
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () => _category_change(item),
                    ),
                  ),
                ).toList(), // 添加toList()以确保正确构建
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildTagRow(String title, List<DictDataDataVideoTag> items) {
    if (items.isEmpty) {
      return Container();
    } else {
      return ValueListenableBuilder<int>(
        valueListenable: tagCurrent,
        builder: (context, key, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  child: TDTag(
                    title,
                    shape: TDTagShape.round,
                    isLight: true,
                    size: TDTagSize.large,
                    textColor:
                        tagCurrent.value == 0
                            ? const Color.fromRGBO(255, 122, 27, 1)
                            : Theme.of(context).textTheme.titleLarge?.color,
                    backgroundColor:
                        tagCurrent.value == 0
                            ? const Color.fromRGBO(244, 244, 244, 1)
                            : Colors.transparent,
                    isOutline: true,
                    style: TDTagStyle(
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () {
                    _tag_change(null);
                  },
                ),

                ...(items).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      child: TDTag(
                        item.name ?? "",
                        shape: TDTagShape.round,
                        isLight: true,
                        size: TDTagSize.large,
                        textColor:
                            key == item.id
                                ? const Color.fromRGBO(255, 122, 27, 1)
                                : Theme.of(context).textTheme.titleLarge?.color,
                        backgroundColor:
                            key == item.id
                                ? const Color.fromRGBO(244, 244, 244, 1)
                                : Colors.transparent,
                        isOutline: true,
                        style: TDTagStyle(
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () => _tag_change(item),
                    ),
                  ),
                ).toList(), // 添加toList()以确保正确构建
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildAreaRow(String title, List<DictInfoListData> items) {
    if (items.isEmpty) {
      return Container();
    } else {
      return ValueListenableBuilder<int>(
        valueListenable: regionCurrent,
        builder: (context, key, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  child: TDTag(
                    title,
                    isLight: true,
                    textColor:
                        regionCurrent.value == 0
                            ? const Color.fromRGBO(255, 122, 27, 1)
                            : Theme.of(context).textTheme.titleLarge?.color,
                    backgroundColor:
                        regionCurrent.value == 0
                            ? const Color.fromRGBO(244, 244, 244, 1)
                            : Colors.transparent,
                    shape: TDTagShape.round,
                    size: TDTagSize.large,
                    isOutline: true,
                    style: TDTagStyle(
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () {
                    _area_change(null);
                  },
                ),
                ...(items).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      child: TDTag(
                        item.name ?? "",
                        shape: TDTagShape.round,
                        size: TDTagSize.large,
                        isLight: true,
                        textColor:
                            key == item.id
                                ? const Color.fromRGBO(255, 122, 27, 1)
                                : Theme.of(context).textTheme.titleLarge?.color,
                        backgroundColor:
                            key == item.id
                                ? const Color.fromRGBO(244, 244, 244, 1)
                                : Colors.transparent,
                        isOutline: true,
                        style: TDTagStyle(
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () => _area_change(item),
                    ),
                  ),
                ).toList(), // 添加toList()以确保正确构建
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildYearRow(String title, List<int> items) {
    return ValueListenableBuilder<int>(
      valueListenable: yearCurrent,
      builder: (context, key, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                child: TDTag(
                  title,
                  isLight: true,
                  textColor:
                      yearCurrent.value == 0
                          ? const Color.fromRGBO(255, 122, 27, 1)
                          : Theme.of(context).textTheme.titleLarge?.color,
                  backgroundColor:
                      yearCurrent.value == 0
                          ? const Color.fromRGBO(244, 244, 244, 1)
                          : Colors.transparent,
                  shape: TDTagShape.round,
                  size: TDTagSize.large,
                  isOutline: true,
                  style: TDTagStyle(
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onTap: () {
                  _year_change(0);
                },
              ),
              ...(items).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    child: TDTag(
                      item.toString(),
                      isLight: true,
                      textColor:
                          key == item
                              ? const Color.fromRGBO(255, 122, 27, 1)
                              : Theme.of(context).textTheme.titleLarge?.color,
                      backgroundColor:
                          key == item
                              ? const Color.fromRGBO(244, 244, 244, 1)
                              : Colors.transparent,
                      shape: TDTagShape.round,
                      size: TDTagSize.large,
                      isOutline: true,
                      style: TDTagStyle(
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onTap: () => _year_change(item),
                  ),
                ),
              ).toList(), // 添加toList()以确保正确构建
            ],
          ),
        );
      },
    );
  }

  _scrollControllerAdd() {
    _scrollController.addListener(listenLoadMoreCallback);
    _scrollController.addListener(listenCallback);
  }

  void listenLoadMoreCallback() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // 滚动到底部时触发
      loadMore();
    }
  }

  Future<void> onRefresh() async {
    videoPageData.clear();
    currentPage = 1;
    categoryCurrent.value = 0;
    yearCurrent.value = 0;
    tagCurrent.value = 0;
    regionCurrent.value = 0;
    await getVideoPages();
    if (disposed) {
      return;
    }
  }

  void listenCallback() {
    if (_scrollController.offset >= 100) {
      if (!showBackTop) {
        setState(() {
          showBackTop = true;
        });
      }
    } else {
      if (showBackTop) {
        setState(() {
          showBackTop = false;
        });
      }
    }
  }

  Future<void> loadMore() async {
    currentPage++;
    await getVideoPages();
    TDToast.dismissLoading();
    if (disposed) {
      return;
    }
  }

  final RefreshController _refreshController = RefreshController();

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        debugPrint('snapshot: ${snapshot.hasData}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.hasData) {
          return SmartRefresher(
            onRefresh: () async {
              await onRefresh();
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              await loadMore();
              _refreshController.loadComplete();
            },
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(child: _buildDefaultSearchBar()),
                SliverStickyHeader(
                  header: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.only(
                      left: Layout.paddingL,
                      right: Layout.paddingR,
                      top: 5,
                      bottom: Layout.paddingB,
                    ),
                    child: Visibility(
                      visible: (categoryData.isNotEmpty),
                      child: Column(
                        spacing: 10,
                        //左对齐
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategoryRow('全部分类', categoryData),
                          _buildTagRow("全部标签", tagData),
                          _buildAreaRow('全部地区', areaDictList),
                          _buildYearRow("全部年份", years),
                        ],
                      ),
                    ),
                  ),
                  sliver: isShowContent(),
                ),
              ],
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget isShowContent() {
    if (videoPageData.isEmpty) {
      return SliverToBoxAdapter(child: Center(child: NoData()));
    } else {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150.0, // 每个 item 的最大宽度
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: 0.7,
          mainAxisExtent: 205,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GridTile(
            child: Center(child: Video(videoData: videoPageData[i])),
          ),
          childCount: videoPageData.length,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用 super.build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.transparent,
        elevation: 0,
        //不显示icon
        leading: Container(),
        automaticallyImplyLeading: false, //设置为false
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: _buildContent(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
