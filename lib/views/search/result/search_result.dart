import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/no_data.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../api/api.dart';
import '../../../components/loading.dart';
import '../../../components/video_one_small.dart';
import '../../../db/entity/SearchHistoryEntity.dart';
import '../../../db/manager/search_history_database_helper.dart';
import '../../../entity/video_page_entity.dart';

class SearchResult extends StatefulWidget {
  //接受路由传递过来的props id
  const SearchResult({super.key});

  @override
  SearchResultState createState() => SearchResultState();
}

class SearchResultState extends State<SearchResult>
    with SingleTickerProviderStateMixin {
  late Future<String> _futureBuilderFuture;
  String inputText = "";
  List<VideoPageDataList> videoPageData = [];
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  bool disposed = false;
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  String keyWord = Get.arguments["keyWord"];
  final searchHistory = SearchHistoryDatabaseHelper();

  // 添加状态标志，用于批量更新
  bool _shouldUpdateUI = false;

  // 添加搜索加载状态
  bool _isLoading = false;

  // 常量定义
  static const String _searchText = '搜索';
  static const String _searchResultText = '搜索结果';
  static const String _noDataAvailableText = 'No data available';
  static const double _navBarHeight = 36.0;
  static const double _navBarTitleMargin = 5.0;
  static const double _searchBarPaddingTop = 2.0;
  static const double _searchBarPaddingBottom = 2.0;
  static const double _searchResultPaddingLeft = 10.0;
  static const double _searchResultPaddingRight = 10.0;
  static const double _searchResultPaddingTop = 10.0;
  static const double _searchResultFontSize = 18.0;
  static const double _videoListPaddingTop = 10.0;
  static const int _pageSize = 10;
  static const int _apiTimeout = 10;

  // 布局常量
  static const EdgeInsets _navBarPadding = EdgeInsets.only(left: 0, right: 0);
  static const EdgeInsets _searchBarPadding = EdgeInsets.only(left: 0, right: 0, bottom: _searchBarPaddingBottom, top: _searchBarPaddingTop);
  static const EdgeInsets _searchResultPadding = EdgeInsets.only(
    left: _searchResultPaddingLeft,
    right: _searchResultPaddingRight,
    top: _searchResultPaddingTop,
  );
  static const EdgeInsets _videoListPadding = EdgeInsets.only(top: _videoListPaddingTop);
  static const TextStyle _searchResultTextStyle = TextStyle(
    fontSize: _searchResultFontSize,
    fontWeight: FontWeight.bold,
  );

  Future<void> getVideoPages() async {
    try {
      final data = {"page": currentPage, "keyWord": inputText};

      final response = await Api.getVideoPages(data).timeout(const Duration(seconds: _apiTimeout));
      final list = response.data?.list ?? [] as List<VideoPageDataList>;
      videoPageData = [...videoPageData, ...list];
    } catch (e) {
      // 捕获并处理异常
      debugPrint('getVideoPages failed: $e');
    }
  }

  // 批量更新UI的方法
  void _updateUI() {
    if (_shouldUpdateUI && mounted) {
      setState(() {});
      _shouldUpdateUI = false;
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
      debugPrint('Initialization failed: $e');
      return "init success";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    searchController.dispose();
    disposed = true;
    super.dispose();
  }

  Future<void> loadMore() async {
    debugPrint('loadMore');
    currentPage++;
    await getVideoPages();
    if (disposed) {
      return;
    }
    _shouldUpdateUI = true;
    _updateUI();
  }

  Widget _buildDefaultSearchBar() {
    return TDNavBar(
      useDefaultBack: true,
      screenAdaptation: false,
      backgroundColor: Colors.transparent,
      titleMargin: _navBarTitleMargin,
      height: _navBarHeight,
      centerTitle: false,
      padding: _navBarPadding,
      titleWidget: TDSearchBar(
        backgroundColor: Colors.transparent,
        controller: searchController,
        placeHolder: '',
        action: _searchText,
        style: TDSearchStyle.round,
        padding: _searchBarPadding,
        onTextChanged: (String text) {
          inputText = text; // 直接更新变量，不需要立即setState
        },
        onActionClick: (ctx) => search(context), // 使用当前widget的context
      ),
    );
  }

  Future<void> search(BuildContext context) async {
    // 关闭键盘
    FocusScope.of(context).unfocus();
    
    // 保存搜索历史
    if (inputText.isNotEmpty) {
      searchHistory.insertSearchHistory(
        SearchHistoryEntity(query: inputText, timestamp: DateTime.now()),
      );
    }

    // 设置加载状态为true
    setState(() {
      _isLoading = true;
    });

    // 重置分页并加载数据
    currentPage = 1;
    videoPageData.clear();
    await getVideoPages();

    // 设置加载状态为false
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (disposed) {
      return;
    }
    _shouldUpdateUI = true;
    _updateUI();
    // 刷新完成
    _refreshController.refreshCompleted();
  }

  // 添加刷新方法
  Future<void> _onRefresh() async {
    currentPage = 1;
    videoPageData.clear();
    await getVideoPages();

    if (disposed) return;
    _shouldUpdateUI = true;
    _updateUI();
    _refreshController.refreshCompleted();
  }

  // 添加加载更多方法
  Future<void> _onLoading() async {
    currentPage++;
    await getVideoPages();
    if (disposed) return;
    _shouldUpdateUI = true;
    _updateUI();

    // 判断是否还有更多数据
    if (videoPageData.length < currentPage * _pageSize) {
      // 假设每页10条数据
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(child: PageLoading()),
    );
  }

  Widget _buildNoDataWidget() {
    return NoData();
  }

  Widget _buildVideoListWidget() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: _videoListPadding,
            width: double.infinity,
            child: Column(
              children: [VideoOneSmall(videoPageData: videoPageData)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentWidget() {
    // 使用 SmartRefresher 包装内容，始终使用SmartRefresher
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child:
          _isLoading
              ? _buildLoadingWidget()
              : videoPageData.isEmpty
              ? _buildNoDataWidget()
              : _buildVideoListWidget(),
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
          return Center(child: Text('Error: ${snapshot.error}')); // 显示错误信息
        } else if (snapshot.hasData) {
          return Column(
            children: [
              _buildDefaultSearchBar(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: _searchResultPadding,
                      child: Text(
                        _searchResultText,
                        textAlign: TextAlign.left,
                        style: _searchResultTextStyle,
                      ),
                    ),
                    Expanded(child: _buildContentWidget()),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text(_noDataAvailableText));
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
}
