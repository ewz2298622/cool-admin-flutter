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
  // 提取常量
  static const double _swiperHeight = 158.0;
  static const double _topBarHeight = 120.0;
  static const double _tabBarHeight = 35.0;
  static const double _searchBarHeight = 36.0;
  static const double _borderRadius = 5.0;
  static const double _searchBarBorderRadius = 20.0;
  static const Duration _tabAnimationDuration = Duration(milliseconds: 300);
  static const Duration _updateCheckDelay = Duration(seconds: 3);
  static const Color _selectedTabColor = Color.fromRGBO(252, 119, 66, 1);
  static const Color _searchBarBgColor = Color.fromRGBO(245, 244, 247, 1);
  static const Color _searchIconColor = Color.fromRGBO(153, 153, 153, 1);
  static const Color _searchTextColor = Color(0xFF979797);
  static const Color _buttonColor = Color.fromRGBO(255, 95, 1, 1);

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
    // 延迟检查更新，避免影响初始化性能
    Future.delayed(_updateCheckDelay, () {
      if (mounted) {
        AppUpdater.checkUpdate();
      }
    });
  }

  @override
  void dispose() {
    disposed = true;
    _tabController.dispose();
    pageController.dispose();
    _refreshController.dispose();
    // 释放所有 RefreshController
    for (final controller in tabRefreshController) {
      controller.dispose();
    }
    tabRefreshController.clear();
    _tabContentCache.clear();
    _swiperItemCache.clear();
    super.dispose();
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    
    try {
      // 先获取分类数据，因为后续操作依赖它
      await getDictInfoPages();
      
      if (!mounted || videoCategoryIds.isEmpty) {
        if (mounted) {
          setState(() {
            _showLoading = false;
          });
        }
        return;
      }

      // 并行加载其他数据，提高初始化速度
      await Future.wait([
        getSwiperListByCategoryIds(),
        getAlbumListByCategoryIds(),
        noticeInfo(),
      ]);

      if (!mounted) return;

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

        // 延迟显示通知，避免阻塞初始化
        if (noticeInfoData.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              message();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
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

    final notice = noticeInfoData.first;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = TDTheme.of(dialogContext);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  notice.summary ?? '',
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.fontGyColor2,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                TDButton(
                  text: '我知道了',
                  isBlock: true,
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: () => Navigator.of(dialogContext).pop(),
                  style: TDButtonStyle(
                    backgroundColor: const Color.fromRGBO(255, 95, 1, 1),
                    textColor: Colors.white,
                    radius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> onRefresh(int index) async {
    if (!mounted || index >= videoCategoryIds.length) {
      if (index < tabRefreshController.length) {
        tabRefreshController[index].refreshFailed();
      }
      return;
    }

    try {
      final categoryId = videoCategoryIds[index];

      // 清除缓存
      _tabContentCache.remove(categoryId);
      for (final key in _swiperItemCache.keys.where(
        (k) => k.startsWith('$categoryId-'),
      )) {
        _swiperItemCache.remove(key);
      }

      // 并行重新获取数据
      final results = await Future.wait([
        Api.getSwiperListByCategoryIds([categoryId]),
        Api.getAlbumListByCategoryIds([categoryId]),
      ]);

      if (!mounted) return;

      final swiperResult = results[0] as Map<int, List<SwiperDataList>>;
      final albumResult = results[1] as Map<int, List<AlbumDataList>>;

      setState(() {
        swiperMap.remove(categoryId);
        swiperMap.addAll(swiperResult);
        albumMap.remove(categoryId);
        albumMap.addAll(albumResult);
      });

      if (mounted && index < tabRefreshController.length) {
        tabRefreshController[index].refreshCompleted();
      }
    } catch (e) {
      debugPrint('onRefresh failed for index $index: $e');
      if (mounted && index < tabRefreshController.length) {
        tabRefreshController[index].refreshFailed();
      }
    }
  }

  void _handleTabSelection() {
    if (!mounted || !_tabController.indexIsChanging) return;
    
    pageController.animateToPage(
      _tabController.index,
      duration: _tabAnimationDuration,
      curve: Curves.ease,
    );
  }

  Widget _buildDotsSwiper(int id) {
    final swiperList = swiperMap[id];
    if (swiperList == null || swiperList.isEmpty) {
      return SizedBox(
        height: _swiperHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            color: Colors.grey[200],
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: Swiper(
        itemHeight: _swiperHeight,
        autoplay: true,
        itemCount: swiperList.length,
        itemBuilder: (BuildContext context, int index) {
          final cacheKey = '$id-${swiperList[index].id}';
          if (!_swiperItemCache.containsKey(cacheKey)) {
            _swiperItemCache[cacheKey] = _buildSwiperItem(swiperList[index]);
          }
          return _swiperItemCache[cacheKey]!;
        },
      ),
    );
  }

  Widget _buildSwiperItem(SwiperDataList item) {
    return RepaintBoundary(
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              TDImage(
                height: _swiperHeight,
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
                  borderRadius: BorderRadius.circular(_borderRadius),
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
      ),
    );
  }

  Widget _buildDefaultSearchBar() {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () => Get.toNamed("/search"),
                child: Container(
                  height: _searchBarHeight,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: _searchBarBgColor,
                    borderRadius: BorderRadius.circular(_searchBarBorderRadius),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: _searchIconColor),
                      const SizedBox(width: 8),
                      const Text(
                        '请输入关键字',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: _searchTextColor,
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
        RepaintBoundary(
          child: Container(
            width: double.infinity,
            height: _topBarHeight,
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
                    height: _tabBarHeight,
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
                      onTap: (index) {
                        pageController.animateToPage(
                          index,
                          duration: _tabAnimationDuration,
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                ],
              ),
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

    final albumList = albumMap[categoryId] ?? [];

    return SmartRefresher(
      controller: tabRefreshController[index],
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () => onRefresh(index),
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 0,
          left: Layout.paddingL,
          right: Layout.paddingL,
        ),
        itemCount: albumList.length + 1, // +1 for swiper
        itemBuilder: (context, itemIndex) {
          if (itemIndex == 0) {
            // 第一个是轮播图
            return SizedBox(
              height: _swiperHeight,
              child: _buildDotsSwiper(categoryId),
            );
          }
          
          // 专辑内容
          final albumIndex = itemIndex - 1;
          final album = albumList[albumIndex];
          
          return RepaintBoundary(
            key: ValueKey('album_${album.id}_$itemIndex'),
            child: Column(
              children: [
                if (albumIndex > 0) 
                  const SizedBox(height: Layout.paddingL)
                else
                  const SizedBox(height: Layout.paddingL),
                _buildAlbumHeader(album),
                _buildAlbumItemWidgetType(album, albumIndex),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        addSemanticIndexes: false,
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


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body: _buildContent());
  }

  @override
  bool get wantKeepAlive => true;
}
