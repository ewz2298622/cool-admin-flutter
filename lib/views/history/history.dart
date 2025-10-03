import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/loading.dart';
import '../../../entity/video_page_entity.dart';
import '../../api/api.dart';
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
      viewsData =
          (await Api.getViews({
                "createUserId": user?.userId,
                "type": 19,
              })).data?.list
              as List<ViewsDataList>;
      //重构数据将associationId赋值给id
      for (var element in viewsData) {
        element.id = element.associationId;
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
        debugPrint('snapshot: ${snapshot.hasData}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.hasData) {
          return SmartRefresher(
            onRefresh: () async {
              await init();
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              loadMore();
              _refreshController.loadComplete();
            },
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            // child: ListView(
            //   padding: const EdgeInsets.only(top: 0),
            //   children: [VideoHistory(videoPageData: viewsData)],
            // ),
            child: ListView.builder(
              itemCount: viewsData.length,
              itemBuilder: (context, index) {
                return VideoHistoryItem(videoData: viewsData[index]);
              },
            ),
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
