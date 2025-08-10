import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../api/api.dart';
import '../../../components/loading.dart';
import '../../../entity/video_page_entity.dart';
import '../../components/no_data.dart';
import '../../entity/notice_Info_entity.dart';
import '../htmlPage/html.dart';

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

  // 数据加载逻辑分离
  Future<void> noticeInfo() async {
    try {
      List<NoticeInfoDataList> list =
          (await Api.noticeInfo({"page": currentPage})).data?.list
              as List<NoticeInfoDataList>;
      setState(() {
        noticeInfoData = list;
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
    TDToast.showLoading(context: context, text: "加载中");
    await noticeInfo();
    TDToast.dismissLoading();
    if (disposed) {
      return;
    }
    setState(() {});
  }

  // 页面跳转逻辑分离
  void _handleTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => HtmlPage(
              content: noticeInfoData?[index].content ?? "",
              title: noticeInfoData?[index].title ?? "",
            ),
      ),
    );
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
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            child: contentIsEmpty(context),
          );
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
      return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              noticeInfoData.isEmpty
                  ? Container()
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                        onTap: () {
                          _handleTap(index);
                        },
                      );
                    },
                  ),
            ],
          ),
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
