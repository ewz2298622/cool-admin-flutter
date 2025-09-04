// second_page.dart
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/home_two_video.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../components/sectionWithMore.dart';
import '../../components/video_scroll.dart';
import '../../entity/album_entity.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../../entity/swiper_entity.dart';
import '../../style/layout.dart';
import '../../utils/appUpdater.dart';
import '../album/album.dart';
import '../notice/notice.dart';

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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //定义swiperData
  SwiperData? swiperData;
  String inputText = '';
  List<TDTab> tabs = [];
  List<int> videoCategoryIds = [];
  final PageController pageController = PageController(initialPage: 0);
  bool disposed = false;
  bool isLogin = false;
  var _futureBuilderFuture;
  List<DictInfoListData> dictInfoListData = [];

  Map<int, List<SwiperDataList>> swiperMap = {};
  Map<int, List<AlbumDataList>> albumMap = {};
  List<NoticeInfoDataList> noticeInfoData = [];

  List<DictDataDataVideoCategory> category = [];
  List<RefreshController> tabRefreshController = [];

  // 添加 TabController
  late TabController _tabController;

  // 添加滚动监听相关变量
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0; // AppBar透明度

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  Future<void> getDictInfoPages() async {
    try {
      category =
          ((await Api.getDictData({
                    "types": ["video_category"],
                  })).data
                  as DictDataData)
              .videoCategory!;

      category = category.where((element) => element.parentId == null).toList();

      videoCategoryIds = category.map((e) => e.id ?? 0).toList();
      tabs.clear();
      for (var element in category) {
        tabs.add(TDTab(text: element.name));
      }
    } catch (e) {
      // 捕获并处理异常
      print('获取视频分类数据失败: $e');
    }
  }

  Future<void> getSwiperListByCategoryIds() async {
    try {
      swiperMap = await Api.getSwiperListByCategoryIds(videoCategoryIds);
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
    }
  }

  Future<void> getAlbumListByCategoryIds() async {
    try {
      albumMap = await Api.getAlbumListByCategoryIds(videoCategoryIds);
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    // 添加滚动监听器
    _scrollController.addListener(_onScroll);
    AppUpdater.checkUpdate();
    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
    _tabController.dispose(); // 释放 TabController
    _scrollController.dispose(); // 释放 ScrollController
    _refreshController.dispose(); // 释放 RefreshController
    super.dispose();
  }

  Future<String> init() async {
    try {
      await getDictInfoPages();
      await getSwiperListByCategoryIds();
      await getAlbumListByCategoryIds();
      noticeInfo();
      // 初始化 TabController
      _tabController = TabController(length: tabs.length, vsync: this);
      // 添加监听器以同步 PageView 和 TabBar
      _tabController.addListener(_handleTabSelection);

      //判斷noticeInfoData是否有數據
      if (noticeInfoData.isNotEmpty) {
        message();
      }
      return "init success";
    } catch (e) {
      return "init err";
    }
  }

  // 数据加载逻辑分离
  Future<void> noticeInfo() async {
    try {
      List<NoticeInfoDataList> list =
          (await Api.noticeInfo({
                "page": 1,
                "size": 1,
                "type": 637,
                "status": 1,
              })).data?.list
              as List<NoticeInfoDataList>;
      noticeInfoData = list;
    } catch (e) {
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  message() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // 动态宽度
            height: 250, // 固定高度
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 10,
                  children: [
                    Text(noticeInfoData[0].title ?? ""),
                    Text(
                      noticeInfoData[0].summary ?? "",
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: TDTheme.of(context).fontGyColor2,
                      ),
                    ),
                  ],
                ),
                TDButton(
                  text: '我知道了',
                  isBlock: true,
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: () {
                    Navigator.of(context).pop(); //退出弹出框
                  },
                  style: TDButtonStyle(
                    backgroundColor: Color.fromRGBO(255, 95, 1, 1),
                    textColor: Colors.white,
                    radius: BorderRadius.circular(20),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    '查看更多',
                    style: TextStyle(color: TDTheme.of(context).fontGyColor4),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notice()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> onRefresh(int index) async {
    try {
      // 只刷新当前分类的数据
      final categoryId = videoCategoryIds[index];

      // 清除当前分类的数据
      swiperMap.remove(categoryId);
      albumMap.remove(categoryId);

      // 重新获取当前分类的数据
      final swiperData = await Api.getSwiperListByCategoryIds([categoryId]);
      final albumData = await Api.getAlbumListByCategoryIds([categoryId]);

      if (disposed) {
        return;
      }

      // 更新数据
      swiperMap.addAll(swiperData);
      albumMap.addAll(albumData);

      setState(() {});
      tabRefreshController[index].refreshCompleted();
    } catch (e) {
      tabRefreshController[index].refreshFailed();
    }
  }

  // 处理 Tab 选择事件
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      pageController.animateToPage(
        _tabController.index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  /// 轮播图视图
  Widget _buildDotsSwiper(int id) {
    super.build(context); // 必须调用 super.build
    return Swiper(
      itemHeight: 158,
      autoplay: true,
      itemCount: (swiperMap[id]?.length) ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            //5px圆角
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              TDImage(
                height: 158,
                width: double.infinity,
                fit: BoxFit.cover,
                imgUrl: swiperMap[id]?[index].image ?? '',
                errorWidget: const TDImage(
                  //宽度100%
                  width: double.infinity,
                  fit: BoxFit.cover,
                  assetUrl: 'assets/images/loading.gif',
                ),
              ),
              Container(
                height: 158,
                width: double.infinity,
                //向下对其
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), // 添加圆角
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, // 顶部透明
                      Colors.black.withOpacity(0.6), // 底部黑色
                    ],
                  ),
                ),
                child: Text(
                  swiperMap[id]![index].title ?? "",
                  maxLines: 1,
                  //溢出省略号
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left, // 改为左对齐
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          GestureDetector(
            child: Container(
              height: 36,
              //宽度设置成百分之80%
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(245, 244, 247, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.search, color: Color.fromRGBO(153, 153, 153, 1)),
                  Text(
                    '请输入关键字',
                    style: TextStyle(
                      fontFamily: 'PingFang SC', // iOS 默认支持，Android 需确保字体可用
                      fontWeight: FontWeight.w500, // 对应 500
                      fontSize: 14.0, // 14px
                      color: Color(0xFF979797), // #979797
                      fontStyle: FontStyle.normal, // 正常样式
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => Get.toNamed("/search"),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: GestureDetector(
                onTap: () => Get.toNamed("/week"),
                //渲染svg
                // child: SvgPicture.asset('assets/images/zhou.svg'),
                //设置SvgPicture宽高
                child: SvgPicture.asset(
                  'assets/images/zhou.svg',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent(BuildContext context) {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        debugPrint('snapshot: ${snapshot.hasData}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.hasData) {
          return _buildTabs(context);
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Column(
      children: [
        // 顶部搜索栏和TabBar部分 - 使用固定高度
        Container(
          width: double.infinity,
          height: 120, // 改回固定高度，避免过大空白
          decoration: BoxDecoration(
            //从上到下的线性渐变
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(252, 214, 67, 1.0), // 顶部颜色
                Color.fromRGBO(252, 214, 67, 0.5), // 中间颜色
                Color.fromRGBO(252, 214, 67, 0), // 底部透明
              ],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(_appBarOpacity),
            ),
            child: Column(
              children: [
                SizedBox(height: 40),
                _buildDefaultSearchBar(),
                SizedBox(
                  height: 35,
                  child: TabBar(
                    padding: EdgeInsets.only(top: 2),
                    controller: _tabController, // 使用 controller
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,

                    dividerHeight: 0,
                    indicator: GradientTabIndicator(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(250, 165, 49, 1), // 完全不透明的橙色
                          Color.fromRGBO(254, 210, 71, 0), // 完全透明（alpha=0）
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
                    unselectedLabelColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,

                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    tabs: tabs,
                    onTap: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // 内容区域
        Expanded(child: contentIsEmpty(context)),
      ],
    );
  }

  //判断是否为空
  Widget contentIsEmpty(BuildContext context) {
    if (tabs.isEmpty) {
      return Center(child: NoData());
    }

    return PageView(
      controller: pageController,
      onPageChanged: (pageViewIndex) {
        _tabController.animateTo(pageViewIndex);
      },
      children: List.generate(tabs.length, (index) {
        // 确保每个tab都有对应的RefreshController
        while (tabRefreshController.length <= index) {
          tabRefreshController.add(RefreshController());
        }

        return SmartRefresher(
          controller: tabRefreshController[index],
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: () async {
            debugPrint('onRefresh: $index');
            await onRefresh(index);
          },
          child: ListView(
            padding: EdgeInsets.only(
              top: 20, // 原始值20，保持适当间距
              left: Layout.paddingL,
              right: Layout.paddingL,
            ),
            children: [
              SizedBox(
                height: 158,
                child: _buildDotsSwiper(category[index].id ?? 0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: Layout.paddingL),
                child: Column(
                  children: _buildAlbumContentList(
                    albumMap[category[index].id] ?? [],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).unfocus(); // 移除焦点
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body: _buildContent(context));
  }

  List<Widget> _buildAlbumContentList(List<AlbumDataList> list) {
    return List<Widget>.generate(
      list.length,
      (index) => Column(
        spacing: 16,
        children: [
          _buildAlbumHeader(list[index]),
          _buildAlbumItemWidgetType(list[index], index),
        ],
      ),
    );
  }

  Widget _buildAlbumItemWidgetType(AlbumDataList item, int index) {
    if (index % 2 == 0) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: HomeTwoVideo(videoPageData: item.list as List<dynamic>),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: HorizontalVideoList(videoPageData: item.list as List<dynamic>),
      );
    }
  }

  Widget _buildAlbumHeader(AlbumDataList album) {
    return SectionWithMore(
      title: album.title ?? "", // 传入标题
      onMorePressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoAlbum(id: album.id ?? 0),
          ),
        );
      },
    );
  }

  // 处理滚动事件
  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    // 根据滚动位置计算透明度 (0-0.8)
    final newOpacity = (scrollOffset / 100).clamp(0.0, 0.8);

    if (_appBarOpacity != newOpacity) {
      setState(() {
        _appBarOpacity = newOpacity;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
