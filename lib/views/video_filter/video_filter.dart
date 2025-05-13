import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
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
    with SingleTickerProviderStateMixin {
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

  Future<void> getVideoPages() async {
    try {
      Map<String, dynamic>? data = {"page": currentPage};
      //使用查找categoryOriginalDictList中parentId等于category_id的数据并返回
      late List<DictInfoListData> category =
          categoryOriginalDictList
              .where((element) => element.parentId == categoryCurrent.value)
              .toList();
      data = {
        "page": currentPage,
        "category_id": category.isEmpty ? null : category[0].id,
        "year": yearCurrent.value == 0 ? null : yearCurrent.value,
        "region": regionCurrent.value == 0 ? null : regionCurrent.value,
      };

      List<VideoPageDataList> list =
          (await Api.getVideoPages(data)).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageData = [...videoPageData, ...list];
      debugPrint(
        'getVideoPages success data ${categoryData!.list?[categoryCurrent.value]}',
      );
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoListByCategoryIds failed: $e');
    }
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
    _futureBuilderFuture = init();
    super.initState();
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
    TDToast.showLoading(context: context, text: "加载中");
    await getVideoPages();
    TDToast.dismissLoading();
    setState(() {});
  }

  Future<void> _year_change(int item) async {
    yearCurrent.value = item;
    videoPageData.clear();
    currentPage = 1;
    TDToast.showLoading(context: context, text: "加载中");
    await getVideoPages();
    TDToast.dismissLoading();
    setState(() {});
  }

  Future<void> _area_change(DictInfoListData item) async {
    regionCurrent.value = item.id ?? 0;
    videoPageData.clear();
    currentPage = 1;
    TDToast.showLoading(context: context, text: "加载中");
    await getVideoPages();
    TDToast.dismissLoading();
    setState(() {});
  }

  Widget _buildCategoryRow(String title, List<DictInfoListData> items) {
    return ValueListenableBuilder<int>(
      valueListenable: categoryCurrent,
      builder: (context, key, child) {
        return Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Center(child: Text(title ?? "")),
                ),
                ...(items ?? [])
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TDButton(
                          text: item.name ?? "",
                          size: TDButtonSize.small,
                          style: TDButtonStyle(
                            backgroundColor:
                                key == item.id
                                    ? const Color.fromRGBO(249, 174, 61, 1)
                                    : Colors.transparent,
                            textColor:
                                key == item.id ? Colors.white : Colors.black,
                          ),
                          onTap: () => _category_change(item),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAreaRow(String title, List<DictInfoListData> items) {
    return ValueListenableBuilder<int>(
      valueListenable: regionCurrent,
      builder: (context, key, child) {
        return Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Center(child: Text(title ?? "")),
                ),
                ...(items ?? [])
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TDButton(
                          text: item.name ?? "",
                          size: TDButtonSize.small,
                          style: TDButtonStyle(
                            backgroundColor:
                                key == item.id
                                    ? const Color.fromRGBO(249, 174, 61, 1)
                                    : Colors.transparent,
                            textColor:
                                key == item.id ? Colors.white : Colors.black,
                          ),
                          onTap: () => _area_change(item),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearRow(String title, List<int> items) {
    return ValueListenableBuilder<int>(
      valueListenable: yearCurrent,
      builder: (context, key, child) {
        return Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Center(child: Text(title ?? "")),
                ),
                ...(items ?? [])
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TDButton(
                          text: item.toString() ?? "",
                          size: TDButtonSize.small,
                          style: TDButtonStyle(
                            backgroundColor:
                                key == item
                                    ? const Color.fromRGBO(249, 174, 61, 1)
                                    : Colors.transparent,
                            textColor:
                                key == item ? Colors.white : Colors.black,
                          ),
                          onTap: () => _year_change(item),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
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

  Widget _buildCircleBackTop() {
    //定位到页面的右下角
    return Positioned(
      right: 20,
      bottom: 20,
      child: TDButton(
        width: 70,
        height: 70,
        shape: TDButtonShape.circle,
        style: TDButtonStyle(
          //设置透明背景色
          backgroundColor: Colors.transparent,
        ),
        // iconWidget: const Icon(Icons.arrow_upward),
        //设置本地图片为icon
        iconWidget: Image.asset(
          'assets/images/backTop.png',
          width: 50,
          height: 50,
        ),
        onTap: () {
          setState(() {
            showBackTop = true;
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            }
            style = TDBackTopStyle.circle;
          });
        },
      ),
    );
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
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Container(
              padding: EdgeInsets.only(
                left: Layout.paddingL,
                right: Layout.paddingR,
              ),
              child: Column(
                spacing: 10,
                children: [
                  _buildDefaultSearchBar(),
                  _buildCategoryRow('全部分类', categoryDictList),
                  _buildAreaRow('全部地区', areaDictList),
                  _buildYearRow("全部年份", years),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: VideoThree(videoPageData: videoPageData),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20, backgroundColor: _gradientColors[0]),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: _gradientStops,
                  colors: _gradientColors,
                ),
              ),
              child: _buildContent(),
            ),
            _buildCircleBackTop(),
          ],
        ),
      ),
    );
  }
}
