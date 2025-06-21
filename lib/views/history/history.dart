import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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
  // 提取常量
  static const _gradientColors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];
  static const _gradientStops = [0.2, 0.8];

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
  Future<void> noticeInfo() async {
    try {} catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

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
      _scrollControllerAdd();
      await noticeInfo();
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

  _scrollControllerAdd() {
    _scrollController.addListener(listenLoadMoreCallback);
  }

  void listenLoadMoreCallback() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // 滚动到底部时触发
      loadMore();
    }
  }

  Future<void> loadMore() async {
    debugPrint('loadMore');
    currentPage++;
    TDToast.showLoading(context: context, text: "加载中");
    await noticeInfo();
    TDToast.dismissLoading();
    if (disposed) {
      return;
    }
    setState(() {});
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
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  //设置背景色
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: VideoHistory(videoPageData: viewsData),
                ),
              ],
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
