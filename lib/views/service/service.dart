import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/video_live_entity.dart';
import '../../style/layout.dart';
import '../live_detail/live_detail.dart';

/// 直播页面主组件
class VideoService extends StatefulWidget {
  const VideoService({super.key});

  @override
  State<VideoService> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<VideoService> {
  List<DictInfoListData> dictInfoListData = [];
  List<VideoLiveDataList> videoLiveData = [];
  final _sideBarController = TDSideBarController();
  var _futureBuilderFuture;
  // 选中的分类
  int _selectedCategory = 0;
  String keyWord = "";
  // 添加 RefreshController
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  int _currentPage = 1;
  static const int _pageSize = 20;
  bool _isLoading = false;

  Future<void> getDictInfoPages() async {
    try {
      dictInfoListData =
          (await Api.getDictInfoPages({
            "order": "orderNum",
            "sort": "desc",
            "typeId": 34,
          })).data ??
          [] as List<DictInfoListData>;
    } catch (e) {
      // 捕获并处理异常
    }
  }

  Future<void> getVideoLivePages({bool isRefresh = true}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final categoryId = _selectedCategory != 0 ? _selectedCategory : null;
      final page = isRefresh ? 1 : _currentPage + 1;

      final response = await Api.getVideoLivePages({
        "page": page,
        "size": _pageSize,
        "keyword": keyWord,
        if (categoryId != null) "category_id": categoryId,
      });

      if (isRefresh) {
        videoLiveData.clear();
        _currentPage = 1;
      } else {
        _currentPage = page;
      }

      final newData = response.data?.list ?? [];
      videoLiveData.addAll(newData);

      // 判断是否还有更多数据
      if (newData.length < _pageSize) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }

      _refreshController.refreshCompleted();
      setState(() {});
    } catch (e) {
      // 处理异常
      _refreshController.refreshFailed();
      _refreshController.loadFailed();
    } finally {
      _isLoading = false;
    }
  }

  Future<String> init() async {
    try {
      await getDictInfoPages();
      await getVideoLivePages();
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      return "init success";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  Future<void> onRefresh() async {
    await getVideoLivePages(isRefresh: true);
  }

  Future<void> onLoadMore() async {
    await getVideoLivePages(isRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        automaticallyImplyLeading: false, //设置为false
        // 添加黑夜模式支持
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(
          left: Layout.paddingL,
          right: Layout.paddingR,
        ),
        //设置一个下到上以此是白色向黄色渐变的背景色
        child: _buildContent(),
      ),
    );
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        debugPrint('snapshot: ${snapshot.hasData}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: TextStyle(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
          ); // 显示错误信息
        } else if (snapshot.hasData) {
          return Row(
            children: [
              // 左侧分类侧边栏
              _buildCategorySidebar(),
              // 右侧内容区域
              Expanded(
                child: Column(
                  children: [
                    // 顶部搜索框
                    // _buildDefaultSearchBar(),
                    // 列表
                    Expanded(child: _buildStreamList()),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text(
            'No data available',
            style: TextStyle(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
          );
        }
      },
    );
  }

  /// 构建分类侧边栏
  Widget _buildCategorySidebar() {
    if (dictInfoListData.isEmpty) {
      return Container();
    }
    return SizedBox(
      width: 120,
      child: Card(
        // 添加黑夜模式支持
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
              bodyMedium: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
          child: TDSideBar(
            style: TDSideBarStyle.normal,
            value: _selectedCategory,
            controller: _sideBarController,
            unSelectedBgColor: Colors.transparent,
            selectedBgColor: Colors.transparent,
            selectedColor: Color.fromRGBO(255, 197, 6, 1),
            children:
                dictInfoListData
                    .map(
                      (ele) => TDSideBarItem(
                        label: ele.name ?? '',
                        value: ele.id ?? 0,
                      ),
                    )
                    .toList(),
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }

  Future<void> onSelected(int value) async {
    _selectedCategory = value;
    getVideoLivePages();
  }

  /// 构建直播列表
  Widget _buildStreamList() {
    if (videoLiveData.isEmpty) {
      return const NoData();
    }
    // 使用 SmartRefresher 包装 GridView
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 4.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: videoLiveData.length,
        itemBuilder: (context, index) {
          return videoCard(videoLiveData[index]);
        },
      ),
    );
  }

  Widget videoCard(VideoLiveDataList item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Live_Detail(id: item.id ?? 0),
          ),
        );
      },
      child: Card(
        // 添加黑夜模式支持
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            TDImage(width: 40, height: 40, imgUrl: item.image),
            SizedBox(
              width: 150,
              child: Text(
                item.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // 添加黑夜模式支持
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 添加 dispose 方法释放资源
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
