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

  int _lastDanmakuIndex = 0;

  List<mock_data.DanmakuItem> get _danmakuList => widget.danmakuList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(DanmakuViewComponents oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPosition != oldWidget.currentPosition) {
      _checkAndShowDanmaku(widget.currentPosition.inMilliseconds);
    }
    if (widget.showDanmaku != oldWidget.showDanmaku) {
      if (widget.showDanmaku) {
        _controller?.resume();
        _lastDanmakuIndex = 0;
        _controller?.clear();
        _checkAndShowDanmaku(widget.currentPosition.inMilliseconds);
      } else {
        _controller?.pause();
        _controller?.clear();
      }
    }
    if (widget.paused != oldWidget.paused) {
      if (widget.paused) {
        _controller?.pause();
      } else {
        _controller?.resume();
      }
    }
  }

  void _checkAndShowDanmaku(int currentMilliseconds) {
    if (_controller == null) return;

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
    _lastDanmakuIndex = 0;
    _controller?.clear();
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
            createdController: (e) {
              _controller = e;
              if (widget.showDanmaku && widget.danmakuList.isNotEmpty) {
                _checkAndShowDanmaku(widget.currentPosition.inMilliseconds);
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
    super.dispose();
  }
}
