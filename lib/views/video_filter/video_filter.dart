import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/common/common_search_bar.dart';
import '../../components/common/filter_row.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../components/video_three.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/dict_info_list_entity.dart';
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提取常量

  //定义currentPage
  int currentPage = 1;
  TDBackTopStyle style = TDBackTopStyle.circle;
  var _futureBuilderFuture;
  var inputText = "";
  List<DictDataDataVideoCategory> categoryData = [];
  List<DictDataDataVideoTag> tagData = [];
  List<VideoPageDataList> videoPageData = [];
  //实现一个从今年到15年前的list
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
  bool disposed = false;
  List<DictInfoListData> categoryDictList = [];
  List<DictInfoListData> areaDictList = [];
  List<DictInfoListData> categoryOriginalDictList = [];

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
          } catch (e) {
            tagName = null;
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

      // 直接调用 API，不需要 Future.microtask
      final response = await Api.getVideoPages(data);
      final list = response.data?.list ?? <VideoPageDataList>[];

      // 使用 ListView.separated 或 GridView.builder 时，添加唯一键可以提高性能
      if (currentPage == 1) {
        videoPageData = list;
      } else {
        videoPageData = [...videoPageData, ...list];
      }

      // 数据更新后必须调用 setSt ate 来触发 UI 重建
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Initialization getVideoPages failed: $e');
    } finally {
      // 使用ValueNotifier更新加载状态，而不是setState
      isLoadingNotifier.value = false;
    }
  }

  Future<void> getVideoCategoryPages() async {
    try {
      categoryData =
          ((await Api.getDictData({
                    "types": ["video_category"],
                  })).data
                  as DictDataData)
              .videoCategory!;
      categoryData =
          categoryData.where((element) => element.parentId == null).toList();
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoListByCategoryIds failed: $e');
    }
  }

  Future<void> getVideoTagPages() async {
    try {
      tagData =
          ((await Api.getDictData({
                    "types": ["video_tag"],
                  })).data
                  as DictDataData)
              .videoTag!;
      debugPrint(
        'Initialization getVideoTagPages success ${tagData[tagCurrent.value]}',
      );
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoTagPages failed: $e');
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
    }
  }

  Future<String> init() async {
    if (!mounted) return "init failed";

    try {
      // 使用ValueNotifier更新加载状态
      isLoadingNotifier.value = true;

      // 并行执行所有初始化任务，提升加载速度
      await Future.wait([
        getVideoPages(),
        getVideoCategoryPages(),
        getVideoAreaPages(),
        getVideoTagPages(),
      ]);

      // 加载完成后更新状态
      isLoadingNotifier.value = false;
      return "init success";
    } catch (e) {
      debugPrint('Initialization failed: $e');
      isLoadingNotifier.value = false;
      return "init success";
    }
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  @override
  void dispose() {
    disposed = true;
    // 释放 ValueNotifier 资源
    categoryCurrent.dispose();
    tagCurrent.dispose();
    yearCurrent.dispose();
    regionCurrent.dispose();
    isLoadingNotifier.dispose();
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

    await getVideoPages();

    // 重置其他筛选条件
    yearCurrent.value = 0;
    regionCurrent.value = 0;

    // 加载完成后更新状态
    isLoadingNotifier.value = false;
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

    await getVideoPages();

    // 重置其他筛选条件
    yearCurrent.value = 0;
    regionCurrent.value = 0;

    isLoadingNotifier.value = false;
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

    await getVideoPages();

    isLoadingNotifier.value = false;
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

    await getVideoPages();

    isLoadingNotifier.value = false;
  }

  // 添加清除缓存的方法
  void _clearTagCache() {
    _categoryWidgetCache.clear();
    _tagWidgetCache.clear();
    _areaWidgetCache.clear();
    _yearWidgetCache.clear();
  }

  Future<void> onRefresh() async {
    videoPageData.clear();
    // 清除所有缓存
    _clearTagCache();
    _videoItemCache.clear();
    // 使用ValueNotifier更新加载状态
    isLoadingNotifier.value = true;
    currentPage = 1;
    await getVideoPages();
    isLoadingNotifier.value = false;
    // 不再在这里调用_refreshController.refreshCompleted()，因为它在SmartRefresher的回调中调用
  }

  Future<void> loadMore() async {
    currentPage++;
    await getVideoPages();
    // 加载完成后更新加载状态
    isLoadingNotifier.value = false;
    TDToast.dismissLoading();
    // 不再在这里调用_refreshController.loadComplete()，因为它在SmartRefresher的回调中调用
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PageLoading();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // 注意：我们不再缓存整个内容，因为这会阻止下拉刷新和上拉加载更多功能
          // 每次都需要重新构建内容以确保刷新功能正常工作
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
            child: CustomScrollView(
              cacheExtent: 2000, // 增加缓存区域提高滚动性能
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: RepaintBoundary(child: _buildDefaultSearchBar()),
                ),
                SliverStickyHeader(
                  header: RepaintBoundary(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: EdgeInsets.only(
                        // left: Layout.paddingL,
                        // right: Layout.paddingR,
                        top: 5,
                        bottom: Layout.paddingB,
                      ),
                      child: Visibility(
                        visible: categoryData.isNotEmpty,
                        child: Column(
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
                        ),
                      ),
                    ),
                  ),
                  sliver: ValueListenableBuilder<bool>(
                    valueListenable: isLoadingNotifier,
                    builder: (context, isLoading, child) {
                      return isShowContent(isLoading);
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  // 修改isShowContent方法，接收isLoading参数
  Widget isShowContent(bool isLoading) {
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
          maxCrossAxisExtent: 150.0,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          mainAxisExtent: 205,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            final videoItem = videoPageData[i];
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

            // 缓存组件（仅对前两页的数据进行缓存以平衡内存和性能）
            if (id != null && currentPage <= 2) {
              _videoItemCache[id] = widget;
            }

            return widget;
          },
          childCount: videoPageData.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: false, // 关闭语义索引以提高性能
        ),
      );
    }
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
