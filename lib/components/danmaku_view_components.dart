import 'dart:async';

import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/material.dart';

import '../data/danmaku_mock_data.dart' as mock_data;

class DanmakuViewComponents extends StatefulWidget {
  final Widget? child;
  final Widget? overlayWidget;
  final List<mock_data.DanmakuItem> danmakuList;
  final bool showDanmaku;
  final DanmakuOption? danmakuOption;
  final double? width;
  final double? height;
  final bool paused;
  final Duration currentPosition;

  const DanmakuViewComponents({
    super.key,
    this.child,
    this.overlayWidget,
    required this.danmakuList,
    this.showDanmaku = true,
    this.danmakuOption,
    this.width,
    this.height,
    this.paused = false,
    this.currentPosition = Duration.zero,
  });

  @override
  State<DanmakuViewComponents> createState() => _DanmakuViewState();
}

class _DanmakuViewState extends State<DanmakuViewComponents> {
  DanmakuController<int>? _controller;
  final _danmuKey = GlobalKey();

  int _currentSecond = 0;
  int _lastDanmakuIndex = 0;
  Timer? _playTimer;

  List<mock_data.DanmakuItem> get _danmakuList => widget.danmakuList;

  @override
  void initState() {
    super.initState();
    if (widget.showDanmaku) {
      _startPlay();
    }
  }

  @override
  void didUpdateWidget(DanmakuViewComponents oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showDanmaku != oldWidget.showDanmaku) {
      if (widget.showDanmaku) {
        _controller?.resume();
        _currentSecond = widget.currentPosition.inSeconds;
        _lastDanmakuIndex = 0;
        _controller?.clear();
        while (_lastDanmakuIndex < _danmakuList.length) {
          final nextDanmaku = _danmakuList[_lastDanmakuIndex];
          if (nextDanmaku.time <= widget.currentPosition.inMilliseconds) {
            _lastDanmakuIndex++;
          } else {
            break;
          }
        }
        _startPlayFromCurrent();
      } else {
        _controller?.pause();
        _controller?.clear();
        _stopTimer();
      }
    }
    if (widget.paused != oldWidget.paused) {
      if (widget.paused) {
        _controller?.pause();
        _stopTimer();
      } else {
        _controller?.resume();
        _startPlay();
      }
    }
    if (widget.currentPosition != oldWidget.currentPosition) {
      final newMs = widget.currentPosition.inMilliseconds;
      final oldMs = oldWidget.currentPosition.inMilliseconds;
      if ((newMs - oldMs).abs() > 2000) {
        _seekTo(newMs);
      }
    }
  }

  void _seekTo(int milliseconds) {
    _currentSecond = milliseconds ~/ 1000;
    _lastDanmakuIndex = 0;
    _controller?.clear();
    while (_lastDanmakuIndex < _danmakuList.length) {
      final nextDanmaku = _danmakuList[_lastDanmakuIndex];
      if (nextDanmaku.time <= milliseconds) {
        _lastDanmakuIndex++;
      } else {
        break;
      }
    }
  }

  void _startPlay() {
    _stopTimer();
    _currentSecond = 0;
    _lastDanmakuIndex = 0;
    _playTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && widget.showDanmaku) {
        setState(() {
          _currentSecond++;
        });
        _checkAndShowDanmaku();
      }
    });
  }

  void _startPlayFromCurrent() {
    _stopTimer();
    _playTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && widget.showDanmaku) {
        setState(() {
          _currentSecond++;
        });
        _checkAndShowDanmaku();
      }
    });
  }

  void _stopTimer() {
    _playTimer?.cancel();
    _playTimer = null;
  }

  void _checkAndShowDanmaku() {
    if (_controller == null) return;

    final currentMilliseconds = _currentSecond * 1000;

    while (_lastDanmakuIndex < _danmakuList.length) {
      final nextDanmaku = _danmakuList[_lastDanmakuIndex];
      if (currentMilliseconds >= nextDanmaku.time) {
        _controller?.addDanmaku(
          DanmakuContentItem(
            nextDanmaku.text,
            color: nextDanmaku.color,
            type: nextDanmaku.type,
          ),
        );
        _lastDanmakuIndex++;
      } else {
        break;
      }
    }
  }

  void reset() {
    _stopTimer();
    _currentSecond = 0;
    _lastDanmakuIndex = 0;
    _controller?.clear();
    if (widget.showDanmaku) {
      _startPlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.child != null) widget.child!,
          DanmakuScreen<int>(
            key: _danmuKey,
            createdController: (e) {
              _controller = e;
              if (widget.showDanmaku) {
                _startPlay();
              }
            },
            option: widget.danmakuOption ?? const DanmakuOption(
              fontSize: 16,
              fontWeight: 4,
              duration: 8.0,
              staticDuration: 3.0,
              strokeWidth: 1.5,
              lineHeight: 1.6,
              opacity: 1.0,
              safeArea: false,
            ),
          ),
          if (widget.overlayWidget != null) widget.overlayWidget!,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
