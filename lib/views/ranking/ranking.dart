import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/video_one.dart';
import '../../entity/video_page_entity.dart';

class VideoRanking extends StatefulWidget {
  const VideoRanking({super.key});

  @override
  VideoRankingState createState() => VideoRankingState();
}

class VideoRankingState extends State<VideoRanking>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var _futureBuilderFuture;
  List<VideoPageDataList> videoPageData = [];
  List<VideoPageDataList> popularity_day = [];
  List<VideoPageDataList> popularity_week = [];
  List<VideoPageDataList> popularity_month = [];
  List<VideoPageDataList> popularity_sum = [];
  var tabs = [
    const TDTab(text: '热片榜'),
    const TDTab(text: '新片榜'),
    const TDTab(text: '好评榜'),
    const TDTab(text: '收藏榜'),
  ];
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

      data = {"page": currentPage, "sort": sort[0]};
      if (currentIndex == 0) {
        List<VideoPageDataList> list =
            (await Api.getVideoSortPage(data)).data?.list ??
            [] as List<VideoPageDataList>;
        data = {"page": currentPage, "sort": sort[2]};
        popularity_day = [...popularity_day, ...list];
      } else if (currentIndex == 1) {
        List<VideoPageDataList> list =
            (await Api.getVideoSortPage(data)).data?.list ??
            [] as List<VideoPageDataList>;
        data = {"page": currentPage, "sort": sort[0]};
        popularity_week = [...popularity_week, ...list];
      } else if (currentIndex == 2) {
        List<VideoPageDataList> list =
            (await Api.getVideoSortPage(data)).data?.list ??
            [] as List<VideoPageDataList>;
        data = {"page": currentPage, "sort": sort[3]};
        popularity_month = [...popularity_month, ...list];
      } else if (currentIndex == 3) {
        List<VideoPageDataList> list =
            (await Api.getVideoSortPage(data)).data?.list ??
            [] as List<VideoPageDataList>;
        data = {"page": currentPage, "sort": sort[currentIndex]};
        popularity_sum = [...popularity_sum, ...list];
      }
      setState(() {});
    } catch (e) {
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> initRequest() async {
    List<VideoPageDataList> popularity_day_list =
        (await Api.getVideoSortPage({
          "page": currentPage,
          "sort": "popularity_day",
          "size": 100,
        })).data?.list ??
        [] as List<VideoPageDataList>;

    popularity_day = [...popularity_day, ...popularity_day_list];

    List<VideoPageDataList> popularity_week_list =
        (await Api.getVideoSortPage({
          "page": currentPage,
          "sort": "popularity_week",
          "size": 100,
        })).data?.list ??
        [] as List<VideoPageDataList>;
    popularity_week = [...popularity_week, ...popularity_week_list];

    List<VideoPageDataList> popularity_month_list =
        (await Api.getVideoSortPage({
          "page": currentPage,
          "sort": "popularity_month",
          "size": 100,
        })).data?.list ??
        [] as List<VideoPageDataList>;
    popularity_month = [...popularity_month, ...popularity_month_list];

    List<VideoPageDataList> popularity_sum_list =
        (await Api.getVideoSortPage({
          "page": currentPage,
          "sort": "popularity_sum",
          "size": 100,
        })).data?.list ??
        [] as List<VideoPageDataList>;
    popularity_sum = [...popularity_sum, ...popularity_sum_list];
  }

  Future<String> init() async {
    try {
      _initTabController(0);
      await initRequest();
      // await getVideoSortPage();
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

  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Stack(
            children: [
              TDImage(
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                assetUrl: "assets/images/ranking.png",
                errorWidget: const TDImage(
                  width: 150,
                  assetUrl: 'assets/images/loading.gif',
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 70, left: 20),
                child: Text(
                  "排行榜",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildTabsContent(),
            ],
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  /// 初始化tab
  void _initTabController(int initialIndex) {
    _tabController = TabController(
      initialIndex: initialIndex,
      length: tabs.length,
      vsync: this,
    );
  }

  Widget _buildTabs() {
    return DefaultTabController(
      //清理下边框的样式
      length: tabs.length,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 0, top: 0),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerHeight: 0,
              //移除下划线
              // 使用空的指示器来移除下划线
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 0.0,
                  color: Colors.transparent,
                ), // 将宽度设置为0来隐藏下划线
              ),
              //选中的字体颜色
              labelColor: const Color.fromRGBO(252, 119, 66, 1),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelColor: const Color.fromRGBO(102, 102, 102, 1),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              tabs: tabs,
            ),
          ),
          Flexible(
            flex: 1,
            child: TabBarView(
              children: List.generate(tabs.length, (index) {
                return _getTabViews()[index];
              }),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getTabViews() {
    List<Widget> tabViews;
    tabViews = [
      VideoOne(videoData: popularity_day),
      VideoOne(videoData: popularity_week),
      VideoOne(videoData: popularity_month),
      VideoOne(videoData: popularity_sum),
    ];

    return tabViews;
  }

  Widget _buildTabsContent() {
    return Container(
      //动态计算高度
      margin: const EdgeInsets.only(top: 180),
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: _buildTabs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用 super.build
    return Scaffold(body: _buildContent());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
