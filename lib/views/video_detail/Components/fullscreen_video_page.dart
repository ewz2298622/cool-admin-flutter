import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class FullScreenVideoPage extends StatefulWidget {
  final Player player;
  final VideoController videoController;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onCastingPressed;
  final VoidCallback? onPipPressed;
  final VoidCallback? onRateChanged;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;
  final String videoTitle;
  final double videoRate;
  final int currentVideoFit;
  final Function(int) onVideoFitChanged;
  final List<double> rateList;
  final List<String> fitModes;

  const FullScreenVideoPage({
    super.key,
    required this.player,
    required this.videoController,
    this.onSettingsPressed,
    this.onCastingPressed,
    this.onPipPressed,
    this.onRateChanged,
    this.onNextVideo,
    this.onPreviousVideo,
    this.videoTitle = '',
    this.videoRate = 1.0,
    this.currentVideoFit = 0,
    required this.onVideoFitChanged,
    required this.rateList,
    required this.fitModes,
  });

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  bool _showControls = true;
  Timer? _hideTimer;
  bool _wasPlaying = false;
  bool _userIsDraggingSlider = false;
  Duration _pendingSeekPosition = Duration.zero;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  double _currentRate = 1.0;
  bool _showSettings = false;
  double _selectedVolume = 1.0;
  double _selectedBrightness = 1.0;
  int _videoFit = 0;
  double _skipOpening = 0.0;
  double _skipEnding = 0.0;
  double _longPressRate = 2.0;

  final List<double> _longPressRates = [1.25, 1.5, 2.0, 2.5, 3.0];

  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<double>? _rateSubscription;
  StreamSubscription<double>? _volumeSubscription;

  @override
  void initState() {
    super.initState();
    _enterFullScreenMode();
    _startHideTimer();
    _initializeState();
    _setupListeners();
  }

  void _initializeState() {
    _isPlaying = widget.player.state.playing;
    _currentPosition = widget.player.state.position;
    _totalDuration = widget.player.state.duration;
    _currentRate = widget.player.state.rate;
    _selectedVolume = widget.player.state.volume / 100.0;
    _videoFit = widget.currentVideoFit;
  }

  void _setupListeners() {
    _playingSubscription = widget.player.stream.playing.listen((playing) {
      if (mounted) {
        setState(() => _isPlaying = playing);
      }
    });
    _positionSubscription = widget.player.stream.position.listen((position) {
      if (mounted && !_userIsDraggingSlider) {
        setState(() => _currentPosition = position);
      }
    });
    _durationSubscription = widget.player.stream.duration.listen((duration) {
      if (mounted && duration > Duration.zero) {
        setState(() => _totalDuration = duration);
      }
    });
    _rateSubscription = widget.player.stream.rate.listen((rate) {
      if (mounted) {
        setState(() => _currentRate = rate);
      }
    });
    _volumeSubscription = widget.player.stream.volume.listen((volume) {
      if (mounted) {
        setState(() => _selectedVolume = volume / 100.0);
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _playingSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _rateSubscription?.cancel();
    _volumeSubscription?.cancel();
    _exitFullScreenMode();
    super.dispose();
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
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _onTapVideo() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _onSliderChangeStart(double value) {
    _wasPlaying = widget.player.state.playing;
    _userIsDraggingSlider = true;
    _pendingSeekPosition = Duration(milliseconds: value.toInt());
    _hideTimer?.cancel();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _onTapVideo,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              Center(
                child: Video(
                  controller: widget.videoController,
                  fill: Colors.black,
                  fit: _getBoxFit(_videoFit),
                  controls: null,
                  subtitleViewConfiguration: const SubtitleViewConfiguration(
                    visible: false,
                  ),
                ),
              ),
              if (_showControls) ...[
                _buildTopBar(),
                _buildMiddleControls(),
                _buildBottomBar(),
              ],
              if (_showSettings) _buildSettingsPanel(),
            ],
          ),
        ),
      ),
    );
  }

  BoxFit _getBoxFit(int fitMode) {
    switch (fitMode) {
      case 0:
        return BoxFit.contain;
      case 1:
        return BoxFit.none;
      case 2:
        return BoxFit.fill;
      case 3:
        return BoxFit.cover;
      case 4:
        return BoxFit.contain;
      default:
        return BoxFit.contain;
    }
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
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onPipPressed,
              child: const Icon(
                CupertinoIcons.rectangle_on_rectangle,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onCastingPressed,
              child: const Icon(
                CupertinoIcons.tv,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() => _showSettings = true);
                _hideTimer?.cancel();
              },
              child: const Icon(
                CupertinoIcons.settings,
                color: Colors.white,
                size: 24,
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
              _formatDuration(_currentPosition),
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
              _formatDuration(_totalDuration),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(width: 8),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onRateChanged,
              child: Text(
                '${_currentRate}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
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
                          _selectedVolume,
                          (v) {
                            setState(() => _selectedVolume = v);
                            widget.player.setVolume(v * 100);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSliderRow(
                          '屏幕亮度',
                          _selectedBrightness,
                          (v) {
                            setState(() => _selectedBrightness = v);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSliderRow(
                          '跳过片头',
                          _skipOpening,
                          (v) => setState(() => _skipOpening = v),
                          max: 120,
                          isTime: true,
                        ),
                        const SizedBox(height: 16),
                        _buildSliderRow(
                          '跳过片尾',
                          _skipEnding,
                          (v) => setState(() => _skipEnding = v),
                          max: 120,
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
                                  setState(() => _currentRate = rate);
                                  widget.player.setRate(rate);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _currentRate == rate
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
                                  setState(() => _videoFit = i);
                                  widget.onVideoFitChanged(i);
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
                ? _formatDuration(Duration(seconds: value.toInt()))
                : '${(value * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _resetToDefaults() {
    setState(() {
      _selectedVolume = 1.0;
      _selectedBrightness = 1.0;
      _videoFit = 0;
      _skipOpening = 0.0;
      _skipEnding = 0.0;
      _currentRate = 1.0;
    });
    widget.player.setVolume(100);
    widget.player.setRate(1.0);
    widget.onVideoFitChanged(0);
  }
}
