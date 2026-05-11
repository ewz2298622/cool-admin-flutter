import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../api/api.dart';
import '../../../components/danmaku_input_panel.dart';
import '../../../components/danmaku_view_components.dart';
import '../../../components/loading.dart';
import '../../../entity/video_barrage_entity.dart';
import '../../../entity/video_detail_data_entity.dart';
import '../../../store/player/player_state_notifier.dart';
import '../../../utils/video_player_utils.dart';

class UnifiedVideoPlayer extends StatefulWidget {
  final Player player;
  final VideoController videoController;
  final PlayerStateNotifier? playerStateNotifier;
  final String videoUrl;
  final String? videoId;
  final int currentEpisodeIndex;
  final int videoFit;
  final double videoRate;
  final double longPressRate;
  final List<double> rateList;
  final bool isFullScreen;
  final String videoTitle;
  final List<String> fitModes;
  final List<VideoDetailDataDataLines>? tabData;
  final ValueNotifier<int> currentLine;
  final ValueNotifier<int> currentPlay;
  final Function(int tabIndex, Set<int> selectedIndices)? onSelectionChanged;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onFullScreenPressed;
  final VoidCallback? onCastingPressed;
  final VoidCallback? onPipPressed;
  final VoidCallback? onRateChanged;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;
  final VoidCallback? onResetToDefaults;
  final ValueChanged<bool>? onPipModeChanged;
  final VoidCallback? onPipEntering;
  final VoidCallback? onRateValueChanged;
  final VoidCallback? onVideoFitChanged;
  final bool showControls;
  final VoidCallback? onPlayPause;
  final VoidCallback? onSkipForward;
  final VoidCallback? onSkipBackward;
  final Function()? onUpdate;
  final double skipOpening;
  final double skipEnding;
  final double brightness;

  const UnifiedVideoPlayer({
    super.key,
    required this.player,
    required this.videoController,
    this.playerStateNotifier,
    this.videoUrl = '',
    this.videoId,
    this.currentEpisodeIndex = 0,
    this.videoFit = 0,
    this.videoRate = 1.0,
    this.longPressRate = 2.0,
    this.rateList = const [0.75, 1.0, 1.25, 1.5, 2.0],
    this.isFullScreen = false,
    this.videoTitle = '',
    this.fitModes = const ['contain', 'cover', 'fill', 'fitWidth', 'fitHeight'],
    this.tabData,
    required this.currentLine,
    required this.currentPlay,
    this.onSelectionChanged,
    this.onSettingsPressed,
    this.onFullScreenPressed,
    this.onCastingPressed,
    this.onPipPressed,
    this.onRateChanged,
    this.onNextVideo,
    this.onPreviousVideo,
    this.onResetToDefaults,
    this.onPipModeChanged,
    this.onPipEntering,
    this.onRateValueChanged,
    this.onVideoFitChanged,
    this.showControls = true,
    this.onPlayPause,
    this.onSkipForward,
    this.onSkipBackward,
    this.onUpdate,
    this.skipOpening = 0.0,
    this.skipEnding = 0.0,
    this.brightness = 1.0,
  });

  @override
  State<UnifiedVideoPlayer> createState() => _UnifiedVideoPlayerState();
}

class _UnifiedVideoPlayerState extends State<UnifiedVideoPlayer>
    with SingleTickerProviderStateMixin {
  bool _showControls = true;
  final ControlsHideManager _hideManager = ControlsHideManager();
  bool _wasPlaying = false;
  bool _userIsDraggingSlider = false;
  Duration _pendingSeekPosition = Duration.zero;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  bool _showSettings = false;
  bool _showEpisodeSelection = false;
  bool _isLongPressing = false;
  bool _isBuffering = false;
  double _previousRate = 1.0;
  final PlayerStateManager _playerStateManager = PlayerStateManager();
  final PipManager _pipManager = PipManager();
  final ScreenBrightness _screenBrightness = ScreenBrightness();
  bool _hasSkippedOpening = false;
  bool _hasTriggeredEnding = false;
  double _originalBrightness = 0.0;
  bool _showDanmaku = true;
  bool _showDanmakuInput = false;
  bool _isMuted = false;
  double _previousVolume = 1.0;
  bool _isLocked = false;
  Duration? _lastDanmakuRequestPosition;
  List<VideoBarrageDataList> danmakuList = [];
  String? _danmakuPlusOneText;
  int _episodeTabIndex = 0;
  TabController? _tabController;

  int get _videoFit => widget.playerStateNotifier?.videoFit ?? widget.videoFit;
  double get _volume => widget.playerStateNotifier?.volume ?? 1.0;
  double get _brightness =>
      widget.playerStateNotifier?.brightness ?? widget.brightness;
  double get _skipOpening =>
      widget.playerStateNotifier?.skipOpening ?? widget.skipOpening;
  double get _skipEnding =>
      widget.playerStateNotifier?.skipEnding ?? widget.skipEnding;
  double get _videoRate =>
      widget.playerStateNotifier?.videoRate ?? widget.videoRate;
  double get _longPressRate =>
      widget.playerStateNotifier?.longPressRate ?? widget.longPressRate;

  @override
  void initState() {
    super.initState();
    _showControls = widget.showControls;
    _totalDuration = widget.player.state.duration;
    _currentPosition = widget.player.state.position;
    _isPlaying = widget.player.state.playing;
    _episodeTabIndex = widget.currentLine.value.clamp(0, (widget.tabData?.length ?? 1) - 1);

    widget.currentLine.addListener(_onCurrentLineChanged);
    widget.currentPlay.addListener(_onCurrentPlayChanged);

    if (widget.isFullScreen) {
      _enterFullScreenMode();
    }

    _startHideTimer();
    _initializeState();
    _setupListeners();
    _initPip();
    _initBrightness();
    _notifyUpdate();
  }

  void _onCurrentLineChanged() {
    if (mounted) {
      _episodeTabIndex = widget.currentLine.value.clamp(0, (widget.tabData?.length ?? 1) - 1);
      _updateTabController();
      setState(() {});
    }
  }

  void _onCurrentPlayChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _updateTabController() {
    if (_tabController != null &&
        widget.tabData != null &&
        _tabController!.length == widget.tabData!.length) {
      if (_tabController!.index != _episodeTabIndex) {
        _tabController!.animateTo(_episodeTabIndex);
      }
    }
  }

  void _notifyUpdate() {
    if (widget.onUpdate != null) {
      widget.onUpdate!();
    }
  }

  Future<void> _initBrightness() async {
    try {
      _originalBrightness = await _screenBrightness.current;
      if (_brightness > 0 && _brightness <= 1.0) {
        await _screenBrightness.setApplicationScreenBrightness(_brightness);
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
      onPipModeChanged: (isInPipMode) {
        widget.onPipModeChanged?.call(isInPipMode);
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
          _requestDanmaku(position.toString());
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

  //0:01:53.303000 转毫秒 函数
  double _convertTimeToMilliseconds(String timeStr) {
    final parts = timeStr.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = double.parse(parts[2]);
    return (hours * 3600 + minutes * 60 + seconds) * 1000;
  }

  //请求函数
  Future<void> _requestDanmaku(
    String position, {
    bool forceExecute = false,
  }) async {
    final currentPosition = _convertTimeToMilliseconds(position);
    if (!forceExecute &&
        _lastDanmakuRequestPosition != null &&
        (currentPosition - _lastDanmakuRequestPosition!.inMilliseconds).abs() <
            180000) {
      return;
    }
    _lastDanmakuRequestPosition = Duration(
      milliseconds: currentPosition.toInt(),
    );
    final milliseconds = currentPosition;
    debugPrint('requestDanmaku 执行: position=$position 转化成毫秒数=$milliseconds');
    debugPrint(
      'requestDanmaku videoId: ${widget.videoId}  索引: ${widget.currentEpisodeIndex}',
    );
    danmakuList =
        (await Api.videoBarrage({
          'videoId': widget.videoId,
          'startTime': milliseconds,
          'endTime': milliseconds + 1000 * 60,
        })).data?.list ??
        [];
    setState(() {});
    debugPrint('requestDanmaku 执行: danmakuList=${danmakuList.length}');
  }

  Future<void> _sendDanmaku(String text, int position, Color color) async {
    if (text.isEmpty) return;

    try {
      final hexColor =
          '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
      final newDanmaku = VideoBarrageDataList()
        ..text = text
        ..color = hexColor
        ..type = position
        ..time = _currentPosition.inMilliseconds;
      setState(() {
        danmakuList.insert(0, newDanmaku);
      });
    } catch (e) {
      debugPrint('发送弹幕失败: $e');
      Fluttertoast.showToast(msg: '网络错误，发送失败');
    }
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

    if (_skipEnding > 0 &&
        _totalDuration.inSeconds > 0 &&
        !_hasTriggeredEnding) {
      final endingSeconds = _skipEnding;
      final remainingSeconds = _totalDuration.inSeconds - position.inSeconds;

      if (remainingSeconds <= endingSeconds.toInt()) {
        _hasTriggeredEnding = true;
        widget.onNextVideo?.call();
      }
    }
  }

  @override
  void didUpdateWidget(UnifiedVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentEpisodeIndex != oldWidget.currentEpisodeIndex) {
      _lastDanmakuRequestPosition = null;
      _requestDanmaku('00:00:00');
    }
    if (oldWidget.currentLine.value != widget.currentLine.value ||
        oldWidget.currentPlay.value != widget.currentPlay.value) {
      _episodeTabIndex = widget.currentLine.value.clamp(0, (widget.tabData?.length ?? 1) - 1);
      _updateTabController();
    }
    if (widget.showControls != oldWidget.showControls) {
      _showControls = widget.showControls;
    }
    if (widget.videoRate != oldWidget.videoRate) {
      widget.player.setRate(widget.videoRate);
    }
    if (widget.brightness != oldWidget.brightness) {
      _setBrightness(widget.brightness);
    }
  }

  @override
  void dispose() {
    widget.currentLine.removeListener(_onCurrentLineChanged);
    widget.currentPlay.removeListener(_onCurrentPlayChanged);
    _resetBrightness();
    _hideManager.dispose();
    _playerStateManager.dispose();
    _pipManager.dispose();
    _tabController?.dispose();
    if (widget.isFullScreen) {
      _exitFullScreenMode();
    }
    super.dispose();
  }

  Future<void> _resetBrightness() async {
    try {
      if (_originalBrightness > 0) {
        await _screenBrightness.resetApplicationScreenBrightness();
      }
    } catch (e) {
      debugPrint('重置亮度失败: $e');
    }
  }

  Future<void> _setBrightness(double value) async {
    try {
      await _screenBrightness.setApplicationScreenBrightness(value);
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
    if (_isLocked) return;
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
    _requestDanmaku(
      VideoPlayerUtils.formatDuration(_pendingSeekPosition),
      forceExecute: true,
    );
  }

  void _onSliderChanged(double value) {
    _pendingSeekPosition = Duration(milliseconds: value.toInt());
    if (mounted) {
      setState(() => _currentPosition = _pendingSeekPosition);
    }
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
      if (_isPlaying) {
        widget.player.pause();
      } else {
        widget.player.play();
      }
    }
  }

  void _toggleMute() {
    setState(() {
      if (!_isMuted) {
        _previousVolume = _volume > 0 ? _volume : 1.0;
        widget.player.setVolume(0);
        _isMuted = true;
      } else {
        widget.player.setVolume(_previousVolume);
        _isMuted = false;
      }
    });
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
      if (_isLocked) {
        _showControls = false;
        _hideManager.cancelTimer();
      } else {
        _showControls = true;
        _startHideTimer();
      }
    });
  }

  Future<void> _togglePipMode() async {
    await _pipManager.togglePipMode(
      onPipEntering: () => widget.onPipEntering?.call(),
      onPipSuccess: () {
        if (!_isPlaying) {
          widget.player.play();
        }
      },
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

  void _resetToDefaults() {
    widget.onResetToDefaults?.call();
  }

  @override
  Widget build(BuildContext context) {
    final playerNotifier = widget.playerStateNotifier;

    Widget content =
        widget.isFullScreen ? _buildFullScreenContent() : _buildNormalContent();

    if (playerNotifier != null) {
      content = ListenableBuilder(
        listenable: playerNotifier,
        builder: (context, child) {
          return widget.isFullScreen
              ? _buildFullScreenContent()
              : _buildNormalContent();
        },
      );
    }

    if (widget.isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: content,
      );
    }

    return content;
  }

  Widget _buildFullScreenContent() {
    return GestureDetector(
      onTap: _onTapVideo,
      onDoubleTap: _isLocked ? null : _togglePlayPause,
      onLongPressStart:
          _isLocked
              ? null
              : (_) {
                _previousRate = widget.player.state.rate;
                widget.player.setRate(_longPressRate);
                Fluttertoast.showToast(
                  msg: "${_longPressRate}x 倍速播放",
                  toastLength: Toast.LENGTH_SHORT,
                );
              },
      onLongPressEnd:
          _isLocked
              ? null
              : (_) {
                widget.player.setRate(_previousRate);
              },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: DanmakuViewComponents(
          danmakuList: danmakuList,
          showDanmaku: _showDanmaku,
          paused: !_isPlaying,
          currentPosition: _currentPosition,
          child: Stack(
            children: [
              Center(
                child: Video(
                  controller: widget.videoController,
                  fill: Colors.black,
                  fit:
                      _pipManager.isInPipMode
                          ? BoxFit.fill
                          : VideoPlayerUtils.getFullScreenBoxFit(_videoFit),
                  controls: null,
                  subtitleViewConfiguration: const SubtitleViewConfiguration(
                    visible: false,
                  ),
                ),
              ),
              if (_isLocked) ...[_buildMiddleControls()],
              if (!_isLocked && _showControls && !_isBuffering) ...[
                _buildTopBar(),
                _buildMiddleControls(),
                _buildBottomBar(),
              ],
              if (_isBuffering) const Center(child: PageLoading()),
              if (_showSettings && !_isLocked) _buildSettingsPanel(),
              if (_showEpisodeSelection && !_isLocked) ...[
                _buildEpisodeSelectionPanel(),
                _buildEpisodeSelectionContent(),
              ],
              if (_showDanmakuInput && !_isLocked)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  child: DanmakuInputPanel(
                    isFullScreen: widget.isFullScreen,
                    onSend: _sendDanmaku,
                    onClose: () => setState(() => _showDanmakuInput = false),
                    initialText: _danmakuPlusOneText,
                  ),
                ),
              if (widget.isFullScreen) ...[
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 20,
                  child: Center(
                    child: GestureDetector(
                      onTap: _toggleLock,
                      child: Icon(
                        _isLocked
                            ? CupertinoIcons.lock_fill
                            : CupertinoIcons.lock_open_fill,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalContent() {
    return GestureDetector(
      child: DanmakuViewComponents(
        danmakuList: danmakuList,
        height: 200,
        paused: !_isPlaying,
        currentPosition: _currentPosition,
        showDanmaku: true,
        child: GestureDetector(
          onTap: _onTapVideo,
          onDoubleTap: _togglePlayPause,
          onLongPressStart: (_) {
            _previousRate = widget.player.state.rate;
            widget.player.setRate(widget.longPressRate);
            Fluttertoast.showToast(
              msg: "${widget.longPressRate}x 倍速播放",
              toastLength: Toast.LENGTH_SHORT,
            );
          },
          onLongPressEnd: (_) {
            widget.player.setRate(_previousRate);
          },
          child: Stack(
            children: [
              Video(
                controller: widget.videoController,
                fill: Colors.black,
                fit:
                    _pipManager.isInPipMode
                        ? BoxFit.fill
                        : VideoPlayerUtils.getBoxFit(_videoFit),
                controls: null,
                subtitleViewConfiguration: const SubtitleViewConfiguration(
                  visible: false,
                ),
              ),
              if (_isBuffering)
                const Center(child: PageLoading())
              else if (_showControls) ...[
                _buildNormalTopBar(),
                _buildNormalMiddleControls(),
                _buildNormalBottomBar(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: widget.isFullScreen ? 0 : -12,
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
            if (widget.isFullScreen)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
                child: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            if (!widget.isFullScreen)
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
            if (widget.isFullScreen) ...[
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
            ] else ...[
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
            onTap: _isLocked ? null : _skipBackward,
            child: Icon(
              CupertinoIcons.gobackward_10,
              color:
                  _isLocked
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 60),
          GestureDetector(
            onTap: _isLocked ? null : _skipForward,
            child: Icon(
              CupertinoIcons.goforward_10,
              color:
                  _isLocked
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.white,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalTopBar() {
    return Positioned(
      top: -12,
      left: 0,
      right: 0,
      child: Container(
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

  Widget _buildNormalMiddleControls() {
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

  Widget _buildNormalBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _togglePlayPause,
              child: Icon(
                _isPlaying
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_fill,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _playNext,
              child: const Icon(
                CupertinoIcons.forward_end_fill,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              VideoPlayerUtils.formatDuration(_currentPosition),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(width: 8),
            Expanded(child: _buildProgressIndicator()),
            const SizedBox(width: 8),
            Text(
              VideoPlayerUtils.formatDuration(_totalDuration),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => widget.onRateValueChanged?.call(),
              child: Text(
                '${widget.videoRate}x',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onFullScreenPressed,
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

  Widget _buildBottomBar() {
    final maxValue =
        _totalDuration.inMilliseconds > 0
            ? _totalDuration.inMilliseconds.toDouble()
            : 1.0;
    final currentValue =
        _userIsDraggingSlider
            ? _pendingSeekPosition.inMilliseconds.toDouble().clamp(
              0.0,
              maxValue,
            )
            : _currentPosition.inMilliseconds.toDouble().clamp(0.0, maxValue);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isFullScreen)
              _buildProgressSlider(currentValue, maxValue),
            if (!widget.isFullScreen) _buildSimpleBottomBar(),
            if (widget.isFullScreen) _buildFullScreenBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSlider(double currentValue, double maxValue) {
    return Row(
      children: [
        Text(
          VideoPlayerUtils.formatDuration(_currentPosition),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFE53935),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              thumbColor: const Color(0xFFE53935),
              overlayColor: Colors.transparent,
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
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
        const SizedBox(width: 8),
        Text(
          VideoPlayerUtils.formatDuration(_totalDuration),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSimpleBottomBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: Icon(
            _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _playNext,
          child: const Icon(
            CupertinoIcons.forward_end_fill,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildProgressIndicator()),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => widget.onRateValueChanged?.call(),
          child: Text(
            '${widget.videoRate}x',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: widget.onFullScreenPressed,
          child: const Icon(
            CupertinoIcons.arrow_up_left_arrow_down_right,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    final displayPosition =
        _userIsDraggingSlider ? _pendingSeekPosition : _currentPosition;
    final progress =
        _totalDuration.inMilliseconds > 0
            ? displayPosition.inMilliseconds / _totalDuration.inMilliseconds
            : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) {
            _hideManager.cancelTimer();
            _userIsDraggingSlider = true;
          },
          onHorizontalDragUpdate: (details) {
            final width = constraints.maxWidth;
            if (width > 0 && _totalDuration.inMilliseconds > 0) {
              final double localDx = details.localPosition.dx.clamp(0.0, width);
              final double progressFactor = localDx / width;
              final Duration seekPosition = Duration(
                milliseconds:
                    (_totalDuration.inMilliseconds * progressFactor).round(),
              );
              _pendingSeekPosition = seekPosition;
              setState(() => _currentPosition = seekPosition);
            }
          },
          onHorizontalDragEnd: (_) {
            _userIsDraggingSlider = false;
            if (_totalDuration.inMilliseconds > 0) {
              widget.player.seek(_pendingSeekPosition);
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullScreenBottomControls() {
    return Row(
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: Icon(
            _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _playNext,
          child: const Icon(
            CupertinoIcons.forward_end_fill,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _toggleMute,
          child: Icon(
            _isMuted
                ? CupertinoIcons.speaker_slash_fill
                : CupertinoIcons.speaker_fill,
            color: _isMuted ? Colors.red : Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() => _showDanmaku = !_showDanmaku);
          },
          child: Container(
            width: 42,
            height: 22,
            decoration: BoxDecoration(
              color:
                  _showDanmaku
                      ? const Color(0xFFE53935)
                      : const Color(0xFFB0B0B0),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment:
                      _showDanmaku
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '弹',
                        style: TextStyle(
                          color:
                              _showDanmaku
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFFB0B0B0),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _showDanmakuInput = true);
            },
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '点我发弹幕',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            setState(() => _showEpisodeSelection = !_showEpisodeSelection);
          },
          child: const Text(
            '选集',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: widget.onRateChanged,
          child: Text(
            '${_videoRate}x',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
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
            decoration: const BoxDecoration(color: Color(0x991A1A1A)),
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
                          style: TextStyle(color: Colors.white70, fontSize: 12),
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
                        _buildSliderRow('音量调节', _volume, (v) {
                          widget.playerStateNotifier?.setVolume(v);
                          widget.player.setVolume(v * 100);
                        }),
                        const SizedBox(height: 16),
                        _buildSliderRow('屏幕亮度', _brightness, (v) {
                          widget.playerStateNotifier?.setBrightness(v);
                          _setBrightness(v);
                        }),
                        const SizedBox(height: 16),
                        _buildSliderRow(
                          '跳过片头',
                          _skipOpening,
                          (v) => widget.playerStateNotifier?.setSkipOpening(v),
                          max: 300,
                          isTime: true,
                        ),
                        const SizedBox(height: 16),
                        _buildSliderRow(
                          '跳过片尾',
                          _skipEnding,
                          (v) => widget.playerStateNotifier?.setSkipEnding(v),
                          max: 300,
                          isTime: true,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '倍速播放',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children:
                              widget.rateList.map((rate) {
                                final isSelected = _videoRate == rate;
                                return GestureDetector(
                                  onTap: () {
                                    widget.playerStateNotifier?.setVideoRate(
                                      rate,
                                    );
                                    widget.player.setRate(rate);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? const Color(0xFFE53935)
                                              : Colors.white12,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${rate}x',
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.white70,
                                        fontSize: 14,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '画面填充',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children:
                              widget.fitModes.asMap().entries.map((entry) {
                                final isSelected = _videoFit == entry.key;
                                return GestureDetector(
                                  onTap: () {
                                    widget.playerStateNotifier?.setVideoFit(
                                      entry.key,
                                    );
                                    widget.onVideoFitChanged?.call();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? const Color(0xFFE53935)
                                              : Colors.white12,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.white70,
                                        fontSize: 14,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              isTime ? '${value.toInt()}秒' : '${(value * 100).toInt()}%',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFE53935),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
            thumbColor: const Color(0xFFE53935),
            overlayColor: Colors.red.withValues(alpha: 0.2),
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: value.clamp(0.0, max),
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodeSelectionPanel() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() => _showEpisodeSelection = false);
        },
        child: Container(color: Colors.black.withValues(alpha: 0.5)),
      ),
    );
  }

  Widget _buildEpisodeSelectionContent() {
    _episodeTabIndex = widget.currentLine.value.clamp(0, (widget.tabData?.length ?? 1) - 1);

    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      width: 300,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xCC1A1A1A),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '选集',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showEpisodeSelection = false);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.tabData != null && widget.tabData!.isNotEmpty) ...[
              _buildTabBar(),
              Expanded(
                child: _buildTabBarView(),
              ),
            ] else ...[
              const Expanded(
                child: Center(
                  child: Text(
                    '暂无选集信息',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    if (_tabController == null || _tabController!.length != widget.tabData!.length) {
      _tabController?.dispose();
      _tabController = TabController(
        length: widget.tabData!.length,
        vsync: this,
        initialIndex: _episodeTabIndex,
      );
      _tabController!.addListener(() {
        if (_tabController!.indexIsChanging) {
          setState(() => _episodeTabIndex = _tabController!.index);
        }
      });
    }

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      dividerHeight: 0,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2.0,
          color: Color(0xFFE53935),
        ),
        insets: EdgeInsets.symmetric(horizontal: 16),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: const Color(0xFFE53935),
      unselectedLabelColor: Colors.white70,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      tabs: widget.tabData!
          .map((tab) => Tab(text: tab.collectionName ?? '线路'))
          .toList(),
    );
  }

  Widget _buildTabBarView() {
    return ValueListenableBuilder<int>(
      valueListenable: widget.currentLine,
      builder: (context, currentLineValue, _) {
        return ValueListenableBuilder<int>(
          valueListenable: widget.currentPlay,
          builder: (context, currentPlayValue, _) {
            return TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: widget.tabData!.map((line) {
                final tabIndex = widget.tabData!.indexOf(line);
                final playLines = line.playLines ?? [];

                if (playLines.isEmpty) {
                  return const Center(
                    child: Text(
                      '暂无播放线路',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: playLines.length,
                  itemBuilder: (context, index) {
                    final playLine = playLines[index];
                    final isSelected =
                        currentLineValue == tabIndex &&
                        currentPlayValue == index;

                    return GestureDetector(
                      onTap: () {
                        widget.onSelectionChanged?.call(
                          tabIndex,
                          {index},
                        );
                        setState(() => _showEpisodeSelection = false);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE53935)
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            playLine.name ?? '${index + 1}',
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
