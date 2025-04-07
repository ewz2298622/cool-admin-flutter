import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../api/api.dart';
import '../../../entity/video_page_entity.dart';
import '../../video_detail/detail.dart';

class SearchResult extends StatefulWidget {
  //接受路由传递过来的props id
  final String keyWord;
  const SearchResult({super.key, required this.keyWord});

  @override
  SearchResultState createState() => SearchResultState();
}

class SearchResultState extends State<SearchResult>
    with SingleTickerProviderStateMixin {
  // 提取常量
  static const _gradientColors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1)
  ];
  static const _gradientStops = [0.2, 0.8];
  static const _hdTagTextStyle = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
  static const _videoNoteTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  var _futureBuilderFuture;
  String inputText = "";
  List<VideoPageDataList> videoPageData = [];
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  bool disposed = false;
  final ScrollController _scrollController = ScrollController();

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
      inputText = widget.keyWord;
      searchController.text = widget.keyWord;
      _scrollControllerAdd();
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
    await getVideoPages();
    TDToast.dismissLoading();
    if (disposed) {
      return;
    }
    setState(() {});
  }

  Widget _buildDefaultSearchBar() {
    return TDSearchBar(
      placeHolder: '',
      action: "搜索",
      backgroundColor: Colors.transparent,
      controller: searchController,
      style: TDSearchStyle.round,
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
      onActionClick: (contexts) => search(),
    );
  }

  Future<void> search() async {
    currentPage = 1;
    videoPageData.clear();
    TDToast.showLoading(context: context, text: "加载中");
    await getVideoPages();
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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            child: Column(
              children: [
                _buildDefaultSearchBar(),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  //白色圆角背景
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(children: [_buildAlbumItems()]),
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

  void _buildvideo_onClick(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  Widget _buildAlbumItems() {
    return Column(
      children: List<Widget>.generate(videoPageData.length, (i) {
        return GestureDetector(
          onTap: () => {_buildvideo_onClick(videoPageData[i].id ?? 0)},
          child: Container(
            height: 185,
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 15),
            child: Row(
              children: [
                Stack(
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: 120,
                      height: 180,
                      imgUrl: videoPageData?[i].cycleImg ?? "",
                      errorWidget: const TDImage(
                        width: 150,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    _buildVideoItemOverlay(videoPageData?[i]),
                  ],
                ),
                SizedBox(
                  width: 220, // 调整宽度以确保有足够的空间
                  height: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        videoPageData?[i].title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${videoPageData?[i].year ?? ''} / ${videoPageData?[i].actors}",
                        maxLines: 3, // 限制最多显示 3 行
                        overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                        style: const TextStyle(
                          fontSize: 12, // 调整字体大小
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        videoPageData?[i].introduce ?? "",
                        maxLines: 3, // 限制最多显示 3 行
                        overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                        style: const TextStyle(
                          fontSize: 12, // 调整字体大小
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVideoItemOverlay(dynamic item) {
    return Container(
      width: 130,
      height: 175,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildVideoItemHDTag(), _buildVideoItemNote(item)],
      ),
    );
  }

  Widget _buildVideoItemNote(dynamic item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 15, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromRGBO(0, 0, 0, 0.302),
          ),
          child: Text(
            item?.note ?? '',
            maxLines: 1, // 限制最大显示一行
            overflow: TextOverflow.ellipsis, // 溢出时显示省略号
            style: _videoNoteTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoItemHDTag() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 15, top: 5),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(59, 101, 244, 1),
                Color.fromRGBO(64, 177, 254, 1),
              ],
            ),
          ),
          child: const Text(
            "高清",
            style: _hdTagTextStyle,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: _gradientColors[0],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
        ],
      ),
    );
  }
}
