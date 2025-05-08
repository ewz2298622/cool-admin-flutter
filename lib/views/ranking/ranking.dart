import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/auto_height_page_view/auto_height_page_view.dart';
import '../../components/loading.dart';
import '../../components/video_one.dart';
import '../../entity/video_sort_entity.dart';
import '../../style/layout.dart';
import '../video_detail/detail.dart';

class VideoRanking extends StatefulWidget {
  const VideoRanking({super.key});

  @override
  VideoRankingState createState() => VideoRankingState();
}

class VideoRankingState extends State<VideoRanking>
    with SingleTickerProviderStateMixin {
  var _futureBuilderFuture;
  List<VideoSortDataList> videoPageData = [];
  List<VideoSortDataList> popularity_day = [];
  List<VideoSortDataList> popularity_week = [];
  List<VideoSortDataList> popularity_month = [];
  List<VideoSortDataList> popularity_sum = [];
  final PageController pageController = PageController(initialPage: 0);
  TabController? _tabController;
  int currentPage = 1;
  int currentIndex = 0;
  List<String> sort = [
    "popularity_day",
    "popularity_week",
    "popularity_month",
    "popularity_sum",
  ];

  Future<void> getVideoSortPage() async {
    try {
      Map<String, dynamic>? data = {"page": currentPage, "category_pid": "1"};

      data = {
        "page": currentPage,
        "sort": sort[0],
        "category_pid": currentIndex,
      };
      List<VideoSortDataList> list =
          (await Api.getVideoSortPage(data)).data?.list ??
          [] as List<VideoSortDataList>;
      data = {
        "page": currentPage,
        "sort": sort[1],
        "category_pid": currentIndex,
      };
      videoPageData = [...videoPageData, ...list];
      if (currentIndex == 0) {
        List<VideoSortDataList> list =
            (await Api.getVideoSortPage(data)).data?.list ??
            [] as List<VideoSortDataList>;
        data = {"page": currentPage, "sort": sort[2], "category_pid": 0};
        popularity_day = [...popularity_day, ...list];
      } else if (currentIndex == 1) {
        List<VideoSortDataList> list =
            (await Api.getVideoSortPage(data)).data?.list ??
            [] as List<VideoSortDataList>;
        data = {"page": currentPage, "sort": sort[0], "category_pid": 1};
        popularity_week = [...popularity_week, ...list];
      } else if (currentIndex == 2) {
        List<VideoSortDataList> list =
            (await Api.getVideoSortPage(data)).data?.list ??
            [] as List<VideoSortDataList>;
        data = {"page": currentPage, "sort": sort[3], "category_pid": 2};
        popularity_month = [...popularity_month, ...list];
      } else if (currentIndex == 3) {
        List<VideoSortDataList> list =
            (await Api.getVideoSortPage(data)).data?.list ??
            [] as List<VideoSortDataList>;
        data = {
          "page": currentPage,
          "sort": sort[currentIndex],
          "category_pid": 3,
        };
        popularity_sum = [...popularity_sum, ...list];
      }
    } catch (e) {
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> initRequest() async {
    List<VideoSortDataList> popularity_day_list =
        (await Api.getVideoSortPage({
          "page": currentPage,
          "sort": "popularity_day",
        })).data?.list ??
        [] as List<VideoSortDataList>;

    popularity_day = [...popularity_day, ...popularity_day_list];

    List<VideoSortDataList> popularity_week_list =
        (await Api.getVideoSortPage({
          "page": currentPage,
          "sort": "popularity_week",
        })).data?.list ??
        [] as List<VideoSortDataList>;
    popularity_week = [...popularity_week, ...popularity_week_list];

    List<VideoSortDataList> popularity_month_list =
        (await Api.getVideoSortPage({
          "page": currentPage,
          "sort": "popularity_month",
        })).data?.list ??
        [] as List<VideoSortDataList>;
    popularity_month = [...popularity_month, ...popularity_month_list];

    List<VideoSortDataList> popularity_sum_list =
        (await Api.getVideoSortPage({
          "page": currentPage,
          "sort": "popularity_sum",
        })).data?.list ??
        [] as List<VideoSortDataList>;
    popularity_sum = [...popularity_sum, ...popularity_sum_list];
  }

  Future<String> init() async {
    try {
      _initTabController();
      await initRequest();
      // await getVideoSortPage();
      return "init success";
    } catch (e) {
      print('Initialization failed: $e');
      return "init success";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

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
            child: Column(
              children: [
                Stack(
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      assetUrl: "assets/images/ranking.png" ?? "",
                      errorWidget: const TDImage(
                        width: 150,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        "排行榜",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildList(),
                    Container(
                      margin: const EdgeInsets.only(top: 160, left: 20),
                      child: _buildTabsContent(),
                    ),
                  ],
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

  /// 初始化tab
  void _initTabController() {
    _tabController = TabController(length: 4, vsync: this);
  }

  Widget _buildTabsContent() {
    var tabs = [
      const TDTab(text: '热片榜'),
      const TDTab(text: '新片榜'),
      const TDTab(text: '好评榜'),
      const TDTab(text: '收藏榜'),
    ];
    return Stack(
      children: [
        TDTabBar(
          tabs: tabs,
          controller: _tabController,
          showIndicator: false,
          dividerHeight: 0,
          height: 40,
          isScrollable: true,
          labelColor: const Color.fromRGBO(252, 119, 66, 1),
          unselectedLabelColor: const Color.fromRGBO(102, 102, 102, 1),
          labelPadding: const EdgeInsets.only(left: 16, right: 16),
          onTap: (index) {
            currentIndex = index;
            pageController.jumpToPage(index);
          },
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return AutoHeightPageView(
      pageController: pageController,
      children: _getTabViews(),
      onPageChanged: (index) {
        _tabController?.animateTo(index);
      },
    );
  }

  List<Widget> _getTabViews() {
    List<Widget> tabViews;
    debugPrint("popularity_day: $popularity_day");
    debugPrint("popularity_week: $popularity_week");
    tabViews = [
      VideoOne(videoData: popularity_day),
      VideoOne(videoData: popularity_week),
      VideoOne(videoData: popularity_month),
      VideoOne(videoData: popularity_sum),
    ];

    return tabViews;
  }

  Widget _buildList() {
    return Container(
      margin: const EdgeInsets.only(top: 160),
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
        top: Layout.paddingT + 20,
        bottom: Layout.paddingB,
      ),
      width: double.infinity,
      //动态计算高度
      height: MediaQuery.of(context).size.height - 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(children: [_buildTabs()]),
      ),
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
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
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
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  void _buildvideo_onClick(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Color.fromRGBO(255, 218, 112, 1),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 0.8],
                colors: [
                  Color.fromRGBO(255, 218, 112, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
              ),
            ),
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}
