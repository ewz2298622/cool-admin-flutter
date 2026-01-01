import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import '../../entity/app_ads_entity.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/play_line_entity.dart';
import '../../entity/video_detail_data_entity.dart';
import '../../entity/video_detail_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../main.dart'; // 导入main.dart以访问routeObserver
import '../../style/layout.dart';
import '../../utils/ads_config.dart';
import '../../utils/bus/bus.dart';
import '../../utils/bus/constant.dart';
import '../../utils/cast_screen_manager.dart'; // 导入投屏管理类
import '../../utils/dict.dart';
import '../../utils/user.dart';
import '../../utils/video.dart';
import '../../utils/video_download.dart';

String TAG = 'Video_Detail';

class Video_Detail extends StatefulWidget {
  const Video_Detail({super.key});

  @override
  _Video_DetailState createState() => _Video_DetailState();
}

class _Video_DetailState extends State<Video_Detail> with RouteAware {
  final ValueNotifier<int> currentLine = ValueNotifier<int>(0);
  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0);
  StateSetter? showModalBottomSheetListSate;
  //获取当前时间戳
  final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

  var _futureBuilderFuture;
  VideoDetailData? videoData;
  List<VideoPageDataList> videoPageData = [];
  List<VideoPageDataList> selectVideoPageData = [];
  List<PlayLineDataList> playerLineData = [];
  List<VideoItem> videoList = [];
  List<DictDataDataArea>? area = [];
  List<DictDataDataVideoCategory>? videoCategory = [];
  List<DictDataDataLanguage>? language = [];
  final PageController pageController = PageController(initialPage: 0);
  late FPlayer player = FPlayer();
  List<dynamic> deviceList = [];
  StateSetter? TVshowModalBottomSheetListSate;
  final CastScreenManager _castScreenManager = CastScreenManager(); // 添加投屏管理器
  final id = Get.arguments["id"];
  final viewingDuration = Get.arguments["viewingDuration"];
  String androidCodeId = AdsConfig.INTERSTITIAL_AD_ANDROID;
  String iosCodeId = AdsConfig.INTERSTITIAL_AD_IOS;
  VideoDetailDataData videoInfoData = VideoDetailDataData();
  List<TDTab> tabs = []; // 添加缺失的 tabs 变量定义
  //定义进度
  int progress = 0;
  //定义视频总时长
  int duration = 0;
  // 倍速列表
  final Map<String, double> speedList = {
    "2.0": 2.0,
    "1.5": 1.5,
    "1.0": 1.0,
    "0.5": 0.5,
  };

  // 模拟播放记录视频初始化完需要跳转的进度
  int seekTime = 100000;

  // 添加一个变量来跟踪是否已经调用了addViews
  bool _hasAddedViews = false;

  // 添加一个定时器来定期更新播放进度
  Timer? _positionTimer;

  // 添加变量来跟踪播放器状态
  bool _isPlayerInitialized = false;
  bool _isPlayerReleased = false;

  // 开始监听播放进度
  void _startPositionListener() {
    _positionTimer?.cancel();
  }

  // 停止监听播放进度
  void _stopPositionListener() {
    _positionTimer?.cancel();
    _positionTimer = null;
  }

  // 在页面离开时调用addViews的方法
  void _onPageLeave() {
    if (!_hasAddedViews) {
      addViews();
      _hasAddedViews = true;
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

  getVideoDetail() async {
    try {
      videoInfoData =
          ((await Api.getVideoDetail({"id": id})).data as VideoDetailDataData);
      // 添加容错处理：确保lines存在且不为空
      if (videoInfoData.lines != null && videoInfoData.lines!.isNotEmpty) {
        for (var element in videoInfoData.lines!) {
          tabs.add(TDTab(text: element.collectionName ?? '线路'));
        }
        // 修复类型错误，正确获取选中的播放链接
        final selectedLine = videoInfoData.lines?[currentLine.value];
        final selectedPlayLine = selectedLine?.playLines?[currentPlay.value];
        setVideoUrl(selectedPlayLine?.file ?? "");
        //如果selectedLine?.playLines不是空且selectedLine?.playLines的长度大于0
        if (selectedLine?.playLines != null) {
          final playerLineData = selectedLine?.playLines ?? [];
          if (playerLineData.isNotEmpty) {
            videoList.addAll(
              playerLineData.map((playLine) {
                return VideoItem(
                  title: playLine.videoName ?? "",
                  url: playLine.file ?? "",
                  subTitle: playLine.subTitle ?? "",
                );
              }),
            );
          }
        }
      } else {
        // 如果lines不存在或为空，设置默认值
        tabs = [TDTab(text: "默认线路")];
        videoList = [
          VideoItem(
            title: videoInfoData.video?.title ?? "视频",
            url: "",
            subTitle: "暂无播放链接",
          ),
        ];
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoDetail failed: $e');
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
            "category_id": videoInfoData.video?.categoryId ?? 0,
            //page参数随机1-20整数
            "page": Random().nextInt(2) + 1,
          })).data?.list ??
          [] as List<VideoPageDataList>;
      setState(() {
        videoPageData = list;
      });
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

  //视频监听
  void _videoListener() {
    player.onCurrentPosUpdate.listen((pos) {
      progress = pos.inSeconds;
    });
  }

  Future<void> addViews() async {
    if (!User.isLogin()) {
      return;
    }
    try {
      if (videoInfoData.video?.id != null) {
        await Api.addViews({
          "title": videoInfoData.video?.title,
          "associationId": videoInfoData.video?.id ?? 1,
          "viewingDuration": progress,
          "duration": player.value.duration.inMilliseconds ~/ 1000,
          "type": 19,
          "cover": videoInfoData.video?.surfacePlot ?? "",
          "videoIndex": currentPlay.value,
        });
        eventBus.fire(RefreshViewEvent());
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization addViews failed: $e');
    }
  }

  /// 初始化tab
  void _initTabController() {}

  Future<String> init() async {
    try {
      _initTabController();
      await getVideoDetail();
      await Future.wait([
        getDictVideoCategoryData(),
        getDictLanguageData(),
        getDictAreaData(),
        getVideoPages(),
      ]);
      _errorListener();
      await _loadAd();
      _videoListener();
      _isPlayerInitialized = true;
      _isPlayerReleased = false;
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      return "init success";
    }
  }

  //广告加载（直接从 API 请求，带超时保护，不阻塞页面显示）
  Future<void> _loadAd() async {
    try {
      // 设置请求超时为 2 秒，避免长时间阻塞
      AppAdsEntity response = await Api.getAdsList({
        'status': 1,
        "adsPage": 897,
        'type': 680,
      }).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint("Banner广告请求超时");
          throw TimeoutException("Banner广告请求超时");
        },
      );

      List<AppAdsDataList> adsList =
          response.data?.list ?? [] as List<AppAdsDataList>;

      if (!mounted) return;

      if (adsList.isNotEmpty) {
        //筛选adsList数组中adsPage=897且type=680的数据
        List<AppAdsDataList> filteredAds =
            adsList.where((adsData) {
              return adsData.adsPage == 897 && adsData.type == 680;
            }).toList();
        if (filteredAds.isNotEmpty) {
          AppAdsDataList adsData = filteredAds[0];
          if (mounted) {
            setState(() {
              androidCodeId = adsData.adsId ?? androidCodeId;
              iosCodeId = adsData.adsId ?? iosCodeId;
            });
            debugPrint("_loadAd Banner广告数据:$filteredAds");
          }
        }
      }
    } catch (e) {
      debugPrint("_loadAd Banner广告加载失败: $e");
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
      // 添加容错处理
      if (videoInfoData.lines != null &&
          videoInfoData.lines!.isNotEmpty &&
          currentPlay.value < videoInfoData.lines!.length) {
        Api.VideoLineUpdate({
          "id": videoInfoData.lines?[currentPlay.value].id,
          "status": 0,
        });
      }
    }
  }

  Future<void> setVideoUrl(String url) async {
    try {
      // 如果播放器已被释放，重新初始化
      if (_isPlayerReleased) {
        _isPlayerReleased = false;
      }
      // 添加容错处理，如果url为空则不播放
      if (url.isNotEmpty) {
        // 重置播放器并设置新的数据源
        await player.reset();
        player.setDataSource(url, autoPlay: true, showCover: true);
      }
      // 开始监听播放进度
      _startPositionListener();
      setState(() {});
    } catch (error) {
      debugPrint('setVideoUrl error: $error');
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    // 设置投屏设备列表更新回调
    _castScreenManager.onDeviceListUpdate = (devices) {
      setState(() {
        deviceList = devices;
      });
      TVshowModalBottomSheetListSate?.call(() {});
    };
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 订阅路由变化
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    debugPrint('Video_Detail: dispose called');
    // 在组件销毁前调用addViews
    _onPageLeave();
    // 停止监听播放进度
    _stopPositionListener();
    super.dispose();
    removeVideo();
    // 取消路由订阅
    routeObserver.unsubscribe(this);
    // 释放投屏管理器资源
    _castScreenManager.dispose();
  }

  // 当页面被其他页面覆盖时调用
  @override
  void didPushNext() {
    debugPrint('Video_Detail: didPushNext called - page is being covered');
    // 页面被其他页面覆盖时不调用addViews，保持播放状态
    // _onPageLeave();
  }

  // 当页面从导航栈中移除时调用
  @override
  void didPop() {
    debugPrint(
      'Video_Detail: didPop called - page is being removed from stack',
    );
    // 页面从导航栈中移除时调用addViews
    _onPageLeave();
  }

  // 当页面重新变为可见时调用
  @override
  void didPopNext() {
    debugPrint(
      'Video_Detail: didPopNext called - page is becoming visible again',
    );
    // 页面重新变为可见时，如果播放器已被释放则重新初始化
    if (_isPlayerReleased && _isPlayerInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 重新设置当前视频URL
        if (videoInfoData.lines != null &&
            videoInfoData.lines!.isNotEmpty &&
            currentLine.value < videoInfoData.lines!.length) {
          final selectedLine = videoInfoData.lines?[currentLine.value];
          if (selectedLine?.playLines != null &&
              currentPlay.value < (selectedLine?.playLines?.length ?? 0)) {
            final selectedPlayLine =
                selectedLine?.playLines?[currentPlay.value];
            setVideoUrl(selectedPlayLine?.file ?? "");
          }
        }
      });
    }
  }

  goFeedbackPage() {
    // 添加容错处理
    String? videoId;
    String? videoUrl;
    String? videoName;
    int? playLineId;

    if (videoInfoData.lines != null &&
        videoInfoData.lines!.isNotEmpty &&
        currentLine.value < videoInfoData.lines!.length) {
      final selectedLine = videoInfoData.lines?[currentLine.value];
      if (selectedLine?.playLines != null &&
          currentPlay.value < (selectedLine?.playLines?.length ?? 0)) {
        videoId = selectedLine?.playLines?[currentPlay.value].videoId;
        videoUrl = selectedLine?.playLines?[currentPlay.value].file;
        playLineId = selectedLine?.playLines?[currentPlay.value].id;
      }
    }
    removeVideo();
    Get.toNamed(
      "/feedback",
      arguments: {
        "videoId": videoId,
        "videoUrl": videoUrl,
        "videoName": videoData?.title,
        "playLineId": playLineId,
      },
    );
  }

  removeVideo() {
    // 在视频被销毁前调用addViews记录观看历史
    _onPageLeave();
    // 停止监听播放进度
    _stopPositionListener();
    player.reset();
    _isPlayerReleased = true;
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
                    // _buildPopFromBottomWithCloseAndLeftTitle(context),
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
                  videoInfoData.video?.title ?? "",
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
                  VideoUtil.formatScore(videoInfoData.video?.doubanScore),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(255, 153, 0, 1),
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                        Text(videoInfoData.video?.year.toString() ?? "暂无数据"),
                        Text(
                          Dict.getDictName(
                            videoInfoData.video?.region ?? 0,
                            area ?? [],
                          ),
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          Dict.getDictName(
                            videoInfoData.video?.categoryId ?? 0,
                            videoCategory ?? [],
                          ),
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          Dict.getDictName(
                            videoInfoData.video?.language ?? 0,
                            language ?? [],
                          ),
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          (videoInfoData.video?.videoTag ?? "暂无标签").replaceAll(
                            ",",
                            "/",
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
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheetList();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              videoInfoData.video?.remarks ?? "暂无描述",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(162, 162, 162, 1),
                              ),
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
    // 添加容错处理：检查lines是否存在且不为空
    if (videoInfoData.lines != null && videoInfoData.lines!.isNotEmpty) {
      return ValueListenableBuilder<int>(
        valueListenable: currentLine,
        builder: (context, lineIndex, child) {
          // 在builder内部获取当前线路的playLines，确保数据是最新的
          final selectedLine = videoInfoData.lines?[lineIndex];
          final playLines = selectedLine?.playLines ?? [];

          if (playLines.isNotEmpty) {
            return ValueListenableBuilder<int>(
              valueListenable: currentPlay,
              builder: (context, playIndex, child) {
                return SizedBox(
                  height: 40,
                  //最小宽度
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // 水平滚动
                    itemCount: playLines.length, // 列表项数量
                    itemBuilder: (context, index) {
                      final item = playLines[index]; // 获取当前项
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 35,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      playIndex == index
                                          ? const Color.fromRGBO(
                                            252,
                                            119,
                                            66,
                                            1,
                                          )
                                          : const Color.fromRGBO(
                                            246,
                                            247,
                                            248,
                                            1,
                                          ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  try {
                                    if (item.vip == 1 &&
                                        (item.file ?? "").isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: "请开通VIP后重试",
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                      return;
                                    }
                                    // 更新当前选集
                                    currentPlay.value = index;
                                    // 设置新的视频URL - 确保使用最新的playLines数据
                                    final currentSelectedLine =
                                        videoInfoData.lines?[currentLine.value];
                                    final currentPlayLines =
                                        currentSelectedLine?.playLines ?? [];
                                    if (index < currentPlayLines.length) {
                                      setVideoUrl(
                                        currentPlayLines[index].file ?? "",
                                      );
                                    }
                                  } catch (e) {
                                    debugPrint("切换选集：${e.toString()}");
                                  }
                                },
                                child: Text(
                                  item.name ?? '',
                                  style: TextStyle(
                                    color:
                                        playIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            //VIP角标右上角位置
                            if (item.vip == 1)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: const TDBadge(
                                  TDBadgeType.subscript,
                                  size: TDBadgeSize.large,
                                  message: 'VIP',
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Container(
              height: 40,
              alignment: Alignment.center,
              //居中
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheetList();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TDLink(
                      linkClick: (url) {
                        showModalBottomSheetList();
                      },
                      style: TDLinkStyle.primary,

                      label: '当前线路暂无数据,建议切换线路',
                      type: TDLinkType.withSuffixIcon,
                      size: TDLinkSize.medium,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
    } else {
      // 当没有播放线路时显示提示信息
      return Container(
        height: 40,
        alignment: Alignment.centerLeft,
        child: Text(
          "暂无播放线路",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }
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
                          // 添加容错处理
                          tabData: videoInfoData.lines ?? [],
                          onSelectionChanged: (tabIndex, selectedIndices) {
                            try {
                              // 添加容错处理
                              if (videoInfoData.lines != null &&
                                  tabIndex < videoInfoData.lines!.length) {
                                // 更新当前线路
                                setState(() {
                                  currentLine.value = tabIndex;
                                });

                                // 修复类型错误，正确获取选中的播放链接
                                final selectedLine =
                                    videoInfoData.lines?[tabIndex];
                                if (selectedLine?.playLines != null &&
                                    selectedIndices.isNotEmpty &&
                                    selectedIndices.first <
                                        (selectedLine?.playLines?.length ??
                                            0)) {
                                  // 更新当前播放索引
                                  setState(() {
                                    currentPlay.value = selectedIndices.first;
                                  });

                                  final selectedPlayLine =
                                      selectedLine?.playLines?[selectedIndices
                                          .first];
                                  setVideoUrl(selectedPlayLine?.file ?? "");
                                }
                              }
                            } catch (e) {
                              debugPrint("切换选集错误：${e.toString()}");
                            }
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
      child: BannerAds(androidCodeId: androidCodeId, iosCodeId: iosCodeId),
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
          HorizontalVideoList(videoPageData: videoPageData, onTap: removeVideo),
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
                imgUrl: videoInfoData.video?.surfacePlot ?? "",
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
                      videoInfoData.video?.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TDRate(
                      value: (videoInfoData.video?.doubanScore ?? 0).toDouble(),
                      disabled: true,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 5,
                        children: [
                          Text(
                            videoInfoData.video?.videoClass ?? "暂无分类",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            (videoInfoData.video?.videoTag ?? "暂无标签")
                                .replaceAll(",", "/"),
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
                            videoInfoData.video?.year.toString() ?? "暂无上映时间",
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                          TDTag(
                            Dict.getDictName(
                              videoInfoData.video?.region ?? 0,
                              area ?? [],
                            ),
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                          TDTag(
                            Dict.getDictName(
                              videoInfoData.video?.categoryId ?? 0,
                              videoCategory ?? [],
                            ),
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                          TDTag(
                            Dict.getDictName(
                              videoInfoData.video?.language ?? 0,
                              language ?? [],
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
            items: formatString(videoInfoData.video?.directors ?? ""),
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
            items: formatString(videoInfoData.video?.actors ?? ""),
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
          data: videoInfoData.video?.introduce ?? "",
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
    await _castScreenManager.startSearchDevices();
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
                try {
                  // 添加容错处理
                  if (videoInfoData.lines != null &&
                      videoInfoData.lines!.isNotEmpty &&
                      currentLine.value < videoInfoData.lines!.length) {
                    // 修复类型错误，正确获取选中的播放链接
                    final selectedLine =
                        videoInfoData.lines?[currentLine.value];
                    if (selectedLine?.playLines != null &&
                        currentPlay.value <
                            (selectedLine?.playLines?.length ?? 0)) {
                      final selectedPlayLine =
                          selectedLine?.playLines?[currentPlay.value];
                      _castScreenManager.castToDevice(
                        deviceList[index],
                        selectedPlayLine?.file ?? "",
                        "${videoInfoData.video?.title ?? ""}  ${selectedPlayLine?.name ?? ""} ",
                      );
                    }
                  }
                } catch (e) {
                  debugPrint("投屏错误：${e.toString()}");
                }
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

  videoDownload() async {
    final downloader = VideoDownload(
      onProgress: (downloaded, total, currentProgress, totalProgress) {
        debugPrint(
          'videoDownload下载进度: ${(totalProgress * 100).toStringAsFixed(2)}%',
        );
      },
      onStatus: (status, message) {
        debugPrint('videoDownload下载状态: $status $message');
      },
    );
    // 开始下载
    try {
      final selectedLine = videoInfoData.lines?[currentLine.value];
      if (selectedLine?.playLines != null &&
          currentPlay.value < (selectedLine?.playLines?.length ?? 0)) {
        final selectedPlayLine = selectedLine?.playLines?[currentPlay.value];
        //将selectedPlayLine?.file复制粘贴到剪贴板中
        Clipboard.setData(ClipboardData(text: selectedPlayLine?.file ?? ""));
        Fluttertoast.showToast(
          msg: "请打开迅雷app",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      debugPrint('videoDownload 下载失败: $e');
    }

    // 取消下载（如果需要）
    // downloader.cancel();

    // 释放资源
    downloader.dispose();
  }

  Widget _buildVideo() {
    // 添加容错处理
    String videoUrl = "";
    String videoTitle = videoInfoData.video?.title ?? "";
    String videoName = "";

    if (videoInfoData.lines != null &&
        videoInfoData.lines!.isNotEmpty &&
        currentLine.value < videoInfoData.lines!.length) {
      final selectedLine = videoInfoData.lines?[currentLine.value];
      if (selectedLine?.playLines != null &&
          currentPlay.value < (selectedLine?.playLines?.length ?? 0)) {
        final selectedPlayLine = selectedLine?.playLines?[currentPlay.value];
        videoUrl = selectedPlayLine?.file ?? "";
        videoName = selectedPlayLine?.name ?? "";
      }
    }

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
            isSnapShot: false,
            // 右上方按钮组开关
            isRightButton: true,
            // 右上方按钮组
            rightButtonList: [
              InkWell(
                onTap: () {
                  showModalBottomSheetList();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    '选集',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  tvDevice();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: Icon(Icons.tv, color: Theme.of(context).primaryColor),
                ),
              ),

              ///下载按钮
              InkWell(
                onTap: () {
                  videoDownload();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                  child: Icon(
                    Icons.cloud_download,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
            // 视频列表列表
            videoList:
                videoList.isEmpty
                    ? [
                      VideoItem(
                        url: "",
                        title: videoInfoData.video?.title ?? "加载失败",
                        subTitle: "",
                      ),
                    ]
                    : videoList,
            // 当前视频索引
            videoIndex: currentPlay.value,
            // 全屏模式下点击播放下一集视频回调
            playNextVideoFun: () {
              setState(() {
                // 添加容错处理
                if (videoList.isNotEmpty &&
                    currentPlay.value < videoList.length - 1) {
                  currentPlay.value += 1;
                  // 确保播放器加载新的视频
                  setVideoUrl(videoList[currentPlay.value].url);
                }
              });
            },
            // 视频播放完成回调
            onVideoEnd: () async {
              var index = currentPlay.value + 1;
              // 视频播放完成时记录观看历史
              _onPageLeave();
              // 停止监听播放进度
              _stopPositionListener();
              // 添加容错处理
              if (index < videoList.length) {
                await player.reset();
                setState(() {
                  currentPlay.value = index;
                });
                setVideoUrl(videoList[index].url);
              }
            },
            // 视频播放错误点击刷新回调
            onError: () async {
              await player.reset();
            },
            onVideoTimeChange: () {
              // 视频时间变动则触发一次，可以保存视频历史
            },
          ),
        ),
      ],
    );
  }
}
