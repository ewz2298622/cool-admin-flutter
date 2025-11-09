import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_page_entity.dart';
import '../utils/video.dart';

/// 小尺寸视频列表组件
class VideoOneSmall extends StatelessWidget {
  final List<VideoPageDataList> videoPageData;

  const VideoOneSmall({super.key, required this.videoPageData});

  // 常量定义
  static const double _itemHeight = 140.0;
  static const double _imageWidth = 110.0;
  static const double _imageHeight = 140.0;
  static const double _textHeight = 55.0;
  static const double _borderRadius = 5.0;
  static const double _spacing = 5.0;
  static const double _overlayOpacity = 0.7;
  static const int _textGreyColor = 0xFF999999;
  static const int _gradientColor1 = 0xFF3B65F4;
  static const int _gradientColor2 = 0xFF40B1FE;

  @override
  Widget build(BuildContext context) {
    // 容错处理：检查列表是否为空
    if (videoPageData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: List.generate(
        videoPageData.length,
        (i) {
          // 容错处理：检查索引有效性
          if (i >= videoPageData.length) {
            return const SizedBox.shrink();
          }

          return RepaintBoundary(
            child: _VideoItem(
              videoData: videoPageData[i],
            ),
          );
        },
      ),
    );
  }
}

/// 单个视频项组件
class _VideoItem extends StatelessWidget {
  final VideoPageDataList videoData;

  const _VideoItem({required this.videoData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 容错处理：检查ID是否有效
        if (videoData.id == null) {
          return;
        }
        Get.toNamed(
          "/video_detail",
          arguments: {"id": videoData.id},
          preventDuplicates: false,
        );
      },
      child: Container(
        height: VideoOneSmall._itemHeight,
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 15),
        child: Row(
          spacing: VideoOneSmall._spacing,
          children: [
            _buildImageStack(),
            Expanded(
              child: SizedBox(
                height: VideoOneSmall._itemHeight,
                child: _buildTextContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建图片堆栈
  Widget _buildImageStack() {
    return Stack(
      children: [
        TDImage(
          fit: BoxFit.cover,
          width: VideoOneSmall._imageWidth,
          height: VideoOneSmall._imageHeight,
          imgUrl: videoData.surfacePlot ?? "",
          errorWidget: const TDImage(
            width: VideoOneSmall._imageWidth,
            height: VideoOneSmall._imageHeight,
            fit: BoxFit.cover,
            assetUrl: 'assets/images/loading.gif',
          ),
        ),
        _buildVideoItemOverlay(),
      ],
    );
  }

  /// 构建文本内容
  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          videoData.title ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          _buildYearActorsText(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(VideoOneSmall._textGreyColor),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          _buildVideoClassText(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(VideoOneSmall._textGreyColor),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: VideoOneSmall._textHeight,
          child: Text(
            VideoUtil.extractPlainText(videoData.introduce ?? ""),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(
              color: Color(VideoOneSmall._textGreyColor),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建年份和演员文本
  String _buildYearActorsText() {
    // 容错处理：year 可能是 dynamic 类型，需要转换为字符串
    final year = (videoData.year?.toString() ?? '').trim();
    final actors = (videoData.actors ?? '').trim();
    if (year.isEmpty && actors.isEmpty) {
      return '';
    } else if (year.isEmpty) {
      return actors;
    } else if (actors.isEmpty) {
      return year;
    } else {
      return "$year / $actors";
    }
  }

  /// 构建视频分类文本（修复重复字段错误）
  String _buildVideoClassText() {
    // 容错处理：videoClass 和 videoTag 是 dynamic 类型，需要转换为字符串
    final videoClass = (videoData.videoClass?.toString() ?? '').trim();
    final videoTag = (videoData.videoTag?.toString() ?? '').trim();
    if (videoClass.isEmpty && videoTag.isEmpty) {
      return '';
    } else if (videoClass.isEmpty) {
      return videoTag;
    } else if (videoTag.isEmpty) {
      return videoClass;
    } else {
      return "$videoClass / $videoTag";
    }
  }

  /// 构建视频项覆盖层
  Widget _buildVideoItemOverlay() {
    // 修复布局错误：高度应该与容器高度一致（140）
    return Container(
      width: VideoOneSmall._imageWidth,
      height: VideoOneSmall._imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(VideoOneSmall._borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildVideoItemHDTag(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: VideoOneSmall._overlayOpacity),
                ],
              ),
              borderRadius: BorderRadius.circular(VideoOneSmall._borderRadius),
            ),
            child: _buildVideoItemNote(),
          ),
        ],
      ),
    );
  }

  /// 构建视频备注
  Widget _buildVideoItemNote() {
    final remarks = videoData.remarks;
    if (remarks == null || remarks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: VideoOneSmall._imageWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              remarks,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                textBaseline: TextBaseline.alphabetic,
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建视频HD标签
  Widget _buildVideoItemHDTag() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5, top: 5),
          padding: const EdgeInsets.only(
            top: 2,
            bottom: 2,
            left: 4,
            right: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(VideoOneSmall._borderRadius),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(VideoOneSmall._gradientColor1),
                Color(VideoOneSmall._gradientColor2),
              ],
            ),
          ),
          child: Text(
            VideoUtil.formatTag(videoData.pubdate ?? ""),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
