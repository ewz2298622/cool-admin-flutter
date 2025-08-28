import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:dlna_dart/dlna.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fplayer/fplayer.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/banner_ads.dart';
import '../../components/detail_tabs_vews.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../components/select_option_detail.dart';
import '../../components/video_scroll.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/play_line_entity.dart';
import '../../entity/video_detail_entity.dart';
import '../../entity/video_line_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../style/layout.dart';
import '../../utils/bus/bus.dart';
import '../../utils/bus/constant.dart';
import '../../utils/dict.dart';
import '../../utils/video.dart';
import '../feedback/feedback.dart';

String TAG = 'Video_Detail';

class Video_Detail extends StatefulWidget {
  const Video_Detail({super.key});

  @override
  _Video_DetailState createState() => _Video_DetailState();
}

class _Video_DetailState extends State<Video_Detail> with RouteAware {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  final ValueNotifier<int> currentLine = ValueNotifier<int>(0);
  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0);
  StateSetter? showModalBottomSheetListSate;
  //获取当前时间戳
  final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

  var _futureBuilderFuture;
  VideoDetailData? videoData;
  List<VideoPageDataList> videoPageData = [];
  List<VideoPageDataList> selectVideoPageData = [];
  List<VideoLineDataList> videoLineData = [];
  List<PlayLineDataList> playerLineData = [];
  List<VideoItem> videoList = [];
  List<DictDataDataArea>? area = [];
  List<DictDataDataVideoCategory>? videoCategory = [];
  List<DictDataDataLanguage>? language = [];
  late ChewieController chewieController;
  final PageController pageController = PageController(initialPage: 0);
  final FPlayer player = FPlayer();
  List<dynamic> deviceList = [];
  List<TDTab> tabs = [];
  List<List<PlayLineDataList>> tabData = [];
  StateSetter? TVshowModalBottomSheetListSate;
  final id = Get.arguments["id"];

  // 倍速列表
  final Map<String, double> speedList = {
    "2.0": 2.0,
    "1.5": 1.5,
    "1.0": 1.0,
    "0.5": 0.5,
  };

  // 模拟播放记录视频初始化完需要跳转的进度
  int seekTime = 100000;

  Future<void> getVideoById() async {
    try {
      videoData = (await Api.getVideoById({"id": id})).data as VideoDetailData;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getDictAreaData() async {
    try {
      area =
          ((await Api.getDictData({
                    "types": ["area"],
                  })).data
                  as DictDataData)
              .area;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getDictVideoCategoryData() async {
    try {
      videoCategory =
          ((await Api.getDictData({
                    "types": ["video_category"],
                  })).data
                  as DictDataData)
              .videoCategory;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getDictLanguageData() async {
    try {
      language =
          ((await Api.getDictData({
                    "types": ["language"],
                  })).data
                  as DictDataData)
              .language;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getVideoPages() async {
    try {
      List<VideoPageDataList> list =
          (await Api.getVideoPages({
            "category_id": videoData?.categoryId ?? 0,
          })).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageData = list;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<String> getSelectVideoPages(Map<String, dynamic> params) async {
    try {
      List<VideoPageDataList> list =
          (await Api.getVideoPages(params)).data?.list ??
          [] as List<VideoPageDataList>;
      selectVideoPageData = list;
      setState(() {
        selectVideoPageData = list;
      });
      return "init success";
    } catch (e) {
      return "init error";
    }
  }

  Future<void> addViews() async {
    try {
      if (videoData?.duration == null) {
        return;
      }
      await Api.addViews({
        "title": videoData?.title,
        "associationId": videoData?.id,
        "viewingDuration": seekTime,
        "duration": videoData?.duration,
        "type": 19,
        "cover": videoData?.surfacePlot,
        "videoIndex": currentPlay.value + 1,
      });
      eventBus.fire(RefreshViewEvent());
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getVideoLinePages() async {
    try {
      videoLineData =
          (await Api.getVideoLinePages({"video_id": id})).data?.list
              as List<VideoLineDataList>;
      for (var element in videoLineData) {
        tabs.add(TDTab(text: element.collectionName));
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getPlayLinePages() async {
    try {
      playerLineData.clear();
      videoList.clear();
      playerLineData =
          (await Api.getPlayLinePages({
                "video_id": id,
                "video_line_id": videoLineData[currentLine.value].id,
                "size": 10000,
              })).data?.list
              as List<PlayLineDataList>;

      setState(() {
        for (var element in playerLineData) {
          videoList.add(
            VideoItem(
              url: element.file ?? "",
              title: element.videoName ?? "",
              subTitle: element.subTitle ?? '',
            ),
          );
        }
      });
      debugPrint(
        'Initialization getPlayLinePages success "video_id": ${id}"video_line_id": ${videoLineData[currentLine.value].id}',
      );
      debugPrint(
        'Initialization getPlayLinePages success videoList: ${videoList.length}',
      );
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getPlayLinePagesTabs() async {
    try {
      playerLineData.clear();
      videoList.clear();
      playerLineData =
          (await Api.getPlayLinePages({
                "video_id": id,
                // "video_line_id": videoLineData[currentLine.value].id,
                "size": 10000,
              })).data?.list
              as List<PlayLineDataList>;

      tabData = groupAndSortByCollectionId(playerLineData);
      getPlayLinePages();
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  List<List<PlayLineDataList>> groupAndSortByCollectionId(
    List<PlayLineDataList> data,
  ) {
    debugPrint("groupAndSortByCollectionId");
    // 创建一个Map来存储按collection_id分组的数据
    Map<int, List<PlayLineDataList>> groupedData = {};

    // 遍历原始数据，按collection_id分组
    for (var item in data) {
      int collectionId = item.collectionId as int;
      if (!groupedData.containsKey(collectionId)) {
        groupedData[collectionId] = [];
      }
      groupedData[collectionId]!.add(item);
    }

    // 对每个分组内的数据按sort字段进行排序
    List<List<PlayLineDataList>> result = [];
    groupedData.forEach((collectionId, items) {
      // 按sort字段从小到大排序
      items.sort((a, b) => (a.sort as int).compareTo(b.sort as int));
      result.add(items);
    });

    // 如果需要按collection_id排序（可选）
    // result.sort((a, b) => a.first['collection_id'].compareTo(b.first['collection_id']));

    debugPrint("groupAndSortByCollectionId: ${result.length}");

    return result;
  }

  /// 初始化tab
  void _initTabController() {}

  Future<String> init() async {
    try {
      _initTabController();
      await getVideoById();
      await getVideoLinePages();
      await getPlayLinePages();
      // await getVideoPages();
      await getPlayLinePagesTabs();
      await Future.wait([
        getDictVideoCategoryData(),
        getDictLanguageData(),
        getDictAreaData(),
        getVideoPages(),
      ]);
      _errorListener();
      setVideoUrl(playerLineData[currentPlay.value].file ?? "");
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      return "init success";
    }
  }

  _errorListener() {
    // player._errorListener(() => {});
    //监听播放器错误
    player.addListener(playerValueChanged);
  }

  playerValueChanged() {
    FValue value = player.value;
    if (value.state == FState.error) {
      debugPrint("播放失败");
      Api.VideoLineUpdate({
        "id": playerLineData[currentPlay.value].id,
        "status": 0,
      });
    }
  }

  Future<void> setVideoUrl(String url) async {
    try {
      await player.reset();
      player.setDataSource(url, autoPlay: true, showCover: true);
    } catch (error) {
      debugPrint('setVideoUrl error: $error');
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  goFeedbackPage() {
    player.stop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => FeedbackPage(
              videoId: playerLineData[currentPlay.value].videoId ?? "0",
              videoUrl: playerLineData[currentPlay.value].file ?? "",
              videoName: videoData?.title ?? "",
              playLineId: playerLineData[currentPlay.value].id ?? 0,
            ),
      ),
    );
  }

  @override
  void didPop() {
    ///从B退回到A的是调用
    print("detailllll didPop");
    super.didPop();
  }

  @override
  void didPush() {
    ///从A进入B的时候调用
    print("detailllll didPush");

    super.didPush();
  }

  @override
  void didPopNext() {
    ///从C回到B的时候调用
    print("detailllll didPopNext");
    super.didPopNext();
  }

  @override
  void didPushNext() {
    ///从B进入C的时候调用
    print("detailllll didPushNext");
    super.didPushNext();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
    removeVideo();
    debugPrint('detailllll dispose');
    addViews();
  }

  removeVideo() {
    player.stop();
    player.reset();
    player.release();
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
          return _handleFutureBuilder(snapshot);
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget _handleFutureBuilder(AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return PageLoading();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      return Padding(
        padding: const EdgeInsets.only(
          left: Layout.paddingL,
          right: Layout.paddingR,
        ),
        // child: _buildNavigationTabs(),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TabBar(
                        dividerHeight: 0,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicatorPadding: const EdgeInsets.all(0),
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 0.0,
                            color: Colors.transparent,
                          ), // 将宽度设置为0来隐藏下划线
                        ),
                        //设置未选中的字体颜色
                        unselectedLabelColor: const Color.fromRGBO(
                          153,
                          153,
                          153,
                          1,
                        ),
                        //选中的字体颜色
                        labelColor: const Color.fromRGBO(252, 119, 66, 1),
                        tabs: [Tab(text: '详情'), Tab(text: '简介')],
                      ),
                    ),
                    IconButton(
                      onPressed: goFeedbackPage,
                      icon: Icon(Icons.warning_rounded),
                    ),
                    _buildPopFromBottomWithCloseAndLeftTitle(context),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // 视频信息
                            _buildVideoInfo(),
                            // 广告横幅
                            _buildBanner(),
                            // 猜你喜欢
                            _buildRecommendations(),
                          ],
                        ),
                      ),
                      SingleChildScrollView(child: _buildTabsVideoInfo()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Text('No data available');
    }
  }

  Widget _buildSponsorBar() {
    return Padding(
      padding: const EdgeInsets.only(
        // left: Layout.paddingL,
        // right: Layout.paddingR,
        top: 5,
      ),
      child: TDNoticeBar(
        context: '本片仅供学习参考，请勿用于商业用途。切勿传播违法信息。视频中的广告不参与本片制作，仅供学习参考。谨防上当受骗',
        speed: 50,
        height: 15,
        prefixIcon: TDIcons.sound,
        style: TDNoticeBarStyle(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        ),
        marquee: true,
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Text(
                  videoData?.title ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      begin: Alignment.bottomCenter, // 从底部开始
                      end: Alignment.topCenter, // 到顶部结束
                      colors: [
                        Color.fromRGBO(255, 153, 0, 0),
                        Color.fromRGBO(255, 153, 0, 1), // 完全不透明的橙色
                      ], // 黑色到白色
                    ).createShader(bounds),
                child: Text(
                  VideoUtil.formatScore(videoData?.doubanScore),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(255, 153, 0, 1),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children:
                [
                      Text(videoData?.year.toString() ?? ""),
                      Text(
                        Dict.getDictName(
                          videoData?.region ?? 0,
                          area as List<DictDataDataArea>,
                        ),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        Dict.getDictName(
                          videoData?.categoryId ?? 0,
                          videoCategory as List<DictDataDataVideoCategory>,
                        ),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        Dict.getDictName(
                          videoData?.language ?? 0,
                          language as List<DictDataDataLanguage>,
                        ),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        videoData?.videoTag ?? "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(right: Layout.paddingR),
                        child: e,
                      ),
                    )
                    .toList(),
          ),
          _buildSponsorBar(),
          _buildEpisodeList(),
        ],
      ),
    );
  }

  Widget _buildEpisodeList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        spacing: 5,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '选集',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheetList();
                    },
                    child: Row(
                      children: [
                        Text(
                          videoData?.remarks ?? "暂无描述",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(162, 162, 162, 1),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Color.fromRGBO(203, 203, 203, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 自定义小屏列表
          _buildPlayer(),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (tabData.isEmpty) {
      return const Text("暂无数据");
    }
    if (tabData[currentPlay.value].isEmpty) {
      return const Text("暂无数据");
    }
    List<PlayLineDataList> entry = tabData[currentPlay.value];
    return ValueListenableBuilder<int>(
      valueListenable: currentPlay,
      builder: (context, key, child) {
        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 水平滚动
            itemCount: entry.length, // 列表项数量
            itemBuilder: (context, index) {
              final item = entry[index]; // 获取当前项
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        currentPlay.value == index
                            ? const Color.fromRGBO(252, 119, 66, 1)
                            : Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    try {
                      currentPlay.value = index;
                      setVideoUrl(entry[index].file ?? "");
                    } catch (e) {
                      debugPrint("切换选集：${e.toString()}");
                    }
                  },
                  child: Text(
                    item.name ?? '',
                    style: TextStyle(
                      color:
                          currentPlay.value == index
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottomWithCloseAndLeftTitle(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPlay, // 确保绑定到正确的 ValueNotifier
      builder: (context, key, child) {
        return TDButton(
          text: '切换线路',
          size: TDButtonSize.small,
          type: TDButtonType.fill,
          shape: TDButtonShape.round,
          theme: TDButtonTheme.primary,
          style: TDButtonStyle(
            backgroundColor: Colors.transparent,
            textColor: const Color.fromRGBO(252, 119, 66, 1),
          ),
          onTap: () {
            showModalBottomSheetList();
          },
        );
      },
    );
  }

  showModalBottomSheetList() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            showModalBottomSheetListSate = setState;
            return Card(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                height: 650,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "切换线路",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: Navigator.of(context).pop,
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      Flexible(
                        flex: 1,
                        child: DetailTabsView(
                          tabData: tabData,
                          tabs: videoLineData,
                          onSelectionChanged: (tabIndex, selectedIndices) {
                            setVideoUrl(
                              tabData[tabIndex][selectedIndices.first].file ??
                                  "",
                            );
                            setState(() {
                              currentPlay.value = selectedIndices.first;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBanner() {
    return Container(
      //宽度95%
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: BannerAds(androidCodeId: "969380337", iosCodeId: "969380337"),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
        top: Layout.paddingT,
        bottom: Layout.paddingB,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SectionWithMore(title: "猜你喜欢"),
          HorizontalVideoList(videoPageData: videoPageData),
        ],
      ),
    );
  }

  Widget _buildTabsVideoInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
      ),
      child: Column(
        // 使用 Column 替代 ListView
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          // 标题部分
          Row(
            spacing: 6,
            children: [
              TDImage(
                width: 150,
                height: 100,
                fit: BoxFit.cover,
                imgUrl: videoData?.surfacePlot ?? "",
                errorWidget: const TDImage(
                  fit: BoxFit.cover,
                  assetUrl: 'assets/images/loading.gif',
                ),
              ),
              Expanded(
                child: Column(
                  //从上到下排列
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      videoData?.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TDRate(
                      value: (videoData?.doubanScore ?? 0).toDouble(),
                      disabled: true,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 5,
                        children: [
                          Text(
                            videoData?.videoClass ?? "暂无分类",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            videoData?.videoTag ?? "暂无标签",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        //可以水平滚动
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          TDTag(
                            videoData?.year.toString() ?? "暂无上映时间",
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                          TDTag(
                            Dict.getDictName(
                              videoData?.region ?? 0,
                              area as List<DictDataDataArea>,
                            ),
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                          TDTag(
                            Dict.getDictName(
                              videoData?.categoryId ?? 0,
                              videoCategory as List<DictDataDataVideoCategory>,
                            ),
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                          TDTag(
                            Dict.getDictName(
                              videoData?.language ?? 0,
                              language as List<DictDataDataLanguage>,
                            ),
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 导演
          DynamicSelectOption(
            title: '导演',
            items: formatString(videoData?.directors ?? ""),
            paramsKey: 'directors',
            loadData: (params) async {
              List<VideoPageDataList> list =
                  (await Api.getVideoPages(params)).data?.list ??
                  [] as List<VideoPageDataList>;
              return list;
            },
          ),
          DynamicSelectOption(
            title: '演员',
            items: formatString(videoData?.actors ?? ""),
            paramsKey: 'actors',
            loadData: (params) async {
              List<VideoPageDataList> list =
                  (await Api.getVideoPages(params)).data?.list ??
                  [] as List<VideoPageDataList>;
              return list;
            },
          ),
          // 剧情
          _buildPlotSection(),
        ],
      ),
    );
  }

  //实现一个格式化函数 判断传入的字符串是否含有,或者/ 如果有就按照这两个字符串分割返回一个list
  List<String> formatString(String str) {
    if (str.contains(',')) {
      return str.split(',');
    }
    if (str.contains('/')) {
      return str.split('/');
    }
    return [str];
  }

  Widget _buildPlotSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '剧情',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 2,
          ),
        ),
        Html(
          data: videoData?.introduce ?? "",
          style: {
            "body": Style(
              // maxLines: 4, // 限制最大行数
              // textOverflow: TextOverflow.ellipsis, // 溢出显示省略号
              color: Color.fromRGBO(153, 153, 153, 1),
              backgroundColor: Colors.transparent,
            ),
            "p": Style(
              color: Color.fromRGBO(153, 153, 153, 1),
              backgroundColor: Colors.transparent,
            ),
            //设置所有html元素字体的颜色
            "span": Style(
              color: Color.fromRGBO(153, 153, 153, 1),
              backgroundColor: Colors.transparent,
            ),
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 背景
          _buildVideo(),
          Container(
            margin: EdgeInsets.only(top: 200),
            child: _buildContent(),
          ), // 错误
        ],
      ),
    );
  }

  //搜索设备
  Future<void> searchDevice() async {
    final searcher = DLNAManager();
    final m = await searcher.start();
    m.devices.stream.listen((dataList) {
      for (var entry in dataList.entries) {
        final key = entry.key;
        final value = entry.value;

        TVshowModalBottomSheetListSate?.call(() {
          if (deviceList.isEmpty) {
            Map<String, dynamic> data = {'key': key, 'value': value};
            deviceList.add(data);
          } else {
            bool isAlreadyAdded = false;
            for (var element in deviceList) {
              if (element['key'] == key) {
                isAlreadyAdded = true;
                break;
              }
            }
            if (!isAlreadyAdded) {
              Map<String, dynamic> data = {'key': key, 'value': value};
              deviceList.add(data);
            }
          }
        });
      }
    });
  }

  tvDevice() {
    searchDevice();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            TVshowModalBottomSheetListSate = setState;
            return Card(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                height: 650,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "投屏",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: Navigator.of(context).pop,
                              child: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        //定位组件
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Text(
                                  "注意:",
                                  style: TextStyle(
                                    color: Color.fromARGB(142, 142, 142, 0),
                                  ),
                                ),
                                Text(
                                  "1、电视投屏的广告与本APP无关",
                                  style: TextStyle(
                                    color: Color.fromARGB(142, 142, 142, 0),
                                  ),
                                ),
                                Text(
                                  "2、投屏后无法再次投屏，请重置投屏或者退出投屏",
                                  style: TextStyle(
                                    color: Color.fromARGB(142, 142, 142, 0),
                                  ),
                                ),
                                Text(
                                  "3、设备扫描过程是持续的请静心等待10秒左右",
                                  style: TextStyle(
                                    color: Color.fromARGB(142, 142, 142, 0),
                                  ),
                                ),

                                // 修改: 解决Row可能存在的布局溢出问题
                                tvDeviceLoading(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget tvDeviceLoading() {
    if (deviceList.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: TDLoading(
            size: TDLoadingSize.large,
            icon: TDLoadingIcon.circle,
          ),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: deviceList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TDButton(
              text: deviceList[index]["value"].info.friendlyName,
              size: TDButtonSize.large,
              onTap: () {
                deviceList[index]["value"].setUrl(
                  playerLineData[currentPlay.value].file ?? "",
                );
              },
              type: TDButtonType.outline,
              shape: TDButtonShape.rectangle,
              theme: TDButtonTheme.primary,
            ),
          );
        },
      );
    }
  }

  Widget _buildVideo() {
    return Column(
      children: [
        FView(
          player: player,
          width: double.infinity,
          height: 200, // 需自行设置，此处宽度/高度=16/9
          color: Colors.black,
          fsFit: FFit.contain, // 全屏模式下的填充
          fit: FFit.fill, // 正常模式下的填充
          panelBuilder: fPanelBuilder(
            // 视频列表开关
            isVideos: true,
            // 右下方截屏按钮
            isSnapShot: true,
            // 右上方按钮组开关
            isRightButton: true,
            // 右上方按钮组
            // rightButtonList: [
            //   InkWell(
            //     onTap: () {},
            //     child: Container(
            //       padding: const EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).primaryColorLight,
            //         borderRadius: const BorderRadius.vertical(
            //           top: Radius.circular(5),
            //         ),
            //       ),
            //       child: Icon(
            //         Icons.favorite,
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //   ),
            //   InkWell(
            //     onTap: () {},
            //     child: Container(
            //       padding: const EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).primaryColorLight,
            //         borderRadius: const BorderRadius.vertical(
            //           bottom: Radius.circular(5),
            //         ),
            //       ),
            //       child: Icon(
            //         Icons.thumb_up,
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //   ),
            // ],
            settingFun: () {
              tvDevice();
            },
            // 视频列表列表
            videoList:
                videoList.isEmpty
                    ? [
                      VideoItem(
                        url: "",
                        title: videoData?.title ?? "加载失败",
                        subTitle: "",
                      ),
                    ]
                    : videoList,
            // 当前视频索引
            videoIndex: currentPlay.value,
            // 全屏模式下点击播放下一集视频回调
            playNextVideoFun: () {
              setState(() {
                currentPlay.value += 1;
              });
            },
            // 视频播放完成回调
            onVideoEnd: () async {
              var index = currentPlay.value + 1;
              if (index < videoList.length) {
                await player.reset();
                setState(() {
                  currentPlay.value = index;
                });
                setVideoUrl(videoList[index].url);
              }
            },
          ),
        ),
      ],
    );
  }
}
