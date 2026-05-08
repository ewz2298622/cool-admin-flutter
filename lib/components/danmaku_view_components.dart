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
    _danmakuList.forEach((element) {
    _controller?.addDanmaku(
          DanmakuContentItem(
            element.text ?? '',
            color:getRandomColor(element.color ?? '#FFFFFF'),
            type: (element.type is DanmakuItemType) ? element.type as DanmakuItemType : const [
                          DanmakuItemType.top,
                          DanmakuItemType.bottom,
                          DanmakuItemType.scroll,
                        ][_random.nextInt(3)], 
          ),
        );
    });
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
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.child != null) widget.child!,
         SizedBox(
          width: widget.width,
          height: widget.height * 0.6,
          child:  DanmakuScreen<int>(
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
