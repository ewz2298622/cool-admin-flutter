import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../components/loading.dart';
import '../../../utils/video_player_utils.dart';

import '../../../components/danmaku_view_components.dart';

class VideoPlayerSettings {
  final int videoFit;
  final double videoRate;
  final double volume;
  final double brightness;
  final double skipOpening;
  final double skipEnding;
  final double longPressRate;

  VideoPlayerSettings({
    required this.videoFit,
    required this.videoRate,
    required this.volume,
    required this.brightness,
    required this.skipOpening,
    required this.skipEnding,
    required this.longPressRate,
  });
}

class VideoPlayerWidget extends StatefulWidget {
  final Player player;
  final VideoController videoController;
  final String videoUrl;
  final int videoFit;
  final double videoRate;
  final double longPressRate;
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
  final Function(VideoPlayerSettings)? onUpdate;
  final double skipOpening;
  final double skipEnding;
  final double brightness;

  const VideoPlayerWidget({
    super.key,
    required this.player,
    required this.videoController,
    required this.videoUrl,
    this.videoFit = 0,
    this.videoRate = 1.0,
    this.longPressRate = 2.0,
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
    this.onUpdate,
    this.skipOpening = 0.0,
    this.skipEnding = 0.0,
    this.brightness = 1.0,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _localShowControls = true;
  final ControlsHideManager _hideManager = ControlsHideManager();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration _pendingSeekPosition = Duration.zero;
  bool _isDragging = false;
  bool _isPlaying = false;
  bool _isLongPressing = false;
  bool _isBuffering = false;
  double _previousRate = 1.0;
  final PlayerStateManager _playerStateManager = PlayerStateManager();
  final PipManager _pipManager = PipManager();
  final ScreenBrightness _screenBrightness = ScreenBrightness();
  bool _hasSkippedOpening = false;
  bool _hasTriggeredEnding = false;
  double _originalBrightness = 0.0;

  @override
  void initState() {
    super.initState();
    debugPrint('[VideoPlayerWidget] initState, position=${widget.player.state.position}, skipOpening=${widget.skipOpening}');
    _localShowControls = widget.showControls;
    _totalDuration = widget.player.state.duration;
    _currentPosition = widget.player.state.position;
    _isPlaying = widget.player.state.playing;
    _initPip();
    _initBrightness();
    _notifyUpdate();
    _playerStateManager.setupListeners(
      player: widget.player,
      onPlayingChanged: (playing) {
        if (mounted) {
          setState(() => _isPlaying = playing);
        }
      },
      onDurationChanged: (duration) {
        if (duration > Duration.zero && _totalDuration != duration) {
          setState(() => _totalDuration = duration);
          _resetSkipFlags();
        }
      },
      onPositionChanged: (position) {
        if (mounted && !_isDragging) {
          setState(() => _currentPosition = position);
          _handleSkipLogic(position);
        }
      },
      onRateChanged: (rate) {
        _notifyUpdate();
      },
      onVolumeChanged: (volume) {
        _notifyUpdate();
      },
      onBufferingChanged: (buffering) {
        if (mounted) {
          setState(() => _isBuffering = buffering);
        }
      },
    );
  }

  Future<void> _initBrightness() async {
    try {
      _originalBrightness = await _screenBrightness.current;
      if (widget.brightness > 0 && widget.brightness <= 1.0) {
        await _screenBrightness.setScreenBrightness(widget.brightness);
      }
    } catch (e) {
      debugPrint('初始化亮度失败: $e');
    }
  }


  void _resetSkipFlags() {
    _hasSkippedOpening = false;
    _hasTriggeredEnding = false;
  }

  void _handleSkipLogic(Duration position) {
    debugPrint('[SkipLogic] position=${position.inSeconds}s, skipOpening=${widget.skipOpening}, skipEnding=${widget.skipEnding}, hasSkippedOpening=$_hasSkippedOpening');
    if (widget.skipOpening > 0 && !_hasSkippedOpening) {
      final openingSeconds = widget.skipOpening;
      debugPrint('[SkipLogic] 触发跳过片头: 跳转到${openingSeconds.toInt()}秒');
      if (position.inSeconds < openingSeconds.toInt()) {
        debugPrint('[Seek] 跳过片头 seek to ${openingSeconds.toInt()}s');
        widget.player.seek(Duration(seconds: openingSeconds.toInt()));
        _hasSkippedOpening = true;
      }
    }

    if (widget.skipEnding > 0 &&
        _totalDuration.inSeconds > 0 &&
        !_hasTriggeredEnding) {
      final endingSeconds = widget.skipEnding;
      final remainingSeconds = _totalDuration.inSeconds - position.inSeconds;
      debugPrint('[SkipLogic] 剩余时间=${remainingSeconds}s, 跳过片尾阈值=${endingSeconds.toInt()}s');

      if (remainingSeconds <= endingSeconds.toInt()) {
        debugPrint('[SkipLogic] 触发跳过片尾: 跳转下一集');
        _hasTriggeredEnding = true;
        widget.onNextVideo?.call();
      }
    }
  }

  void _notifyUpdate() {
    widget.onUpdate?.call(
      VideoPlayerSettings(
        videoFit: widget.videoFit,
        videoRate: widget.videoRate,
        volume: widget.player.state.volume / 100.0,
        brightness: widget.brightness,
        skipOpening: widget.skipOpening,
        skipEnding: widget.skipEnding,
        longPressRate: widget.longPressRate,
      ),
    );
  }

  Future<void> _initPip() async {
    await _pipManager.initialize();
    await _pipManager.registerStateObserver(
      onPipStarted: () {
        if (mounted) {
          setState(() => _localShowControls = false);
        }
      },
      onPipStopped: () {
        _hideManager.startTimer(
          onHide: () {
            if (mounted) {
              setState(() => _localShowControls = false);
            }
          },
        );
      },
      onPipModeChanged: (isInPipMode) {
        widget.onPipModeChanged?.call(isInPipMode);
      },
      onAutoPlay: () {
        widget.player.play();
      },
    );
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showControls != oldWidget.showControls) {
      _localShowControls = widget.showControls;
    }
    if (widget.videoRate != oldWidget.videoRate) {
      widget.player.setRate(widget.videoRate);
    }
    if (widget.brightness != oldWidget.brightness) {
      _setBrightness(widget.brightness);
    }
    if (widget.skipOpening != oldWidget.skipOpening ||
        widget.skipEnding != oldWidget.skipEnding ||
        widget.videoFit != oldWidget.videoFit) {
      _notifyUpdate();
    }
  }

  Future<void> _setBrightness(double value) async {
    try {
      await _screenBrightness.setScreenBrightness(value);
    } catch (e) {
      debugPrint('设置亮度失败: $e');
    }
  }

  @override
  void dispose() {
    _resetBrightness();
    _hideManager.dispose();
    _playerStateManager.dispose();
    _pipManager.dispose();
    super.dispose();
  }

  Future<void> _resetBrightness() async {
    try {
      if (_originalBrightness > 0) {
        await _screenBrightness.resetScreenBrightness();
      }
    } catch (e) {
      debugPrint('重置亮度失败: $e');
    }
  }

  void _startHideTimer() {
    _hideManager.startTimer(
      onHide: () {
        if (mounted) {
          setState(() => _localShowControls = false);
        }
      },
    );
  }

  void _onTapVideo() {
    setState(() => _localShowControls = !_localShowControls);
    if (_localShowControls) {
      _startHideTimer();
    } else {
      _hideManager.cancelTimer();
    }
  }

  void _updateSeekPosition(Duration position) {
    _pendingSeekPosition = position;
    setState(() {});
  }

  void _confirmSeek() {
    widget.player.seek(_pendingSeekPosition);
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
    await _pipManager.togglePipMode(
      onPipEntering: () => widget.onPipEntering?.call(),
      onPipSuccess: () => widget.player.play(),
      onPipFailed: (message) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          widget.onPipModeChanged?.call(false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: GestureDetector(
          onTap: _onTapVideo,
          onDoubleTap: _togglePlayPause,
          onLongPressStart: (_) {
            _previousRate = widget.player.state.rate;
            widget.player.setRate(widget.longPressRate);
            setState(() => _isLongPressing = true);
          },
          onLongPressEnd: (_) {
            widget.player.setRate(_previousRate);
            setState(() => _isLongPressing = false);
          },
          child: Stack(
            children: [
              Video(
                controller: widget.videoController,
                fill: Colors.black,
                fit:
                    _pipManager.isInPipMode
                        ? BoxFit.fill
                        : VideoPlayerUtils.getBoxFit(widget.videoFit),
                controls: null,
                subtitleViewConfiguration: const SubtitleViewConfiguration(
                  visible: false,
                ),
              ),
              if (_isBuffering)
                const Center(child: PageLoading())
              else if (_localShowControls) ...[
                _buildTopBar(),
                _buildMiddleControls(),
                _buildBottomBar(),
              ],
              if (_isLongPressing)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${widget.longPressRate}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
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
            colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
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
            if (_pipManager.isPipSupported)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _togglePipMode,
                child: Icon(
                  _pipManager.isInPipMode
                      ? CupertinoIcons.rectangle_on_rectangle_angled
                      : CupertinoIcons.rectangle_on_rectangle,
                  color: _pipManager.isInPipMode ? Colors.blue : Colors.white,
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
            child: const Icon(
              CupertinoIcons.gobackward_10,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 60),
          GestureDetector(
            onTap: _skipForward,
            child: const Icon(
              CupertinoIcons.goforward_10,
              color: Colors.white,
              size: 34,
            ),
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
            colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _togglePlayPause,
              child: Icon(
                _isPlaying
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_fill,
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
              VideoPlayerUtils.formatDuration(_currentPosition),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            Expanded(child: _buildProgressBar()),
            Text(
              VideoPlayerUtils.formatDuration(_totalDuration),
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
            _hideManager.cancelTimer();
            _isDragging = true;
          },
          onHorizontalDragUpdate: (details) {
            final width = constraints.maxWidth;
            if (width > 0 && _totalDuration.inMilliseconds > 0) {
              final double localDx = details.localPosition.dx.clamp(0.0, width);
              final double progress = localDx / width;
              final Duration seekPosition = Duration(
                milliseconds:
                    (_totalDuration.inMilliseconds * progress).round(),
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
                    color: Colors.white.withValues(alpha: 0.3),
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
    final displayPosition =
        _isDragging ? _pendingSeekPosition : _currentPosition;
    final progress =
        _totalDuration.inMilliseconds > 0
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
