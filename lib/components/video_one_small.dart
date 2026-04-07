import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_page_entity.dart';
import '../utils/video.dart';

/// 小尺寸视频列表组件
class VideoOneSmall extends StatelessWidget {
  static const double _itemHeight = 140.0;
  static const double _imageWidth = 110.0;
  static const double _imageHeight = 140.0;
  static const double _textHeight = 55.0;
  static const double _borderRadius = 5.0;
  static const double _spacing = 5.0;
  static const double _textSpacing = 4.0;
  static const double _overlayOpacity = 0.7;
  static const int _textGreyColor = 0xFF999999;
  static const int _gradientColor1 = 0xFF3B65F4;
  static const int _gradientColor2 = 0xFF40B1FE;
  static const EdgeInsetsGeometry _itemPadding = EdgeInsets.only(left: 4, right: 4, bottom: 15);
  static const EdgeInsetsGeometry _hdTagMargin = EdgeInsets.only(right: 5, top: 5);
  static const EdgeInsetsGeometry _hdTagPadding = EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4);
  static const EdgeInsetsGeometry _notePadding = EdgeInsets.only(left: 4);
  static const double _noteFontSize = 10.0;
  static const double _tagFontSize = 11.0;
  static const double _infoFontSize = 12.0;
  static const int _maxInfoLines = 1;
  static const int _maxIntroLines = 3;
  static const String _videoDetailRoute = "/video_detail";
  static const String _errorAssetUrl = 'assets/images/loading.gif';
  static const Color _greyColor = Color(_textGreyColor);
  static const LinearGradient _hdTagGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(_gradientColor1),
      Color(_gradientColor2),
    ],
  );

  final List<VideoPageDataList> videoPageData;

  const VideoOneSmall({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    if (videoPageData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: videoPageData
          .map((item) => RepaintBoundary(
                child: _VideoItem(videoData: item),
              ))
          .toList(),
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
      onTap: _handleTap,
      child: Container(
        height: VideoOneSmall._itemHeight,
        padding: VideoOneSmall._itemPadding,
        child: Row(
          spacing: VideoOneSmall._spacing,
          children: [
            _buildImageStack(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  void _handleTap() {
    if (videoData.id == null) {
      return;
    }
    Get.toNamed(
      VideoOneSmall._videoDetailRoute,
      arguments: {"id": videoData.id},
      preventDuplicates: false,
    );
  }

  Widget _buildImageStack() {
    return Stack(
      children: [
        _buildImage(),
        _buildVideoItemOverlay(),
      ],
    );
  }

  Widget _buildImage() {
    return TDImage(
      fit: BoxFit.cover,
      width: VideoOneSmall._imageWidth,
      height: VideoOneSmall._imageHeight,
      imgUrl: videoData.surfacePlot ?? "",
      errorWidget: const TDImage(
        width: VideoOneSmall._imageWidth,
        height: VideoOneSmall._imageHeight,
        fit: BoxFit.cover,
        assetUrl: VideoOneSmall._errorAssetUrl,
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: SizedBox(
        height: VideoOneSmall._itemHeight,
        child: _buildTextContent(),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: VideoOneSmall._textSpacing,
      children: [
        _buildTitle(),
        _buildYearActorsText(),
        _buildVideoClassText(),
        _buildIntroduction(),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      videoData.title ?? "",
      maxLines: VideoOneSmall._maxInfoLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }

  Widget _buildYearActorsText() {
    final text = _getYearActorsText();
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      text,
      maxLines: VideoOneSmall._maxInfoLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: VideoOneSmall._greyColor,
        fontSize: VideoOneSmall._infoFontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildVideoClassText() {
    final text = _getVideoClassText();
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      text,
      maxLines: VideoOneSmall._maxInfoLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: VideoOneSmall._greyColor,
        fontSize: VideoOneSmall._infoFontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildIntroduction() {
    return SizedBox(
      width: double.infinity,
      height: VideoOneSmall._textHeight,
      child: Text(
        VideoUtil.extractPlainText(videoData.introduce ?? ""),
        overflow: TextOverflow.ellipsis,
        maxLines: VideoOneSmall._maxIntroLines,
        style: const TextStyle(
          color: VideoOneSmall._greyColor,
          fontSize: VideoOneSmall._infoFontSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  String _getYearActorsText() {
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

  String _getVideoClassText() {
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

  Widget _buildVideoItemOverlay() {
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
          _buildVideoItemNote(),
        ],
      ),
    );
  }

  Widget _buildVideoItemNote() {
    final remarks = videoData.remarks;
    if (remarks == null || remarks.isEmpty) {
      return const SizedBox.shrink();
    }

    return DecoratedBox(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: VideoOneSmall._imageWidth,
            child: Padding(
              padding: VideoOneSmall._notePadding,
              child: Text(
                remarks,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: VideoOneSmall._noteFontSize,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItemHDTag() {
    final tag = VideoUtil.formatTag(videoData.pubdate ?? "");
    if (tag.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: VideoOneSmall._hdTagMargin,
          padding: VideoOneSmall._hdTagPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(VideoOneSmall._borderRadius),
            gradient: VideoOneSmall._hdTagGradient,
          ),
          child: Text(
            tag,
            style: const TextStyle(
              fontSize: VideoOneSmall._tagFontSize,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
