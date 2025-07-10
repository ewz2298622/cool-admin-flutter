import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../components/video_three.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/video_category_entity.dart';
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
  static const _gradientColors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];
  static const _gradientStops = [0.2, 0.8];

  final ScrollController _scrollController = ScrollController();
  //定义currentPage
  int currentPage = 1;
  bool showBackTop = false;
  TDBackTopStyle style = TDBackTopStyle.circle;
  var _futureBuilderFuture;
  var inputText = "";
  VideoCategoryData? categoryData;
  List<VideoPageDataList> videoPageData = [];
  //实现一个从今年到15年前的list
  List<int> years = List.generate(20, (index) => DateTime.now().year - index);
  final ValueNotifier<int> categoryCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> yearCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> regionCurrent = ValueNotifier<int>(0);
  bool disposed = false;
  List<DictInfoListData> categoryDictList = [];
  List<DictInfoListData> areaDictList = [];
  List<DictInfoListData> categoryOriginalDictList = [];
  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey();
  bool isLoading = true;

  Future<void> getVideoPages() async {
    try {
      isLoading = true;
      Map<String, dynamic>? data = {"page": currentPage};
      data = {
        "page": currentPage,
        "category_pid":
            categoryCurrent.value == 0 ? null : categoryCurrent.value,
        "year": yearCurrent.value == 0 ? null : yearCurrent.value,
        "region": regionCurrent.value == 0 ? null : regionCurrent.value,
      };

      List<VideoPageDataList> list =
          (await Api.getVideoPages(data)).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageData = [...videoPageData, ...list];
      isLoading = false;
    } catch (e) {
      isLoading = false;
    }
    setState(() {});
  }

  Future<void> getVideoCategoryPages() async {
    try {
      categoryData =
          (await Api.getVideoCategoryPages({
                "page": 1,
                "size": 100,
                "parent_id": 0,
                "type": 1,
              })).data
              as VideoCategoryData;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoListByCategoryIds failed: $e');
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
      print('获取视频地区数据失败: $e');
    }
  }

  Future<void> getDictInfoPages() async {
    try {
      categoryDictList =
          (await Api.getDictInfoPages({
                "order": "orderNum",
                "sort": "desc",
                "typeId": 49,
              })).data
              as List<DictInfoListData>;
      //使用浅拷贝
      categoryOriginalDictList =
          categoryDictList.map((e) {
            return e;
          }).toList();
      //返回parentId :  null 的数据
      categoryDictList =
          categoryDictList
              .where((element) => element.parentId == null)
              .toList();
    } catch (e) {
      // 捕获并处理异常
      print('获取视频分类数据失败: $e');
    }
  }

  Future<String> init() async {
    try {
      await getVideoPages();
      await getVideoCategoryPages();
      await getDictInfoPages();
      await getVideoAreaPages();
      _scrollControllerAdd();
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
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

  Future<void> _category_change(DictInfoListData item) async {
    categoryCurrent.value = item.id ?? 0;
    videoPageData.clear();
    currentPage = 1;
    await getVideoPages();
    setState(() {});
  }

  Future<void> _year_change(int item) async {
    yearCurrent.value = item;
    videoPageData.clear();
    currentPage = 1;

    await getVideoPages();
    setState(() {});
  }

  Future<void> _area_change(DictInfoListData item) async {
    regionCurrent.value = item.id ?? 0;
    videoPageData.clear();
    currentPage = 1;
    await getVideoPages();
    setState(() {});
  }

  Widget _buildCategoryRow(String title, List<DictInfoListData> items) {
    return ValueListenableBuilder<int>(
      valueListenable: categoryCurrent,
      builder: (context, key, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Center(child: Text(title ?? "")),
              ...(items ?? [])
                  .map(
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
                                  : Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.color,
                          backgroundColor:
                              key == item.id
                                  ? const Color.fromRGBO(244, 244, 244, 1)
                                  : Colors.transparent,
                          isOutline: false,
                        ),
                        onTap: () => _category_change(item),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAreaRow(String title, List<DictInfoListData> items) {
    return ValueListenableBuilder<int>(
      valueListenable: regionCurrent,
      builder: (context, key, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Center(child: Text(title ?? "")),
              ...(items ?? [])
                  .map(
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
                                  : Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.color,
                          backgroundColor:
                              key == item.id
                                  ? const Color.fromRGBO(244, 244, 244, 1)
                                  : Colors.transparent,
                          isOutline: false,
                        ),
                        onTap: () => _area_change(item),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildYearRow(String title, List<int> items) {
    return ValueListenableBuilder<int>(
      valueListenable: yearCurrent,
      builder: (context, key, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Center(child: Text(title ?? "")),
              ...(items ?? []).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    child: TDTag(
                      item.toString() ?? "",
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
                      isOutline: false,
                    ),
                    onTap: () => _year_change(item),
                  ),
                ),
              ),
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
    await getVideoPages();
    if (disposed) {
      return;
    }
    setState(() {});
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
    debugPrint('loadMore');
    currentPage++;
    TDToast.showLoading(context: context, text: "加载中");
    await getVideoPages();
    TDToast.dismissLoading();
    if (disposed) {
      return;
    }
    setState(() {});
  }

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
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverToBoxAdapter(child: _buildDefaultSearchBar()),
              SliverStickyHeader(
                header: Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: EdgeInsets.only(
                    left: Layout.paddingL,
                    right: Layout.paddingR,
                    bottom: Layout.paddingB,
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      _buildCategoryRow('全部分类', categoryDictList),
                      _buildAreaRow('全部地区', areaDictList),
                      _buildYearRow("全部年份", years),
                    ],
                  ),
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
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
                ),
              ),
            ],
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget isShowContent() {
    if (videoPageData.isEmpty && isLoading == false) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: NoData(),
      );
    } else if (isLoading == false && videoPageData.isEmpty == false) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: VideoThree(videoPageData: videoPageData),
      );
    } else if (videoPageData.isEmpty && isLoading == true) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TDLoading(
          size: TDLoadingSize.small,
          icon: TDLoadingIcon.point,
          iconColor: const Color.fromRGBO(255, 162, 16, 1),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: NoData(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用 super.build
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: _buildContent(),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
