import 'dart:developer';
import 'dart:async';

// Flutter 核心库
import 'package:flutter/material.dart';

// 第三方库
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// 本地文件
import '../../api/api.dart';
import 'package:dio/dio.dart';
import '../../components/common/common_search_bar.dart';
import '../../components/common/filter_row.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../components/video_three.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../services/video_filter_prefetch_service.dart';
import '../../style/layout.dart';
import '../search/search.dart';

const String TAG = "VideoFilter";

// 布局常量
const double _gridMaxCrossAxisExtent = 150.0;
const double _gridCrossAxisSpacing = 4.0;
const double _gridMainAxisSpacing = 4.0;
const double _gridMainAxisExtent = 205.0;
const double _cacheExtent = 2000.0;
const int _maxCachePage = 2;

/// 视频筛选页面
class VideoFilter extends StatefulWidget {
  //接受路由传递过来的props id
  const VideoFilter({super.key});

  @override
  VideoFilterState createState() => VideoFilterState();
}

class VideoFilterState extends State<VideoFilter>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提取常量

  // 页面相关变量
  int currentPage = 1;
  TDBackTopStyle style = TDBackTopStyle.circle;
  var _headerFuture;
  var _contentFuture;
  var _inputText = "";
  List<DictDataDataVideoCategory> categoryData = [];
  List<DictDataDataVideoTag> tagData = [];
  List<VideoPageDataList> videoPageData = [];
  // 实现一个从今年到19年前的list
  final List<int> years = List.generate(
    20,
    (index) => DateTime.now().year - index,
  );
  final ValueNotifier<int> categoryCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> tagCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> yearCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> regionCurrent = ValueNotifier<int>(0);
  // 添加加载状态 ValueNotifier，替代布尔变量
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  // 添加头部加载状态 ValueNotifier
  final ValueNotifier<bool> isHeaderLoadingNotifier = ValueNotifier<bool>(true);
  bool _disposed = false;
  List<DictInfoListData> categoryDictList = [];
  List<DictInfoListData> areaDictList = [];
  List<DictInfoListData> categoryOriginalDictList = [];
  
  // 取消令牌，用于取消正在进行的异步操作
  final _cancelToken = CancelToken();

  // 添加组件缓存映射
  final Map<int, Widget> _videoItemCache = {};
  final Map<String, Widget> _categoryWidgetCache = {};
  final Map<String, Widget> _tagWidgetCache = {};
  final Map<String, Widget> _areaWidgetCache = {};
  final Map<String, Widget> _yearWidgetCache = {};

  // 标签查找缓存，避免重复查找
  final Map<int, String?> _tagNameCache = {};

  // RefreshController 用于下拉刷新和上拉加载
  final RefreshController _refreshController = RefreshController();

  // 移除内容缓存，因为它会阻止下拉刷新功能

  Future<void> getVideoPages() async {
    if (!mounted) return;

    try {
      debugPrint('$TAG: 开始获取视频页面数据，页码: $currentPage');
      // 优化标签查找，使用缓存
      String? tagName;
      if (tagCurrent.value != 0) {
        tagName = _tagNameCache[tagCurrent.value];
        if (tagName == null) {
          try {
            final tag = tagData.firstWhere(
              (element) => element.id == tagCurrent.value,
              orElse: () => tagData.first,
            );
            tagName = tag.name;
            _tagNameCache[tagCurrent.value] = tagName;
            debugPrint('$TAG: 缓存标签名称: $tagName');
          } catch (e) {
            tagName = null;
            debugPrint('$TAG: 查找标签失败: $e');
          }
        }
      }

      final data = {
        "page": currentPage,
        "category_pid":
            categoryCurrent.value == 0 ? null : categoryCurrent.value,
        "video_tag": tagName,
        "year": yearCurrent.value == 0 ? null : yearCurrent.value,
        "region": regionCurrent.value == 0 ? null : regionCurrent.value,
      };

      debugPrint('$TAG: 请求参数: $data');
      // 直接调用 API，添加超时处理
      final response = await Api.getVideoPages(data).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('$TAG: 获取视频页面数据超时');
          throw TimeoutException('获取视频页面数据超时');
        },
      );
      final list = response.data?.list ?? <VideoPageDataList>[];

      debugPrint('$TAG: 获取到 ${list.length} 个视频数据');
      // 使用 ListView.separated 或 GridView.builder 时，添加唯一键可以提高性能
      if (currentPage == 1) {
        videoPageData = list;
      } else {
        videoPageData = [...videoPageData, ...list];
      }

      // 数据更新后必须调用 setState 来触发 UI 重建
      if (mounted) {
        setState(() {});
      }
    } catch (e, stackTrace) {
      debugPrint('$TAG: 获取视频页面数据失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      // 显示错误提示
      if (mounted) {
        TDToast.showText('获取数据失败，请稍后重试',context: context);
      }
    } finally {
      // 使用ValueNotifier更新加载状态，而不是setState
      isLoadingNotifier.value = false;
      debugPrint('$TAG: 获取视频页面数据完成');
    }
  }

  Future<void> getVideoCategoryPages() async {
    try {
      debugPrint('$TAG: 开始获取视频分类数据');
      final response = await Api.getDictData({
                "types": ["video_category"],
              }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('$TAG: 获取视频分类数据超时');
          throw TimeoutException('获取视频分类数据超时');
        },
      );
      final dictData = response.data as DictDataData;
      categoryData = dictData.videoCategory ?? [];
      categoryData = categoryData.where((element) => element.parentId == null).toList();
      debugPrint('$TAG: 获取到 ${categoryData.length} 个视频分类');
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('$TAG: 获取视频分类数据失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      // 确保 categoryData 不为 null
      categoryData = [];
    }
  }

  Future<void> getVideoTagPages() async {
    try {
      debugPrint('$TAG: 开始获取视频标签数据');
      final response = await Api.getDictData({
                "types": ["video_tag"],
              }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('$TAG: 获取视频标签数据超时');
          throw TimeoutException('获取视频标签数据超时');
        },
      );
      final dictData = response.data as DictDataData;
      tagData = dictData.videoTag ?? [];
      debugPrint('$TAG: 获取到 ${tagData.length} 个视频标签');
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('$TAG: 获取视频标签数据失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      // 确保 tagData 不为 null
      tagData = [];
    }
  }

  Future<void> getVideoAreaPages() async {
    try {
      debugPrint('$TAG: 开始获取视频地区数据');
      final response = await Api.getDictInfoPages({
                "order": "orderNum",
                "sort": "desc",
                "typeId": 39,
              }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('$TAG: 获取视频地区数据超时');
          throw TimeoutException('获取视频地区数据超时');
        },
      );
      areaDictList = response.data as List<DictInfoListData> ?? [];
      //返回parentId :  null 的数据
      areaDictList = areaDictList.where((element) => element.parentId == null).toList();
      debugPrint('$TAG: 获取到 ${areaDictList.length} 个视频地区');
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('$TAG: 获取视频地区数据失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      // 确保 areaDictList 不为 null
      areaDictList = [];
    }
  }

  Future<String> initHeader() async {
    if (!mounted) return "init header failed";

    try {
      debugPrint('$TAG: 开始初始化头部数据');
      // 首先尝试从预加载服务获取数据，添加超时处理
      final prefetchService = VideoFilterPrefetchService.instance;
      final prefetchData = await prefetchService.preload().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('$TAG: 预加载数据超时');
          return null;
        },
      );

      if (prefetchData != null) {
        // 使用预加载的数据
        categoryData = prefetchData.categoryData;
        tagData = prefetchData.tagData;
        areaDictList = prefetchData.areaData;
        debugPrint('$TAG: 使用预加载数据初始化头部');
      } else {
        // 如果预加载失败或没有预加载数据，则直接获取数据，添加超时处理
        debugPrint('$TAG: 预加载数据不存在，开始直接获取数据');
        await Future.wait([
          getVideoCategoryPages(),
          getVideoAreaPages(),
          getVideoTagPages(),
        ]).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            debugPrint('$TAG: 直接获取数据超时');
            return [];
          },
        );
      }

      // 头部数据加载完成，更新头部加载状态
      if (mounted) {
        isHeaderLoadingNotifier.value = false;
      }

      debugPrint('$TAG: 头部数据初始化完成');
      return "init header success";
    } catch (e, stackTrace) {
      debugPrint('$TAG: 头部数据初始化失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      // 即使出错也要更新头部加载状态
      if (mounted) {
        isHeaderLoadingNotifier.value = false;
      }
      return "init header failed";
    }
  }

  Future<String> initContent() async {
    if (!mounted) return "init content failed";

    try {
      debugPrint('$TAG: 开始初始化内容数据');
      // 使用ValueNotifier更新加载状态
      isLoadingNotifier.value = true;

      // 获取视频页面数据，添加超时处理
      await getVideoPages().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          debugPrint('$TAG: 初始化内容数据超时');
          throw TimeoutException('初始化内容数据超时');
        },
      );

      // 加载完成后更新状态
      isLoadingNotifier.value = false;
      debugPrint('$TAG: 内容数据初始化完成');
      return "init content success";
    } catch (e, stackTrace) {
      debugPrint('$TAG: 内容数据初始化失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      isLoadingNotifier.value = false;
      return "init content failed";
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始化头部和内容数据
    _headerFuture = initHeader();
    _contentFuture = initContent();
  }

  @override
  void dispose() {
    _disposed = true;
    // 取消所有正在进行的异步操作
    _cancelToken.cancel('Component disposed');
    // 释放 ValueNotifier 资源
    categoryCurrent.dispose();
    tagCurrent.dispose();
    yearCurrent.dispose();
    regionCurrent.dispose();
    isLoadingNotifier.dispose();
    isHeaderLoadingNotifier.dispose(); // 释放头部加载状态 ValueNotifier
    // 释放 RefreshController
    _refreshController.dispose();
    // 清理缓存
    _videoItemCache.clear();
    _categoryWidgetCache.clear();
    _tagWidgetCache.clear();
    _areaWidgetCache.clear();
    _yearWidgetCache.clear();
    _tagNameCache.clear();
    super.dispose();
  }

  Widget _buildDefaultSearchBar() {
    return CommonSearchBar(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VideoSearch()),
        );
      },
    );
  }

  Future<void> _category_change(DictDataDataVideoCategory? item) async {
    if (!mounted) return;

    categoryCurrent.value = item?.id ?? 0;
    // 清除相关缓存
    _clearTagCache();
    _videoItemCache.clear();
    _tagNameCache.clear();
    videoPageData.clear();
    // 使用ValueNotifier更新加载状态
    isLoadingNotifier.value = true;
    currentPage = 1;

    try {
      await getVideoPages().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('$TAG: 分类切换超时');
          throw TimeoutException('分类切换超时');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('$TAG: 分类切换失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
    } finally {
      // 重置其他筛选条件
      yearCurrent.value = 0;
      regionCurrent.value = 0;

      // 加载完成后更新状态
      isLoadingNotifier.value = false;
    }
  }

  Future<void> _tag_change(DictDataDataVideoTag? item) async {
    if (!mounted) return;

    tagCurrent.value = item?.id ?? 0;
    // 清除相关缓存
    _clearTagCache();
    _videoItemCache.clear();
    _tagNameCache.clear();
    videoPageData.clear();
    // 使用ValueNotifier更新加载状态
    isLoadingNotifier.value = true;
    currentPage = 1;

    try {
      await getVideoPages().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('$TAG: 标签切换超时');
          throw TimeoutException('标签切换超时');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('$TAG: 标签切换失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
    } finally {
      // 重置其他筛选条件
      yearCurrent.value = 0;
      regionCurrent.value = 0;

      isLoadingNotifier.value = false;
    }
  }

  Future<void> _year_change(int item) async {
    if (!mounted) return;

    yearCurrent.value = item;
    // 清除相关缓存
    _clearTagCache();
    _videoItemCache.clear();
    videoPageData.clear();
    // 使用ValueNotifier更新加载状态
    isLoadingNotifier.value = true;
    currentPage = 1;

    try {
      await getVideoPages().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('$TAG: 年份切换超时');
          throw TimeoutException('年份切换超时');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('$TAG: 年份切换失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  Future<void> _area_change(DictInfoListData? item) async {
    if (!mounted) return;

    regionCurrent.value = item?.id ?? 0;
    // 清除相关缓存
    _clearTagCache();
    _videoItemCache.clear();
    videoPageData.clear();
    // 使用ValueNotifier更新加载状态
    isLoadingNotifier.value = true;
    currentPage = 1;

    try {
      await getVideoPages().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('$TAG: 地区切换超时');
          throw TimeoutException('地区切换超时');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('$TAG: 地区切换失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
    } finally {
      isLoadingNotifier.value = false;
    }
  }

/**
 * 清除筛选相关的缓存
 * 当筛选条件变化时调用，确保显示最新的筛选选项
 */
  void _clearTagCache() {
    _categoryWidgetCache.clear();
    _tagWidgetCache.clear();
    _areaWidgetCache.clear();
    _yearWidgetCache.clear();
  }

  /// 下拉刷新方法
  /// 清除缓存并重新加载第一页数据
  Future<void> onRefresh() async {
    videoPageData.clear();
    // 清除所有缓存
    _clearTagCache();
    _videoItemCache.clear();
    // 使用ValueNotifier更新加载状态
    isLoadingNotifier.value = true;
    currentPage = 1;
    try {
      await getVideoPages().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('$TAG: 下拉刷新超时');
          throw TimeoutException('下拉刷新超时');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('$TAG: 下拉刷新失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
    } finally {
      isLoadingNotifier.value = false;
      // 不再在这里调用_refreshController.refreshCompleted()，因为它在SmartRefresher的回调中调用
    }
  }

  /// 上拉加载更多方法
  /// 加载下一页数据
  Future<void> loadMore() async {
    currentPage++;
    try {
      await getVideoPages().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('$TAG: 上拉加载更多超时');
          throw TimeoutException('上拉加载更多超时');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('$TAG: 上拉加载更多失败: $e');
      debugPrint('$TAG: 堆栈跟踪: $stackTrace');
      // 加载失败时回退页码
      currentPage--;
    } finally {
      TDToast.dismissLoading();
      // 不要在这里设置isLoadingNotifier.value = false，由SmartRefresher控制
    }
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return ValueListenableBuilder<bool>(
      valueListenable: isHeaderLoadingNotifier,
      builder: (context, isHeaderLoading, child) {
        // 如果头部还在加载，显示全局加载动画
        if (isHeaderLoading) {
          return const PageLoading();
        } else {
          // 头部加载完成，显示页面内容
          return Stack(
            children: [
              // 首先构建包含头部筛选区域的页面
              _buildSmartRefresher(),
            ],
          );
        }
      },
    );
  }

  /// 构建智能刷新组件
  Widget _buildSmartRefresher() {
    return SmartRefresher(
      onRefresh: () async {
        await onRefresh();
        if (mounted) {
          _refreshController.refreshCompleted();
        }
      },
      onLoading: () async {
        await loadMore();
        if (mounted) {
          _refreshController.loadComplete();
        }
      },
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      child: _buildCustomScrollView(),
    );
  }

  /// 构建自定义滚动视图
  Widget _buildCustomScrollView() {
    return CustomScrollView(
      cacheExtent: _cacheExtent, // 增加缓存区域提高滚动性能
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: RepaintBoundary(child: _buildDefaultSearchBar()),
        ),
        SliverStickyHeader(
          header: _buildStickyHeader(),
          sliver: _buildContentSliver(),
        ),
      ],
    );
  }

  /// 构建粘性头部
  Widget _buildStickyHeader() {
    return RepaintBoundary(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.only(
          // left: Layout.paddingL,
          // right: Layout.paddingR,
          top: 5,
          bottom: Layout.paddingB,
        ),
        // 直接显示筛选控件，因为我们已经确认头部加载完成
        child: Visibility(
          visible: categoryData.isNotEmpty,
          child: _buildFilterRows(),
        ),
      ),
    );
  }

  /// 构建筛选行
  Widget _buildFilterRows() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterRow<DictDataDataVideoCategory>(
          title: '全部分类',
          items: categoryData,
          notifier: categoryCurrent,
          labelBuilder: (item) => item?.name ?? '全部分类',
          onTap: _category_change,
        ),
        FilterRow<DictDataDataVideoTag>(
          title: "全部标签",
          items: tagData,
          notifier: tagCurrent,
          labelBuilder: (item) => item?.name ?? "全部标签",
          onTap: _tag_change,
        ),
        FilterRow<DictInfoListData>(
          title: '全部地区',
          items: areaDictList,
          notifier: regionCurrent,
          labelBuilder: (item) => item?.name ?? '全部地区',
          onTap: _area_change,
        ),
        FilterRow<int>(
          title: "全部年份",
          items: years,
          notifier: yearCurrent,
          labelBuilder:
              (item) =>
                  item == null || item == 0
                      ? "全部年份"
                      : item.toString(),
          onTap: (item) => _year_change(item ?? 0),
        ),
      ],
    );
  }

  /// 构建内容区域
  Widget _buildContentSliver() {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoadingNotifier,
      builder: (context, isLoading, child) {
        // 根据内容区域的加载状态决定显示什么
        if (isLoading) {
          // 内容区域仍在加载中，显示加载指示器
          return const SliverToBoxAdapter(
            child: Center(child: PageLoading()),
          );
        } else {
          // 内容区域加载完成
          return _buildContentGrid(isLoading);
        }
      },
    );
  }

  /// 构建内容网格
  /// 根据加载状态和数据情况显示不同的内容
  Widget _buildContentGrid(bool isLoading) {
    if (isLoading) {
      // 显示加载指示器
      return const SliverToBoxAdapter(child: Center(child: PageLoading()));
    } else if (videoPageData.isEmpty) {
      // 确认无数据时显示 NoData 组件
      return const SliverToBoxAdapter(child: Center(child: NoData()));
    } else {
      // 使用预构建的组件列表来提高性能
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _gridMaxCrossAxisExtent,
          crossAxisSpacing: _gridCrossAxisSpacing,
          mainAxisSpacing: _gridMainAxisSpacing,
          mainAxisExtent: _gridMainAxisExtent,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => _buildVideoItem(videoPageData[i]),
          childCount: videoPageData.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: false, // 关闭语义索引以提高性能
        ),
      );
    }
  }

/**
 * 构建视频项组件
 * 使用缓存机制提高性能，避免重复构建相同的视频项
 * @param videoItem 视频数据项
 * @return 视频项组件
 */
  Widget _buildVideoItem(VideoPageDataList videoItem) {
    final id = videoItem.id;

    // 检查是否有缓存的组件
    if (id != null && _videoItemCache.containsKey(id)) {
      return _videoItemCache[id]!;
    }

    // 创建新的组件并缓存，使用 RepaintBoundary 隔离重绘
    final widget = RepaintBoundary(
      key: ValueKey('video_$id'),
      child: GridTile(
        child: Center(child: Video(videoData: videoItem)),
      ),
    );

    // 缓存组件（仅对前几页的数据进行缓存以平衡内存和性能）
    if (id != null && currentPage <= _maxCachePage) {
      _videoItemCache[id] = widget;
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用 super.build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.transparent,
        elevation: 0,
        //不显示icon
        leading: Container(),
        automaticallyImplyLeading: false, //设置为false
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: _buildContent(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
