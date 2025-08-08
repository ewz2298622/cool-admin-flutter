// // second_page.dart
//
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/home_two_video.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../components/video_scroll.dart';
import '../../entity/album_entity.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../../entity/swiper_entity.dart';
import '../../style/layout.dart';
import '../album/album.dart';
import '../notice/notice.dart';
import '../search/search.dart';
import '../week/week.dart';

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
  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey();
  final PageController pageController = PageController(initialPage: 0);
  bool disposed = false;
  bool isLogin = false;
  var _futureBuilderFuture;
  List<DictInfoListData> dictInfoListData = [];

  Map<int, List<SwiperDataList>> swiperMap = {};
  Map<int, List<AlbumDataList>> albumMap = {};
  List<NoticeInfoDataList>? noticeInfoData = [];

  List<DictDataDataVideoCategory> category = [];

  // 添加 TabController
  late TabController _tabController;

  // 添加滚动监听相关变量
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0; // AppBar透明度

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
    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
    _tabController.dispose(); // 释放 TabController
    _scrollController.dispose(); // 释放 ScrollController
    super.dispose();
  }

  Future<String> init() async {
    try {
      await getDictInfoPages();
      await getSwiperListByCategoryIds();
      await getAlbumListByCategoryIds();
      await noticeInfo();

      // 初始化 TabController
      _tabController = TabController(length: tabs.length, vsync: this);
      // 添加监听器以同步 PageView 和 TabBar
      _tabController.addListener(_handleTabSelection);

      //判斷noticeInfoData是否有數據
      if (noticeInfoData?.isNotEmpty ?? false) {
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
                    Text(noticeInfoData?[0].title ?? ""),
                    Text(
                      noticeInfoData?[0].summary ?? "",
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

  Future<void> onRefresh() async {
    swiperMap.clear();
    albumMap.clear();
    tabs.clear();
    await getDictInfoPages();
    await getSwiperListByCategoryIds();
    await getAlbumListByCategoryIds();
    if (disposed) {
      return;
    }
    // 重新初始化 TabController
    _tabController.dispose();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    setState(() {});
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
      autoplay: true,
      itemCount: (swiperMap[id]?.length) ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            TDImage(
              height: double.infinity,
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
              height: double.infinity,
              width: double.infinity,
              //向下对其
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
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
        );
      },
    );
  }

  Widget _buildDefaultSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          SizedBox(
            height: 36,
            //宽度设置成百分之80%
            width: MediaQuery.of(context).size.width * 0.8,
            child: SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.4),
                  ),
                  hintText: '搜索...',
                  hintStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.white),
                  ),
                  trailing: [
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                  onTap: () {
                    //打印
                    print('点击了搜索');
                    // 直接在这里跳转
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoSearch()),
                    );
                  },
                );
              },
              suggestionsBuilder: (context, controller) {
                return [ListTile(title: Text('建议项'))];
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeekPage()),
                );
              },
              child: Center(child: Text("更新")),
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
    return Stack(
      fit: StackFit.passthrough,
      children: [
        PageView(
          controller: pageController,
          onPageChanged: (index) {
            _tabController.animateTo(index);
          },
          children: List.generate(tabs.length, (index) {
            return ListView(
              controller: _scrollController, // 添加控制器
              padding: EdgeInsets.only(top: 0),
              children: [
                SizedBox(
                  height: 250,
                  child: _buildDotsSwiper(category[index].id ?? 0),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Layout.paddingL,
                    right: Layout.paddingL,
                    left: Layout.paddingL,
                  ),
                  child: Column(
                    children: _buildAlbumContentList(
                      albumMap[category[index].id] ?? [],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        SizedBox(
          height: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(_appBarOpacity),
              //添加白色外阴影
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3), // 降低透明度（0.0 ~ 1.0）
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0,
                ),
              ],
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
                          Color.fromRGBO(255, 153, 0, 1), // 完全不透明的橙色
                          Color.fromRGBO(255, 153, 0, 0), // 完全透明（alpha=0）
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
      ],
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
    return _buildContent(context);
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
