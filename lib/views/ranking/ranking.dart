import 'package:flutter/material.dart';

// 第三方库
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// 本地文件
import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../components/video_one.dart';
import '../../entity/video_page_entity.dart';
import '../../utils/store/ranking/ranking_background_notifier.dart';

/**
 * 视频排行榜页面
 * 展示不同类型的视频排行榜，包括热片榜、新片榜、好评榜和收藏榜
 */
class VideoRanking extends StatefulWidget {
  const VideoRanking({super.key});

  @override
  VideoRankingState createState() => VideoRankingState();
}

/**
 * 视频排行榜页面状态管理
 * 负责处理排行榜数据的加载、刷新和展示
 */
class VideoRankingState extends State<VideoRanking>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提取常量
  // 布局常量
  static const double _backgroundHeight = 200.0;
  static const double _tabsContentTopMargin = 180.0;
  static const double _borderRadius = 20.0;
  static const double _backgroundBorderRadius = 5.0;
  
  // 配置常量
  static const int _pageSize = 10;
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Duration _backgroundUpdateDelay = Duration(milliseconds: 100);
  
  // 颜色常量
  static const Color _selectedTabColor = Color.fromRGBO(252, 119, 66, 1);
  static const Color _unselectedTabColor = Color.fromRGBO(102, 102, 102, 1);
  
  // 其他常量
  static const String TAG = "VideoRanking";

  // 视频数据列表
  List<VideoPageDataList> videoPageData = [];
  List<VideoPageDataList> popularityDay = [];
  List<VideoPageDataList> popularityWeek = [];
  List<VideoPageDataList> popularityMonth = [];
  List<VideoPageDataList> popularitySum = [];
  // 二维数组储存所有排行榜数据
  List<List<VideoPageDataList>> videoPageDataList = [];
  // 每个 tab 的刷新控制器
  List<RefreshController> tabRefreshControllers = [];

  // 使用 const 构造器创建 tabs 列表
  static const List<TDTab> tabs = [
    TDTab(text: '热片榜'),
    TDTab(text: '新片榜'),
    TDTab(text: '好评榜'),
    TDTab(text: '收藏榜'),
  ];
  // 使用 late 修饰符延迟初始化 PageController
  late final PageController pageController;
  TabController? _tabController;
  int currentPage = 1;
  int currentIndex = 0;
  // 添加一个变量来跟踪当前显示的背景图片索引，避免快速切换时的闪烁
  late RankingBackgroundNotifier _backgroundNotifier;
  final List<String> sort = [
    "popularity_day",
    "popularity_week",
    "popularity_month",
    "popularity_sum",
  ];
  // 添加每个tab的当前页码
  List<int> pageList = [1, 1, 1, 1];
  // 添加每个tab是否还有更多数据的标记
  List<bool> hasMoreList = [true, true, true, true];

  // 添加加载状态
  bool _isInitializing = true;

  // 添加数据缓存，避免重复请求
  final Map<String, List<VideoPageDataList>> _dataCache = {};

  // 新增共用函数，根据index添加不同分类的数据
  Future<List<VideoPageDataList>> _fetchDataByIndex(
    int index, {
    int page = 1,
  }) async {
    if (!mounted) return [];

    // 如果没有更多数据，直接返回空列表
    if (!hasMoreList[index]) {
      return [];
    }

    // 生成缓存键
    final cacheKey = '${sort[index]}_$page';
    
    // 检查缓存中是否有数据
    if (_dataCache.containsKey(cacheKey)) {
      debugPrint('$TAG: 使用缓存数据 for $cacheKey');
      return _dataCache[cacheKey]!;
    }

    try {
      debugPrint('$TAG: 开始获取数据 for index $index, page $page');
      final response = await Api.getVideoSortPage({
        "page": page,
        "sort": sort[index],
        "size": _pageSize,
      });

      final list = response.data?.list ?? <VideoPageDataList>[];
      debugPrint('$TAG: 获取到 ${list.length} 条数据 for index $index, page $page');

      // 检查是否还有更多数据
      if (list.length < _pageSize) {
        hasMoreList[index] = false;
        debugPrint('$TAG: 没有更多数据 for index $index');
      }

      // 缓存数据
      _dataCache[cacheKey] = list;

      return list;
    } catch (e, stackTrace) {
      debugPrint('$TAG: 获取数据失败 for index $index: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      return [];
    }
  }

  Future<void> initRequest() async {
    if (!mounted) return;

    try {
      debugPrint('$TAG: 开始初始化请求数据');
      // 重置状态
      pageList = [1, 1, 1, 1];
      hasMoreList = [true, true, true, true];

      // 并行加载所有数据，提高初始化速度
      debugPrint('$TAG: 并行加载所有排行榜数据');
      final results = await Future.wait([
        _fetchDataByIndex(0, page: 1),
        _fetchDataByIndex(1, page: 1),
        _fetchDataByIndex(2, page: 1),
        _fetchDataByIndex(3, page: 1),
      ]);

      if (!mounted) return;

      popularityDay = results[0];
      popularityWeek = results[1];
      popularityMonth = results[2];
      popularitySum = results[3];

      videoPageDataList = [
        popularityDay,
        popularityWeek,
        popularityMonth,
        popularitySum,
      ];

      debugPrint('$TAG: 初始化请求数据完成');
    } catch (e, stackTrace) {
      debugPrint('$TAG: 初始化请求数据失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
    }
  }

  // 新增加载更多数据的函数
  Future<void> loadMoreData(int index) async {
    if (!mounted || !hasMoreList[index]) return;

    try {
      debugPrint('$TAG: 开始加载更多数据 for index $index');
      pageList[index]++;
      final dataList = await _fetchDataByIndex(index, page: pageList[index]);

      if (!mounted || dataList.isEmpty) {
        debugPrint('$TAG: 没有更多数据或页面已销毁 for index $index');
        return;
      }

      debugPrint('$TAG: 加载到 ${dataList.length} 条数据 for index $index');
      // 使用更高效的方式更新列表
      switch (index) {
        case 0:
          popularityDay = [...popularityDay, ...dataList];
          break;
        case 1:
          popularityWeek = [...popularityWeek, ...dataList];
          break;
        case 2:
          popularityMonth = [...popularityMonth, ...dataList];
          break;
        case 3:
          popularitySum = [...popularitySum, ...dataList];
          break;
      }

      videoPageDataList = [
        popularityDay,
        popularityWeek,
        popularityMonth,
        popularitySum,
      ];

      if (mounted) {
        setState(() {});
        debugPrint('$TAG: 加载更多数据完成 for index $index');
      }
    } catch (e, stackTrace) {
      debugPrint('$TAG: 加载更多数据失败 for index $index: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      // 恢复页码，以便下次加载
      pageList[index]--;
    }
  }

/**
 * 初始化数据
 * 初始化标签控制器和请求排行榜数据
 */
  Future<void> _initData() async {
    if (!mounted) return;

    try {
      debugPrint('$TAG: 开始初始化数据');
      _initTabController(0);
      await initRequest();
      _isInitializing = false;
      if (mounted) {
        setState(() {});
      }
      debugPrint('$TAG: 初始化数据完成');
    } catch (e, stackTrace) {
      _isInitializing = false;
      debugPrint('$TAG: 初始化数据失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始化 PageController
    pageController = PageController(initialPage: 0);
    _backgroundNotifier = RankingBackgroundNotifier();
    _initData();
  }

  @override
  void dispose() {
    // 释放 TabController
    _tabController?.dispose();
    // 释放 PageController
    pageController.dispose();
    // 释放所有 RefreshController
    for (final controller in tabRefreshControllers) {
      controller.dispose();
    }
    tabRefreshControllers.clear();
    // 释放 BackgroundNotifier
    _backgroundNotifier.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    if (_isInitializing || videoPageDataList.isEmpty) {
      return const PageLoading();
    }
    return contentIsEmpty();
  }

  Widget contentIsEmpty() {
    if (videoPageDataList.isEmpty ||
        (videoPageDataList.isNotEmpty && videoPageDataList[0].isEmpty)) {
      return const Padding(padding: EdgeInsets.only(top: 120), child: NoData());
    }

    return ChangeNotifierProvider.value(
      value: _backgroundNotifier,
      child: Stack(
        children: [
          // 使用 Consumer 监听背景图片索引变化
          _buildBackgroundImage(),
          // 渐变遮罩层
          _buildGradientOverlay(),
          _buildTabsContent(),
        ],
      ),
    );
  }

  /// 构建背景图片
  Widget _buildBackgroundImage() {
    return Consumer<RankingBackgroundNotifier>(
      builder: (context, notifier, child) {
        return RepaintBoundary(
          child: AnimatedSwitcher(
            duration: _animationDuration,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: TDImage(
              key: ValueKey('bg_${notifier.backgroundIndex}'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: _backgroundHeight,
              imgUrl:
                  videoPageDataList.length > notifier.backgroundIndex &&
                          videoPageDataList[notifier.backgroundIndex]
                              .isNotEmpty
                      ? videoPageDataList[notifier.backgroundIndex][0]
                              .surfacePlot ??
                          ""
                      : "",
              errorWidget: const TDImage(
                width: 150,
                assetUrl: 'assets/images/loading.gif',
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建渐变遮罩层
  Widget _buildGradientOverlay() {
    return Container(
      height: _backgroundHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_backgroundBorderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: _buildTitleText(),
      ),
    );
  }

  /// 构建标题文本
  Widget _buildTitleText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: const [
        Text(
          "排行榜",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "根据内容热点排名，每小时更新一次",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }

  /// 初始化tab
  void _initTabController(int initialIndex) {
    _tabController = TabController(
      initialIndex: initialIndex,
      length: tabs.length,
      vsync: this,
    );
    _tabController!.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!mounted || _tabController == null) return;

    final newIndex = _tabController!.index;
    if (newIndex != currentIndex) {
      currentIndex = newIndex;
      // 同步更新 PageView
      pageController.animateToPage(
        currentIndex,
        duration: _animationDuration,
        curve: Curves.easeInOut,
      );
      // 延迟更新背景图索引，避免快速切换时的闪烁
      Future.delayed(_backgroundUpdateDelay, () {
        if (mounted) {
          _backgroundNotifier.updateBackgroundIndex(currentIndex);
        }
      });
    }
  }

  void _onPageChanged(int index) {
    if (!mounted || index == currentIndex) return;

    currentIndex = index;
    // 延迟更新显示的背景图片索引，避免快速切换时的闪烁
    Future.delayed(_backgroundUpdateDelay, () {
      if (mounted && currentIndex == index) {
        _backgroundNotifier.updateBackgroundIndex(index);
      }
    });
    // 同步更新 tab 控制器的 index
    _tabController?.animateTo(index);
  }

  Widget _buildTabs() {
    return Column(
      children: [
        RepaintBoundary(
          child: Container(
            margin: EdgeInsets.zero,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerHeight: 0,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 0.0, color: Colors.transparent),
              ),
              labelColor: _selectedTabColor,
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelColor: _unselectedTabColor,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              tabs: tabs,
            ),
          ),
        ),
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: _onPageChanged,
            children: List.generate(tabs.length, (index) {
              // 确保每个tab都有独立的RefreshController
              while (tabRefreshControllers.length <= index) {
                tabRefreshControllers.add(RefreshController());
              }
              return _buildTabContent(index);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(int index) {
    return SmartRefresher(
      controller: tabRefreshControllers[index],
      onRefresh: () => _onRefresh(index),
      onLoading: () => _onLoadMore(index),
      enablePullUp: true,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount:
            videoPageDataList.length > index
                ? videoPageDataList[index].length
                : 0,
        cacheExtent: 200, // 优化缓存范围
        itemBuilder: (context, key) {
          final videoData = videoPageDataList[index][key];
          return RepaintBoundary(
            key: ValueKey('video_${videoData.id}_$index'),
            child: VideoOne(videoData: videoData),
          );
        },
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        addSemanticIndexes: false,
      ),
    );
  }

  Future<void> _onRefresh(int index) async {
    if (!mounted) return;

    pageList[index] = 1;
    hasMoreList[index] = true;
    
    // 清除对应分类的缓存
    final sortKey = sort[index];
    _dataCache.removeWhere((key, value) => key.startsWith(sortKey));

    final dataList = await _fetchDataByIndex(index, page: 1);

    if (!mounted) return;

    switch (index) {
      case 0:
        popularityDay = dataList;
        break;
      case 1:
        popularityWeek = dataList;
        break;
      case 2:
        popularityMonth = dataList;
        break;
      case 3:
        popularitySum = dataList;
        break;
    }

    videoPageDataList = [
      popularityDay,
      popularityWeek,
      popularityMonth,
      popularitySum,
    ];

    if (mounted) {
      setState(() {});
      tabRefreshControllers[index].refreshCompleted();
    }
  }

  Future<void> _onLoadMore(int index) async {
    if (!mounted) return;

    await loadMoreData(index);

    if (!mounted || index >= tabRefreshControllers.length) return;

    if (hasMoreList[index]) {
      tabRefreshControllers[index].loadComplete();
    } else {
      tabRefreshControllers[index].loadNoData();
    }
  }

  Widget _buildTabsContent() {
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.only(top: _tabsContentTopMargin),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: _buildTabs(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用 super.build
    return Scaffold(body: _buildContent());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
