import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../components/loading.dart';
import '../../api/api.dart';
import '../../components/no_data.dart';
import '../../components/video_history.dart';
import '../../db/entity/UserEntity.dart';
import '../../db/manager/UserDatabaseHelper.dart';
import '../../entity/views_entity.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> with SingleTickerProviderStateMixin {
  var _futureBuilderFuture;
  String inputText = "";
  List<ViewsDataList> viewsData = [];
  TextEditingController searchController = TextEditingController();
  UserEntity? user;
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool _isLoading = false;
  bool _initialFetchCompleted = false;
  final RefreshController _refreshController = RefreshController();

  Future<void> getUserInfo() async {
    try {
      Iterable<UserEntity> list = userDatabaseHelper.list();
      if (list.isNotEmpty) {
        user = list.first;
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> _fetchViews({bool refresh = false}) async {
    if (_isLoading) {
      return;
    }
    if (refresh) {
      currentPage = 1;
      hasMore = true;
    }
    if (!hasMore) {
      return;
    }
    _isLoading = true;
    if (mounted) {
      setState(() {});
    }
    try {
      if (user == null) {
        await getUserInfo();
      }
      if (user != null) {
        final response = await Api.getViews({
          "createUserId": user?.userId,
          "type": 19,
          "page": currentPage,
          "size": pageSize,
        });

        final List<ViewsDataList> fetched =
            List<ViewsDataList>.from(response.data?.list ?? <ViewsDataList>[]);

        if (refresh) {
          viewsData = fetched;
        } else {
          viewsData.addAll(fetched);
        }

        final pagination = response.data?.pagination;
        final requestPage = currentPage;

        if (pagination != null && pagination.total != null) {
          final total = pagination.total ?? 0;
          final fetchedCount = requestPage * pageSize;
          hasMore = fetchedCount < total;
        } else {
          hasMore = fetched.length == pageSize;
        }

        if (hasMore) {
          currentPage = requestPage + 1;
        }
      } else {
        viewsData = [];
        hasMore = false;
      }

    } catch (e) {
      if (refresh) {
        viewsData = [];
      }
      hasMore = false;
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    } finally {
      _isLoading = false;
      _initialFetchCompleted = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> getViews({bool refresh = false}) async {
    await _fetchViews(refresh: refresh);
  }

  Future<String> init() async {
    try {
      await getUserInfo();
      await getViews(refresh: true);
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization failed: $e');
      return "init failed";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // 刷新数据的方法
  void _refreshData() {
    setState(() {
      _futureBuilderFuture = init();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 每次页面显示时刷新数据
    _refreshData();
  }

  Future<void> _onRefresh() async {
    await getViews(refresh: true);
    _refreshController
      ..refreshCompleted()
      ..resetNoData();
  }

  Future<void> _onLoading() async {
    if (!hasMore) {
      _refreshController.loadNoData();
      return;
    }
    await getViews();
    if (!hasMore) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        debugPrint('snapshot: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // 显示错误信息
        } else if (snapshot.hasData && snapshot.data == "init success") {
          if (!_initialFetchCompleted && _isLoading) {
            return PageLoading();
          }
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            enablePullDown: true,
            enablePullUp: true,
            child: viewsData.isEmpty
                ? (_isLoading ? PageLoading() : const NoData())
                : ListView.builder(
                    itemCount: viewsData.length,
                    itemBuilder: (context, index) {
                      return TDSwipeCell(
                        right: TDSwipeCellPanel(
                          children: [
                            TDSwipeCellAction(
                              flex: 60,
                              backgroundColor: TDTheme.of(context).errorColor6,
                              label: '删除',
                              onPressed: (context) async {
                                TDSwipeCell.of(context);
                                await Api.delViews({
                                  "ids": [viewsData[index].id],
                                });
                                viewsData.removeAt(index);
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                        cell: VideoHistoryItem(videoData: viewsData[index]),
                      );
                    },
                  ),
          );
        } else {
          return const Center(child: Text('暂无观看历史'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("观看历史", style: TextStyle(fontSize: 16)),
        //返回
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false, //设置为false
      ),
      body: _buildContent(),
    );
  }
}
