import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../api/api.dart';
import '../../../components/loading.dart';
import '../../../entity/video_page_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../htmlPage/html.dart';

class Notice extends StatefulWidget {
  const Notice({super.key});

  @override
  NoticeState createState() => NoticeState();
}

class NoticeState extends State<Notice> with SingleTickerProviderStateMixin {
  // 提取常量
  static const _gradientColors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];
  static const _gradientStops = [0.2, 0.8];

  var _futureBuilderFuture;
  String inputText = "";
  List<VideoPageDataList> videoPageData = [];
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  bool disposed = false;
  final ScrollController _scrollController = ScrollController();
  List<NoticeInfoDataList>? noticeInfoData = [];
  Future<void> noticeInfo() async {
    try {
      List<NoticeInfoDataList> list =
          (await Api.noticeInfo({"page": currentPage})).data?.list
              as List<NoticeInfoDataList> ??
          [];
      noticeInfoData = list;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<String> init() async {
    try {
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
            child: SingleChildScrollView(
              child: Expanded(
                child: Container(
                  //设置背景色
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  color: Color.fromRGBO(247, 250, 252, 1),
                  child: Column(
                    spacing: 10,
                    children: [
                      noticeInfoData!.isEmpty
                          ? Container()
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: noticeInfoData?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
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
                                        //两端对齐
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        //垂直居中
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          TDTag(
                                            "公告",
                                            isOutline: true,
                                            textColor: Color.fromRGBO(
                                              249,
                                              99,
                                              7,
                                              1,
                                            ),
                                            style: TDTagStyle(
                                              backgroundColor:
                                                  Colors.transparent,
                                              borderColor: Color.fromRGBO(
                                                249,
                                                99,
                                                7,
                                                1,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            noticeInfoData?[index].title ?? "",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),

                                      //修改Html最大两行
                                      Text(
                                        noticeInfoData?[index].summary ?? "",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      //分割线
                                      Divider(
                                        height: 0.5,
                                        color: Colors.grey[200],
                                      ),
                                      //
                                      Row(
                                        //两端对齐
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        //垂直居中
                                        children: [
                                          //点击时事件
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => HtmlPage(
                                                        content:
                                                            noticeInfoData?[index]
                                                                .content ??
                                                            "",
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Text("查看详情"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ),
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
        toolbarHeight: 20,
        automaticallyImplyLeading: false, //设置为false
        backgroundColor: const Color.fromRGBO(255, 218, 112, 1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: _gradientStops,
            colors: _gradientColors,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }
}
