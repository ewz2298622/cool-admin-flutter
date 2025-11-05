import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
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
  List<int> years = List.generate(20, (index) => DateTime.now().year - index);
  final ValueNotifier<int> categoryCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> tagCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> yearCurrent = ValueNotifier<int>(0);
  final ValueNotifier<int> regionCurrent = ValueNotifier<int>(0);
  bool disposed = false;
  List<DictInfoListData> categoryDictList = [];
  List<DictInfoListData> areaDictList = [];
  List<DictInfoListData> categoryOriginalDictList = [];
  // 添加加载状态标志
  bool _isLoading = false;
  
  // 添加组件缓存映射
  final Map<int, Widget> _videoItemCache = {};
  final Map<String, Widget> _categoryWidgetCache = {};
  final Map<String, Widget> _tagWidgetCache = {};
  final Map<String, Widget> _areaWidgetCache = {};
  final Map<String, Widget> _yearWidgetCache = {};
  
  // 移除内容缓存，因为它会阻止下拉刷新功能

  Future<void> getVideoPages() async {
    try {
      final data = {
        "page": currentPage,
        "category_pid":
            categoryCurrent.value == 0 ? null : categoryCurrent.value,
        "video_tag":
            tagCurrent.value == 0
                ? null
                : tagData
                    .where((element) => element.id == tagCurrent.value)
                    .toList()[0]
                    .name,
        "year": yearCurrent.value == 0 ? null : yearCurrent.value,
        "region": regionCurrent.value == 0 ? null : regionCurrent.value,
      };

      // 使用 Future.microtask 来避免阻塞UI线程
      final response = await Future.microtask(() => Api.getVideoPages(data));
      final list = response.data?.list ?? [] as List<VideoPageDataList>;

      // 使用 ListView.separated 或 GridView.builder 时，添加唯一键可以提高性能
      if (currentPage == 1) {
        videoPageData = list;
      } else {
        videoPageData = [...videoPageData, ...list];
      }

      // 避免不必要的 setState 调用
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
      debugPrint('Initialization getVideoPages failed: $e');
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
    try {
      _isLoading = true; // 设置初始加载状态
      setState(() {});
      
      // 使用 Future.microtask 来避免阻塞UI线程
      await Future.microtask(() async {
        await Future.wait([
          getVideoPages(),
          getVideoCategoryPages(),
          getVideoAreaPages(),
          getVideoTagPages(),
        ]);
      });
      
      _isLoading = false; // 取消初始加载状态
      setState(() {});
      return "init success";
    } catch (e) {
      _isLoading = false; // 发生错误时取消加载状态
      setState(() {});
      // 捕获并处理异常
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
    super.dispose();
  }

  Widget _buildDefaultSearchBar() {
    return TDSearchBar(
      placeHolder: '',
      backgroundColor: Colors.transparent,
      readOnly: true,
      style: TDSearchStyle.round,
      onInputClick: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VideoSearch()),
        );
      },
    );
  }

  Future<void> _category_change(DictDataDataVideoCategory? item) async {
    if (item != null) {
      categoryCurrent.value = item.id ?? 0;
    } else {
      categoryCurrent.value = 0;
    }
    // 清除标签缓存
    _clearTagCache();
    // 清除视频项缓存
    _videoItemCache.clear();
    // 不再需要清除内容缓存
    // _cachedContent = null;
    videoPageData.clear();
    _isLoading = true;
    setState(() {});
    currentPage = 1;
    await getVideoPages();
    _isLoading = false;
    _year_change(0);
    _area_change(null);
    setState(() {});
  }

  Future<void> _tag_change(DictDataDataVideoTag? item) async {
    if (item != null) {
      tagCurrent.value = item.id ?? 0;
    } else {
      tagCurrent.value = 0;
    }
    // 清除标签缓存
    _clearTagCache();
    // 清除视频项缓存
    _videoItemCache.clear();
    // 不再需要清除内容缓存
    // _cachedContent = null;
    videoPageData.clear();
    _isLoading = true;
    setState(() {});
    currentPage = 1;
    await getVideoPages();
    _isLoading = false;
    _year_change(0);
    _area_change(null);
    setState(() {});
  }

  Future<void> _year_change(int item) async {
    yearCurrent.value = item;
    // 清除标签缓存
    _clearTagCache();
    // 清除视频项缓存
    _videoItemCache.clear();
    // 不再需要清除内容缓存
    // _cachedContent = null;
    videoPageData.clear();
    _isLoading = true;
    setState(() {});
    currentPage = 1;
    await getVideoPages();
    _isLoading = false;
    setState(() {});
  }

  Future<void> _area_change(DictInfoListData? item) async {
    if (item != null) {
      regionCurrent.value = item.id ?? 0;
    } else {
      regionCurrent.value = 0;
    }
    // 清除标签缓存
    _clearTagCache();
    // 清除视频项缓存
    _videoItemCache.clear();
    // 不再需要清除内容缓存
    // _cachedContent = null;
    videoPageData.clear();
    _isLoading = true;
    setState(() {});
    currentPage = 1;
    await getVideoPages();
    _isLoading = false;
  }

  // 添加清除缓存的方法
  void _clearTagCache() {
    _categoryWidgetCache.clear();
    _tagWidgetCache.clear();
    _areaWidgetCache.clear();
    _yearWidgetCache.clear();
  }

  Widget _buildCategoryRow(
    String title,
    List<DictDataDataVideoCategory> items,
  ) {
    if (items.isEmpty) {
      return Container();
    } else {
      return ValueListenableBuilder<int>(
        valueListenable: categoryCurrent,
        builder: (context, key, child) {
          // 生成缓存键
          final cacheKey = '$title-$key-${items.length}';
          
          // 检查缓存中是否已存在该组件
          if (_categoryWidgetCache.containsKey(cacheKey)) {
            return _categoryWidgetCache[cacheKey]!;
          }
          
          final widget = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  child: TDTag(
                    title,
                    shape: TDTagShape.round,
                    isLight: true,
                    size: TDTagSize.large,
                    textColor:
                        categoryCurrent.value == 0
                            ? const Color.fromRGBO(255, 122, 27, 1)
                            : Theme.of(context).textTheme.titleLarge?.color,
                    backgroundColor:
                        categoryCurrent.value == 0
                            ? const Color.fromRGBO(244, 244, 244, 1)
                            : Colors.transparent,
                    isOutline: true,
                    style: TDTagStyle(
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () {
                    _category_change(null);
                  },
                ),

                ...(items).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      child: TDTag(
                        item.name ?? "",
                        shape: TDTagShape.round,
                        isLight: true,
                        size: TDTagSize.large,
                        textColor:
                            key == item.id
                                ? const Color.fromRGBO(255, 122, 27, 1)
                                : Theme.of(context).textTheme.titleLarge?.color,
                        backgroundColor:
                            key == item.id
                                ? const Color.fromRGBO(244, 244, 244, 1)
                                : Colors.transparent,
                        isOutline: true,
                        style: TDTagStyle(
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () => _category_change(item),
                    ),
                  ),
                ),
              ],
            ),
          );
          
          // 缓存组件
          _categoryWidgetCache[cacheKey] = widget;
          return widget;
        },
      );
    }
  }

  Widget _buildTagRow(String title, List<DictDataDataVideoTag> items) {
    if (items.isEmpty) {
      return Container();
    } else {
      return ValueListenableBuilder<int>(
        valueListenable: tagCurrent,
        builder: (context, key, child) {
          // 生成缓存键
          final cacheKey = '$title-$key-${items.length}';
          
          // 检查缓存中是否已存在该组件
          if (_tagWidgetCache.containsKey(cacheKey)) {
            return _tagWidgetCache[cacheKey]!;
          }
          
          final widget = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  child: TDTag(
                    title,
                    shape: TDTagShape.round,
                    isLight: true,
                    size: TDTagSize.large,
                    textColor:
                        tagCurrent.value == 0
                            ? const Color.fromRGBO(255, 122, 27, 1)
                            : Theme.of(context).textTheme.titleLarge?.color,
                    backgroundColor:
                        tagCurrent.value == 0
                            ? const Color.fromRGBO(244, 244, 244, 1)
                            : Colors.transparent,
                    isOutline: true,
                    style: TDTagStyle(
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () {
                    _tag_change(null);
                  },
                ),

                ...(items).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      child: TDTag(
                        item.name ?? "",
                        shape: TDTagShape.round,
                        isLight: true,
                        size: TDTagSize.large,
                        textColor:
                            key == item.id
                                ? const Color.fromRGBO(255, 122, 27, 1)
                                : Theme.of(context).textTheme.titleLarge?.color,
                        backgroundColor:
                            key == item.id
                                ? const Color.fromRGBO(244, 244, 244, 1)
                                : Colors.transparent,
                        isOutline: true,
                        style: TDTagStyle(
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () => _tag_change(item),
                    ),
                  ),
                ),
              ],
            ),
          );
          
          // 缓存组件
          _tagWidgetCache[cacheKey] = widget;
          return widget;
        },
      );
    }
  }

  Widget _buildAreaRow(String title, List<DictInfoListData> items) {
    if (items.isEmpty) {
      return Container();
    } else {
      return ValueListenableBuilder<int>(
        valueListenable: regionCurrent,
        builder: (context, key, child) {
          // 生成缓存键
          final cacheKey = '$title-$key-${items.length}';
          
          // 检查缓存中是否已存在该组件
          if (_areaWidgetCache.containsKey(cacheKey)) {
            return _areaWidgetCache[cacheKey]!;
          }
          
          final widget = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  child: TDTag(
                    title,
                    isLight: true,
                    textColor:
                        regionCurrent.value == 0
                            ? const Color.fromRGBO(255, 122, 27, 1)
                            : Theme.of(context).textTheme.titleLarge?.color,
                    backgroundColor:
                        regionCurrent.value == 0
                            ? const Color.fromRGBO(244, 244, 244, 1)
                            : Colors.transparent,
                    shape: TDTagShape.round,
                    size: TDTagSize.large,
                    isOutline: true,
                    style: TDTagStyle(
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () {
                    _area_change(null);
                  },
                ),
                ...(items).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      child: TDTag(
                        item.name ?? "",
                        shape: TDTagShape.round,
                        size: TDTagSize.large,
                        isLight: true,
                        textColor:
                            key == item.id
                                ? const Color.fromRGBO(255, 122, 27, 1)
                                : Theme.of(context).textTheme.titleLarge?.color,
                        backgroundColor:
                            key == item.id
                                ? const Color.fromRGBO(244, 244, 244, 1)
                                : Colors.transparent,
                        isOutline: true,
                        style: TDTagStyle(
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () => _area_change(item),
                    ),
                  ),
                ),
              ],
            ),
          );
          
          // 缓存组件
          _areaWidgetCache[cacheKey] = widget;
          return widget;
        },
      );
    }
  }

  Widget _buildYearRow(String title, List<int> items) {
    return ValueListenableBuilder<int>(
      valueListenable: yearCurrent,
      builder: (context, key, child) {
        // 生成缓存键
        final cacheKey = '$title-$key-${items.length}';
        
        // 检查缓存中是否已存在该组件
        if (_yearWidgetCache.containsKey(cacheKey)) {
          return _yearWidgetCache[cacheKey]!;
        }
        
        final widget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                child: TDTag(
                  title,
                  isLight: true,
                  textColor:
                      yearCurrent.value == 0
                          ? const Color.fromRGBO(255, 122, 27, 1)
                          : Theme.of(context).textTheme.titleLarge?.color,
                  backgroundColor:
                      yearCurrent.value == 0
                          ? const Color.fromRGBO(244, 244, 244, 1)
                          : Colors.transparent,
                  shape: TDTagShape.round,
                  size: TDTagSize.large,
                  isOutline: true,
                  style: TDTagStyle(
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onTap: () {
                  _year_change(0);
                },
              ),
              ...(items).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    child: TDTag(
                      item.toString(),
                      isLight: true,
                      textColor:
                          key == item
                              ? const Color.fromRGBO(255, 122, 27, 1)
                              : Theme.of(context).textTheme.titleLarge?.color,
                      backgroundColor:
                          key == item
                              ? const Color.fromRGBO(244, 244, 244, 1)
                              : Colors.transparent,
                      shape: TDTagShape.round,
                      size: TDTagSize.large,
                      isOutline: true,
                      style: TDTagStyle(
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onTap: () => _year_change(item),
                  ),
                ),
              ),
            ],
          ),
        );
        
        // 缓存组件
        _yearWidgetCache[cacheKey] = widget;
        return widget;
      },
    );
  }

  Future<void> onRefresh() async {
    videoPageData.clear();
    // 清除所有缓存
    _clearTagCache();
    _videoItemCache.clear();
    _isLoading = true;
    if (mounted) {
      setState(() {});
    }
    currentPage = 1;
    await getVideoPages();
    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
    // 不再在这里调用_refreshController.refreshCompleted()，因为它在SmartRefresher的回调中调用
  }

  Future<void> loadMore() async {
    currentPage++;
    await getVideoPages();
    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
    TDToast.dismissLoading();
    // 不再在这里调用_refreshController.loadComplete()，因为它在SmartRefresher的回调中调用
  }

  final RefreshController _refreshController = RefreshController();

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        debugPrint('snapshot: ${snapshot.hasData}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.hasData) {
          // 注意：我们不再缓存整个内容，因为这会阻止下拉刷新和上拉加载更多功能
          // 每次都需要重新构建内容以确保刷新功能正常工作
          return SmartRefresher(
            onRefresh: () async {
              await onRefresh();
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              await loadMore();
              _refreshController.loadComplete();
            },
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            child: CustomScrollView(
              cacheExtent: 2000, // 增加缓存区域提高滚动性能
              slivers: <Widget>[
                SliverToBoxAdapter(child: _buildDefaultSearchBar()),
                SliverStickyHeader(
                  header: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.only(
                      left: Layout.paddingL,
                      right: Layout.paddingR,
                      top: 5,
                      bottom: Layout.paddingB,
                    ),
                    child: Visibility(
                      visible: (categoryData.isNotEmpty),
                      child: Column(
                        spacing: 10,
                        //左对齐
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategoryRow('全部分类', categoryData),
                          _buildTagRow("全部标签", tagData),
                          _buildAreaRow('全部地区', areaDictList),
                          _buildYearRow("全部年份", years),
                        ],
                      ),
                    ),
                  ),
                  sliver: isShowContent(),
                ),
              ],
            ),
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  Widget isShowContent() {
    if (_isLoading) {
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
            
            // 创建新的组件并缓存
            final widget = GridTile(
              key: ValueKey(id),
              child: Center(child: Video(videoData: videoItem)),
            );
            
            // 缓存组件（仅对第一页的数据进行缓存以节省内存）
            if (id != null && currentPage == 1) {
              _videoItemCache[id] = widget;
            }
            
            return widget;
          },
          childCount: videoPageData.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
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
