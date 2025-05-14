import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fplayer/fplayer.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../api/api.dart';
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
import '../../utils/dict.dart';

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
  //获取当前时间戳
  final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

  var _futureBuilderFuture;
  VideoDetailData? videoData;
  List<VideoPageDataList> videoPageData = [];
  List<VideoPageDataList> selectVideoPageData = [];
  List<VideoLineDataList>? videoLineData = [];
  List<PlayLineDataList>? playerLineData = [];
  List<VideoItem> videoList = [];
  List<DictDataDataArea>? area = [];
  List<DictDataDataVideoCategory>? videoCategory = [];
  List<DictDataDataLanguage>? language = [];
  TabController? _tabController;
  late VideoPlayerController _videoPlayerController;
  late ChewieController chewieController;
  final PageController pageController = PageController(initialPage: 0);
  final FPlayer player = FPlayer();
  late StreamSubscription _currentPosSubs;
  Duration _currentPos = Duration();

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
      await Api.addViews({
        "title": videoData?.title,
        "associationId": videoData?.id,
        "viewingDuration": seekTime,
        "duration": videoData?.duration,
        "type": 19,
        "cover": videoData?.surfacePlot,
        "videoIndex": currentPlay.value + 1,
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
      await getDictVideoCategoryData();
      await getDictLanguageData();
      await getDictAreaData();
      await getVideoById();
      await getVideoLinePages();
      await getPlayLinePages();
      await getVideoPages();
      setVideoUrl(playerLineData?[currentPlay.value].file ?? "");
      _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
        setState(() {
          _currentPos = v;
          videoData?.duration = player.value.duration.inMilliseconds;
          seekTime = _currentPos.inMilliseconds;
        });
      });
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
    addViews();
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
      return Stack(
        children: [
          _buildSponsorBar(),
          Padding(
            padding: const EdgeInsets.only(
              left: Layout.paddingL,
              right: Layout.paddingR,
              top: 0,
            ),
            // child: _buildNavigationTabs(),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
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
                    Expanded(
                      child: TabBarView(
                        children: [
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
                          SingleChildScrollView(child: _buildTabsVideoInfo()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Text('No data available');
    }
  }

  Widget _buildSponsorBar() {
    return Container(
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
        top: Layout.paddingT,
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
                                            width: 80,
                                            height: 48,
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
      child: Column(
        // 使用 Column 替代 ListView
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Column(
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
                      TDTag(
                        Dict.getDictName(
                          videoData?.region ?? 0,
                          area as List<DictDataDataArea>,
                        ),
                      ),
                      TDTag(
                        Dict.getDictName(
                          videoData?.categoryId ?? 0,
                          videoCategory as List<DictDataDataVideoCategory>,
                        ),
                      ),
                      TDTag(
                        Dict.getDictName(
                          videoData?.language ?? 0,
                          language as List<DictDataDataLanguage>,
                        ),
                      ),
                    ],
                  ),
                  TDRate(value: (videoData?.doubanScore ?? 0).toDouble()),
                ],
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
        Html(data: videoData?.introduce ?? ""),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
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
