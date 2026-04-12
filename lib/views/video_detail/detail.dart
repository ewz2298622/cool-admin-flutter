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

String TAG = 'Video_Detail';

class Video_Detail extends StatefulWidget {
  const Video_Detail({super.key});

  @override
  _Video_DetailState createState() => _Video_DetailState();
}

// 1. 【修改】: 混入 WidgetsBindingObserver 以监听App生命周期
class _Video_DetailState extends State<Video_Detail>
    with RouteAware, WidgetsBindingObserver {
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
  late FPlayer player;

  @override
  void initState() {
    // 2. 【修改】: super.initState() 推荐放在最前面
    super.initState();

    // 3. 【修改】: 注册App生命周期监听器
    WidgetsBinding.instance.addObserver(this);
    
    // 初始化页面活跃状态
    _isPageActive = true;

    player = FPlayer();
    _futureBuilderFuture = init();
    // 设置投屏设备列表更新回调
    _castScreenManager.onDeviceListUpdate = (devices) {
      if (!mounted) return;
      setState(() {
        deviceList = devices;
      });
      TVshowModalBottomSheetListSate?.call(() {});
    };
  }

  @override
  void dispose() {
    debugPrint('Video_Detail: dispose called');
    
    // 立即暂停播放器，防止音频继续播放
    try {
      if (player.isPlayable()) {
        player.pause();
      }
    } catch (e) {
      debugPrint('Video_Detail: Error pausing player in dispose: $e');
    }

    // 4. 【修改】: 统一在此处释放和反注册所有监听器
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);

    // 在组件销毁前调用addViews
    _onPageLeave();
    // 停止监听播放进度
    _stopPositionListener();
    
    // 确保播放器完全停止并释放资源
    try {
      player.reset();
      player.dispose();
    } catch (e) {
      debugPrint('Video_Detail: Error disposing player: $e');
    }
    
    // 释放投屏管理器资源
    _castScreenManager.dispose();

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
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      debugPrint('App is in background/inactive, pausing player.');
      _pausePlayerImmediately();
    }
    // 当App回到前台时，根据之前的播放状态决定是否恢复播放
    else if (state == AppLifecycleState.resumed) {
      debugPrint('App is resumed, checking player state.');
      _resumePlayerIfNeeded();
    }
  }
  
  // 立即暂停播放器的方法
  void _pausePlayerImmediately() {
    try {
      // 只有在页面活跃且播放器可播放时才暂停
      if (_isPageActive && player.isPlayable()) {
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
      // 只有在播放器已初始化且之前是播放状态时才恢复
      if (_isPlayerInitialized && !_isPlayerReleased && player.isPlayable()) {
        // 可以选择是否自动恢复播放，这里暂时不自动恢复
        debugPrint('Player ready to resume, but not auto-resuming');
      }
    } catch (e) {
      debugPrint('Error resuming player: $e');
    }
  }
  
  // 全局播放器状态安全检查
  void _ensurePlayerSafety() {
    try {
      // 如果页面不活跃但播放器仍在播放，则强制暂停
      if (!_isPageActive && player.isPlayable() && player.value.state == FState.started) {
        debugPrint('Safety check: Page inactive but player playing, forcing pause');
        player.pause();
      }
      
      // 如果播放器已释放但仍被标记为初始化，则修正状态
      if (_isPlayerReleased && _isPlayerInitialized) {
        _isPlayerInitialized = false;
        debugPrint('Safety check: Corrected player initialization state');
      }
    } catch (e) {
      debugPrint('Safety check error: $e');
    }
  }

  List<dynamic> deviceList = [];
  StateSetter? TVshowModalBottomSheetListSate;
  final CastScreenManager _castScreenManager = CastScreenManager(); // 添加投屏管理器
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
      debugPrint('Get dict video category data success, count: ${videoCategory?.length ?? 0}');
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
      videoList = [
        VideoItem(
          title: "视频",
          url: "",
          subTitle: "暂无播放链接",
        ),
      ];
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
      debugPrint('Get dict language data success, count: ${language?.length ?? 0}');
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
      List<VideoPageDataList> list = response.data?.list ?? [] as List<VideoPageDataList>;
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
      List<VideoPageDataList> list = response.data?.list ?? [] as List<VideoPageDataList>;
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
    player.onCurrentPosUpdate
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
        // 添加空值检查，防止player.value.duration在播放器未初始化时抛出异常
        int videoDuration = 0;
        if (player.value.duration != null &&
            !player.value.duration.isNegative) {
          videoDuration = player.value.duration.inMilliseconds ~/ 1000;
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
    // player._errorListener(() => {});
    //监听播放器错误
    player.addListener(playerValueChanged);
  }

  playerValueChanged() {
    try {
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
    } catch (e) {
      debugPrint('playerValueChanged error: $e');
    }
  }

/**
 * 设置视频播放地址
 * @param url 视频播放地址
 * 处理视频播放的核心方法，包括播放器状态管理、数据源设置和错误处理
 */
  Future<void> setVideoUrl(String url) async {
    try {
      debugPrint('Setting video URL: $url');
      
      // 如果播放器已被释放，重新初始化
      if (_isPlayerReleased) {
        _isPlayerReleased = false;
        _isPlayerInitialized = true;
      }
      
      // 添加容错处理，如果url为空则不播放
      if (url.isNotEmpty) {
        // 重置播放器并设置新的数据源
        await player.reset();
        await player.setDataSource(url, autoPlay: true, showCover: true);
        debugPrint('Video URL set successfully');
      } else {
        debugPrint('Empty URL provided, not setting video source');
        // 如果URL为空，暂停当前播放
        if (player.isPlayable()) {
          player.pause();
        }
      }
      
      // 开始监听播放进度
      _startPositionListener();
      if (mounted) {
        setState(() {});
      }
    } catch (error, stackTrace) {
      debugPrint('setVideoUrl error: $error');
      debugPrint('Stack trace: $stackTrace');
      // 出错时确保播放器处于暂停状态
      try {
        if (player.isPlayable()) {
          player.pause();
        }
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
    } else if (player.isPlayable()) {
      // 如果播放器只是被暂停，则恢复播放
      // 注意：这里不自动恢复播放，让用户手动控制
      debugPrint('Player is playable but not auto-starting');
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
    // 立即暂停播放
    _pausePlayerImmediately();
    // 在视频被销毁前调用addViews记录观看历史
    _onPageLeave();
    // 停止监听播放进度
    _stopPositionListener();
    // 重置播放器
    try {
      if (player.isPlayable()) {
        player.reset();
      }
    } catch (e) {
      debugPrint('Error resetting player in removeVideo: $e');
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
                      tabs: [
                        Tab(text: '详情'),
                        Tab(text: '简介'),
                      ],
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
                        Text(videoInfoData.video?.year.toString() ?? "暂无数据",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937),
                            )),
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
                                  shadowColor: playIndex == index
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
                                    fontWeight: playIndex == index
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
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
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
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
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
                          onTap: Navigator.of(context).pop,
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
                                      (selectedLine?.playLines?.length ??
                                          0)) {
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
    return GuessYouLike(
      videoPageData: videoPageData,
      onVideoTap: removeVideo,
    );
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

  Widget _buildPlotSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '剧情',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
            height: 1.4,
          ),
        ),
        SizedBox(height: 12),
        Html(
          data: videoInfoData.video?.introduce ?? "",
          style: {
            "body": Style(
              color: Color(0xFF4B5563),
              backgroundColor: Colors.transparent,
              fontSize: FontSize(15),
              lineHeight: LineHeight(1.6),
            ),
            "p": Style(
              color: Color(0xFF4B5563),
              backgroundColor: Colors.transparent,
              fontSize: FontSize(15),
              lineHeight: LineHeight(1.6),
              margin: Margins.only(bottom: 8),
            ),
            "span": Style(
              color: Color(0xFF4B5563),
              backgroundColor: Colors.transparent,
              fontSize: FontSize(15),
              lineHeight: LineHeight(1.6),
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
          height: 200,
          // 需自行设置，此处宽度/高度=16/9
          color: Colors.black,
          fsFit: FFit.contain,
          // 全屏模式下的填充
          fit: FFit.fill,
          // 正常模式下的填充
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
                  // 10. 【修复】: 减小垂直内边距，防止全屏时布局溢出
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
                  // 10. 【修复】: 减小垂直内边距
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
                  // 10. 【修复】: 减小垂直内边距
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
