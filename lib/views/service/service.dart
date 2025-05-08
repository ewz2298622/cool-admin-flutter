import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/auto_height_page_view/auto_height_page_view.dart';
import '../../components/loading.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/video_category_entity.dart';
import '../../entity/video_live_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../style/color_styles.dart';
import '../../style/layout.dart';

class VideoService extends StatefulWidget {
  //接受路由传递过来的props id
  const VideoService({super.key});

  @override
  VideoServiceState createState() => VideoServiceState();
}

class VideoServiceState extends State<VideoService>
    with SingleTickerProviderStateMixin {
  // 提取常量
  static const _gradientColors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];
  static const _gradientStops = [0.2, 0.8];

  final ScrollController _scrollController = ScrollController();
  //
  TDBackTopStyle style = TDBackTopStyle.circle;
  var _futureBuilderFuture;
  var inputText = "";
  VideoCategoryData? categoryData;
  List<VideoPageDataList> videoPageData = [];
  bool disposed = false;
  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey();
  var currentValue = 1;
  var itemHeight = 90.0;
  final _demoScroller = ScrollController(initialScrollOffset: 278.5);
  final _sideBarController = TDSideBarController();
  static const threshold = 50;
  final PageController pageController = PageController(initialPage: 0);
  var lock = false;
  List<DictInfoListData> dictInfoListData = [];
  List<VideoLiveDataList> videoLiveData = [];
  final List<GlobalKey> globalKeyList = [];
  TabController? _tabController;

  Future<String> init() async {
    try {
      await getDictInfoPages();
      await getVideoLivePages();
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
      return "init success";
    }
  }

  Future<void> getDictInfoPages() async {
    try {
      dictInfoListData =
          (await Api.getDictInfoPages({
            "order": "orderNum",
            "sort": "desc",
            "typeId": 34,
          })).data ??
          [] as List<DictInfoListData>;
    } catch (e) {
      // 捕获并处理异常
      print('获取视频分类数据失败: $e');
    }
  }

  /// 初始化tab
  void _initTabController(int initialIndex) {
    _tabController = TabController(
      initialIndex: initialIndex,
      length: dictInfoListData.length,
      vsync: this,
    );
  }

  //根据入参筛选 dictInfoListData type 为 入参 的数据 并返回
  List<DictInfoListData> filterDictInfoListDataByType(int typeId) {
    return dictInfoListData
        .where((dictInfoListData) => dictInfoListData.typeId == typeId)
        .toList();
  }

  Future<void> getVideoLivePages() async {
    try {
      videoLiveData =
          (await Api.getVideoLivePages({"page": 1, "size": 9999})).data?.list ??
          [] as List<VideoLiveDataList>;
    } catch (e) {
      // 捕获并处理异常
      print('获取视频分类数据失败: $e');
    }
  }

  _sideBarControllerInit() {
    _demoScroller.addListener(() {
      if (lock) {
        return;
      }
      var scrollTop = _demoScroller.offset;
      var index = (scrollTop + threshold) ~/ itemHeight;

      if (currentValue != index) {
        setState(() {
          _sideBarController.selectTo(index);
        });
      }
    });
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
    _initTabController(0);
    _sideBarControllerInit();
  }

  ///获取个数
  int getCount(int index) {
    if (index == 0) {
      return 0;
    } else {
      int count = 0;
      for (var i = 0; i < index; i++) {
        List<VideoLiveDataList> list = filterVideoLiveDataList(
          dictInfoListData[i].id ?? 0,
        );
        count += list.length;
      }
      return count;
    }
  }

  Future<void> onSelected(int value) async {
    try {
      if (currentValue != value) {
        currentValue = value;
      }
    } catch (e) {
      debugPrint("onSelected error: $e");
    }
  }

  void onChanged(int value) {
    if (mounted) {
      setState(() {
        currentValue = value;
      });
    }
  }

  Widget getAnchor(DictInfoListData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: TDText(
              data.name ?? "",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(children: displayImageList(data)),
        ),
      ],
    );
  }

  //根据入参筛选 videoLiveData type 为 入参 的数据 并返回
  List<VideoLiveDataList> filterVideoLiveDataList(int type) {
    return videoLiveData.where((element) => element.type == type).toList();
  }

  List<Widget> displayImageList(DictInfoListData dictInfoListData) {
    List<VideoLiveDataList> list = filterVideoLiveDataList(
      dictInfoListData.id ?? 0,
    );

    return List<Widget>.generate(list.length, (i) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          //设置圆角
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            //颜色设置成 [[0xAEE1E1, 0.0], [0xD3E0DC, 0.3], [0xFCD1D1, 1.0]] 转成rgba
            colors: [
              Color.fromRGBO(174, 225, 225, 1.0),
              Color.fromRGBO(211, 224, 220, 1.0),
              Color.fromRGBO(252, 209, 209, 1.0),
            ],

            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: Container(
          height: 60,
          padding: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            //设置背景色白色
            color: ColorStyles.color_FFFFFF,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(229, 229, 229, 0.5),
                blurRadius: 10,
                offset: const Offset(2, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TDImage(
                  imgUrl: list[i].image ?? 'assets/img/empty.png',
                  type: TDImageType.roundedSquare,
                  width: 23,
                  height: 23,
                ),
                const SizedBox(width: 16),
                TDText(
                  list[i].title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAnchorSideBar(BuildContext context) {
    // 锚点用法
    final list = <SideItemProps>[];
    final pages = <Widget>[];
    for (var i = 0; i < dictInfoListData.length; i++) {
      globalKeyList.add(GlobalKey());
      list.add(
        SideItemProps(
          index: i,
          label: dictInfoListData[i].name ?? '',
          value: i,
        ),
      );
      pages.add(
        Container(key: globalKeyList[i], child: getAnchor(dictInfoListData[i])),
      );
    }

    var demoHeight = MediaQuery.of(context).size.height;
    _sideBarController.init(list);

    return Row(
      children: [
        Container(
          width: 110,
          //设置圆角
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.outline,
            value: currentValue,
            controller: _sideBarController,
            children:
                list
                    .map(
                      (ele) => TDSideBarItem(
                        label: ele.label ?? '',
                        badge: ele.badge,
                        value: ele.value,
                        icon: ele.icon,
                      ),
                    )
                    .toList(),
            onSelected: (int index) {
              pageController.jumpToPage(index);
            },
          ),
        ),
        Expanded(
          child: SizedBox(
            height: demoHeight,
            child: SingleChildScrollView(
              controller: _demoScroller,
              child: AutoHeightPageView(
                pageController: pageController,
                children: pages,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  Future<void> onRefresh() async {
    await init();
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
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Container(
              padding: EdgeInsets.only(
                left: Layout.paddingL,
                right: Layout.paddingR,
              ),
              child: Column(children: [_buildAnchorSideBar(context)]),
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
          ],
        ),
      ),
    );
  }
}
