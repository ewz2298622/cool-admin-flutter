import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../entity/video_barrage_entity.dart';

class DanmakuViewComponents extends StatefulWidget {
  final Widget? child;
  final Widget? overlayWidget;
  final List<VideoBarrageDataList> danmakuList;
  final bool showDanmaku;
  final DanmakuOption? danmakuOption;
  final double? width;
  final double? height;
  final bool paused;
  final Duration currentPosition;
  final Function(String text)? onDanmakuLongPress;

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
    this.onDanmakuLongPress,
  });

  @override
  State<DanmakuViewComponents> createState() => _DanmakuViewState();
}

class _DanmakuViewState extends State<DanmakuViewComponents> {
  DanmakuController<int>? _controller;
  final Random _random = Random();

  int _lastDanmakuIndex = 0;

  List<VideoBarrageDataList> get _danmakuList => widget.danmakuList;

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
    for (int i = _lastDanmakuIndex; i < _danmakuList.length; i++) {
      final element = _danmakuList[i];
      final danmakuTime = element.time ?? 0;
      if (danmakuTime <= currentMilliseconds) {
        _controller?.addDanmaku(
          DanmakuContentItem(
            element.text ?? '',
            color: getRandomColor(element.color ?? '#FFFFFF'),
            type: DanmakuItemType.values[element.type ?? 0],
          ),
        );
        _lastDanmakuIndex = i + 1;
      } else {
        break;
      }
    }
  }

  // 生成随机颜色
  static Color getRandomColor(String color) {
    final hexColor = color.replaceAll('#', '');
    final intColor = int.parse(hexColor, radix: 16);
    return Color(0xFF000000 | intColor);
  }

  void reset() {
    _lastDanmakuIndex = 0;
    _controller?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.child != null) widget.child!,
          SizedBox(
            width: widget.width ?? double.infinity,
            height: (widget.height ?? 200) * 0.6,
            child: DanmakuScreen<int>(
              createdController: (e) {
                _controller = e;
                if (widget.showDanmaku && widget.danmakuList.isNotEmpty) {
                  _checkAndShowDanmaku(widget.currentPosition.inMilliseconds);
                }
              },
              option:
                  widget.danmakuOption ??
                  const DanmakuOption(
                    fontSize: 16,
                    fontWeight: 4,
                    duration: 8.0,
                    staticDuration: 3.0,
                    strokeWidth: 1.5,
                    lineHeight: 1.6,
                    opacity: 1.0,
                    safeArea: true,
                  ),
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
