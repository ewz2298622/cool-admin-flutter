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

/// 短视频播放页面
/// 支持垂直滑动切换视频，长按倍速播放
class ShortDrama extends StatefulWidget {
  // 接受路由传递过来的props id
  const ShortDrama({super.key});

  @override
  _ShortDramaState createState() => _ShortDramaState();
}

class _ShortDramaState extends State<ShortDrama>
    with SingleTickerProviderStateMixin {
  late final Future<String> _futureBuilderFuture;
  final PageController _pageController = PageController();
  VideoDetailData? videoData;
  List<VideoLineDataList> videoLineData = [];
  List<PlayLineDataList> playerLineData = [];
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
  static const Duration _controlHideDuration = Duration(seconds: 2);
  Timer? _controlHideTimer;

  /// 根据ID获取视频详情
  Future<void> getVideoById() async {
    try {
      debugPrint('Starting getVideoById');
      final response = await Api.getVideoById({"id": id}).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('Get video by id timeout');
          throw TimeoutException('Get video by id timeout');
        },
      );
      videoData = response.data as VideoDetailData;
      debugPrint('Get video by id success');
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoById failed: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// 获取视频线路列表
  Future<void> getVideoLinePages() async {
    try {
      debugPrint('Starting getVideoLinePages');
      final response = await Api.getVideoLinePages({"video_id": id}).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('Get video line pages timeout');
          throw TimeoutException('Get video line pages timeout');
        },
      );
      videoLineData = response.data?.list as List<VideoLineDataList>;
      debugPrint('Get video line pages success, count: ${videoLineData.length}');
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization getVideoLinePages failed: $e');
      debugPrint('Stack trace: $stackTrace');
      videoLineData = [];
    }
  }

  /// 获取播放线路详情
  Future<void> getPlayLinePages() async {
    try {
      debugPrint('Starting getPlayLinePages');
      playerLineData.clear();
      if (videoLineData.isEmpty) {
        _videoList = [];
        debugPrint('Video line data is empty');
        return;
      }

      final safeIndex = currentLine.value.clamp(0, videoLineData.length - 1);
      final currentVideoLineId = videoLineData[safeIndex].id;
      if (currentVideoLineId == null) {
        _videoList = [];
        debugPrint('Current video line id is null');
        return;
      }

      final response = await Api.getPlayLinePages({
        "video_id": id,
        "video_line_id": currentVideoLineId,
        "size": 10000,
      }).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('Get play line pages timeout');
          throw TimeoutException('Get play line pages timeout');
        },
      );

      final rawList = response.data?.list;
      if (rawList == null) {
        playerLineData = [];
      } else {
        playerLineData = rawList;
      }

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
      debugPrint('Get play line pages success, count: ${playerLineData.length}');
    } catch (e, stackTrace) {
      // 捕获并处理异常
      debugPrint('Initialization getPlayLinePages failed: $e');
      debugPrint('Stack trace: $stackTrace');
      playerLineData = [];
      _videoList = [];
    }
  }

  /// 初始化数据
  Future<String> init() async {
    try {
      debugPrint('Starting ShortDrama initialization');
      // 并行获取视频基本信息和线路信息
      await Future.wait([
        getVideoById(),
        getVideoLinePages(),
      ]).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          debugPrint('Initialization timeout');
          throw TimeoutException('Initialization timeout');
        },
      );
      // 获取播放线路详情
      await getPlayLinePages();
      debugPrint('ShortDrama initialization success');
      return "init success";
    } catch (e, stackTrace) {
      debugPrint('ShortDrama init failed: $e');
      debugPrint('Stack trace: $stackTrace');
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

  /// 延迟隐藏控制栏
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

  /// 构建内容区域
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PageLoading();
        } else if (snapshot.hasError) {
          debugPrint('ShortDrama initialization error: ${snapshot.error}');
          return const Center(
            child: Text(
              '加载失败，请重试',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        } else if (!snapshot.hasData || _videoList.isEmpty) {
          return const Center(
            child: Text(
              '暂无数据',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        return PageView.builder(
          key: const PageStorageKey<String>('short_drama_page_view'),
          controller: _pageController,
          itemCount: _videoList.length,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            if (_currentIndex == index) return;
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
                if (_isDragging && _showControls) return;
                setState(() {
                  _showControls = true;
                  _isDragging = true;
                });
              },
              onLongPressEnd: () {
                if (!_isDragging) return;
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      backgroundColor: Colors.black,
    );
  }
}

/// 视频项数据模型
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

/// 短视频项组件
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
  bool _isLoading = true;

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

  /// 初始化视频播放器
  Future<void> _initializePlayer() async {
    if (widget.videoItem.videoUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _videoPlayerController = VideoPlayerController.network(
      widget.videoItem.videoUrl,
    );

    if (!mounted) return;
    await _videoPlayerController?.initialize();

    _videoPlayerController?.addListener(_videoListener);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (widget.isActive) {
      _startPlaying();
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// 视频状态监听器
  void _videoListener() {
    if (_videoPlayerController?.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _videoPlayerController?.value.isPlaying ?? false;
      });
    }
  }

  /// 释放视频播放器资源
  void _disposePlayer() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.removeListener(_videoListener);
      _videoPlayerController!.pause();
      _videoPlayerController!.dispose();
      _videoPlayerController = null;
      _isLoading = true;
      debugPrint('Video player controller disposed');
    }
  }

  /// 开始播放视频
  void _startPlaying() {
    _videoPlayerController?.play();
    _videoPlayerController?.setPlaybackSpeed(_playbackSpeed);
  }

  /// 暂停播放视频
  void _pausePlaying() {
    _videoPlayerController?.pause();
  }

  /// 切换播放速度
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
    // 检查视频URL是否变化，如果变化则重新初始化播放器
    if (oldWidget.videoItem.videoUrl != widget.videoItem.videoUrl) {
      _disposePlayer();
      _initializePlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenHeight = screenSize.height;
    final contentWidth = screenSize.width - 32;

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
          Positioned.fill(child: _buildVideoContent()),

          // 渐变背景
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.2, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 内容区域
          Positioned(
            left: 16,
            right: 80, // 为右侧操作栏留出空间
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 剧集信息
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.videoItem.subTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // 视频标题
                SizedBox(
                  width: contentWidth - 64, // 为右侧操作栏留出空间
                  child: Text(
                    widget.videoItem.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                // 视频简介
                SizedBox(
                  width: contentWidth - 64, // 为右侧操作栏留出空间
                  child: Text(
                    VideoUtil.extractPlainText(
                      widget.videoData.introduce ?? "",
                    ),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
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
            top: 40, // 调整顶部距离，适配安全区域
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          // 右侧操作栏
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 头像
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.videoData.surfacePlot ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Icon(Icons.person, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 点赞按钮
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const Text(
                      '12.5k',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // 评论按钮
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.comment_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const Text(
                      '1.2k',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // 分享按钮
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share, color: Colors.white, size: 32),
                    ),
                    const Text('分享', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // 播放速度提示
          if (_playbackSpeed == 2.0 && widget.isActive)
            Positioned(
              left: 0,
              right: 0,
              top: screenHeight * 0.4,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    '${_playbackSpeed}x 快放',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建视频内容区域
  Widget _buildVideoContent() {
    final controller = _videoPlayerController;
    if (controller != null && controller.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        // 封面图
        Image.network(
          widget.videoItem.coverUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.black,
              child: const Center(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.black,
              child: const Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            );
          },
        ),
        // 加载指示器
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
