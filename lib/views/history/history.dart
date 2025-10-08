import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../components/loading.dart';
import '../../../entity/video_page_entity.dart';
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
  List<VideoPageDataList> videoPageData = [];
  List<ViewsDataList> viewsData = [];
  TextEditingController searchController = TextEditingController();
  UserEntity? user;
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  int currentPage = 1;
  bool disposed = false;
  final ScrollController _scrollController = ScrollController();

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

  Future<void> getViews() async {
    try {
      if (user != null) {
        var response = await Api.getViews({
          "createUserId": user?.userId,
          "type": 19,
        });

        if (response.data?.list != null) {
          viewsData = response.data!.list as List<ViewsDataList>;
        }
        setState(() {});
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<String> init() async {
    try {
      await getUserInfo();
      await getViews();
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
    disposed = true;
    _scrollController.dispose();
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

  Future<void> loadMore() async {
    debugPrint('loadMore');
    currentPage++;
    if (disposed) {
      return;
    }
    setState(() {});
  }

  final RefreshController _refreshController = RefreshController();

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
          return SmartRefresher(
            onRefresh: () async {
              await init();
              _refreshController.refreshCompleted();
              setState(() {}); // 刷新UI
            },
            onLoading: () async {
              await loadMore();
              _refreshController.loadComplete();
            },
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            child: ListView.builder(
              itemCount: viewsData.length,
              itemBuilder: (context, index) {
                // return VideoHistoryItem(videoData: viewsData[index]);
                if (viewsData.isEmpty) {
                  return NoData();
                }
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
                          getViews();
                          viewsData.removeAt(index);
                          setState(() {});
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
