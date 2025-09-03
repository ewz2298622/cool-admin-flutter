import 'package:flutter/material.dart';
import 'package:flutter_app/components/no_data.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../api/api.dart';
import '../../../components/loading.dart';
import '../../../components/video_one_small.dart';
import '../../../entity/video_page_entity.dart';

class SearchResult extends StatefulWidget {
  //接受路由传递过来的props id
  const SearchResult({super.key});

  @override
  SearchResultState createState() => SearchResultState();
}

class SearchResultState extends State<SearchResult>
    with SingleTickerProviderStateMixin {
  var _futureBuilderFuture;
  String inputText = "";
  List<VideoPageDataList> videoPageData = [];
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  bool disposed = false;
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  String keyWord = Get.arguments["keyWord"];

  Future<void> getVideoPages() async {
    try {
      Map<String, dynamic>? data = {"page": currentPage};
      data = {"page": currentPage, "keyWord": inputText};

      List<VideoPageDataList> list =
          (await Api.getVideoPages(data)).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageData = [...videoPageData, ...list];
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<String> init() async {
    try {
      setState(() {
        inputText = keyWord;
        searchController.text = keyWord;
      });
      await getVideoPages();
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
      return "init success";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  Future<void> loadMore() async {
    debugPrint('loadMore');
    currentPage++;
    // TDToast.showLoading(context: context, text: "加载中");
    await getVideoPages();
    // TDToast.dismissLoading();
    if (disposed) {
      return;
    }
    setState(() {});
  }

  Widget _buildDefaultSearchBar() {
    return TDNavBar(
      useDefaultBack: true,
      screenAdaptation: false,
      backgroundColor: Colors.transparent,
      titleMargin: 5,
      height: 36,
      centerTitle: false,
      padding: EdgeInsets.only(left: 0, right: 0),
      titleWidget: TDSearchBar(
        backgroundColor: Colors.transparent,
        controller: searchController,
        placeHolder: '',
        action: "搜索",
        style: TDSearchStyle.round,
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 2, top: 2),
        onTextChanged: (String text) {
          setState(() {
            inputText = text;
          });
        },
        onActionClick: (contexts) => search(),
      ),
    );
  }

  Future<void> search() async {
    currentPage = 1;
    videoPageData.clear();
    // TDToast.showLoading(context: context, text: "加载中");
    await getVideoPages();
    // TDToast.dismissLoading();
    if (disposed) {
      return;
    }
    setState(() {});
    // 刷新完成
    _refreshController.refreshCompleted();
  }

  // 添加刷新方法
  Future<void> _onRefresh() async {
    currentPage = 1;
    videoPageData.clear();
    await getVideoPages();
    if (disposed) return;
    setState(() {});
    _refreshController.refreshCompleted();
  }

  // 添加加载更多方法
  Future<void> _onLoading() async {
    currentPage++;
    await getVideoPages();
    if (disposed) return;
    setState(() {});

    // 判断是否还有更多数据
    if (videoPageData.length < currentPage * 10) {
      // 假设每页10条数据
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  Widget isShowContent() {
    // 使用 SmartRefresher 包装内容，始终使用SmartRefresher
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: _onRefresh,
      onLoading: _onLoading, child: videoPageData.isEmpty
          ? NoData()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: Column(
                      children: [VideoOneSmall(videoPageData: videoPageData)],
                    ),
                  ),
                ),
              ],
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
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.hasData) {
          return Column(
            children: [
              _buildDefaultSearchBar(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                      ),
                      child: Text(
                        '搜索结果',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: isShowContent()),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        automaticallyImplyLeading: false, //设置为false
      ),
      body: Container(child: _buildContent()),
    );
  }

  @override
  void dispose() {
    // 释放 RefreshController 资源
    _refreshController.dispose();
    super.dispose();
  }
}