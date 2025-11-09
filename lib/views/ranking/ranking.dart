import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../components/video_one.dart';
import '../../entity/video_page_entity.dart';

class VideoRanking extends StatefulWidget {
  const VideoRanking({super.key});

  @override
  VideoRankingState createState() => VideoRankingState();
}

class VideoRankingState extends State<VideoRanking>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提取常量
  static const double _backgroundHeight = 200.0;
  static const double _tabsContentTopMargin = 180.0;
  static const int _pageSize = 10;
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Duration _backgroundUpdateDelay = Duration(milliseconds: 100);
  static const Color _selectedTabColor = Color.fromRGBO(252, 119, 66, 1);
  static const Color _unselectedTabColor = Color.fromRGBO(102, 102, 102, 1);
  static const double _borderRadius = 20.0;
  static const double _backgroundBorderRadius = 5.0;

  List<VideoPageDataList> videoPageData = [];
  List<VideoPageDataList> popularity_day = [];
  List<VideoPageDataList> popularity_week = [];
  List<VideoPageDataList> popularity_month = [];
  List<VideoPageDataList> popularity_sum = [];
  //定义一个二维数组储存List<VideoPageDataList>
  List<List<VideoPageDataList>> videoPageDataList = [];
  List<RefreshController> tabRefreshController = [];

  final tabs = [
    const TDTab(text: '热片榜'),
    const TDTab(text: '新片榜'),
    const TDTab(text: '好评榜'),
    const TDTab(text: '收藏榜'),
  ];
  final PageController pageController = PageController(initialPage: 0);
  TabController? _tabController;
  int currentPage = 1;
  int currentIndex = 0;
  // 添加一个变量来跟踪当前显示的背景图片索引，避免快速切换时的闪烁
  int displayedBackgroundIndex = 0;
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

    try {
      final response = await Api.getVideoSortPage({
        "page": page,
        "sort": sort[index],
        "size": _pageSize,
      });

      final list = response.data?.list ?? <VideoPageDataList>[];
      
      // 检查是否还有更多数据
      if (list.length < _pageSize) {
        hasMoreList[index] = false;
      }
      
      return list;
    } catch (e) {
      debugPrint('_fetchDataByIndex failed for index $index: $e');
      return [];
    }
  }

  Future<void> initRequest() async {
    if (!mounted) return;
    
    // 重置状态
    pageList = [1, 1, 1, 1];
    hasMoreList = [true, true, true, true];

    // 并行加载所有数据，提高初始化速度
    final results = await Future.wait([
      _fetchDataByIndex(0, page: 1),
      _fetchDataByIndex(1, page: 1),
      _fetchDataByIndex(2, page: 1),
      _fetchDataByIndex(3, page: 1),
    ]);

    if (!mounted) return;

    popularity_day = results[0];
    popularity_week = results[1];
    popularity_month = results[2];
    popularity_sum = results[3];

    videoPageDataList = [
      popularity_day,
      popularity_week,
      popularity_month,
      popularity_sum,
    ];
  }

  // 新增加载更多数据的函数
  Future<void> loadMoreData(int index) async {
    if (!mounted || !hasMoreList[index]) return;

    pageList[index]++;
    final dataList = await _fetchDataByIndex(
      index,
      page: pageList[index],
    );

    if (!mounted || dataList.isEmpty) return;

    // 使用更高效的方式更新列表
    switch (index) {
      case 0:
        popularity_day = [...popularity_day, ...dataList];
        break;
      case 1:
        popularity_week = [...popularity_week, ...dataList];
        break;
      case 2:
        popularity_month = [...popularity_month, ...dataList];
        break;
      case 3:
        popularity_sum = [...popularity_sum, ...dataList];
        break;
    }
    
    videoPageDataList = [
      popularity_day,
      popularity_week,
      popularity_month,
      popularity_sum,
    ];
    
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initData() async {
    if (!mounted) return;
    
    try {
      _initTabController(0);
      await initRequest();
      _isInitializing = false;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _isInitializing = false;
      debugPrint('_initData failed: $e');
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    // 释放 TabController
    _tabController?.dispose();
    // 释放 PageController
    pageController.dispose();
    // 释放所有 RefreshController
    for (final controller in tabRefreshController) {
      controller.dispose();
    }
    tabRefreshController.clear();
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
      return const Padding(
        padding: EdgeInsets.only(top: 120),
        child: NoData(),
      );
    }
    
    return Stack(
      children: [
        // 使用 RepaintBoundary 隔离背景图片重绘
        RepaintBoundary(
          child: AnimatedSwitcher(
            duration: _animationDuration,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: TDImage(
              key: ValueKey('bg_$displayedBackgroundIndex'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: _backgroundHeight,
              imgUrl: videoPageDataList.length > displayedBackgroundIndex && 
                      videoPageDataList[displayedBackgroundIndex].isNotEmpty
                  ? videoPageDataList[displayedBackgroundIndex][0].surfacePlot ?? ""
                  : "",
              errorWidget: const TDImage(
                width: 150,
                assetUrl: 'assets/images/loading.gif',
              ),
            ),
          ),
        ),
        // 渐变遮罩层
        Container(
          height: _backgroundHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_backgroundBorderRadius),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
            child: Column(
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
            ),
          ),
        ),
        _buildTabsContent(),
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
        if (mounted && displayedBackgroundIndex != currentIndex) {
          displayedBackgroundIndex = currentIndex;
          setState(() {});
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
        displayedBackgroundIndex = index;
        setState(() {});
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
                borderSide: BorderSide(
                  width: 0.0,
                  color: Colors.transparent,
                ),
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
              while (tabRefreshController.length <= index) {
                tabRefreshController.add(RefreshController());
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
      controller: tabRefreshController[index],
      onRefresh: () => _onRefresh(index),
      onLoading: () => _onLoadMore(index),
      enablePullUp: true,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: videoPageDataList.length > index 
            ? videoPageDataList[index].length 
            : 0,
        itemBuilder: (context, key) {
          final videoData = videoPageDataList[index][key];
          return RepaintBoundary(
            key: ValueKey('video_${videoData.id}_$index'),
            child: VideoOne(
              videoData: videoData,
            ),
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
    
    final dataList = await _fetchDataByIndex(index, page: 1);
    
    if (!mounted) return;
    
    switch (index) {
      case 0:
        popularity_day = dataList;
        break;
      case 1:
        popularity_week = dataList;
        break;
      case 2:
        popularity_month = dataList;
        break;
      case 3:
        popularity_sum = dataList;
        break;
    }
    
    videoPageDataList = [
      popularity_day,
      popularity_week,
      popularity_month,
      popularity_sum,
    ];
    
    if (mounted) {
      setState(() {});
      tabRefreshController[index].refreshCompleted();
    }
  }

  Future<void> _onLoadMore(int index) async {
    if (!mounted) return;
    
    await loadMoreData(index);
    
    if (!mounted || index >= tabRefreshController.length) return;
    
    if (hasMoreList[index]) {
      tabRefreshController[index].loadComplete();
    } else {
      tabRefreshController[index].loadNoData();
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