import 'package:chewie/chewie.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:fplayer/fplayer.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../api/api.dart';
import '../../components/auto_height_page_view/auto_height_page_view.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../components/video_scroll.dart';
import '../../entity/play_line_entity.dart';
import '../../entity/video_detail_entity.dart';
import '../../entity/video_line_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../style/layout.dart';

String TAG = 'Video_Detail';

class Video_Detail extends StatefulWidget {
  //接受路由传递过来的props id
  final int id;
  const Video_Detail({super.key, required this.id});

  @override
  _Video_DetailState createState() => _Video_DetailState();
}

class _Video_DetailState extends State<Video_Detail>
    with SingleTickerProviderStateMixin {
  // 提取常量
  static const Color primaryColor = Color.fromRGBO(255, 218, 112, 1);
  static const Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);
  final ValueNotifier<int> currentLine = ValueNotifier<int>(0);
  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0);

  var _futureBuilderFuture;
  VideoDetailData? videoData;
  List<VideoPageDataList> videoPageData = [];
  List<VideoLineDataList>? videoLineData = [];
  List<PlayLineDataList>? playerLineData = [];
  List<VideoItem> videoList = [];
  BuildContext? _context;
  TabController? _tabController;
  late VideoPlayerController _videoPlayerController;
  late ChewieController chewieController;
  final PageController pageController = PageController(initialPage: 0);
  final FPlayer player = FPlayer();

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
      videoData =
          (await Api.getVideoById({"id": widget.id})).data as VideoDetailData;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getVideoPages() async {
    try {
      List<VideoPageDataList> list =
          (await Api.getVideoPages({
            "category_id": videoData?.categoryChildId,
          })).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageData = list;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> addViews() async {
    try {
      await Api.addViews({
        "title": videoData?.title,
        "associationId": videoData?.id,
        "type": 19,
        "cover": videoData?.surfacePlot,
      });
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getVideoLinePages() async {
    try {
      videoLineData =
          (await Api.getVideoLinePages({"video_id": widget.id})).data?.list
              as List<VideoLineDataList>;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getPlayLinePages() async {
    try {
      playerLineData =
          (await Api.getPlayLinePages({
                "video_id": widget.id,
                "video_line_id": videoLineData?[currentLine.value].id,
                "size": 10000,
              })).data?.list
              as List<PlayLineDataList>;
      LogUtil.d("getPlayLinePages", tag: TAG);
      playerLineData?.forEach((element) {
        videoList.add(
          VideoItem(
            url: element.file ?? "",
            title: element.name ?? "",
            subTitle: element.subTitle ?? '',
          ),
        );
      });
      debugPrint(
        'Initialization getPlayLinePages success "video_id": ${widget.id}"video_line_id": ${videoLineData?[currentLine.value].id}',
      );
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  /// 初始化tab
  void _initTabController() {
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<String> init() async {
    try {
      _initTabController();
      await getVideoById();
      await getVideoLinePages();
      await getPlayLinePages();
      await getVideoPages();
      await addViews();
      setVideoUrl(playerLineData?[currentPlay.value].file ?? "");
      currentPlay.value = playerLineData?[currentPlay.value].id ?? 0;
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
      return "init success";
    }
  }

  Future<void> setVideoUrl(String url) async {
    try {
      player.setDataSource(url, autoPlay: true, showCover: true);
      debugPrint('setVideoUrl success: $url');
    } catch (error) {
      debugPrint('setVideoUrl error: $error');
      return;
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        return _handleFutureBuilder(snapshot);
      },
    );
  }

  Widget _handleFutureBuilder(AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return PageLoading();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      return Column(children: [_buildSponsorBar(), _buildNavigationTabs()]);
    } else {
      return Text('No data available');
    }
  }

  Widget _buildSponsorBar() {
    return Container(
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
      ),
      child: TDNoticeBar(
        context: '本片仅供学习参考，请勿用于商业用途。切勿传播违法信息。视频中的广告不参与本片制作，仅供学习参考。谨防上当受骗',
        speed: 50,
        height: 15,
        prefixIcon: TDIcons.sound,
        style: TDNoticeBarStyle(
          backgroundColor: const Color.fromRGBO(255, 233, 172, 1),
        ),
        marquee: true,
      ),
    );
  }

  Widget _buildTabsContent() {
    var tabs = [const TDTab(text: '详情'), const TDTab(text: '简介')];
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
        children: [
          Text(
            videoData?.title ?? "",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children:
                [
                      Text(videoData?.year ?? ""),
                      Text(
                        videoData?.region ?? "",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        videoData?.note ?? "",
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
        ],
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Column(children: [_buildTabsContent(), _buildTabs()]);
  }

  List<Widget> _getTabViews() {
    List<Widget> tabViews;
    tabViews = [
      ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // 视频信息
          _buildVideoInfo(),
          _buildEpisodeList(),
          // 广告横幅
          _buildBanner(),
          // 猜你喜欢
          _buildRecommendations(),
        ],
      ),
      _buildTabsVideoInfo(),
    ];

    return tabViews;
  }

  _play_change(PlayLineDataList item) async {
    currentPlay.value = item.id!;
    _videoPlayerController.dispose();
    await player.reset();
    setVideoUrl(item.file ?? "");
    setState(() {});
  }

  Widget _buildEpisodeList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(Layout.paddingL, 0, 16, 20),
      child: Column(
        spacing: 5,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '剧集',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: _buildPopFromBottomWithCloseAndLeftTitle(context),
                  ),
                ],
              ),
              Text(
                videoData?.note ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          // 自定义小屏列表
          SizedBox(
            width: double.infinity,
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                bool isCurrent = currentPlay.value == index;
                Color textColor = Colors.white;
                Color bgColor = Color.fromRGBO(232, 192, 44, 1);
                if (isCurrent) {
                  textColor = Colors.black;
                  bgColor = Color.fromRGBO(232, 220, 99, 1);
                }
                return GestureDetector(
                  onTap: () async {
                    await player.reset();
                    setState(() {
                      currentPlay.value = index;
                    });
                    setVideoUrl(videoList[index].url);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: index == 0 ? 0 : 10),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: bgColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      videoList[index].title,
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _play_change_line(VideoLineDataList item) async {
    currentLine.value = item.id!;
    await getPlayLinePages();
    setState(() {});
  }

  Widget _buildItemWithLogo(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentLine,
      builder: (context, key, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...(videoLineData ?? [])
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TDButton(
                          text: item.collectionName,
                          size: TDButtonSize.small,
                          style: TDButtonStyle(
                            textColor:
                                key == item.id
                                    ? const Color.fromRGBO(249, 174, 61, 1)
                                    : Colors.black,
                          ),
                          onTap: () => {_play_change_line(item)},
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopFromBottomWithCloseAndLeftTitle(BuildContext context) {
    return TDButton(
      text: '切换线路',
      size: TDButtonSize.small,
      type: TDButtonType.fill,
      shape: TDButtonShape.round,
      theme: TDButtonTheme.primary,
      style: TDButtonStyle(backgroundColor: Colors.transparent),
      onTap: () {
        Navigator.of(context).push(
          TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: '选集',
                titleLeft: true,
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildItemWithLogo(context),
                      //设置一个500滚动视图
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              '更新${playerLineData!.length}集',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 500,
                        //宽度占满
                        width: double.infinity,
                        child: ValueListenableBuilder<int>(
                          valueListenable: currentPlay,
                          builder: (context, key, child) {
                            return SingleChildScrollView(
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 8.0, // gap between adjacent chips
                                runSpacing: 4.0, // gap between lines
                                children: [
                                  ...(playerLineData ?? [])
                                      .map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: TDButton(
                                            text: item.name.toString(),
                                            size: TDButtonSize.small,
                                            style: TDButtonStyle(
                                              backgroundColor:
                                                  key == item.id
                                                      ? Color.fromRGBO(
                                                        255,
                                                        218,
                                                        112,
                                                        1,
                                                      )
                                                      : Color.fromRGBO(
                                                        255,
                                                        236,
                                                        180,
                                                        1,
                                                      ),
                                              textColor:
                                                  key == item.id
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                            onTap: () => _play_change(item),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDImage(
            fit: BoxFit.cover,
            width: double.infinity,
            assetUrl: 'assets/images/doubao.png',
            errorWidget: TDImage(
              fit: BoxFit.cover,
              assetUrl: 'assets/images/loading.gif',
            ),
          ),
        ],
      ),
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
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // 标题部分
          Row(
            spacing: 6,
            children: [
              TDImage(
                width: 80,
                height: 100,
                fit: BoxFit.cover,
                imgUrl: videoData?.surfacePlot ?? "",
                errorWidget: const TDImage(
                  fit: BoxFit.cover,
                  assetUrl: 'assets/images/loading.gif',
                ),
              ),
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Text(
                      videoData?.title ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        TDTag(videoData?.year ?? "2021"),
                        TDTag(videoData?.region ?? ""),
                        TDTag(videoData?.language ?? ""),
                        TDTag(videoData?.note ?? ""),
                      ],
                    ),
                    TDRate(value: (videoData?.doubanScore ?? 0).toDouble()),
                  ],
                ),
              ),
            ],
          ),
          // 导演
          _buildSection('导演', [videoData?.directors ?? "暂无"]),
          // 演员分组
          //将字符串 videoData?.actors以 /分割成list
          _buildSection('演员', videoData?.actors?.split('/') ?? []),

          // 剧情
          _buildPlotSection(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: items.map((item) => TDTag(item)).toList(),
        ),
      ],
    );
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
        Text(
          videoData?.introduce ?? "",
          // maxLines: 8,
          // overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      //  Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       stops: [0.2, 0.8],
      //       colors: [primaryColor, backgroundColor],
      //     ),
      //   ),
      //   child: _buildVideo(),
      // ),// 错误
      body: Stack(
        children: [
          // 背景
          _buildVideo(),
          Container(
            margin: EdgeInsets.only(top: 200),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 0.8],
                colors: [primaryColor, backgroundColor],
              ),
            ),
            child: _buildContent(),
          ), // 错误
        ],
      ),
    );
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
            // 视频列表列表
            videoList: videoList,
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
