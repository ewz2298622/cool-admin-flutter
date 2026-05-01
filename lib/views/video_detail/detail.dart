import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
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
import '../../main.dart';
import '../../store/player/player_state_notifier.dart';
import '../../style/layout.dart';
import '../../utils/ads_config.dart';
import '../../utils/bus/bus.dart';
import '../../utils/bus/constant.dart';
import '../../utils/cast_screen_manager.dart';
import '../../utils/dict.dart';
import '../../utils/player_utils.dart';
import '../../utils/user.dart';
import '../../utils/video.dart';
import 'Components/guess_you_like.dart';
import 'Components/video_info_view.dart';
import 'Components/sponsor_bar.dart';
import 'Components/video_player_widget.dart';
import 'Components/fullscreen_video_page.dart';
import 'components/video_settings_sheet.dart';
import 'components/video_info_section.dart';
import 'components/detail_content_view.dart';
import 'utils/casting_helper.dart';
import 'utils/video_download_helper.dart';

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

class _Video_DetailState extends State<Video_Detail>
    with RouteAware, WidgetsBindingObserver {
  final ValueNotifier<int> currentLine = ValueNotifier<int>(0);
  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0);

  late final CastingHelper _castingHelper;
  StateSetter? showModalBottomSheetListSate;

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
  late PlayerStateNotifier _playerStateNotifier;
  final List<String> _fitModes = ['默认', '原始', '拉伸', '填充', '4:3'];
  final List<double> _rateList = [0.75, 1.0, 1.25, 1.5, 2.0];

  final id = Get.arguments?["id"];
  final viewingDuration = Get.arguments?["viewingDuration"];
  String androidCodeId = AdsConfig.INTERSTITIAL_AD_ANDROID;
  String iosCodeId = AdsConfig.INTERSTITIAL_AD_IOS;
  VideoDetailDataData videoInfoData = VideoDetailDataData();
  List<TDTab> tabs = [];
  int progress = 0;
  int duration = 0;
  int seekTime = 100000;
  bool _hasAddedViews = false;
  Timer? _positionTimer;
  final PlayerStateManager _playerStateManager = PlayerStateManager();
  bool _isInPipMode = false;
  bool _isEnteringPipMode = false;
  bool _isAdAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _playerStateManager.isPageActive = true;

    _castingHelper = CastingHelper(
      onDeviceListUpdate: () {
        if (!mounted) return;
        setState(() {});
      },
    );

    player = Player();
    videoController = VideoController(player);
    _playerStateNotifier = PlayerStateNotifier();
    _futureBuilderFuture = init();
  }

  @override
  void dispose() {
    debugPrint('Video_Detail: dispose called');
    try {
      player.pause();
    } catch (e) {
      debugPrint('Video_Detail: Error pausing player in dispose: $e');
    }

    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    _onPageLeave();
    _stopPositionListener();

    try {
      player.dispose();
    } catch (e) {
      debugPrint('Video_Detail: Error disposing player: $e');
    }

    _castingHelper.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('App lifecycle state changed to: $state');

    _playerStateManager.ensurePlayerSafety(player);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_isInPipMode || _isEnteringPipMode) {
        debugPrint(
          'App is in background/inactive but in PiP mode, keeping player playing.',
        );
        return;
      }
      debugPrint('App is in background/inactive, pausing player.');
      _playerStateManager.pausePlayerImmediately(player);
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('App is resumed, checking player state.');
      _playerStateManager.resumePlayerIfNeeded();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPushNext() {
    debugPrint('Video_Detail: didPushNext called');
    _onPageLeave();
    _playerStateManager.ensurePlayerSafety(player);
    _playerStateManager.pausePlayerImmediately(player);
    _playerStateManager.isPageActive = false;
  }

  @override
  void didPop() {
    debugPrint('Video_Detail: didPop called');
    _onPageLeave();
    _playerStateManager.isPageActive = false;
    _playerStateManager.ensurePlayerSafety(player);
    _playerStateManager.pausePlayerImmediately(player);
    super.didPop();
  }

  @override
  void didPopNext() {
    debugPrint('Video_Detail: didPopNext called');
    _playerStateManager.isPageActive = true;
    _playerStateManager.ensurePlayerSafety(player);

    if (_playerStateManager.isPlayerReleased &&
        _playerStateManager.isPlayerInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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

  void _startPositionListener() {
    _positionTimer?.cancel();
    if (_playerStateManager.isPageActive) {
      debugPrint('Position listener started');
    }
  }

  void _stopPositionListener() {
    if (_positionTimer != null) {
      _positionTimer!.cancel();
      _positionTimer = null;
      debugPrint('Position listener stopped');
    }
  }

  void _onPageLeave() {
    if (!_hasAddedViews) {
      addViews();
      _hasAddedViews = true;
      debugPrint('Views recorded on page leave');
    }
  }

  void _videoListener() {
    player.stream.position.listen((pos) {
      if (!mounted) return;
      setState(() => progress = pos.inSeconds);
    }).onError((error) {
      debugPrint('Video position listener error: $error');
    });
  }

  void _errorListener() {
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

  Future<void> setVideoUrl(String url) async {
    try {
      debugPrint('Setting video URL: $url');

      if (_playerStateManager.isPlayerReleased) {
        _playerStateManager.isPlayerReleased = false;
        _playerStateManager.isPlayerInitialized = true;
      }

      if (url.isNotEmpty) {
        await player.open(Media(url), play: true);
        debugPrint('Video URL set successfully');
      } else {
        player.pause();
      }

      _startPositionListener();
      if (mounted) setState(() {});
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

  Future<void> addViews() async {
    if (!User.isLogin()) return;
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
          onTimeout: () => throw TimeoutException('Add views timeout'),
        );
        eventBus.fire(RefreshViewEvent());
        debugPrint('Add views success');
      }
    } catch (e) {
      debugPrint('Add views failed: $e');
    }
  }

  Future<String> init() async {
    try {
      tabs.clear();
      videoList.clear();

      await getVideoDetail().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Video detail initialization timeout'),
      );

      await Future.wait([
        getDictVideoCategoryData(),
        getDictLanguageData(),
        getDictAreaData(),
        getVideoPages(),
      ]).timeout(
        const Duration(seconds: 10),
        onTimeout: () => [],
      );

      _errorListener();
      _loadAd();
      _videoListener();
      _playerStateManager.isPlayerInitialized = true;
      _playerStateManager.isPlayerReleased = false;
      return "init success";
    } catch (e) {
      debugPrint('Initialization error: $e');
      return "init success";
    }
  }

  Future<void> getVideoDetail() async {
    try {
      tabs.clear();
      videoList.clear();

      final response = await Api.getVideoDetail({"id": id}).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Get video detail timeout'),
      );
      videoInfoData = response.data as VideoDetailDataData;

      if (videoInfoData.lines != null && videoInfoData.lines!.isNotEmpty) {
        for (var element in videoInfoData.lines!) {
          tabs.add(TDTab(text: element.collectionName ?? '线路'));
        }

        final selectedLine = videoInfoData.lines?[currentLine.value];
        final selectedPlayLine = selectedLine?.playLines?[currentPlay.value];
        setVideoUrl(selectedPlayLine?.file ?? "");

        if (selectedLine?.playLines != null) {
          final playerLineData = selectedLine?.playLines ?? [];
          if (playerLineData.isNotEmpty) {
            videoList.addAll(
              playerLineData.map((playLine) => VideoItem(
                title: playLine.videoName ?? "",
                url: playLine.file ?? "",
                subTitle: playLine.subTitle ?? "",
              )),
            );
          }
        }
      } else {
        tabs.add(TDTab(text: "默认线路"));
        videoList.add(VideoItem(
          title: videoInfoData.video?.title ?? "视频",
          url: "",
          subTitle: "暂无播放链接",
        ));
      }
    } catch (e) {
      debugPrint('Get video detail failed: $e');
      tabs.add(TDTab(text: "默认线路"));
      videoList.add(VideoItem(title: "视频", url: "", subTitle: "暂无播放链接"));
    }
  }

  Future<void> getDictAreaData() async {
    try {
      final response = await Api.getDictData({"types": ["area"]}).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get dict area data timeout'),
      );
      final dictData = response.data as DictDataData;
      area = dictData.area;
    } catch (e) {
      debugPrint('Get dict area data failed: $e');
      area = [];
    }
  }

  Future<void> getDictVideoCategoryData() async {
    try {
      final response = await Api.getDictData({"types": ["video_category"]}).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get dict video category data timeout'),
      );
      final dictData = response.data as DictDataData;
      videoCategory = dictData.videoCategory;
    } catch (e) {
      debugPrint('Get dict video category data failed: $e');
      videoCategory = [];
    }
  }

  Future<void> getDictLanguageData() async {
    try {
      final response = await Api.getDictData({"types": ["language"]}).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get dict language data timeout'),
      );
      final dictData = response.data as DictDataData;
      language = dictData.language;
    } catch (e) {
      debugPrint('Get dict language data failed: $e');
      language = [];
    }
  }

  Future<void> getVideoPages() async {
    try {
      final response = await Api.getVideoPages({
        "category_id": videoInfoData.video?.categoryId ?? 0,
        "page": DateTime.now().millisecondsSinceEpoch % 2 + 1,
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get video pages timeout'),
      );
      final list = response.data?.list ?? [];
      debugPrint('Get video pages success, count: ${list.length}');
      if (mounted) setState(() => videoPageData = list);
    } catch (e) {
      debugPrint('Get video pages failed: $e');
      if (mounted) setState(() => videoPageData = []);
    }
  }

  Future<void> _loadAd() async {
    try {
      final response = await Api.getAdsList({
        'status': 1,
        "adsPage": 897,
        'type': 680,
      }).timeout(
        const Duration(seconds: 2),
        onTimeout: () => throw TimeoutException("Banner广告请求超时"),
      );

      final adsList = response.data?.list ?? [];
      if (!mounted) return;

      final filteredAds = adsList.where((adsData) {
        return adsData.adsPage == 897 && adsData.type == 680;
      }).toList();

      if (filteredAds.isNotEmpty) {
        final adsData = filteredAds[0];
        setState(() {
          androidCodeId = adsData.adsId ?? androidCodeId;
          iosCodeId = adsData.adsId ?? iosCodeId;
          _isAdAvailable = true;
        });
      } else {
        setState(() => _isAdAvailable = false);
      }
    } catch (e) {
      debugPrint("Banner广告加载失败: $e");
      if (mounted) setState(() => _isAdAvailable = false);
    }
  }

  void goFeedbackPage() {
    String? videoId;
    String? videoUrl;
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
    _playerStateManager.pausePlayerImmediately(player);
    _onPageLeave();
    _stopPositionListener();
    try {
      player.stop();
    } catch (e) {
      debugPrint('Error stopping player in removeVideo: $e');
    }
    _playerStateManager.isPlayerReleased = true;
  }

  void _enterFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPage(
          player: player,
          videoController: videoController,
          videoTitle: videoInfoData.video?.title ?? '',
          videoRate: _playerStateNotifier.videoRate,
          currentVideoFit: _playerStateNotifier.videoFit,
          rateList: _rateList,
          fitModes: _fitModes,
          onCastingPressed: tvDevice,
          onVideoFitChanged: (fit) => _playerStateNotifier.setVideoFit(fit),
          onRateChanged: () {
            int currentIndex = _rateList.indexOf(_playerStateNotifier.videoRate);
            if (currentIndex == -1 || currentIndex >= _rateList.length - 1) {
              currentIndex = 0;
            } else {
              currentIndex++;
            }
            final newRate = _rateList[currentIndex];
            _playerStateNotifier.setVideoRate(newRate);
            player.setRate(newRate);
          },
          onNextVideo: () {
            if (currentPlay.value < videoList.length - 1) {
              currentPlay.value++;
              setVideoUrl(videoList[currentPlay.value].url);
            }
          },
          onPreviousVideo: () {
            if (currentPlay.value > 0) {
              currentPlay.value--;
              setVideoUrl(videoList[currentPlay.value].url);
            }
          },
        ),
      ),
    );
  }

  void tvDevice() {
    _castingHelper.showCastingDialog(
      context: context,
      videoInfoData: videoInfoData,
      currentLine: currentLine.value,
      currentPlay: currentPlay.value,
    );
  }

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
      builder: (context) => VideoSettingsSheet(
        player: player,
        currentRate: _playerStateNotifier.videoRate,
        videoInfoData: videoInfoData,
        currentLine: currentLine.value,
        currentPlay: currentPlay.value,
        currentVideoFit: _playerStateNotifier.videoFit,
        fitModes: _fitModes,
        rateList: _rateList,
        onVideoFitChanged: (fit) => _playerStateNotifier.setVideoFit(fit),
        onVideoRateChanged: (rate) => _playerStateNotifier.setVideoRate(rate),
        onBrightnessChanged: (brightness) =>
            _playerStateNotifier.setBrightness(brightness),
        onSkipOpeningChanged: (seconds) =>
            _playerStateNotifier.setSkipOpening(seconds),
        onSkipEndingChanged: (seconds) =>
            _playerStateNotifier.setSkipEnding(seconds),
      ),
    );
  }

  void showModalBottomSheetList() {
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "切换线路",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
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
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      flex: 1,
                      child: DetailTabsView(
                        tabData: videoInfoData.lines ?? [],
                        onSelectionChanged: (tabIndex, selectedIndices) {
                          try {
                            if (videoInfoData.lines != null &&
                                tabIndex < videoInfoData.lines!.length) {
                              setState(() => currentLine.value = tabIndex);

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
                                    selectedLine?.playLines?[selectedIndices.first];
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
          _buildVideo(),
          Container(
            margin: const EdgeInsets.only(top: 200),
            child: DetailContentView(
              future: _futureBuilderFuture,
              videoInfoData: videoInfoData,
              area: area,
              videoCategory: videoCategory,
              language: language,
              videoPageData: videoPageData,
              currentLine: currentLine,
              currentPlay: currentPlay,
              showModalBottomSheetList: showModalBottomSheetList,
              setVideoUrl: setVideoUrl,
              onVideoTap: removeVideo,
              onFeedbackTap: goFeedbackPage,
              androidCodeId: androidCodeId,
              iosCodeId: iosCodeId,
              isAdAvailable: _isAdAvailable,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideo() {
    return VideoPlayerWidget(
      player: player,
      videoController: videoController,
      videoUrl: '',
      videoFit: _playerStateNotifier.videoFit,
      videoRate: _playerStateNotifier.videoRate,
      rateList: _rateList,
      showControls: true,
      skipOpening: _playerStateNotifier.skipOpening,
      skipEnding: _playerStateNotifier.skipEnding,
      brightness: _playerStateNotifier.brightness,
      onSettingsPressed: _showSettingsSheet,
      onFullScreenPressed: _enterFullScreen,
      onCastingPressed: tvDevice,
      onUpdate: (settings) {
        debugPrint('播放设置 倍速: ${settings.videoRate}');
        debugPrint('播放设置 画面: ${settings.videoFit}');
        debugPrint('播放设置 音量: ${settings.volume}');
        debugPrint('播放设置 亮度: ${settings.brightness}');
        debugPrint('播放设置 跳过片头: ${VideoUtil.formatDuration(settings.skipOpening)}');
        debugPrint('播放设置 跳过片尾: ${VideoUtil.formatDuration(settings.skipEnding)}');
      },
      onPipEntering: () => setState(() => _isEnteringPipMode = true),
      onPipModeChanged: (isInPipMode) {
        setState(() {
          if (isInPipMode) {
            _isInPipMode = true;
            _isEnteringPipMode = false;
          } else {
            _isInPipMode = false;
            _isEnteringPipMode = false;
          }
        });
      },
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
          setVideoUrl(videoList[currentPlay.value].url);
        }
      },
      onPreviousVideo: () {
        if (currentPlay.value > 0) {
          currentPlay.value--;
          setVideoUrl(videoList[currentPlay.value].url);
        }
      },
      onRateChanged: (rate) {
        int currentIndex = _rateList.indexOf(_playerStateNotifier.videoRate);
        if (currentIndex == -1 || currentIndex >= _rateList.length - 1) {
          currentIndex = 0;
        } else {
          currentIndex++;
        }
        final newRate = _rateList[currentIndex];
        _playerStateNotifier.setVideoRate(newRate);
        player.setRate(newRate);
      },
      onVideoFitChanged: (fit) => _playerStateNotifier.setVideoFit(fit),
    );
  }
}
