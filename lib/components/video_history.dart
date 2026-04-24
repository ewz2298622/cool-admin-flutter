import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/views_entity.dart';

/// 视频历史记录列表组件
class VideoHistory extends StatelessWidget {
  final List<ViewsDataList> videoPageData;

  const VideoHistory({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: videoPageData
          .map((item) => RepaintBoundary(
                child: VideoHistoryItem(videoData: item),
              ))
          .toList(),
    );
  }
}

/// 视频历史记录项组件
class VideoHistoryItem extends StatelessWidget {
  static const double _itemHeight = 80.0;
  static const double _imageWidth = 150.0;
  static const double _imageHeight = 80.0;
  static const double _borderRadius = 5.0;
  static const double _spacing = 10.0;
  static const double _titleSpacing = 10.0;
  static const double _overlayMarginRight = 2.0;
  static const double _overlayMarginBottom = 5.0;
  static const double _overlayPaddingVertical = 2.0;
  static const double _overlayPaddingHorizontal = 4.0;
  static const double _fontSize = 12.0;
  static const double _overlayFontSize = 11.0;
  static const EdgeInsetsGeometry _itemPadding = EdgeInsets.only(left: 4, right: 4, bottom: 15);
  static const String _videoDetailRoute = "/video_detail";
  static const String _errorAssetUrl = 'assets/images/loading.gif';
  static const String _remainingTimePrefix = "剩余";
  static const String _defaultTime = '00:00:00';

  final ViewsDataList videoData;

  const VideoHistoryItem({super.key, required this.videoData});

  /// 格式化秒数为 HH:MM:SS 格式（静态方法，可复用）
  static String formatSeconds(int seconds) {
    if (seconds < 0) return _defaultTime;
    
    final int hours = seconds ~/ 3600;
    final int remainingSeconds = seconds % 3600;
    final int minutes = remainingSeconds ~/ 60;
    final int secs = remainingSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  /// 计算剩余时间
  String _getRemainingTime() {
    final duration = videoData.duration ?? 0;
    final viewingDuration = videoData.viewingDuration ?? 0;
    final remaining = duration - viewingDuration;
    return formatSeconds(remaining > 0 ? remaining : 0);
  }

  /// 获取观看时长
  String _getViewingDuration() {
    return formatSeconds(videoData.viewingDuration ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _getRemainingTime();
    final viewingDuration = _getViewingDuration();

    return RepaintBoundary(
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          height: _itemHeight,
          width: MediaQuery.of(context).size.width,
          padding: _itemPadding,
          child: Row(
            spacing: _spacing,
            children: [
              _buildImageStack(viewingDuration),
              Flexible(
                child: _buildTextContent(remainingTime),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    Get.toNamed(
      _videoDetailRoute,
      arguments: {
        "id": videoData.associationId,
        "viewingDuration": videoData.viewingDuration,
      },
    );
  }

  /// 构建图片堆栈（包含图片和覆盖层）
  Widget _buildImageStack(String viewingDuration) {
    return Stack(
      children: [
        TDImage(
          fit: BoxFit.cover,
          width: _imageWidth,
          height: _imageHeight,
          imgUrl: videoData.cover ?? "",
          errorWidget: const TDImage(
            width: _imageWidth,
            assetUrl: _errorAssetUrl,
          ),
        ),
        _buildVideoItemOverlay(viewingDuration),
      ],
    );
  }

  /// 构建文本内容
  Widget _buildTextContent(String remainingTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitle(),
        const SizedBox(height: _titleSpacing),
        _buildRemainingTime(remainingTime),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      videoData.title ?? "",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }

  Widget _buildRemainingTime(String remainingTime) {
    return Text(
      "$_remainingTimePrefix$remainingTime",
      style: const TextStyle(fontSize: _fontSize),
    );
  }

  /// 构建视频项覆盖层
  Widget _buildVideoItemOverlay(String duration) {
    return Container(
      width: _imageWidth,
      height: _imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildDurationOverlay(duration),
        ],
      ),
    );
  }

  Widget _buildDurationOverlay(String duration) {
    return Container(
      margin: const EdgeInsets.only(
        right: _overlayMarginRight,
        bottom: _overlayMarginBottom,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: _overlayPaddingVertical,
        horizontal: _overlayPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Text(
        duration,
        style: const TextStyle(
          fontSize: _overlayFontSize,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
