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
  // 定义swiperData
  SwiperData? swiperData;
  String inputText = '';
  List<TDTab> tabs = [];
  List<int> videoCategoryIds = [];
  final PageController pageController = PageController(initialPage: 0);
  bool disposed = false;
  bool isLogin = false;
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

  bool _isInitialized = false;
  bool _showLoading = true;

  // 缓存组件
  final Map<int, Widget> _tabContentCache = {};
  final Map<String, Widget> _swiperItemCache = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
    //等待三秒后执行    AppUpdater.checkUpdate();
    Future.delayed(const Duration(seconds: 3), () {
      AppUpdater.checkUpdate();
    });
  }

  @override
  void dispose() {
    disposed = true;
    _tabController.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    _tabContentCache.clear();
    _swiperItemCache.clear();
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      await getDictInfoPages();
      await getSwiperListByCategoryIds();
      await getAlbumListByCategoryIds();
      await noticeInfo();

      _tabController = TabController(length: tabs.length, vsync: this);
      _tabController.addListener(_handleTabSelection);

      // 初始化 RefreshController
      for (int i = 0; i < tabs.length; i++) {
        tabRefreshController.add(RefreshController());
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _showLoading = false;
        });

        if (noticeInfoData.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {});
        }
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    }
  }

  Future<void> getDictInfoPages() async {
    try {
      final response = await Api.getDictData({
        "types": ["video_category"],
      });
      final dictData = response.data as DictDataData;

      if (dictData.videoCategory != null) {
        category =
            dictData.videoCategory!
                .where((element) => element.parentId == null)
                .toList();
        videoCategoryIds = category.map((e) => e.id ?? 0).toList();
        tabs = category.map((e) => TDTab(text: e.name)).toList();
      }
    } catch (e) {
      debugPrint('获取视频分类数据失败: $e');
    }
  }

  Future<void> getSwiperListByCategoryIds() async {
    try {
      swiperMap = await Api.getSwiperListByCategoryIds(videoCategoryIds);
    } catch (e) {
      debugPrint('获取轮播图数据失败: $e');
    }
  }

  Future<void> getAlbumListByCategoryIds() async {
    try {
      albumMap = await Api.getAlbumListByCategoryIds(videoCategoryIds);
    } catch (e) {
      debugPrint('获取专辑数据失败: $e');
    }
  }

  Future<void> noticeInfo() async {
    try {
      final response = await Api.noticeInfo({
        "page": 1,
        "size": 1,
        "type": 637,
        "status": 1,
      });
      noticeInfoData = response.data?.list ?? [];
    } catch (e) {
      debugPrint('获取通知信息失败: $e');
    }
  }

  void message() {
    if (noticeInfoData.isEmpty) return;

    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // 关键：设置背景透明
          content: Card(
            color: Colors.white,
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(10),
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(noticeInfoData[0].title ?? ""),
                      const SizedBox(height: 10),
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
                    onTap: () => Navigator.of(context).pop(),
                    style: TDButtonStyle(
                      backgroundColor: const Color.fromRGBO(255, 95, 1, 1),
                      textColor: Colors.white,
                      radius: BorderRadius.circular(20),
                    ),
                  ),
                  GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Notice()),
                        ),
                    child: Text(
                      '查看更多',
                      style: TextStyle(color: TDTheme.of(context).fontGyColor4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onRefresh(int index) async {
    try {
      final categoryId = videoCategoryIds[index];

      // 清除缓存
      _tabContentCache.remove(categoryId);
      for (final key in _swiperItemCache.keys.where(
        (k) => k.startsWith('$categoryId-'),
      )) {
        _swiperItemCache.remove(key);
      }

      // 重新获取数据
      final results = await Future.wait([
        Api.getSwiperListByCategoryIds([categoryId]),
        Api.getAlbumListByCategoryIds([categoryId]),
      ]);

      final swiperResult = results[0] as Map<int, List<SwiperDataList>>;
      final albumResult = results[1] as Map<int, List<AlbumDataList>>;

      if (disposed) return;

      setState(() {
        swiperMap.remove(categoryId);
        swiperMap.addAll(swiperResult);
        albumMap.remove(categoryId);
        albumMap.addAll(albumResult);
      });

      tabRefreshController[index].refreshCompleted();
    } catch (e) {
      tabRefreshController[index].refreshFailed();
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging && mounted) {
      pageController.animateToPage(
        _tabController.index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Widget _buildDotsSwiper(int id) {
    final swiperList = swiperMap[id];
    if (swiperList == null || swiperList.isEmpty) {
      return SizedBox(
        height: 158,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[200],
          ),
        ),
      );
    }

    return Swiper(
      itemHeight: 158,
      autoplay: true,
      itemCount: swiperList.length,
      itemBuilder: (BuildContext context, int index) {
        final cacheKey = '$id-${swiperList[index].id}';
        if (!_swiperItemCache.containsKey(cacheKey)) {
          _swiperItemCache[cacheKey] = _buildSwiperItem(swiperList[index]);
        }
        return _swiperItemCache[cacheKey]!;
      },
    );
  }

  Widget _buildSwiperItem(SwiperDataList item) {
    return Card(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            TDImage(
              height: 158,
              width: double.infinity,
              fit: BoxFit.cover,
              imgUrl: item.image ?? '',
              errorWidget: const TDImage(
                width: double.infinity,
                fit: BoxFit.cover,
                assetUrl: 'assets/images/loading.gif',
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: Text(
                item.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () => Get.toNamed("/search"),
              child: Container(
                height: 36,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(245, 244, 247, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Color.fromRGBO(153, 153, 153, 1)),
                    SizedBox(width: 8),
                    Text(
                      '请输入关键字',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Color(0xFF979797),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Get.toNamed("/week"),
            child: SvgPicture.asset(
              'assets/images/zhou.svg',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_showLoading) {
      return const PageLoading();
    }

    if (!_isInitialized) {
      return const Center(child: Text('初始化失败'));
    }

    return Column(
      children: [
        // 顶部区域
        Container(
          width: double.infinity,
          height: 120,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(245, 224, 207, 1.0),
                Color.fromRGBO(245, 224, 207, 0.5),
                Color.fromRGBO(245, 224, 207, 0),
              ],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(_appBarOpacity),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildDefaultSearchBar(),
                SizedBox(
                  height: 35,
                  child: TabBar(
                    padding: const EdgeInsets.only(top: 2),
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    dividerHeight: 0,
                    indicator: GradientTabIndicator(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(250, 165, 49, 1),
                          Color.fromRGBO(254, 210, 71, 0),
                        ],
                      ),
                      height: 3.0,
                      radius: 4.0,
                    ),
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
        Flexible(flex: 1, child: _buildTabContent()),
      ],
    );
  }

  Widget _buildTabContent() {
    if (tabs.isEmpty) {
      return const Center(child: NoData());
    }

    return PageView(
      controller: pageController,
      onPageChanged: (pageViewIndex) {
        if (_tabController.index != pageViewIndex) {
          _tabController.animateTo(pageViewIndex);
        }
      },
      children: List.generate(tabs.length, (index) {
        final categoryId = category[index].id ?? 0;

        // 使用缓存
        if (!_tabContentCache.containsKey(categoryId)) {
          _tabContentCache[categoryId] = _buildTabPage(index);
        }

        return _tabContentCache[categoryId]!;
      }),
    );
  }

  Widget _buildTabPage(int index) {
    final categoryId = category[index].id ?? 0;

    // 确保有对应的RefreshController
    if (tabRefreshController.length <= index) {
      tabRefreshController.add(RefreshController());
    }

    return SmartRefresher(
      controller: tabRefreshController[index],
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () => onRefresh(index),
      child: ListView(
        padding: const EdgeInsets.only(
          top: 0,
          left: Layout.paddingL,
          right: Layout.paddingL,
        ),
        children: [
          SizedBox(height: 158, child: _buildDotsSwiper(categoryId)),
          Padding(
            padding: const EdgeInsets.only(top: Layout.paddingL),
            child: Column(
              children: _buildAlbumContentList(albumMap[categoryId] ?? []),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAlbumContentList(List<AlbumDataList> list) {
    return List.generate(
      list.length,
      (index) => Column(
        children: [
          _buildAlbumHeader(list[index]),
          _buildAlbumItemWidgetType(list[index], index),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAlbumItemWidgetType(AlbumDataList item, int index) {
    if (index % 2 == 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: HomeTwoVideo(videoPageData: item.list as List<dynamic>),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: HorizontalVideoList(videoPageData: item.list as List<dynamic>),
      );
    }
  }

  Widget _buildAlbumHeader(AlbumDataList album) {
    return SectionWithMore(
      title: album.title ?? "",
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

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;
    final newOpacity = (scrollOffset / 100).clamp(0.0, 0.8).toDouble();

    if (_appBarOpacity != newOpacity && mounted) {
      setState(() {
        _appBarOpacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body: _buildContent());
  }

  @override
  bool get wantKeepAlive => true;
}
