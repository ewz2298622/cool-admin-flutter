import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../entity/video_detail_entity.dart';
import '../../style/color_styles.dart';
import '../../utils/share_util.dart';
import '../../utils/video.dart';
import 'side_action_item.dart';
import 'video_item.dart';

class ShortVideoItemWidget extends StatefulWidget {
  final VideoItem videoItem;
  final bool isActive;
  final VideoDetailData videoData;
  final int currentIndex;
  final int totalCount;
  final bool isFollowing;
  final bool isLiked;
  final bool isFavorited;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final VoidCallback onLike;
  final VoidCallback onFollow;
  final VoidCallback onFavorite;
  final VoidCallback onEpisodeTap;
  final bool isExpanded;
  final VoidCallback onExpandToggle;
  final double playbackSpeed;

  const ShortVideoItemWidget({
    super.key,
    required this.videoItem,
    required this.isActive,
    required this.videoData,
    required this.currentIndex,
    required this.totalCount,
    required this.isFollowing,
    required this.isLiked,
    required this.isFavorited,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.onLike,
    required this.onFollow,
    required this.onFavorite,
    required this.onEpisodeTap,
    required this.isExpanded,
    required this.onExpandToggle,
    required this.playbackSpeed,
  });

  @override
  State<ShortVideoItemWidget> createState() => _ShortVideoItemWidgetState();
}

class _ShortVideoItemWidgetState extends State<ShortVideoItemWidget> {
  Player? _player;
  VideoController? _videoController;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _showControls = true;
  Timer? _hideTimer;
  StreamSubscription? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _positionSubscription?.cancel();
    _disposePlayer();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    if (widget.videoItem.videoUrl.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    _player = Player();
    _videoController = VideoController(_player!);

    await _player!.open(Media(widget.videoItem.videoUrl), play: false);

    _positionSubscription = _player!.stream.playing.listen(_videoListener);

    if (mounted) {
      setState(() => _isLoading = false);
      if (widget.isActive) _startPlaying();
    }
  }

  void _videoListener(bool? playing) {
    if (playing != null && playing != _isPlaying) {
      setState(() => _isPlaying = playing);
    }
  }

  void _disposePlayer() {
    _positionSubscription?.cancel();
    _player?.stop();
    _player?.dispose();
    _player = null;
    _videoController = null;
  }

  void _startPlaying() {
    _player?.play();
  }

  void _pausePlaying() {
    _player?.pause();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pausePlaying();
    } else {
      _startPlaying();
    }
    setState(() => _showControls = true);
    _scheduleHideControls();
  }

  void _scheduleHideControls() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ShortVideoItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startPlaying();
    } else if (!widget.isActive && oldWidget.isActive) {
      _pausePlaying();
    }
    if (oldWidget.videoItem.videoUrl != widget.videoItem.videoUrl) {
      _disposePlayer();
      _initializePlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildVideoContent(),
          if (_showControls) ...[
            _buildPlayPauseIndicator(),
            _buildRightActionBar(),
            _buildBottomInfo(),
            _buildProgressIndicator(),
            _buildBottomBar(),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    final controller = _videoController;
    final player = _player;
    if (controller != null && player != null) {
      return Positioned.fill(
        left: 0,
        right: 0,
        bottom: 100,
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 80,
            child: Video(
              controller: controller,
              fill: Colors.black,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          widget.videoItem.coverUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.black),
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlayPauseIndicator() {
    return Center(
      child: AnimatedOpacity(
        opacity: _isPlaying ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final player = _player;
    if (player == null) {
      return const SizedBox.shrink();
    }
    return StreamBuilder<Duration>(
      stream: player.stream.position,
      builder: (context, positionSnapshot) {
        return StreamBuilder<Duration?>(
          stream: player.stream.duration,
          builder: (context, durationSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            final duration = durationSnapshot.data ?? Duration.zero;
            final progress =
                duration.inMilliseconds > 0
                    ? position.inMilliseconds / duration.inMilliseconds
                    : 0.0;

            return Positioned(
              left: 0,
              right: 0,
              bottom: 65,
              child: Container(
                height: 2,
                color: Colors.white24,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(color: ColorStyles.colorPrimary),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRightActionBar() {
    return Positioned(
      right: 12,
      bottom: 150,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SideActionItem(
            icon: Icons.star,
            filledIcon: Icons.star,
            label: _formatCount(19000),
            isActive: widget.isFavorited,
            activeColor: Colors.amber,
            onTap: widget.onFavorite,
          ),
          const SizedBox(height: 20),
          SideActionItem(
            icon: Icons.favorite,
            filledIcon: Icons.favorite,
            label: _formatCount(widget.likeCount),
            isActive: widget.isLiked,
            activeColor: Colors.red,
            onTap: widget.onLike,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              ShareUtil.shareImage();
            },
            child: SvgPicture.asset(
              'assets/images/share.svg',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    final intro = VideoUtil.extractPlainText(widget.videoData.introduce ?? "");
    final displayIntro =
        widget.isExpanded
            ? intro
            : (intro.length > 30 ? '${intro.substring(0, 30)}...' : intro);

    return Positioned(
      left: 16,
      right: 80,
      bottom: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '新剧',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: widget.onEpisodeTap,
                  child: Text(
                    widget.videoItem.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(color: Color(0xCC000000), blurRadius: 2),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '第${widget.currentIndex + 1}集 | $displayIntro',
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(color: Color(0x4DFFFFFF), blurRadius: 1),
                    ],
                  ),
                  maxLines: widget.isExpanded ? 4 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (intro.length > 30)
                GestureDetector(
                  onTap: widget.onExpandToggle,
                  child: Text(
                    widget.isExpanded ? '收起' : '展开',
                    style: const TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: GestureDetector(
              onTap: widget.onEpisodeTap,
              child: Container(
                width: constraints.maxWidth * 0.95,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.list, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '选集',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '·',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ).copyWith(color: const Color.fromARGB(179, 255, 255, 255)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '已完结',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '·',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ).copyWith(color: const Color.fromARGB(179, 255, 255, 255)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '全${widget.totalCount}集',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.rotate(
                      angle: 3.14159,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
