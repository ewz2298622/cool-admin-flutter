import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
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
  //定义一个二维数组储存List<VideoPageDataList>
  List<List<VideoPageDataList>> videoPageDataList = [];
  List<RefreshController> tabRefreshController = [];

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
  // 添加每个tab的当前页码
  List<int> pageList = [1, 1, 1, 1];
  // 添加每个tab是否还有更多数据的标记
  List<bool> hasMoreList = [true, true, true, true];

  // 新增共用函数，根据index添加不同分类的数据
  Future<List<VideoPageDataList>> _fetchDataByIndex(
    int index, {
    int page = 1,
  }) async {
    // 如果没有更多数据，直接返回空列表
    if (!hasMoreList[index]) {
      return [];
    }

    VideoPageEntity response = await Api.getVideoSortPage({
      "page": page,
      "sort": sort[index],
      "size": 10,
    });

    return response.data?.list ?? [] as List<VideoPageDataList>;
  }

  Future<void> initRequest() async {
    // 重置状态
    pageList = [1, 1, 1, 1];
    hasMoreList = [true, true, true, true];

    // 使用共用函数获取各分类数据
    for (int i = 0; i < sort.length; i++) {
      List<VideoPageDataList> dataList = await _fetchDataByIndex(i, page: 1);
      switch (i) {
        case 0:
          popularity_day = dataList;
          break;
        case 1:
          popularity_week = dataList;
          break;
        case 2:
          popularity_month = dataList;
          break;
        case 3:
          popularity_sum = dataList;
          break;
      }
    }

    videoPageDataList = [
      popularity_day,
      popularity_week,
      popularity_month,
      popularity_sum,
    ];
  }

  // 新增加载更多数据的函数
  Future<void> loadMoreData(int index) async {
    if (!hasMoreList[index]) return;

    pageList[index]++;
    List<VideoPageDataList> dataList = await _fetchDataByIndex(
      index,
      page: pageList[index],
    );

    setState(() {
      switch (index) {
        case 0:
          popularity_day = [...popularity_day, ...dataList];
          break;
        case 1:
          popularity_week = [...popularity_week, ...dataList];
          break;
        case 2:
          popularity_month = [...popularity_month, ...dataList];
          break;
        case 3:
          popularity_sum = [...popularity_sum, ...dataList];
          break;
      }
      videoPageDataList = [
        popularity_day,
        popularity_week,
        popularity_month,
        popularity_sum,
      ];
    });
  }

  Future<String> init() async {
    try {
      _initTabController(0);
      await initRequest();
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
          return contentIsEmpty();
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget contentIsEmpty() {
    if (videoPageDataList.isEmpty) {
      return Padding(padding: const EdgeInsets.only(top: 120), child: NoData());
    } else {
      return Stack(
        children: [
          TDImage(
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
            imgUrl: videoPageDataList[currentIndex][0].surfacePlot ?? "",
            errorWidget: const TDImage(
              width: 150,
              assetUrl: 'assets/images/loading.gif',
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent, // 顶部透明
                  Colors.black, // 底部黑色
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    "排行榜",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "根据内容热点排名，每小时更新一次",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          _buildTabsContent(),
        ],
      );
    }
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
      //会哦去当前索引
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            currentIndex = tabController.index;
            setState(() {});
            print("New tab index: ${tabController.index}");
          });
          return Column(
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
                    // 确保每个tab都有独立的RefreshController
                    while (tabRefreshController.length <= index) {
                      tabRefreshController.add(RefreshController());
                    }
                    return SmartRefresher(
                      controller: tabRefreshController[index],
                      onRefresh: () async {
                        // 刷新当前tab的数据
                        pageList[index] = 1;
                        hasMoreList[index] = true;
                        List<VideoPageDataList> dataList =
                            await _fetchDataByIndex(index, page: 1);
                        switch (index) {
                          case 0:
                            popularity_day = dataList;
                            break;
                          case 1:
                            popularity_week = dataList;
                            break;
                          case 2:
                            popularity_month = dataList;
                            break;
                          case 3:
                            popularity_sum = dataList;
                            break;
                        }
                        videoPageDataList = [
                          popularity_day,
                          popularity_week,
                          popularity_month,
                          popularity_sum,
                        ];
                        setState(() {});
                        tabRefreshController[index].refreshCompleted();
                      },
                      onLoading: () async {
                        // 加载更多数据
                        await loadMoreData(index);
                        if (mounted) {
                          setState(() {});
                        }
                        // 确保控制器存在且状态正确
                        if (index < tabRefreshController.length) {
                          if (hasMoreList[index]) {
                            tabRefreshController[index].loadComplete();
                          } else {
                            tabRefreshController[index].loadNoData();
                          }
                        }
                      },
                      enablePullUp: true,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: videoPageDataList[index].length,
                        itemBuilder: (context, key) {
                          return VideoOne(
                            videoData: videoPageDataList[index][key],
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
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
