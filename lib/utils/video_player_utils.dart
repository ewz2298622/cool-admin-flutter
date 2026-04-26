import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:pip/pip.dart';

/// 视频播放器工具类
/// 提供视频播放器相关的通用功能
class VideoPlayerUtils {
  /// 格式化时长显示
  /// 例如: 01:30 或 01:30:45
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  /// 获取视频适配模式
  /// fitIndex: 0-默认, 1-原始, 2-拉伸, 3-填充, 4-4:3
  static BoxFit getBoxFit(int fitIndex) {
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

  /// 全屏模式下的视频适配模式
  /// fitMode: 0-默认, 1-原始, 2-拉伸, 3-填充, 4-4:3
  static BoxFit getFullScreenBoxFit(int fitMode) {
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

  /// 格式化字符串，支持逗号和斜杠分隔
  /// 例如: "张三,李四" 或 "张三/李四" -> ["张三", "李四"]
  static List<String> formatString(String str) {
    if (str.contains(',')) {
      return str.split(',');
    }
    if (str.contains('/')) {
      return str.split('/');
    }
    return [str];
  }
}

/// 画中画管理器
/// 封装画中画的初始化、状态管理和生命周期处理
class PipManager {
  final Pip _pip = Pip();
  bool _isPipSupported = false;
  bool _isInPipMode = false;

  bool get isPipSupported => _isPipSupported;
  bool get isInPipMode => _isInPipMode;

  /// 初始化画中画功能
  Future<void> initialize({
    int aspectRatioX = 16,
    int aspectRatioY = 9,
    int controlStyle = 2,
  }) async {
    _isPipSupported = await _pip.isSupported();
    if (_isPipSupported) {
      await _pip.setup(
        PipOptions(
          autoEnterEnabled: true,
          aspectRatioX: aspectRatioX,
          aspectRatioY: aspectRatioY,
          controlStyle: controlStyle,
        ),
      );
    }
  }

  /// 注册画中画状态变化观察者
  Future<void> registerStateObserver({
    required VoidCallback onPipStarted,
    required VoidCallback onPipStopped,
    ValueChanged<bool>? onPipModeChanged,
    VoidCallback? onAutoPlay,
  }) async {
    if (!_isPipSupported) return;

    await _pip.registerStateChangedObserver(
      PipStateChangedObserver(
        onPipStateChanged: (state, error) {
          final wasInPipMode = _isInPipMode;
          _isInPipMode = state == PipState.pipStateStarted;

          if (_isInPipMode) {
            onPipStarted.call();
            onAutoPlay?.call();
          } else {
            onPipStopped.call();
          }

          if (_isInPipMode != wasInPipMode) {
            onPipModeChanged?.call(_isInPipMode);
          }
        },
      ),
    );
  }

  /// 切换画中画模式
  Future<bool> togglePipMode({
    VoidCallback? onPipEntering,
    VoidCallback? onPipSuccess,
    ValueChanged<String>? onPipFailed,
  }) async {
    if (!_isPipSupported) {
      onPipFailed?.call('当前设备不支持画中画功能');
      return false;
    }

    if (_isInPipMode) {
      await _pip.stop();
      return true;
    } else {
      onPipEntering?.call();
      final result = await _pip.start();
      if (result) {
        onPipSuccess?.call();
      } else {
        onPipFailed?.call('进入画中画模式失败');
      }
      return result;
    }
  }

  /// 释放资源
  void dispose() {
    _pip.dispose();
  }
}

/// 播放器状态管理器
/// 封装播放器的流订阅和状态同步
class PlayerStateManager {
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<double>? _rateSubscription;
  StreamSubscription<double>? _volumeSubscription;

  /// 设置播放器状态监听
  void setupListeners({
    required Player player,
    ValueChanged<bool>? onPlayingChanged,
    ValueChanged<Duration>? onDurationChanged,
    ValueChanged<Duration>? onPositionChanged,
    ValueChanged<double>? onRateChanged,
    ValueChanged<double>? onVolumeChanged,
    bool Function()? shouldUpdatePosition,
  }) {
    _playingSubscription = player.stream.playing.listen((playing) {
      onPlayingChanged?.call(playing);
    });

    _durationSubscription = player.stream.duration.listen((duration) {
      if (duration > Duration.zero) {
        onDurationChanged?.call(duration);
      }
    });

    _positionSubscription = player.stream.position.listen((position) {
      if (shouldUpdatePosition?.call() ?? true) {
        onPositionChanged?.call(position);
      }
    });

    _rateSubscription = player.stream.rate.listen((rate) {
      onRateChanged?.call(rate);
    });

    _volumeSubscription = player.stream.volume.listen((volume) {
      onVolumeChanged?.call(volume / 100.0);
    });
  }

  /// 取消所有监听
  void dispose() {
    _playingSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _rateSubscription?.cancel();
    _volumeSubscription?.cancel();
  }
}

/// 控件自动隐藏管理器
/// 管理视频控件的显示/隐藏定时器
class ControlsHideManager {
  Timer? _hideTimer;

  /// 开始隐藏定时器
  void startTimer({
    Duration delay = const Duration(seconds: 4),
    required VoidCallback onHide,
  }) {
    _hideTimer?.cancel();
    _hideTimer = Timer(delay, onHide);
  }

  /// 取消隐藏定时器
  void cancelTimer() {
    _hideTimer?.cancel();
  }

  /// 释放资源
  void dispose() {
    _hideTimer?.cancel();
  }
}
