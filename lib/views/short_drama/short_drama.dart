import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/play_line_entity.dart';
import '../../entity/video_detail_entity.dart';
import '../../entity/video_line_entity.dart';
import '../../utils/video.dart';

/// 常量定义
class ShortDramaConstants {
  // 颜色
  static const Color primaryColor = Color(0xFFFF7A00); // 暖橙色
  static const Color secondaryColor = Color(0xFFF5F5F5); // 浅灰色
  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white;
  static const Color redColor = Colors.red;
  
  // 尺寸
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 24.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double avatarSize = 48.0;
  
  // 文本
  static const String loadingFailedText = '加载失败，请重试';
  static const String noDataText = '暂无数据';
  static const String shareText = '分享';
  
  // 动画时长
  static const Duration controlHideDuration = Duration(seconds: 2);
  
  // 超时时间
  static const Duration apiTimeout = Duration(seconds: 15);
  static const Duration initTimeout = Duration(seconds: 20);
  
  // 其他
  static const double playbackSpeedNormal = 1.0;
  static const double playbackSpeedFast = 2.0;
}

/// 短视频播放页面
/// 支持垂直滑动切换视频，长按倍速播放
/// 
/// 功能特性：
/// - 垂直滑动切换剧集
/// - 长按屏幕切换倍速播放
/// - 支持 iOS 风格的操作图标
/// - 响应式布局，适配不同屏幕尺寸
/// - 完善的错误处理和异常捕获
class ShortDrama extends StatefulWidget {
  // 接受路由传递过来的props id
  const ShortDrama({super.key});

  @override
  State<ShortDrama> createState() => _ShortDramaState();
}

class _ShortDramaState extends State<ShortDrama>
    with SingleTickerProviderStateMixin {
  late final Future<String> _futureBuilderFuture; // 初始化数据的 Future
  final PageController _pageController = PageController(); // 页面控制器，用于垂直滑动切换视频
  VideoDetailData? videoData; // 视频详情数据
  List<VideoLineDataList> videoLineData = []; // 视频线路列表
  List<PlayLineDataList> playerLineData = []; // 播放线路详情列表
  final ValueNotifier<int> currentLine = ValueNotifier<int>(0); // 当前选中的视频线路
  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0); // 当前选中的播放线路
  List<VideoItem> _videoList = []; // 视频项列表
  final id = Get.arguments["id"]; // 从路由参数获取视频ID

  int _currentIndex = 0; // 当前视频索引
  bool _isDragging = false; // 是否正在拖动
  bool _showControls = false; // 是否显示控制栏
  final Duration _controlHideDuration = ShortDramaConstants.controlHideDuration; // 控制栏自动隐藏时长
  Timer? _controlHideTimer; // 控制栏隐藏定时器

  /// 处理 API 调用异常
  void _handleApiError(String methodName, dynamic error, StackTrace stackTrace) {
    debugPrint('Initialization $methodName failed: $error');
    debugPrint('Stack trace: $stackTrace');
  }

  /// 根据ID获取视频详情
  Future<void> getVideoById() async {
    try {
      debugPrint('Starting getVideoById');
      final response = await Api.getVideoById({"id": id}).timeout(
        ShortDramaConstants.apiTimeout,
        onTimeout: () {
          debugPrint('Get video by id timeout');
          throw TimeoutException('Get video by id timeout');
        },
      );
      videoData = response.data as VideoDetailData;
      debugPrint('Get video by id success');
    } catch (e, stackTrace) {
      _handleApiError('getVideoById', e, stackTrace);
    }
  }

  /// 获取视频线路列表
  Future<void> getVideoLinePages() async {
    try {
      debugPrint('Starting getVideoLinePages');
      final response = await Api.getVideoLinePages({"video_id": id}).timeout(
        ShortDramaConstants.apiTimeout,
        onTimeout: () {
          debugPrint('Get video line pages timeout');
          throw TimeoutException('Get video line pages timeout');
        },
      );
      videoLineData = response.data?.list as List<VideoLineDataList>;
      debugPrint('Get video line pages success, count: ${videoLineData.length}');
    } catch (e, stackTrace) {
      _handleApiError('getVideoLinePages', e, stackTrace);
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
        ShortDramaConstants.apiTimeout,
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
      _handleApiError('getPlayLinePages', e, stackTrace);
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
        ShortDramaConstants.initTimeout,
        onTimeout: () {
          debugPrint('Initialization timeout');
          throw TimeoutException('Initialization timeout');
        },
      );
      
      // 检查组件是否仍然挂载
      if (!mounted) {
        debugPrint('Component unmounted, skipping further initialization');
        return "init success";
      }
      
      // 获取播放线路详情
      await getPlayLinePages();
      
      // 检查组件是否仍然挂载
      if (!mounted) {
        debugPrint('Component unmounted, skipping state update');
        return "init success";
      }
      
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
              ShortDramaConstants.loadingFailedText,
              style: TextStyle(color: ShortDramaConstants.whiteColor, fontSize: 16),
            ),
          );
        } else if (!snapshot.hasData || _videoList.isEmpty) {
          return const Center(
            child: Text(
              ShortDramaConstants.noDataText,
              style: TextStyle(color: ShortDramaConstants.whiteColor, fontSize: 16),
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
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
       leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: ShortDramaConstants.iconSizeSmall, color: ShortDramaConstants.whiteColor),
          onPressed: () {
            // Navigator.pop(context);
            Get.back();
          },
        ),
        // 透明
        backgroundColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [Container(child: _buildContent())],
      ),
    );
  }
}

/// 视频项数据模型
/// 用于存储单个视频的信息
class VideoItem {
  final int id; // 视频ID
  final String title; // 视频标题
  final String subTitle; // 视频副标题（如剧集信息）
  final String videoUrl; // 视频播放地址
  final String coverUrl; // 视频封面图地址

  VideoItem({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.videoUrl,
    required this.coverUrl,
  });
}

/// 短视频项组件
/// 负责单个视频的播放和展示
class ShortVideoItemWidget extends StatefulWidget {
  final VideoItem videoItem; // 视频项数据
  final bool isActive; // 是否为当前活跃视频
  final VoidCallback onLongPressStart; // 长按开始回调
  final VoidCallback onLongPressEnd; // 长按结束回调
  final bool showControls; // 是否显示控制栏
  final VideoDetailData videoData; // 视频详情数据

  const ShortVideoItemWidget({
    super.key,
    required this.videoItem,
    required this.isActive,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.showControls,
    required this.videoData,
  });

  @override
  State<ShortVideoItemWidget> createState() => _ShortVideoItemWidgetState();
}

class _ShortVideoItemWidgetState extends State<ShortVideoItemWidget> {
  VideoPlayerController? _videoPlayerController; // 视频播放器控制器
  bool _isPlaying = false; // 是否正在播放
  double _playbackSpeed = ShortDramaConstants.playbackSpeedNormal; // 播放速度
  bool _isLoading = true; // 是否正在加载

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
    // 确保在初始化前释放旧的播放器
    _disposePlayer();

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

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoItem.videoUrl),
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
    } catch (e, stackTrace) {
      debugPrint('Video player initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 视频状态监听器
  void _videoListener() {
    if (!mounted) return;
    
    final isPlaying = _videoPlayerController?.value.isPlaying ?? false;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    }
  }

  /// 释放视频播放器资源
  void _disposePlayer() {
    if (_videoPlayerController != null) {
      try {
        _videoPlayerController!.removeListener(_videoListener);
        _videoPlayerController!.pause();
        _videoPlayerController!.dispose();
      } catch (e) {
        debugPrint('Error disposing video player: $e');
      } finally {
        _videoPlayerController = null;
        _isLoading = true;
        debugPrint('Video player controller disposed');
      }
    }
  }

  /// 开始播放视频
  void _startPlaying() {
    try {
      _videoPlayerController?.play();
      _videoPlayerController?.setPlaybackSpeed(_playbackSpeed);
    } catch (e) {
      debugPrint('Error starting video playback: $e');
    }
  }

  /// 暂停播放视频
  void _pausePlaying() {
    try {
      _videoPlayerController?.pause();
    } catch (e) {
      debugPrint('Error pausing video playback: $e');
    }
  }

  /// 切换播放速度
  void _togglePlaybackSpeed() {
    try {
      setState(() {
        _playbackSpeed = _playbackSpeed == ShortDramaConstants.playbackSpeedNormal 
            ? ShortDramaConstants.playbackSpeedFast 
            : ShortDramaConstants.playbackSpeedNormal;
        _videoPlayerController?.setPlaybackSpeed(_playbackSpeed);
      });
    } catch (e) {
      debugPrint('Error toggling playback speed: $e');
    }
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

  /// 构建操作按钮
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: ShortDramaConstants.whiteColor,
            size: ShortDramaConstants.iconSizeLarge,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: ShortDramaConstants.whiteColor, fontSize: 12),
        ),
      ],
    );
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
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.2, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 内容区域
          Positioned(
            left: ShortDramaConstants.paddingMedium,
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
                    color: ShortDramaConstants.redColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(ShortDramaConstants.borderRadiusMedium),
                  ),
                  child: Text(
                    widget.videoItem.subTitle,
                    style: const TextStyle(
                      color: ShortDramaConstants.whiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: ShortDramaConstants.paddingMedium),
                // 视频标题
                SizedBox(
                  width: contentWidth - 64, // 为右侧操作栏留出空间
                  child: Text(
                    widget.videoItem.title,
                    style: const TextStyle(
                      color: ShortDramaConstants.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: ShortDramaConstants.paddingSmall),
                // 视频简介
                SizedBox(
                  width: contentWidth - 64, // 为右侧操作栏留出空间
                  child: Text(
                    VideoUtil.extractPlainText(
                      widget.videoData.introduce ?? "",
                    ),
                    style: TextStyle(
                      color: ShortDramaConstants.whiteColor.withValues(alpha: 0.8),
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


          // 右侧操作栏
          Positioned(
            right: ShortDramaConstants.paddingMedium,
            bottom: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 头像
                Container(
                  width: ShortDramaConstants.avatarSize,
                  height: ShortDramaConstants.avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ShortDramaConstants.whiteColor, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.videoData.surfacePlot ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Icon(Icons.person, color: ShortDramaConstants.whiteColor),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: ShortDramaConstants.paddingLarge),
                // 点赞按钮
                _buildActionButton(
                  icon: CupertinoIcons.heart,
                  label: '12.5k',
                  onPressed: () {},
                ),
                SizedBox(height: ShortDramaConstants.paddingLarge),
                // 评论按钮
                _buildActionButton(
                  icon: CupertinoIcons.chat_bubble,
                  label: '1.2k',
                  onPressed: () {},
                ),
                SizedBox(height: ShortDramaConstants.paddingLarge),
                // 分享按钮
                _buildActionButton(
                  icon: CupertinoIcons.share,
                  label: ShortDramaConstants.shareText,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // 播放速度提示
          if (_playbackSpeed == ShortDramaConstants.playbackSpeedFast && widget.isActive)
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
                    color: ShortDramaConstants.blackColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(ShortDramaConstants.borderRadiusLarge),
                  ),
                  child: Text(
                    '${_playbackSpeed}x 快放',
                    style: const TextStyle(color: ShortDramaConstants.whiteColor, fontSize: 18, fontWeight: FontWeight.bold),
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
            color: Colors.black.withValues(alpha: 0.5),
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
