import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:pip/pip.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Player player;
  final VideoController videoController;
  final String videoUrl;
  final int videoFit;
  final double videoRate;
  final List<double> rateList;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onFullScreenPressed;
  final VoidCallback? onCastingPressed;
  final VoidCallback? onPipPressed;
  final ValueChanged<bool>? onPipModeChanged;
  final VoidCallback? onPipEntering;
  final ValueChanged<double>? onRateChanged;
  final ValueChanged<int>? onVideoFitChanged;
  final bool showControls;
  final VoidCallback? onPlayPause;
  final VoidCallback? onSkipForward;
  final VoidCallback? onSkipBackward;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;

  const VideoPlayerWidget({
    super.key,
    required this.player,
    required this.videoController,
    required this.videoUrl,
    this.videoFit = 0,
    this.videoRate = 1.0,
    this.rateList = const [0.75, 1.0, 1.25, 1.5, 2.0],
    this.onSettingsPressed,
    this.onFullScreenPressed,
    this.onCastingPressed,
    this.onPipPressed,
    this.onPipModeChanged,
    this.onPipEntering,
    this.onRateChanged,
    this.onVideoFitChanged,
    this.showControls = true,
    this.onPlayPause,
    this.onSkipForward,
    this.onSkipBackward,
    this.onNextVideo,
    this.onPreviousVideo,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _localShowControls = true;
  Timer? _hideTimer;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration _pendingSeekPosition = Duration.zero;
  bool _isDragging = false;
  bool _isPlaying = false;
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  final Pip _pip = Pip();
  bool _isPipSupported = false;
  bool _isInPipMode = false;

  @override
  void initState() {
    super.initState();
    _localShowControls = widget.showControls;
    _totalDuration = widget.player.state.duration;
    _currentPosition = widget.player.state.position;
    _isPlaying = widget.player.state.playing;
    _initPip();
    _playingSubscription = widget.player.stream.playing.listen((playing) {
      if (mounted) {
        setState(() => _isPlaying = playing);
      }
    });
    _durationSubscription = widget.player.stream.duration.listen((duration) {
      if (duration > Duration.zero && _totalDuration != duration) {
        setState(() => _totalDuration = duration);
      }
    });
    _positionSubscription = widget.player.stream.position.listen((position) {
      if (mounted && !_isDragging) {
        setState(() => _currentPosition = position);
      }
    });
  }

  Future<void> _initPip() async {
    _isPipSupported = await _pip.isSupported();
    if (_isPipSupported) {
      await _pip.setup(
        PipOptions(
          autoEnterEnabled: true,
          aspectRatioX: 16,
          aspectRatioY: 9,
          controlStyle: 2,
        ),
      );
      await _pip.registerStateChangedObserver(
        PipStateChangedObserver(
          onPipStateChanged: (state, error) {
            if (mounted) {
              final wasInPipMode = _isInPipMode;
              setState(() {
                _isInPipMode = state == PipState.pipStateStarted;
                if (_isInPipMode) {
                  _localShowControls = false;
                }
              });
              if (_isInPipMode != wasInPipMode) {
                widget.onPipModeChanged?.call(_isInPipMode);
              }
              if (state == PipState.pipStateStarted) {
                _hideTimer?.cancel();
                widget.player.play();
              } else if (state == PipState.pipStateStopped) {
                _startHideTimer();
              }
            }
          },
        ),
      );
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showControls != oldWidget.showControls) {
      _localShowControls = widget.showControls;
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _playingSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _pip.dispose();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _localShowControls = false);
      }
    });
  }

  void _onTapVideo() {
    setState(() => _localShowControls = !_localShowControls);
    if (_localShowControls) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _updateSeekPosition(Duration position) {
    _pendingSeekPosition = position;
    setState(() {});
  }

  void _confirmSeek() {
    widget.player.seek(_pendingSeekPosition);
  }

  BoxFit _getBoxFit(int fitIndex) {
    switch (fitIndex) {
      case 0:
        return BoxFit.contain;
      case 1:
        return BoxFit.fitWidth;
      case 2:
        return BoxFit.fill;
      case 3:
        return BoxFit.cover;
      case 4:
        return BoxFit.fill;
      default:
        return BoxFit.contain;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  void _skipForward() {
    if (widget.onSkipForward != null) {
      widget.onSkipForward!();
    } else {
      final currentPos = widget.player.state.position;
      widget.player.seek(currentPos + const Duration(seconds: 10));
    }
  }

  void _skipBackward() {
    if (widget.onSkipBackward != null) {
      widget.onSkipBackward!();
    } else {
      final currentPos = widget.player.state.position;
      final newPos = currentPos - const Duration(seconds: 10);
      widget.player.seek(newPos < Duration.zero ? Duration.zero : newPos);
    }
  }

  void _playNext() {
    widget.onNextVideo?.call();
  }

  void _playPrevious() {
    widget.onPreviousVideo?.call();
  }

  void _togglePlayPause() {
    if (widget.onPlayPause != null) {
      widget.onPlayPause!();
    } else {
      if (widget.player.state.playing) {
        widget.player.pause();
      } else {
        widget.player.play();
      }
    }
  }

  Future<void> _togglePipMode() async {
    if (!_isPipSupported) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('当前设备不支持画中画功能')),
        );
      }
      return;
    }

    if (_isInPipMode) {
      await _pip.stop();
    } else {
      widget.onPipEntering?.call();
      final result = await _pip.start();
      if (result && mounted) {
        widget.player.play();
      } else if (!result && mounted) {
        widget.onPipModeChanged?.call(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('进入画中画模式失败')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapVideo,
      child: Container(
        width: double.infinity,
        height: 200,
        color: Colors.black,
        child: Stack(
          children: [
            Video(
              controller: widget.videoController,
              fill: Colors.black,
              fit: _isInPipMode ? BoxFit.fill : _getBoxFit(widget.videoFit),
              controls: null,
              subtitleViewConfiguration: const SubtitleViewConfiguration(
                visible: false,
              ),
            ),
            if (_localShowControls) ...[
              _buildTopBar(),
              _buildMiddleControls(),
              _buildBottomBar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: -12,
      left: 0,
      right: 0,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(
                CupertinoIcons.back,
                color: Colors.white,
                size: 24,
              ),
            ),
            const Spacer(),
            if (_isPipSupported)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _togglePipMode,
                child: Icon(
                  _isInPipMode
                      ? CupertinoIcons.rectangle_on_rectangle_angled
                      : CupertinoIcons.rectangle_on_rectangle,
                  color: _isInPipMode ? Colors.blue : Colors.white,
                  size: 22,
                ),
              ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onCastingPressed,
              child: const Icon(
                CupertinoIcons.tv,
                color: Colors.white,
                size: 22,
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onSettingsPressed,
              child: const Icon(
                CupertinoIcons.settings,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleControls() {
    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _skipBackward,
            child: const Icon(CupertinoIcons.gobackward_10, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 60),
          GestureDetector(
            onTap: _skipForward,
            child: const Icon(CupertinoIcons.goforward_10, color: Colors.white, size: 34),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _togglePlayPause,
              child: Icon(
                _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                color: Colors.white,
                size: 24,
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _playNext,
              child: const Icon(
                CupertinoIcons.forward_end_fill,
                color: Colors.white,
                size: 24,
              ),
            ),
            Text(
              _formatDuration(_currentPosition),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            Expanded(child: _buildProgressBar()),
            Text(
              _formatDuration(_totalDuration),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => widget.onRateChanged?.call(widget.videoRate),
              child: SizedBox(
                width: 40,
                child: Text(
                  '${widget.videoRate}x',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onFullScreenPressed,
              child: const Icon(
                CupertinoIcons.arrow_up_left_arrow_down_right,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) {
            _hideTimer?.cancel();
            _isDragging = true;
          },
          onHorizontalDragUpdate: (details) {
            final width = constraints.maxWidth;
            if (width > 0 && _totalDuration.inMilliseconds > 0) {
              final double localDx = details.localPosition.dx.clamp(0.0, width);
              final double progress = localDx / width;
              final Duration seekPosition = Duration(
                milliseconds: (_totalDuration.inMilliseconds * progress).round(),
              );
              _updateSeekPosition(seekPosition);
            }
          },
          onHorizontalDragEnd: (_) {
            _isDragging = false;
            if (_totalDuration.inMilliseconds > 0) {
              _confirmSeek();
              _startHideTimer();
            }
          },
          child: SizedBox(
            height: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                _buildProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    final displayPosition = _isDragging ? _pendingSeekPosition : _currentPosition;
    final progress = _totalDuration.inMilliseconds > 0
        ? displayPosition.inMilliseconds / _totalDuration.inMilliseconds
        : 0.0;

    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}