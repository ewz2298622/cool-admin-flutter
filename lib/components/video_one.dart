import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_page_entity.dart';
import '../utils/video.dart';

class VideoItem extends StatelessWidget {
  static const double _posterWidth = 130;
  static const double _posterHeight = 180;
  static const BorderRadius _posterBorderRadius = BorderRadius.all(Radius.circular(5));
  static const BorderRadius _tagBorderRadius = BorderRadius.all(Radius.circular(15));
  static const Color _tagTextColor = Color.fromRGBO(195, 161, 101, 1);
  static const Color _tagBackgroundColor = Color.fromRGBO(195, 161, 101, 0.1);
  static const double _hotIconSize = 20;
  static const LinearGradient _hdTagGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(59, 101, 244, 1),
      Color.fromRGBO(64, 177, 254, 1),
    ],
  );
  static const LinearGradient _overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color.fromRGBO(0, 0, 0, 0.7),
    ],
  );
  static const EdgeInsets _hdTagPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const EdgeInsets _itemPadding = EdgeInsets.only(left: 4, right: 4, bottom: 10);
  static const double _itemSpacing = 5;
  static const double _topPadding = 5;
  static const double _tagSpacing = 10;
  static const double _hotWidgetWidth = 60;
  static const double _remarksRightPadding = 10;
  static const double _remarksBottomPadding = 5;
  static const double _hdTagRightMargin = 10;
  static const double _hdTagTopMargin = 5;
  static const double _smallFontSize = 10;
  static const double _mediumFontSize = 12;
  static const Color _hotTextColor = Color.fromRGBO(255, 101, 39, 1);
  static const Color _introTextColor = Color.fromRGBO(153, 153, 153, 1);
  static const String _videoDetailRoute = "/video_detail";
  static const String _errorAssetUrl = 'assets/images/loading.gif';
  static const String _hotIconAsset = 'assets/images/hot_surface.svg';
  static const int _maxCountLength = 4;
  static const int _maxIntroLines = 4;
  static const int _maxActorLines = 2;

  final VideoPageDataList videoData;
  const VideoItem({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          padding: _itemPadding,
          child: Row(
            spacing: _itemSpacing,
            children: [
              _buildPoster(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    Get.toNamed(_videoDetailRoute, arguments: {"id": videoData.id});
  }

  Widget _buildPoster() {
    return ClipRRect(
      borderRadius: _posterBorderRadius,
      child: SizedBox(
        width: _posterWidth,
        height: _posterHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            _buildVideoItemOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return TDImage(
      fit: BoxFit.cover,
      width: _posterWidth,
      height: _posterHeight,
      imgUrl: videoData.surfacePlot ?? "",
      errorWidget: const TDImage(
        width: _posterWidth,
        height: _posterHeight,
        assetUrl: _errorAssetUrl,
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: SizedBox(
        height: _posterHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitleRow(),
            _buildCategoryRow(),
            _buildYearActorRow(),
            _buildIntroduction(),
            _buildTagsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitle(),
        _buildHotWidget(),
      ],
    );
  }

  Widget _buildTitle() {
    return Flexible(
      flex: 1,
      child: Text(
        videoData.title ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHotWidget() {
    return SizedBox(
      width: _hotWidgetWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildHotText(),
          _buildHotIcon(),
        ],
      ),
    );
  }

  Widget _buildHotText() {
    return Text(
      _formatCount((videoData.up ?? 0).toString()),
      maxLines: 1,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: _hotTextColor,
      ),
    );
  }

  Widget _buildHotIcon() {
    return SvgPicture.asset(
      _hotIconAsset,
      width: _hotIconSize,
      height: _hotIconSize,
    );
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.only(top: _topPadding),
      child: Text(
        "${videoData.videoClass ?? ''} / ${videoData.videoTag ?? ''}",
        style: const TextStyle(
          fontSize: _mediumFontSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildYearActorRow() {
    return Padding(
      padding: const EdgeInsets.only(top: _topPadding),
      child: Text(
        "${videoData.year ?? ''} / ${videoData.actors ?? ''}",
        maxLines: _maxActorLines,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: _mediumFontSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildIntroduction() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: _topPadding),
        child: Text(
          VideoUtil.extractPlainText(videoData.introduce ?? ""),
          maxLines: _maxIntroLines,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: _mediumFontSize,
            color: _introTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTagsRow() {
    return Row(
      spacing: _tagSpacing,
      children: [
        _buildPopularityTag(),
        _buildLikesTag(),
      ],
    );
  }

  Widget _buildPopularityTag() {
    return TDTag(
      '${videoData.popularity ?? 0}万热度',
      isLight: true,
      backgroundColor: _tagBackgroundColor,
      textColor: _tagTextColor,
      shape: TDTagShape.round,
      isOutline: true,
      style: TDTagStyle(
        borderColor: Colors.transparent,
        borderRadius: _tagBorderRadius,
      ),
    );
  }

  Widget _buildLikesTag() {
    return TDTag(
      '${videoData.popularitySum ?? 0}万点赞',
      isLight: true,
      backgroundColor: _tagBackgroundColor,
      textColor: _tagTextColor,
      shape: TDTagShape.round,
      isOutline: true,
      style: TDTagStyle(
        borderColor: Colors.transparent,
        borderRadius: _tagBorderRadius,
      ),
    );
  }

  Widget _buildVideoItemOverlay() {
    return IgnorePointer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildVideoItemHDTag(),
          _buildVideoItemNote(),
        ],
      ),
    );
  }

  Widget _buildVideoItemNote() {
    final remarks = videoData.remarks?.trim();
    if (remarks == null || remarks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: _overlayGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: _remarksRightPadding, bottom: _remarksBottomPadding),
        child: Text(
          remarks,
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: _smallFontSize,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
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
          margin: const EdgeInsets.only(right: _hdTagRightMargin, top: _hdTagTopMargin),
          padding: _hdTagPadding,
          decoration: const BoxDecoration(
            borderRadius: _posterBorderRadius,
            gradient: _hdTagGradient,
          ),
          child: Text(
            tag,
            style: const TextStyle(
              fontSize: _smallFontSize,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCount(String str) {
    return str.length > _maxCountLength ? str.substring(0, _maxCountLength) : str;
  }
}

class VideoOne extends StatelessWidget {
  final VideoPageDataList videoData;

  const VideoOne({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return VideoItem(videoData: videoData);
  }
}
