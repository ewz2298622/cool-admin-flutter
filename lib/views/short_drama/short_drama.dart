import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/play_line_entity.dart';
import '../../entity/video_detail_entity.dart';
import '../../entity/video_line_entity.dart';
import '../../utils/video.dart';

class ShortDrama extends StatefulWidget {
  //接受路由传递过来的props id
  const ShortDrama({super.key});

  @override
  _ShortDramaState createState() => _ShortDramaState();
}

class _ShortDramaState extends State<ShortDrama>
    with SingleTickerProviderStateMixin {
  var _futureBuilderFuture;
  final PageController _pageController = PageController();
  VideoDetailData? videoData;
  List<VideoLineDataList> videoLineData = [];
  List<PlayLineDataList> playerLineData = [];
  List<VideoItem> videoList = [];
  List<DictDataDataArea>? area = [];
  List<DictDataDataVideoCategory>? videoCategory = [];
  List<DictDataDataLanguage>? language = [];
  final ValueNotifier<int> currentLine = ValueNotifier<int>(0);
  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0);
  List<VideoItem> _videoList = [];
  final id = Get.arguments["id"];

  int _currentIndex = 0;
  bool _isDragging = false;
  bool _showControls = false;
  final Duration _controlHideDuration = const Duration(seconds: 2);
  Timer? _controlHideTimer;

  Future<void> getVideoById() async {
    try {
      videoData = (await Api.getVideoById({"id": id})).data as VideoDetailData;
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
      _videoList = List.generate(
        playerLineData.length,
        (index) => VideoItem(
          id: index,
          title: videoData?.title ?? "",
          subTitle: playerLineData[index].subTitle ?? "",
          videoUrl: playerLineData[index].file ?? "",
          coverUrl: videoData?.surfacePlot ?? "",
        ),
      );
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<String> init() async {
    try {
      await getVideoById();
      await getVideoLinePages();
      await getPlayLinePages();
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      return "init success";
    }
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controlHideTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _hideControlsAfterDelay() {
    _controlHideTimer?.cancel();
    _controlHideTimer = Timer(_controlHideDuration, () {
      if (mounted && !_isDragging) {
        setState(() {
          _showControls = false;
        });
      }
    });
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
          return PageView.builder(
            controller: _pageController,
            itemCount: playerLineData.length,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final videoItem = _videoList[index];
              return ShortVideoItemWidget(
                videoItem: videoItem,
                isActive: index == _currentIndex,
                onLongPressStart: () {
                  setState(() {
                    _showControls = true;
                    _isDragging = true;
                  });
                },
                onLongPressEnd: () {
                  setState(() {
                    _isDragging = false;
                  });
                  _hideControlsAfterDelay();
                },
                showControls: _showControls,
                videoData: videoData!,
              );
            },
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }
}

class VideoItem {
  final int id;
  final String title;
  final String subTitle;
  final String videoUrl;
  final String coverUrl;

  VideoItem({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.videoUrl,
    required this.coverUrl,
  });
}

class ShortVideoItemWidget extends StatefulWidget {
  final VideoItem videoItem;
  final bool isActive;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final bool showControls;
  final VideoDetailData videoData;

  const ShortVideoItemWidget({
    Key? key,
    required this.videoItem,
    required this.isActive,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.showControls,
    required this.videoData,
  }) : super(key: key);

  @override
  State<ShortVideoItemWidget> createState() => _ShortVideoItemWidgetState();
}

class _ShortVideoItemWidgetState extends State<ShortVideoItemWidget> {
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(
      widget.videoItem.videoUrl,
    );

    await _videoPlayerController?.initialize();

    _videoPlayerController?.addListener(_videoListener);

    if (widget.isActive) {
      _startPlaying();
    }

    setState(() {});
  }

  void _videoListener() {
    if (_videoPlayerController?.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _videoPlayerController?.value.isPlaying ?? false;
      });
    }
  }

  void _disposePlayer() {
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.pause();
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
  }

  void _startPlaying() {
    _videoPlayerController?.play();
    _videoPlayerController?.setPlaybackSpeed(_playbackSpeed);
  }

  void _pausePlaying() {
    _videoPlayerController?.pause();
  }

  void _togglePlaybackSpeed() {
    setState(() {
      _playbackSpeed = _playbackSpeed == 1.0 ? 2.0 : 1.0;
      _videoPlayerController?.setPlaybackSpeed(_playbackSpeed);
    });
  }

  @override
  void didUpdateWidget(covariant ShortVideoItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _startPlaying();
      } else {
        _pausePlaying();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onLongPressStart: (_) {
        widget.onLongPressStart();
        _togglePlaybackSpeed();
      },
      onLongPressEnd: (_) {
        widget.onLongPressEnd();
        _togglePlaybackSpeed();
      },
      onTap: () {
        if (_isPlaying) {
          _pausePlaying();
        } else {
          _startPlaying();
        }
      },
      child: Stack(
        children: [
          // 视频播放器
          Positioned.fill(
            child: Image.network(widget.videoItem.coverUrl, fit: BoxFit.cover),
          ),

          // 渐变背景
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                  stops: const [0.0, 0.2, 0.8, 1.0],
                ),
              ),
            ),
          ),

          // 内容区域
          Positioned(
            left: 16,
            right: 16,
            bottom: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  child: Text(
                    widget.videoItem.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // 标题 - 处理溢出
                SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  child: Text(
                    VideoUtil.extractPlainText(
                      widget.videoData.introduce ?? "",
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 顶部返回按钮
          Positioned(
            top: 15,
            left: 16,
            child: IconButton(
              icon: Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  Text(
                    widget.videoItem.subTitle,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // 右侧操作栏
          // Positioned(
          //   right: 16,
          //   bottom: 100,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.favorite_border,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       Text(
          //         '12.5k',
          //         style: TextStyle(color: Colors.white, fontSize: 12),
          //       ),
          //       const SizedBox(height: 24),
          //       IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.comment_outlined,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       Text(
          //         '1.2k',
          //         style: TextStyle(color: Colors.white, fontSize: 12),
          //       ),
          //       const SizedBox(height: 24),
          //       IconButton(
          //         onPressed: () {},
          //         icon: const Icon(Icons.share, color: Colors.white, size: 30),
          //       ),
          //       const SizedBox(height: 8),
          //       Text('分享', style: TextStyle(color: Colors.white, fontSize: 12)),
          //     ],
          //   ),
          // ),

          // 进度条和控制条

          // 播放速度提示
          if (_playbackSpeed == 2.0 && widget.isActive)
            Positioned(
              left: 0,
              right: 0,
              top: screenHeight * 0.4,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_playbackSpeed}x 快放',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
