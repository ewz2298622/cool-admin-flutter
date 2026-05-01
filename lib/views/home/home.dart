// home.dart
import 'dart:core';
import 'dart:async';

// Flutter 核心库
import 'package:flutter/material.dart';

// 第三方库
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// 本地文件
import '../../api/api.dart';
import '../../components/build_swiper_item.dart';
import '../../components/common/common_search_bar.dart';
import '../../components/home_two_video.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../components/section_with_more.dart';
import '../../components/video_scroll.dart';
import '../../entity/album_entity.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../../entity/swiper_entity.dart';
import '../../utils/routes.dart';
import '../../services/home_prefetch_service.dart';
import '../../style/layout.dart';
import '../../utils/app_updater.dart';
import '../../utils/color.dart';
import '../../utils/context_manager.dart';
import '../../store/home/color_notifier.dart';

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

/**
 * 首页页面组件
 * 包含轮播图、分类标签、视频专辑列表等内容
 */
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提取常量
  // 布局常量
  static const double _swiperHeight = 208.0;
  static const double _tabBarHeight = 35.0;
  static const double _borderRadius = 5.0;
  static const Duration _tabAnimationDuration = Duration(milliseconds: 300);
  static const Duration _updateCheckDelay = Duration(seconds: 10);
  static const Color _selectedTabColor = Color.fromRGBO(252, 119, 66, 1);
  
  // 轮播图配置
  static const int _swiperAutoplayDelay = 4000;
  
  // 分页器配置
  static const double _paginationSize = 4.0;
  static const double _paginationSpace = 2.0;
  static const double _paginationRoundedRectangleWidth = 12.0;
  // Color _primaryColor = Color.fromRGBO(252, 119, 66, 1); // 已移至ColorNotifier

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

  // 当前活动的 tab 索引
  int _currentTabIndex = 0;

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
    // 延迟检查更新，确保页面已完全构建且 context 已设置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(_updateCheckDelay, () {
        if (mounted) {
          AppUpdater.checkUpdate();
        }
      });
    });
  }

  @override
  void dispose() {
    disposed = true;
    // 移除 TabController 的监听器
    _tabController.removeListener(_handleTabSelection);
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

/**
 * 初始化页面数据
 * 从 HomePrefetchService 获取预加载数据，应用到页面中
 */
  Future<void> _initializeData() async {
    if (!mounted) return;

    try {
      debugPrint('开始初始化首页数据');
      HomePrefetchData? data = HomePrefetchService.instance.cachedData;

      if (data == null || !data.isValid) {
        debugPrint('缓存数据无效，开始预加载数据');
        // 预加载数据，使用 timeout 防止长时间阻塞
        data = await HomePrefetchService.instance.preload().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            debugPrint('预加载数据超时');
            return null;
          },
        );
        debugPrint('预加载数据完成');
      } else {
        debugPrint('使用缓存数据');
      }

      if (!mounted) return;

      if (data == null || !data.isValid) {
        debugPrint('数据加载失败，显示错误状态');
        if (mounted) {
          setState(() {
            _isInitialized = false;
            _showLoading = false;
          });
        }
        return;
      }

      _applyPrefetchedData(data);
      _setupTabInfrastructure();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _showLoading = false;
        });
      }

      debugPrint('首页数据初始化完成');

      if (noticeInfoData.isNotEmpty && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            message();
          }
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Initialization error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _showLoading = false;
        });
      }
    }
  }

/**
 * 应用预加载数据
 * 将预加载的数据应用到页面状态中
 * @param data 预加载的数据对象
 */
  void _applyPrefetchedData(HomePrefetchData data) {
    category = data.categories;
    videoCategoryIds = data.videoCategoryIds;
    tabs = category
        .map((e) => TDTab(text: e.name ?? ''))
        .toList(growable: false);
    swiperMap = Map<int, List<SwiperDataList>>.from(data.swiperMap);
    albumMap = Map<int, List<AlbumDataList>>.from(data.albumMap);
    noticeInfoData = List<NoticeInfoDataList>.from(data.noticeInfo);
  }

/**
 * 设置标签页基础设施
 * 初始化 TabController 和 RefreshController
 */
  void _setupTabInfrastructure() {
    if (tabs.isEmpty) {
      return;
    }

    if (tabRefreshController.isNotEmpty) {
      for (final controller in tabRefreshController) {
        controller.dispose();
      }
      tabRefreshController.clear();
    }

    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);

    for (int i = 0; i < tabs.length; i++) {
      tabRefreshController.add(RefreshController());
    }
  }

  Future<void> getDictInfoPages() async {
    try {
      debugPrint('开始获取视频分类数据');
      final response = await Api.getDictData({
        "types": ["video_category"],
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('获取视频分类数据超时');
          throw TimeoutException('获取视频分类数据超时');
        },
      );
      final dictData = response.data as DictDataData;

      if (dictData.videoCategory != null) {
        category =
            dictData.videoCategory!
                .where((element) => element.parentId == null)
                .toList();
        videoCategoryIds = category.map((e) => e.id ?? 0).toList();
        tabs = category.map((e) => TDTab(text: e.name ?? '')).toList();
        debugPrint('获取视频分类数据成功，共 ${category.length} 个分类');
      }
    } catch (e, stackTrace) {
      debugPrint('获取视频分类数据失败: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> getSwiperListByCategoryIds() async {
    try {
      debugPrint('开始获取轮播图数据');
      swiperMap = await Api.getSwiperListByCategoryIds(videoCategoryIds).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('获取轮播图数据超时');
          return <int, List<SwiperDataList>>{};
        },
      );
      debugPrint('获取轮播图数据成功');
    } catch (e, stackTrace) {
      debugPrint('获取轮播图数据失败: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> getAlbumListByCategoryIds() async {
    try {
      debugPrint('开始获取专辑数据');
      albumMap = await Api.getAlbumListByCategoryIds(videoCategoryIds).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('获取专辑数据超时');
          return <int, List<AlbumDataList>>{};
        },
      );
      debugPrint('获取专辑数据成功');
    } catch (e, stackTrace) {
      debugPrint('获取专辑数据失败: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> noticeInfo() async {
    try {
      debugPrint('开始获取通知信息');
      final response = await Api.noticeInfo({
        "page": 1,
        "size": 1,
        "type": 637,
        "status": 1,
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('获取通知信息超时');
          throw TimeoutException('获取通知信息超时');
        },
      );
      noticeInfoData = response.data?.list ?? [];
      debugPrint('获取通知信息成功，共 ${noticeInfoData.length} 条');
    } catch (e, stackTrace) {
      debugPrint('获取通知信息失败: $e');
      debugPrint('Stack trace: $stackTrace');
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

/**
 * 刷新指定标签页的数据
 * @param index 标签页索引
 */
  Future<void> onRefresh(int index) async {
    if (!mounted || index >= videoCategoryIds.length) {
      if (index < tabRefreshController.length) {
        tabRefreshController[index].refreshFailed();
      }
      return;
    }

    try {
      final categoryId = videoCategoryIds[index];
      debugPrint('开始刷新分类 $categoryId 的数据');

      // 并行重新获取数据，添加超时处理
      final results = await Future.wait([
        Api.getSwiperListByCategoryIds([categoryId]).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            debugPrint('轮播图数据获取超时');
            return <int, List<SwiperDataList>>{};
          },
        ),
        Api.getAlbumListByCategoryIds([categoryId]).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            debugPrint('专辑数据获取超时');
            return <int, List<AlbumDataList>>{};
          },
        ),
      ]);

      if (!mounted) {
        if (index < tabRefreshController.length) {
          tabRefreshController[index].refreshFailed();
        }
        return;
      }

      // 清除缓存
      _tabContentCache.remove(categoryId);
      final keysToRemove = _swiperItemCache.keys.where(
        (k) => k.startsWith('$categoryId-'),
      ).toList();
      for (final key in keysToRemove) {
        _swiperItemCache.remove(key);
      }

      final swiperResult = results[0] as Map<int, List<SwiperDataList>>;
      final albumResult = results[1] as Map<int, List<AlbumDataList>>;

      if (mounted) {
        setState(() {
          swiperMap.remove(categoryId);
          swiperMap.addAll(swiperResult);
          albumMap.remove(categoryId);
          albumMap.addAll(albumResult);
        });
      }

      if (mounted && index < tabRefreshController.length) {
        tabRefreshController[index].refreshCompleted();
        debugPrint('分类 $categoryId 的数据刷新成功');
      }
    } catch (e, stackTrace) {
      debugPrint('onRefresh failed for index $index: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted && index < tabRefreshController.length) {
        tabRefreshController[index].refreshFailed();
      }
    }
  }

/**
 * 处理标签页选择事件
 * 当用户选择标签页时，更新当前标签页索引并切换到对应的页面
 */
  void _handleTabSelection() {
    if (!mounted || !_tabController.indexIsChanging) return;

    // 更新当前选中的tab索引
    setState(() {
      _currentTabIndex = _tabController.index;
    });

    // 切换tab后，主动寻找当前轮播图对象并重新调用getColor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshCurrentSwiperColor();
    });

    pageController.animateToPage(
      _tabController.index,
      duration: _tabAnimationDuration,
      curve: Curves.ease,
    );
  }

/**
 * 刷新当前轮播图的颜色
 * 当标签页切换时，更新当前标签页轮播图的颜色
 */
  void _refreshCurrentSwiperColor() {
    if (!mounted || _currentTabIndex >= category.length) return;

    int currentCategoryId = category[_currentTabIndex].id ?? 0;
    List<SwiperDataList>? swiperList = swiperMap[currentCategoryId];

    if (swiperList != null && swiperList.isNotEmpty) {
      // 确保使用第一个轮播项的颜色作为当前tab的颜色
      String color = swiperList[0].color ?? "";
      if (color.isNotEmpty) {
        updatePrimaryColor(color, context);
      }
    }
  }

  Widget _buildDotsSwiper(int id) {
    final swiperList = swiperMap[id];
    if (swiperList == null || swiperList.isEmpty) {
      return Container(
        height: _swiperHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          color: Colors.grey[200],
        ),
      );
    }

    return Consumer<ColorNotifier>(
      builder: (context, colorNotifier, child) {
        // 获取当前swiper所属的分类索引
        int tabIndex = category.indexWhere((cat) => cat.id == id);

        return Container(
          height: _swiperHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Swiper(
              itemHeight: _swiperHeight,
              autoplay: true,
              // 添加性能优化参数
              autoplayDelay: _swiperAutoplayDelay, // 设置自动播放间隔，降低频率减少性能消耗
              // 移除左右分页器
              // 优化重建
              loop: true,
              // 限制预加载数量，避免过多资源消耗
              itemCount: swiperList.length,
              itemBuilder: (BuildContext context, int index) {
                final cacheKey = '$id-${swiperList[index].id}';
                if (!_swiperItemCache.containsKey(cacheKey)) {
                  // 使用缓存优化，避免重复构建
                  _swiperItemCache[cacheKey] = SwiperItemComponent(
                    item: swiperList[index],
                    borderRadius: _borderRadius,
                  );
                }
                return _swiperItemCache[cacheKey]!;
              },

              ///TODO: 添加图片主色调
              onIndexChanged: (index) {
                // 只有当这个swiper所属的tab是当前激活的tab时才执行颜色获取
                if (tabIndex == _currentTabIndex) {
                  final currentItem = swiperList[index];
                  // 提取图片的主色调 - 优化性能，防止重复计算
                  updatePrimaryColor(currentItem.color ?? "", context);
                }
              },

              // 添加指示器配置 - 居右显示，缩小尺寸
              pagination: const SwiperPagination(
                alignment: Alignment.bottomRight,
                builder: TDSwiperDotsPagination(
                  size: _paginationSize,
                  activeSize: _paginationSize,
                  space: _paginationSpace,
                  roundedRectangleWidth: _paginationRoundedRectangleWidth,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void updatePrimaryColor(String colorString, BuildContext context) {
    // 使用防抖机制，避免频繁计算
    if (mounted) {
      final colorNotifier = Provider.of<ColorNotifier>(context, listen: false);
      colorNotifier.updatePrimaryColor(HexColor(colorString));
    }
  }

  Widget _buildDefaultSearchBar() {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: CommonSearchBar(onTap: () => Get.toNamed(AppRoutes.search)),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.week),
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    if (_showLoading) {
      return const PageLoading();
    }

    if (!_isInitialized) {
      Get.toNamed("/connection_error");
      return Container();
    }

    return Column(
      children: [
        // 顶部区域
        _buildTopBar(statusBarHeight),
        // 内容区域
        Flexible(flex: 1, child: _buildTabContent()),
      ],
    );
  }

  Widget _buildTopBar(double statusBarHeight) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_appBarOpacity),
          ),
          child: Column(
            children: [
              SizedBox(height: statusBarHeight + 8),
              _buildDefaultSearchBar(),
              const SizedBox(height: 8),
              _buildTabBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabCount = tabs.length;
    // 计算每个tab的最小宽度，假设每个tab至少需要80像素
    const double minTabWidth = 80.0;
    // 计算当所有tab平均分布时需要的最小屏幕宽度
    final double requiredWidth = tabCount * minTabWidth;
    
    // 判断是否需要平均分布
    final bool shouldDistributeEvenly = screenWidth >= requiredWidth;

    return SizedBox(
      height: _tabBarHeight,
      child: TabBar(
        padding: const EdgeInsets.only(top: 2),
        controller: _tabController,
        isScrollable: !shouldDistributeEvenly,
        tabAlignment: shouldDistributeEvenly ? TabAlignment.fill : TabAlignment.center,
        dividerHeight: 0,
        indicator: _tabIndicator,
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
          // 更新当前选中的tab索引
          setState(() {
            _currentTabIndex = index;
          });

          pageController.animateToPage(
            index,
            duration: _tabAnimationDuration,
            curve: Curves.ease,
          );
        },
      ),
    );
  }

  GradientTabIndicator get _tabIndicator {
    return const GradientTabIndicator(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(250, 165, 49, 1),
          Color.fromRGBO(254, 210, 71, 0),
        ],
      ),
      height: 3.0,
      radius: 4.0,
    );
  }

  Widget _buildTabContent() {
    if (tabs.isEmpty) {
      return const Center(child: NoData());
    }

    return PageView(
      controller: pageController,
      onPageChanged: (pageViewIndex) {
        // 更新当前选中的tab索引
        setState(() {
          _currentTabIndex = pageViewIndex;
        });

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
    _ensureRefreshController(index);

    final albumList = _filterAlbums(categoryId);

    return SmartRefresher(
      controller: tabRefreshController[index],
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () => onRefresh(index),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 0,
          left: Layout.paddingL,
          right: Layout.paddingL,
        ),
        itemCount: albumList.length + 1, // +1 for swiper
        itemBuilder: (context, itemIndex) => _buildTabPageItem(context, itemIndex, categoryId, albumList),
        addAutomaticKeepAlives: false, // 禁用keep-alive提高性能
        addRepaintBoundaries: false, // 禁用repaint边界提高性能
        addSemanticIndexes: false,
      ),
    );
  }

  void _ensureRefreshController(int index) {
    if (tabRefreshController.length <= index) {
      tabRefreshController.add(RefreshController());
    }
  }

  List<AlbumDataList> _filterAlbums(int categoryId) {
    return (albumMap[categoryId] ?? []).where((album) {
      final data = album.list;
      if (data == null) return false;
      return data.isNotEmpty;
    }).toList();
  }

  Widget _buildTabPageItem(BuildContext context, int itemIndex, int categoryId, List<AlbumDataList> albumList) {
    if (itemIndex == 0) {
      // 第一个是轮播图
      return _buildSwiperItem(categoryId);
    }

    // 专辑内容
    final albumIndex = itemIndex - 1;
    final album = albumList[albumIndex];
    final albumVideos = _extractAlbumVideos(album);
    
    if (albumVideos.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildAlbumItem(album, albumIndex, albumVideos);
  }

  Widget _buildSwiperItem(int categoryId) {
    return Padding(
      padding: const EdgeInsets.only(top: Layout.paddingL),
      child: SizedBox(
        height: _swiperHeight,
        child: _buildDotsSwiper(categoryId),
      ),
    );
  }

  List<dynamic> _extractAlbumVideos(AlbumDataList album) {
    return (album.list is List)
        ? List<dynamic>.from(album.list as List)
        : (album.list is Iterable)
        ? List<dynamic>.from(album.list as Iterable)
        : <dynamic>[];
  }

  Widget _buildAlbumItem(AlbumDataList album, int albumIndex, List<dynamic> albumVideos) {
    return RepaintBoundary(
      key: ValueKey('album_${album.id}_$albumIndex'),
      child: Column(
        children: [
          if (albumIndex > 0)
            const SizedBox(height: Layout.paddingL)
          else
            const SizedBox(height: Layout.paddingL),
          _buildAlbumHeader(album),
          _buildAlbumItemWidgetType(albumVideos, albumIndex),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildAlbumItemWidgetType(List<dynamic> videoList, int index) {
    if (index % 2 == 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: HomeTwoVideo(videoPageData: videoList),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: HorizontalVideoList(videoPageData: videoList),
      );
    }
  }

  Widget _buildAlbumHeader(AlbumDataList album) {
    return SectionWithMore(
      title: album.title ?? "",
      showIcon: true,
      onMorePressed: () {
        Get.toNamed(AppRoutes.videoAlbum, arguments: {"id": album.id});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 确保 context 已设置，用于更新检查
    ContextManager.setContext(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0, // 设置 right: 0 让宽度占满
            child: SizedBox(
              height: 250,
              child: Consumer<ColorNotifier>(
                builder: (context, colorNotifier, child) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorNotifier.primaryColor, // 紫色
                          colorNotifier.primaryColor.withOpacity(0.7),
                          colorNotifier.primaryColor.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.6, 0.9, 1.0],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildContent(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
