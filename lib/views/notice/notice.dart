import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../api/api.dart';
import '../../../components/loading.dart';
import '../../../entity/video_page_entity.dart';
import '../../components/no_data.dart';
import '../../entity/notice_Info_entity.dart';

// 提取渐变配置为独立类
class GradientConfig {
  static const List<Color> colors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];
  static const List<double> stops = [0.2, 0.8];
}

class Notice extends StatefulWidget {
  const Notice({super.key});

  @override
  NoticeState createState() => NoticeState();
}

class NoticeState extends State<Notice> with SingleTickerProviderStateMixin {
  var _futureBuilderFuture;
  String inputText = "";
  List<VideoPageDataList> videoPageData = [];
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  bool disposed = false;
  final ScrollController _scrollController = ScrollController();
  List<NoticeInfoDataList> noticeInfoData = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  // 数据加载逻辑分离
  Future<void> noticeInfo() async {
    try {
      List<NoticeInfoDataList> list =
          (await Api.noticeInfo({"page": currentPage})).data?.list
              as List<NoticeInfoDataList>;
      setState(() {
        noticeInfoData.addAll(list);
      });
    } catch (e) {
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<String> init() async {
    try {
      _scrollControllerAdd();
      await noticeInfo();
      return "init success";
    } catch (e) {
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
      loadMore();
    }
  }

  Future<void> loadMore() async {
    debugPrint('loadMore');
    currentPage++;
    await noticeInfo();
    if (disposed) {
      return;
    }
    setState(() {});
  }

  // 新增刷新方法
  Future<void> _onRefresh() async {
    currentPage = 1;
    noticeInfoData.clear();
    await noticeInfo();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  // 新增加载更多方法
  Future<void> _onLoading() async {
    currentPage++;
    await noticeInfo();
    if (mounted) {
      setState(() {});
      _refreshController.loadComplete();
    }
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return contentIsEmpty(context);
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget contentIsEmpty(BuildContext context) {
    if (noticeInfoData.isEmpty) {
      return NoData();
    } else {
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullUp: true,
        child: ListView.builder(
          itemCount: noticeInfoData.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      spacing: 10,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            _buildTitle(
                              noticeInfoData[index].title ?? "",
                            ),
                          ],
                        ),
                        Text(
                          noticeInfoData[index].summary ?? "",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(height: 0.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("查看详情")],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap:
                  () => Get.toNamed(
                    "/html",
                    arguments: {
                      "title": noticeInfoData[index].title ?? "",
                      "content": noticeInfoData[index].content ?? "",
                    },
                  ),
            );
          },
        ),
      );
    }
  }

  //标题title
  Widget _buildTitle(String title) {
    return TDTag(
      title,
      isOutline: true,
      textColor: Color.fromRGBO(249, 99, 7, 1),
      style: TDTagStyle(
        backgroundColor: Colors.transparent,
        borderColor: Color.fromRGBO(249, 99, 7, 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("通知", style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
      ),
      body: Container(child: _buildContent()),
    );
  }
}
