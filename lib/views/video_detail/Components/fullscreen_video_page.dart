import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../components/loading.dart';
import '../../../components/danmaku_view_components.dart';
import '../../../data/danmaku_mock_data.dart' as mock_data;
import '../../../store/player/player_state_notifier.dart';
import '../../../utils/video_player_utils.dart';

class FullScreenVideoPage extends StatefulWidget {
  final Player player;
  final VideoController videoController;
  final PlayerStateNotifier playerStateNotifier;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onCastingPressed;
  final VoidCallback? onPipPressed;
  final VoidCallback? onRateChanged;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;
  final String videoTitle;
  final List<double> rateList;
  final List<String> fitModes;

  const FullScreenVideoPage({
    super.key,
    required this.player,
    required this.videoController,
    required this.playerStateNotifier,
    this.onSettingsPressed,
    this.onCastingPressed,
    this.onPipPressed,
    this.onRateChanged,
    this.onNextVideo,
    this.onPreviousVideo,
    this.videoTitle = '',
    required this.rateList,
    required this.fitModes,
  });

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  bool _showControls = true;
  final ControlsHideManager _hideManager = ControlsHideManager();
  bool _wasPlaying = false;
  bool _userIsDraggingSlider = false;
  Duration _pendingSeekPosition = Duration.zero;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  bool _showSettings = false;
  bool _isLongPressing = false;
  bool _isBuffering = false;
  double _previousRate = 1.0;
  final PlayerStateManager _playerStateManager = PlayerStateManager();
  final PipManager _pipManager = PipManager();
  final ScreenBrightness _screenBrightness = ScreenBrightness();
  bool _hasSkippedOpening = false;
  bool _hasTriggeredEnding = false;
  double _originalBrightness = 0.0;
  List<mock_data.DanmakuItem> _danmakuList = [];

  int get _videoFit => widget.playerStateNotifier.videoFit;
  double get _volume => widget.playerStateNotifier.volume;
  double get _brightness => widget.playerStateNotifier.brightness;
  double get _skipOpening => widget.playerStateNotifier.skipOpening;
  double get _skipEnding => widget.playerStateNotifier.skipEnding;
  double get _videoRate => widget.playerStateNotifier.videoRate;
  double get _longPressRate => widget.playerStateNotifier.longPressRate;

  @override
  void initState() {
    super.initState();
    _enterFullScreenMode();
    _startHideTimer();
    _initializeState();
    _setupListeners();
    _initPip();
    _initBrightness();
    _loadDanmakuData();
  }

  Future<void> _loadDanmakuData() async {
    final list = await mock_data.DanmakuMockData.loadDanmakuData();
    if (mounted) {
      setState(() => _danmakuList = list);
    }
  }

  Future<void> _initBrightness() async {
    try {
      _originalBrightness = await _screenBrightness.current;
      if (_brightness > 0 && _brightness <= 1.0) {
        await _screenBrightness.setScreenBrightness(_brightness);
      }
    } catch (e) {
      debugPrint('初始化亮度失败: $e');
    }
  }

  Future<void> _initPip() async {
    await _pipManager.initialize();
    await _pipManager.registerStateObserver(
      onPipStarted: () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      },
      onPipStopped: () {
        _hideManager.startTimer(
          onHide: () {
            if (mounted) {
              setState(() => _showControls = false);
            }
          },
        );
      },
      onAutoPlay: () {
        if (!_isPlaying) {
          widget.player.play();
        }
      },
    );
  }

  void _initializeState() {
    _isPlaying = widget.player.state.playing;
    _currentPosition = widget.player.state.position;
    _totalDuration = widget.player.state.duration;
  }

  void _setupListeners() {
    _playerStateManager.setupListeners(
      player: widget.player,
      onPlayingChanged: (playing) {
        if (mounted) {
          setState(() => _isPlaying = playing);
        }
      },
      onPositionChanged: (position) {
        if (mounted && !_userIsDraggingSlider) {
          setState(() => _currentPosition = position);
          _handleSkipLogic(position);
        }
      },
      onDurationChanged: (duration) {
        if (mounted && duration > Duration.zero) {
          setState(() => _totalDuration = duration);
          _resetSkipFlags();
        }
      },
      onBufferingChanged: (buffering) {
        if (mounted) {
          setState(() => _isBuffering = buffering);
        }
      },
    );
  }

  void _resetSkipFlags() {
    _hasSkippedOpening = false;
    _hasTriggeredEnding = false;
  }

  void _handleSkipLogic(Duration position) {
    if (_skipOpening > 0 && !_hasSkippedOpening) {
      final openingSeconds = _skipOpening;
      if (position.inSeconds < openingSeconds.toInt()) {
        widget.player.seek(Duration(seconds: openingSeconds.toInt()));
        _hasSkippedOpening = true;
      }
    }

    if (_skipEnding > 0 && _totalDuration.inSeconds > 0 && !_hasTriggeredEnding) {
      final endingSeconds = _skipEnding;
      final remainingSeconds = _totalDuration.inSeconds - position.inSeconds;
      
      if (remainingSeconds <= endingSeconds.toInt()) {
        _hasTriggeredEnding = true;
        widget.onNextVideo?.call();
      }
    }
  }

  @override
  void dispose() {
    _resetBrightness();
    _hideManager.dispose();
    _playerStateManager.dispose();
    _pipManager.dispose();
    _exitFullScreenMode();
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

  Future<void> _setBrightness(double value) async {
    try {
      await _screenBrightness.setScreenBrightness(value);
    } catch (e) {
      debugPrint('设置亮度失败: $e');
    }
  }

  void _enterFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _exitFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _startHideTimer() {
    _hideManager.startTimer(
      onHide: () {
        if (mounted) {
          setState(() => _showControls = false);
        }
      },
    );
  }

  void _onTapVideo() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _startHideTimer();
    } else {
      _hideManager.cancelTimer();
    }
  }

  void _onSliderChangeStart(double value) {
    _wasPlaying = widget.player.state.playing;
    _userIsDraggingSlider = true;
    _pendingSeekPosition = Duration(milliseconds: value.toInt());
    _hideManager.cancelTimer();
  }

  void _onSliderChangeEnd(double value) {
    _userIsDraggingSlider = false;
    _pendingSeekPosition = Duration(milliseconds: value.toInt());
    widget.player.seek(_pendingSeekPosition);
    setState(() => _currentPosition = _pendingSeekPosition);
    if (_wasPlaying) {
      widget.player.play();
    }
    _startHideTimer();
  }

  void _onSliderChanged(double value) {
    _pendingSeekPosition = Duration(milliseconds: value.toInt());
    if (mounted) {
      setState(() => _currentPosition = _pendingSeekPosition);
    }
  }

  void _skipForward() {
    final currentPos = widget.player.state.position;
    widget.player.seek(currentPos + const Duration(seconds: 10));
  }

  void _skipBackward() {
    final currentPos = widget.player.state.position;
    final newPos = currentPos - const Duration(seconds: 10);
    widget.player.seek(newPos < Duration.zero ? Duration.zero : newPos);
  }

  void _playNext() {
    widget.onNextVideo?.call();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      widget.player.pause();
    } else {
      widget.player.play();
    }
  }

  Future<void> _togglePipMode() async {
    await _pipManager.togglePipMode(
      onPipSuccess: () {
        if (!_isPlaying) {
          widget.player.play();
        }
      },
      onPipFailed: (message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.playerStateNotifier,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: _onTapVideo,
            onDoubleTap: _togglePlayPause,
            onLongPressStart: (_) {
              _previousRate = widget.player.state.rate;
              widget.player.setRate(_longPressRate);
              setState(() => _isLongPressing = true);
            },
            onLongPressEnd: (_) {
              widget.player.setRate(_previousRate);
              setState(() => _isLongPressing = false);
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: DanmakuViewComponents(
                danmakuList: _danmakuList,
                paused: !_isPlaying,
                currentPosition: _currentPosition,
                child: Stack(
                  children: [
                    Center(
                      child: Video(
                        controller: widget.videoController,
                        fill: Colors.black,
                        fit: _pipManager.isInPipMode ? BoxFit.fill : VideoPlayerUtils.getFullScreenBoxFit(_videoFit),
                        controls: null,
                        subtitleViewConfiguration: const SubtitleViewConfiguration(
                          visible: false,
                        ),
                      ),
                    ),
                    if (_showControls && !_isBuffering) ...[
                      _buildTopBar(),
                      _buildMiddleControls(),
                      _buildBottomBar(),
                    ],
                    if (_isBuffering)
                      const Center(child: PageLoading()),
                    if (_showSettings) _buildSettingsPanel(),
                    if (_isLongPressing)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${_longPressRate}x',
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.videoTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
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
              onPressed: () {
                setState(() {
                  _showSettings = true;
                  _showControls = false;
                });
                _hideManager.cancelTimer();
              },
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
    final maxValue = _totalDuration.inMilliseconds > 0
        ? _totalDuration.inMilliseconds.toDouble()
        : 1.0;
    final currentValue = _userIsDraggingSlider
        ? _pendingSeekPosition.inMilliseconds.toDouble().clamp(0.0, maxValue)
        : _currentPosition.inMilliseconds.toDouble().clamp(0.0, maxValue);

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
                size: 28,
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
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFE53935),
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                  thumbColor: const Color(0xFFE53935),
                  overlayColor: Colors.transparent,
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                ),
                child: Slider(
                  value: currentValue,
                  max: maxValue,
                  onChangeStart: _onSliderChangeStart,
                  onChangeEnd: _onSliderChangeEnd,
                  onChanged: _onSliderChanged,
                ),
              ),
            ),
            Text(
              VideoPlayerUtils.formatDuration(_totalDuration),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(width: 8),
            const SizedBox(width: 8),
            SizedBox(
              width: 40,
              child: GestureDetector(
              onTap: widget.onRateChanged,
              child: Text(
                '${_videoRate}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            ),
              const SizedBox(width: 8),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(
                CupertinoIcons.fullscreen_exit,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Positioned.fill(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _showSettings = false);
                _startHideTimer();
              },
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          Container(
            width: 360,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0x991A1A1A),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '播放设置',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
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
                          '恢复默认设置',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() => _showSettings = false);
                        _startHideTimer();
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSliderRow(
                          '音量调节',
                          _volume,
                          (v) {
                            widget.playerStateNotifier.setVolume(v);
                            widget.player.setVolume(v * 100);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSliderRow(
                          '屏幕亮度',
                          _brightness,
                          (v) {
                            widget.playerStateNotifier.setBrightness(v);
                            _setBrightness(v);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSliderRow(
                          '跳过片头',
                          _skipOpening,
                          (v) => widget.playerStateNotifier.setSkipOpening(v),
                          max: 300,
                          isTime: true,
                        ),
                        const SizedBox(height: 16),
                        _buildSliderRow(
                          '跳过片尾',
                          _skipEnding,
                          (v) => widget.playerStateNotifier.setSkipEnding(v),
                          max: 300,
                          isTime: true,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '倍速播放',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final rate in widget.rateList)
                              GestureDetector(
                                onTap: () {
                                  widget.playerStateNotifier.setVideoRate(rate);
                                  widget.player.setRate(rate);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _videoRate == rate
                                            ? const Color(0xFFE53935)
                                            : Colors.white12,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '${rate}x',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '画面尺寸',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (int i = 0; i < widget.fitModes.length; i++)
                              GestureDetector(
                                onTap: () {
                                  widget.playerStateNotifier.setVideoFit(i);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _videoFit == i
                                            ? const Color(0xFFE53935)
                                            : Colors.white12,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    widget.fitModes[i],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(
    String label,
    double value,
    Function(double) onChanged, {
    double max = 1.0,
    bool isTime = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFE53935),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.transparent,
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: value,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            isTime
                ? VideoPlayerUtils.formatDuration(Duration(seconds: value.toInt()))
                : '${(value * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _resetToDefaults() {
    widget.playerStateNotifier.resetToDefaults();
    widget.player.setVolume(100);
    widget.player.setRate(1.0);
  }
}
