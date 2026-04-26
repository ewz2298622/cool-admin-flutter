import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/banner_ads.dart';
import '../../components/detail_tabs_views.dart';
import '../../components/loading.dart';
import '../../entity/app_ads_entity.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/play_line_entity.dart';
import '../../entity/video_detail_data_entity.dart';
import '../../entity/video_detail_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../main.dart'; // 导入 main.dart 以访问 routeObserver
import '../../style/layout.dart';
import '../../utils/ads_config.dart';
import '../../utils/bus/bus.dart';
import '../../utils/bus/constant.dart';
import '../../utils/cast_screen_manager.dart'; // 导入投屏管理类
import '../../utils/dict.dart';
import '../../utils/user.dart';
import '../../utils/video.dart';
import 'Components/guess_you_like.dart';
import 'Components/video_info_view.dart';
import 'Components/sponsor_bar.dart';
import 'Components/video_player_widget.dart';
import 'Components/fullscreen_video_page.dart';
import 'utils/casting_helper.dart';
import 'utils/video_download_helper.dart';

String TAG = 'Video_Detail';

class VideoItem {
  final String title;
  final String url;
  final String subTitle;

  VideoItem({required this.title, required this.url, required this.subTitle});
}

class Video_Detail extends StatefulWidget {
  const Video_Detail({super.key});

  @override
  _Video_DetailState createState() => _Video_DetailState();
}

// 1. 【修改】: 混入 WidgetsBindingObserver 以监听 App 生命周期
class _Video_DetailState extends State<Video_Detail>
    with RouteAware, WidgetsBindingObserver {
  final ValueNotifier<int> currentLine = ValueNotifier<int>(0);
  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0);

  // 投屏助手
  late final CastingHelper _castingHelper;

  // 线路切换对话框状态
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
  late Player player;
  late VideoController videoController;
  int _videoFit = 0;
  final List<String> _fitModes = ['默认', '原始', '拉伸', '填充', '4:3'];
  double _videoRate = 1.0;
  final List<double> _rateList = [0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    // 2. 【修改】: super.initState() 推荐放在最前面
    super.initState();

    // 3. 【修改】: 注册 App 生命周期监听器
    WidgetsBinding.instance.addObserver(this);

    // 初始化页面活跃状态
    _isPageActive = true;

    // 初始化投屏助手
    _castingHelper = CastingHelper(
      onDeviceListUpdate: () {
        if (!mounted) return;
        setState(() {});
      },
    );

    player = Player();
    videoController = VideoController(player);
    _futureBuilderFuture = init();
  }

  @override
  void dispose() {
    debugPrint('Video_Detail: dispose called');

    // 立即暂停播放器，防止音频继续播放
    try {
      player.pause();
    } catch (e) {
      debugPrint('Video_Detail: Error pausing player in dispose: $e');
    }

    // 4. 【修改】: 统一在此处释放和反注册所有监听器
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);

    // 在组件销毁前调用 addViews
    _onPageLeave();
    // 停止监听播放进度
    _stopPositionListener();

    // 确保播放器完全停止并释放资源
    try {
      player.dispose();
    } catch (e) {
      debugPrint('Video_Detail: Error disposing player: $e');
    }

    // 释放投屏助手资源
    _castingHelper.dispose();

    // 5. 【修改】: super.dispose() 必须放在最后
    super.dispose();
  }

  // 6. 【新增】: App生命周期变化回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('App lifecycle state changed to: $state');

    // 执行安全检查
    _ensurePlayerSafety();

    // 当App进入后台或失去焦点时，立即暂停播放
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      debugPrint('App is in background/inactive, pausing player.');
      _pausePlayerImmediately();
    }
    // 当App回到前台时，根据之前的播放状态决定是否恢复播放
    else if (state == AppLifecycleState.resumed) {
      debugPrint('App is resumed, checking player state.');
      _resumePlayerIfNeeded();
    }
  }

  void _pausePlayerImmediately() {
    try {
      if (_isPageActive) {
        player.pause();
        debugPrint('Player paused immediately');
      } else {
        debugPrint('Player not paused - page inactive or player not playable');
      }
    } catch (e) {
      debugPrint('Error pausing player immediately: $e');
    }
  }

  // 根据需要恢复播放的方法
  void _resumePlayerIfNeeded() {
    try {
      if (_isPlayerInitialized && !_isPlayerReleased) {
        debugPrint('Player ready to resume, but not auto-resuming');
      }
    } catch (e) {
      debugPrint('Error resuming player: $e');
    }
  }

  // 全局播放器状态安全检查
  void _ensurePlayerSafety() {
    try {
      if (!_isPageActive && player.state.playing) {
        debugPrint(
          'Safety check: Page inactive but player playing, forcing pause',
        );
        player.pause();
      }

      if (_isPlayerReleased && _isPlayerInitialized) {
        _isPlayerInitialized = false;
        debugPrint('Safety check: Corrected player initialization state');
      }
    } catch (e) {
      debugPrint('Safety check error: $e');
    }
  }

  final id = Get.arguments?["id"];
  final viewingDuration = Get.arguments?["viewingDuration"];
  String androidCodeId = AdsConfig.INTERSTITIAL_AD_ANDROID;
  String iosCodeId = AdsConfig.INTERSTITIAL_AD_IOS;
  VideoDetailDataData videoInfoData = VideoDetailDataData();
  List<TDTab> tabs = []; // 添加缺失的 tabs 变量定义
  //定义进度
  int progress = 0;

  //定义视频总时长
  int duration = 0;

  // 模拟播放记录视频初始化完需要跳转的进度
  int seekTime = 100000;

  // 添加一个变量来跟踪是否已经调用了addViews
  bool _hasAddedViews = false;

  // 添加一个定时器来定期更新播放进度
  Timer? _positionTimer;

  // 添加变量来跟踪播放器状态
  bool _isPlayerInitialized = false;
  bool _isPlayerReleased = false;
  bool _isPageActive = true; // 跟踪页面是否处于活跃状态

  // 开始监听播放进度
  void _startPositionListener() {
    _positionTimer?.cancel();
    // 只有在页面活跃时才启动监听器
    if (_isPageActive) {
      // 这里可以添加具体的进度监听逻辑
      debugPrint('Position listener started');
    }
  }

  // 停止监听播放进度
  void _stopPositionListener() {
    if (_positionTimer != null) {
      _positionTimer!.cancel();
      _positionTimer = null;
      debugPrint('Position listener stopped');
    }
  }

  // 在页面离开时调用addViews的方法
  void _onPageLeave() {
    if (!_hasAddedViews) {
      addViews();
      _hasAddedViews = true;
      debugPrint('Views recorded on page leave');
    }
  }

  Future<void> getDictAreaData() async {
    try {
      debugPrint('Starting getDictAreaData');
      final response = await Api.getDictData({
        "types": ["area"],
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Get dict area data timeout');
          throw TimeoutException('Get dict area data timeout');
        },
      );
      final dictData = response.data as DictDataData;
      area = dictData.area;
      debugPrint('Get dict area data success, count: ${area?.length ?? 0}');
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization getDictAreaData failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // 确保 area 不为 null
      area = [];
    }
  }

  Future<void> getDictVideoCategoryData() async {
    try {
      debugPrint('Starting getDictVideoCategoryData');
      final response = await Api.getDictData({
        "types": ["video_category"],
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Get dict video category data timeout');
          throw TimeoutException('Get dict video category data timeout');
        },
      );
      final dictData = response.data as DictDataData;
      videoCategory = dictData.videoCategory;
      debugPrint(
        'Get dict video category data success, count: ${videoCategory?.length ?? 0}',
      );
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization getDictVideoCategoryData failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // 确保 videoCategory 不为 null
      videoCategory = [];
    }
  }

  Future<void> getVideoDetail() async {
    try {
      // 清空之前的数据以防止数据污染
      tabs.clear();
      videoList.clear();

      // 添加超时处理，确保视频详情获取不会阻塞 UI 线程
      final response = await Api.getVideoDetail({"id": id}).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('Get video detail timeout');
          throw TimeoutException('Get video detail timeout');
        },
      );
      videoInfoData = (response.data as VideoDetailDataData);
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
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoDetail failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // 设置默认值，确保UI能够正常显示
      tabs = [TDTab(text: "默认线路")];
      videoList = [VideoItem(title: "视频", url: "", subTitle: "暂无播放链接")];
    }
  }

  Future<void> getDictLanguageData() async {
    try {
      debugPrint('Starting getDictLanguageData');
      final response = await Api.getDictData({
        "types": ["language"],
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Get dict language data timeout');
          throw TimeoutException('Get dict language data timeout');
        },
      );
      final dictData = response.data as DictDataData;
      language = dictData.language;
      debugPrint(
        'Get dict language data success, count: ${language?.length ?? 0}',
      );
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization getDictLanguageData failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // 确保 language 不为 null
      language = [];
    }
  }

  Future<void> getVideoPages() async {
    try {
      debugPrint('Starting getVideoPages');
      final response = await Api.getVideoPages({
        "category_id": videoInfoData.video?.categoryId ?? 0,
        //page参数随机1-20整数
        "page": Random().nextInt(2) + 1,
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Get video pages timeout');
          throw TimeoutException('Get video pages timeout');
        },
      );
      List<VideoPageDataList> list =
          response.data?.list ?? [] as List<VideoPageDataList>;
      debugPrint('Get video pages success, count: ${list.length}');
      if (mounted) {
        setState(() {
          videoPageData = list;
        });
      }
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoPages failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // 确保 videoPageData 不为 null
      if (mounted) {
        setState(() {
          videoPageData = [];
        });
      }
    }
  }

  Future<String> getSelectVideoPages(Map<String, dynamic> params) async {
    try {
      debugPrint('Starting getSelectVideoPages');
      final response = await Api.getVideoPages(params).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Get select video pages timeout');
          throw TimeoutException('Get select video pages timeout');
        },
      );
      List<VideoPageDataList> list =
          response.data?.list ?? [] as List<VideoPageDataList>;
      debugPrint('Get select video pages success, count: ${list.length}');
      selectVideoPageData = list;
      if (mounted) {
        setState(() {
          selectVideoPageData = list;
        });
      }
      return "init success";
    } catch (e, stackTrace) {
      debugPrint('Get select video pages failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // 确保 selectVideoPageData 不为 null
      if (mounted) {
        setState(() {
          selectVideoPageData = [];
        });
      }
      return "init error";
    }
  }

  //视频监听
  void _videoListener() {
    player.stream.position
        .listen((pos) {
          if (!mounted) return;
          setState(() {
            progress = pos.inSeconds;
          });
        })
        .onError((error) {
          debugPrint('Video position listener error: $error');
        });
  }

  Future<void> addViews() async {
    if (!User.isLogin()) {
      return;
    }
    try {
      if (videoInfoData.video?.id != null) {
        int videoDuration = 0;
        final duration = player.state.duration;
        if (duration.inMilliseconds > 0) {
          videoDuration = duration.inMilliseconds ~/ 1000;
        }

        await Api.addViews({
          "title": videoInfoData.video?.title,
          "associationId": videoInfoData.video?.id ?? 1,
          "viewingDuration": progress,
          "duration": videoDuration,
          "type": 19,
          "cover": videoInfoData.video?.surfacePlot ?? "",
          "videoIndex": currentPlay.value,
        }).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('Add views timeout');
            throw TimeoutException('Add views timeout');
          },
        );
        eventBus.fire(RefreshViewEvent());
        debugPrint('Add views success');
      }
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization addViews failed: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// 初始化tab
  void _initTabController() {}

  Future<String> init() async {
    try {
      // 清空之前的数据以防止数据污染
      tabs.clear();
      videoList.clear();

      _initTabController();
      // 添加超时处理，确保视频详情获取不会阻塞 UI 线程
      await getVideoDetail().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('Video detail initialization timeout');
          throw TimeoutException('Video detail initialization timeout');
        },
      );
      // 并行获取其他数据，添加超时处理
      await Future.wait([
        getDictVideoCategoryData(),
        getDictLanguageData(),
        getDictAreaData(),
        getVideoPages(),
      ]).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Additional data initialization timeout');
          return [];
        },
      );
      _errorListener();
      // 广告加载单独处理，不阻塞初始化
      _loadAd();
      _videoListener();
      _isPlayerInitialized = true;
      _isPlayerReleased = false;
      return "init success";
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization error in init(): $e');
      debugPrint('Stack trace: $stackTrace');
      return "init success";
    }
  }

  //广告加载（直接从 API 请求，带超时保护，不阻塞页面显示）
  bool _isAdAvailable = false; // 添加广告是否可用的状态

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
              _isAdAvailable = true; // 设置广告可用状态
            });
            debugPrint("_loadAd Banner广告数据:$filteredAds");
          }
        } else {
          // 如果筛选后没有符合条件的广告数据，设置广告不可用
          if (mounted) {
            setState(() {
              _isAdAvailable = false;
            });
          }
        }
      } else {
        // 如果没有广告数据，设置广告不可用
        if (mounted) {
          setState(() {
            _isAdAvailable = false;
          });
        }
      }
    } catch (e) {
      debugPrint("_loadAd Banner广告加载失败: $e");
      // 发生异常时，也设置广告不可用
      if (mounted) {
        setState(() {
          _isAdAvailable = false;
        });
      }
    }
  }

  _errorListener() {
    player.stream.error.listen((error) {
      if (error != null) {
        debugPrint("播放失败: $error");
        if (videoInfoData.lines != null &&
            videoInfoData.lines!.isNotEmpty &&
            currentPlay.value < videoInfoData.lines!.length) {
          Api.VideoLineUpdate({
            "id": videoInfoData.lines?[currentPlay.value].id,
            "status": 0,
          });
        }
      }
    });
  }

  playerValueChanged() {}

  Future<void> setVideoUrl(String url) async {
    try {
      debugPrint('Setting video URL: $url');

      if (_isPlayerReleased) {
        _isPlayerReleased = false;
        _isPlayerInitialized = true;
      }

      if (url.isNotEmpty) {
        await player.open(Media(url), play: true);
        debugPrint('Video URL set successfully');
      } else {
        debugPrint('Empty URL provided, not setting video source');
        player.pause();
      }

      _startPositionListener();
      if (mounted) {
        setState(() {});
      }
    } catch (error, stackTrace) {
      debugPrint('setVideoUrl error: $error');
      debugPrint('Stack trace: $stackTrace');
      try {
        player.pause();
      } catch (e) {
        debugPrint('Error pausing player after setVideoUrl failure: $e');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 订阅路由变化
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  // 7. 【修改】: 当有新页面覆盖当前页时，暂停播放
  @override
  void didPushNext() {
    debugPrint(
      'Video_Detail: didPushNext called - page is being covered, pausing player.',
    );
    // 在页面被覆盖前调用addViews记录观看历史
    _onPageLeave();
    // 执行安全检查
    _ensurePlayerSafety();
    _pausePlayerImmediately();
    _isPageActive = false;
  }

  // 8. 【修改】: 当页面被弹出（返回、手势滑动退出）时，立即暂停播放
  @override
  void didPop() {
    debugPrint(
      'Video_Detail: didPop called - page is being removed, pausing player.',
    );
    // 在页面从导航栈中移除前调用addViews记录观看历史
    _onPageLeave();
    _isPageActive = false;
    // 执行安全检查
    _ensurePlayerSafety();
    _pausePlayerImmediately();
    super.didPop();
  }

  // 9. 【修改】: 当从其他页面返回到当前页时，恢复播放
  @override
  void didPopNext() {
    debugPrint(
      'Video_Detail: didPopNext called - page is becoming visible again.',
    );
    _isPageActive = true;

    // 执行安全检查
    _ensurePlayerSafety();

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
        "videoName": videoData?.title ?? videoInfoData.video?.title,
        "playLineId": playLineId,
      },
    );
  }

  void removeVideo() {
    debugPrint('Video_Detail: removeVideo called');
    _pausePlayerImmediately();
    _onPageLeave();
    _stopPositionListener();
    try {
      player.stop();
    } catch (e) {
      debugPrint('Error stopping player in removeVideo: $e');
    }
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
                    TabBar(
                      dividerHeight: 0,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorPadding: const EdgeInsets.all(0),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 0.0,
                          color: Colors.transparent,
                        ),
                      ),
                      unselectedLabelColor: Color(0xFF9CA3AF),
                      labelColor: Color(0xFF111827),
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [Tab(text: '详情'), Tab(text: '简介')],
                    ),
                    IconButton(
                      onPressed: goFeedbackPage,
                      icon: Icon(
                        Icons.warning_rounded,
                        color: Color(0xFF6B7280),
                      ),
                      iconSize: 24,
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(),
                    ),
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
                            _buildVideoInfo(),
                            _buildBanner(),
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
    return const SponsorBar();
  }

  Widget _buildVideoInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  videoInfoData.video?.title ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              SizedBox(width: 12),
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(255, 153, 0, 0.1),
                        Color.fromRGBO(255, 153, 0, 1),
                      ],
                    ).createShader(bounds),
                child: Text(
                  VideoUtil.formatScore(videoInfoData.video?.doubanScore),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(255, 153, 0, 1),
                    letterSpacing: -2,
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
                        Text(
                          videoInfoData.video?.year.toString() ?? "暂无数据",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          Dict.getDictName(
                            videoInfoData.video?.region ?? 0,
                            area ?? [],
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          Dict.getDictName(
                            videoInfoData.video?.categoryId ?? 0,
                            videoCategory ?? [],
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          Dict.getDictName(
                            videoInfoData.video?.language ?? 0,
                            language ?? [],
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          (videoInfoData.video?.videoTag ?? "暂无标签").replaceAll(
                            ",",
                            "/",
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ]
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.only(right: 12),
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
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      child: Column(
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '选集',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
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
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildPlayer(),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (videoInfoData.lines != null && videoInfoData.lines!.isNotEmpty) {
      return ValueListenableBuilder<int>(
        valueListenable: currentLine,
        builder: (context, lineIndex, child) {
          final selectedLine = videoInfoData.lines?[lineIndex];
          final playLines = selectedLine?.playLines ?? [];

          if (playLines.isNotEmpty) {
            return ValueListenableBuilder<int>(
              valueListenable: currentPlay,
              builder: (context, playIndex, child) {
                return SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: playLines.length,
                    itemBuilder: (context, index) {
                      final item = playLines[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: 108,
                              height: 40,
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
                                          : const Color(0xFFF3F4F6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: playIndex == index ? 2 : 0,
                                  shadowColor:
                                      playIndex == index
                                          ? Color.fromRGBO(252, 119, 66, 0.3)
                                          : Colors.transparent,
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
                                    currentPlay.value = index;
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
                                    fontSize: 14,
                                    fontWeight:
                                        playIndex == index
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                    color:
                                        playIndex == index
                                            ? Colors.white
                                            : Color(0xFF111827),
                                  ),
                                ),
                              ),
                            ),
                            if (item.vip == 1)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEAB308),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'VIP',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
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
              height: 44,
              alignment: Alignment.center,
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
      return Container(
        height: 44,
        alignment: Alignment.centerLeft,
        child: Text(
          "暂无播放线路",
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
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
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 24,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16),
              height: 650,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "切换线路",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Flexible(
                      flex: 1,
                      child: DetailTabsView(
                        tabData: videoInfoData.lines ?? [],
                        onSelectionChanged: (tabIndex, selectedIndices) {
                          try {
                            if (videoInfoData.lines != null &&
                                tabIndex < videoInfoData.lines!.length) {
                              setState(() {
                                currentLine.value = tabIndex;
                              });

                              final selectedLine =
                                  videoInfoData.lines?[tabIndex];
                              if (selectedLine?.playLines != null &&
                                  selectedIndices.isNotEmpty &&
                                  selectedIndices.first <
                                      (selectedLine?.playLines?.length ?? 0)) {
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
                        defaultSelectedItems: {
                          currentLine.value: {currentPlay.value},
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBanner() {
    // 只有当广告可用时才显示广告组件
    if (_isAdAvailable) {
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
    } else {
      // 如果广告不可用，返回一个空的容器
      return Container(); // 或者返回 SizedBox.shrink()
    }
  }

  Widget _buildRecommendations() {
    return GuessYouLike(videoPageData: videoPageData, onVideoTap: removeVideo);
  }

  Widget _buildTabsVideoInfo() {
    return VideoInfoView(
      videoInfoData: videoInfoData,
      area: area,
      videoCategory: videoCategory,
      language: language,
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

  Widget _buildVideo() {
    return VideoPlayerWidget(
      player: player,
      videoController: videoController,
      videoUrl: '',
      videoFit: _videoFit,
      videoRate: _videoRate,
      rateList: _rateList,
      showControls: true,
      onSettingsPressed: _showSettingsSheet,
      onFullScreenPressed: _enterFullScreen,
      onCastingPressed: tvDevice,
      onPlayPause: () {
        if (player.state.playing) {
          player.pause();
        } else {
          player.play();
        }
      },
      onSkipForward: () {
        final currentPos = player.state.position;
        player.seek(currentPos + const Duration(seconds: 10));
      },
      onSkipBackward: () {
        final currentPos = player.state.position;
        final newPos = currentPos - const Duration(seconds: 10);
        player.seek(newPos < Duration.zero ? Duration.zero : newPos);
      },
      onNextVideo: () {
        if (currentPlay.value < videoList.length - 1) {
          currentPlay.value++;
          final nextVideo = videoList[currentPlay.value];
          setVideoUrl(nextVideo.url);
        }
      },
      onPreviousVideo: () {
        if (currentPlay.value > 0) {
          currentPlay.value--;
          final prevVideo = videoList[currentPlay.value];
          setVideoUrl(prevVideo.url);
        }
      },
      onRateChanged: (rate) {
        int currentIndex = _rateList.indexOf(_videoRate);
        if (currentIndex == -1 || currentIndex >= _rateList.length - 1) {
          currentIndex = 0;
        } else {
          currentIndex++;
        }
        final newRate = _rateList[currentIndex];
        setState(() {
          _videoRate = newRate;
        });
        player.setRate(newRate);
      },
    );
  }

  void _enterFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => FullScreenVideoPage(
              player: player,
              videoController: videoController,
              videoTitle: videoInfoData.video?.title ?? '',
              videoRate: _videoRate,
              currentVideoFit: _videoFit,
              onVideoFitChanged: (fit) {
                setState(() => _videoFit = fit);
              },
              rateList: _rateList,
              fitModes: _fitModes,
              onCastingPressed: tvDevice,
              onRateChanged: () {
                int currentIndex = _rateList.indexOf(_videoRate);
                if (currentIndex == -1 || currentIndex >= _rateList.length - 1) {
                  currentIndex = 0;
                } else {
                  currentIndex++;
                }
                final newRate = _rateList[currentIndex];
                setState(() {
                  _videoRate = newRate;
                });
                player.setRate(newRate);
              },
              onNextVideo: () {
                if (currentPlay.value < videoList.length - 1) {
                  currentPlay.value++;
                  final nextVideo = videoList[currentPlay.value];
                  setVideoUrl(nextVideo.url);
                }
              },
              onPreviousVideo: () {
                if (currentPlay.value > 0) {
                  currentPlay.value--;
                  final prevVideo = videoList[currentPlay.value];
                  setVideoUrl(prevVideo.url);
                }
              },
            ),
      ),
    );
  }

  /// 显示投屏对话框
  void tvDevice() {
    _castingHelper.showCastingDialog(
      context: context,
      videoInfoData: videoInfoData,
      currentLine: currentLine.value,
      currentPlay: currentPlay.value,
    );
  }

  /// 下载视频
  void videoDownload() async {
    await VideoDownloadHelper.downloadVideo(
      videoInfoData: videoInfoData,
      currentLine: currentLine.value,
      currentPlay: currentPlay.value,
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => _VideoSettingsSheet(
            player: player,
            currentRate: _videoRate,
            videoInfoData: videoInfoData,
            currentLine: currentLine.value,
            currentPlay: currentPlay.value,
            currentVideoFit: _videoFit,
            fitModes: _fitModes,
            rateList: _rateList,
            onVideoFitChanged: (fit) {
              setState(() => _videoFit = fit);
            },
            onVideoRateChanged: (rate) {
              setState(() => _videoRate = rate);
            },
          ),
    );
  }
}

class _VideoSettingsSheet extends StatefulWidget {
  final Player player;
  final double currentRate;
  final VideoDetailDataData videoInfoData;
  final int currentLine;
  final int currentPlay;
  final int currentVideoFit;
  final Function(int) onVideoFitChanged;
  final List<String> fitModes;
  final List<double> rateList;
  final Function(double) onVideoRateChanged;

  const _VideoSettingsSheet({
    required this.player,
    required this.currentRate,
    required this.videoInfoData,
    required this.currentLine,
    required this.currentPlay,
    required this.currentVideoFit,
    required this.onVideoFitChanged,
    required this.fitModes,
    required this.rateList,
    required this.onVideoRateChanged,
  });

  @override
  State<_VideoSettingsSheet> createState() => _VideoSettingsSheetState();
}

class _VideoSettingsSheetState extends State<_VideoSettingsSheet> {
  late double _selectedRate;
  double _selectedVolume = 1.0;
  double _selectedBrightness = 1.0;
  int _videoFit = 0;
  double _skipOpening = 0.0;
  double _skipEnding = 0.0;
  double _longPressRate = 2.0;

  final List<double> _longPressRates = [1.25, 1.5, 2.0, 2.5, 3.0];

  @override
  void initState() {
    super.initState();
    _selectedRate = widget.currentRate;
    _selectedVolume = widget.player.state.volume / 100.0;
    _videoFit = widget.currentVideoFit;
    _initBrightness();
  }

  Future<void> _initBrightness() async {
    // 初始化时设置默认亮度为 100%
    setState(() {
      _selectedBrightness = 1.0;
    });
  }

  void _setBrightness(double value) async {
    setState(() {
      _selectedBrightness = value;
    });
    // 注意：Flutter 标准 API 不直接支持系统亮度控制
    // 如需实际控制亮度，需要添加 screen_brightness 等第三方插件
    // 当前仅做 UI 展示，实际亮度控制需要原生平台支持
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxHeight = screenSize.height * 0.7; // 限制最大高度为屏幕的 70%

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部拖动手柄
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 标题栏
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
              child: Row(
                children: [
                  const Text(
                    '播放设置',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  // 恢复默认按钮
                  GestureDetector(
                    onTap: _resetToDefaults,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '恢复默认',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            // 可滚动内容区
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                child: Column(
                  children: [
                    // 音量和亮度并排
                    _buildVolumeAndBrightnessRow(),
                    const SizedBox(height: 24),
                    // 跳过片头和片尾并排
                    _buildSkipRow(),
                    const SizedBox(height: 24),
                    // 倍速播放
                    _buildSectionTitle('倍速播放'),
                    _buildRateSelector(),
                    const SizedBox(height: 24),
                    // 画面尺寸
                    _buildSectionTitle('画面尺寸'),
                    _buildFitSelector(),
                    const SizedBox(height: 24),
                    // 长按加速
                    _buildSectionTitle('长按加速'),
                    _buildLongPressSelector(),
                    const SizedBox(height: 24),
                    // 线路选择
                    _buildSectionTitle('线路选择'),
                    _buildLineSelector(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _selectedRate = 1.0;
      _selectedVolume = 1.0;
      _selectedBrightness = 1.0;
      _videoFit = 0;
      _skipOpening = 0.0;
      _skipEnding = 0.0;
      _longPressRate = 2.0;
    });
    widget.player.setRate(1.0);
    widget.player.setVolume(100);
    _setBrightness(1.0);
  }

  Widget _buildBrightnessSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.brightness_high,
              color: Colors.white70,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFFE53935),
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                overlayColor: const Color(0xFFE53935).withValues(alpha: 0.2),
                trackHeight: 5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              ),
              child: Slider(
                value: _selectedBrightness,
                onChanged: (value) {
                  _setBrightness(value);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${(_selectedBrightness * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeAndBrightnessRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildSliderLabel('音量调节', '${(_selectedVolume * 100).toInt()}%'),
              const SizedBox(height: 12),
              _buildGradientSlider(
                value: _selectedVolume,
                onChanged: (value) {
                  setState(() => _selectedVolume = value);
                  widget.player.setVolume(value * 100);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _buildSliderLabel(
                '屏幕亮度',
                '${(_selectedBrightness * 100).toInt()}%',
              ),
              const SizedBox(height: 12),
              _buildGradientSlider(
                value: _selectedBrightness,
                onChanged: (value) {
                  _setBrightness(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliderLabel(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildGradientSlider({
    required double value,
    required ValueChanged<double> onChanged,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    double min = 0.0,
    double max = 1.0,
    int? divisions,
  }) {
    return SizedBox(
      height: 24,
      child: SliderTheme(
        data: SliderThemeData(
          activeTrackColor: const Color(0xFFE53935),
          inactiveTrackColor: const Color(0xFF4A4A4A),
          thumbColor: Colors.white,
          overlayColor: Colors.transparent,
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          onChangeStart: onChangeStart,
          onChangeEnd: onChangeEnd,
        ),
      ),
    );
  }

  Widget _buildSkipRow() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildSliderLabel('跳过片头', _formatDuration(_skipOpening)),
                const SizedBox(height: 12),
                _buildGradientSlider(
                  value: _skipOpening,
                  min: 0,
                  max: 300,
                  divisions: 30,
                  onChanged: (value) {
                    setState(() => _skipOpening = value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildSliderLabel('跳过片尾', _formatDuration(_skipEnding)),
                const SizedBox(height: 12),
                _buildGradientSlider(
                  value: _skipEnding,
                  min: 0,
                  max: 300,
                  divisions: 30,
                  onChanged: (value) {
                    setState(() => _skipEnding = value);
                  },
                ),
              ],
            ),
          ),
        ],
      );
  }

  Widget _buildRateSelector() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: widget.rateList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final rate = widget.rateList[index];
          final isSelected = (_selectedRate - rate).abs() < 0.01;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedRate = rate);
              widget.player.setRate(rate);
              widget.onVideoRateChanged(rate);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFFE53935)
                        : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  rate == 1.0 ? '1.0x' : '${rate}x',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVolumeSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.volume_up, color: Colors.white70, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFFE53935),
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                overlayColor: const Color(0xFFE53935).withValues(alpha: 0.2),
                trackHeight: 5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              ),
              child: Slider(
                value: _selectedVolume,
                onChanged: (value) {
                  setState(() => _selectedVolume = value);
                  widget.player.setVolume(value * 100);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${(_selectedVolume * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitSelector() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: widget.fitModes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final mode = widget.fitModes[index];
          final isSelected = _videoFit == index;
          return GestureDetector(
            onTap: () {
              setState(() => _videoFit = index);
              widget.onVideoFitChanged(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFFE53935)
                        : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  mode,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLongPressSelector() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: _longPressRates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final rate = _longPressRates[index];
          final isSelected = (_longPressRate - rate).abs() < 0.01;
          return GestureDetector(
            onTap: () {
              setState(() => _longPressRate = rate);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFFE53935)
                        : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  '${rate}x',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLineSelector() {
    return GestureDetector(
      onTap: () {
        // TODO: 实现线路切换逻辑
        Fluttertoast.showToast(
          msg: '正在检测线路...',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.network_check, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            const Text(
              '卡顿？检测切换线路',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipOpeningSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.skip_next, color: Colors.white70, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFFE53935),
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                overlayColor: const Color(0xFFE53935).withValues(alpha: 0.2),
                trackHeight: 5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              ),
              child: Slider(
                value: _skipOpening,
                min: 0,
                max: 300,
                divisions: 30,
                onChanged: (value) {
                  setState(() => _skipOpening = value);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _formatDuration(_skipOpening),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipEndingSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.skip_previous,
              color: Colors.white70,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFFE53935),
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                overlayColor: const Color(0xFFE53935).withValues(alpha: 0.2),
                trackHeight: 5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              ),
              child: Slider(
                value: _skipEnding,
                min: 0,
                max: 300,
                divisions: 30,
                onChanged: (value) {
                  setState(() => _skipEnding = value);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _formatDuration(_skipEnding),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(double seconds) {
    final mins = (seconds / 60).floor();
    final secs = (seconds % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData sliderTheme = const SliderThemeData(),
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
