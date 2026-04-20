import 'package:flutter/material.dart';
import 'package:flutter_app/entity/swiper_entity.dart';
import 'package:get/get.dart';

class SwiperItemComponent extends StatelessWidget {
  static const double defaultBorderRadius = 8.0;
  static const double bottomPadding = 10.0;
  static const double leftRightPadding = 10.0;
  static const double titleFontSize = 18.0;
  static const double subTitleFontSize = 12.0;
  static const double titleSubtitleSpacing = 5.0;
  static const double titleWidthRatio = 0.7;

  final SwiperDataList item;
  final double borderRadius;

  const SwiperItemComponent({
    Key? key,
    required this.item,
    this.borderRadius = defaultBorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleWidth = screenWidth * titleWidthRatio;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: _handleTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildBackgroundImage(),
              _buildGradientOverlay(),
              _buildTextContent(context, titleWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.network(
      item.image ?? '',
      fit: BoxFit.cover,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[300],
        );
      },
      errorBuilder: (
        BuildContext context,
        Object exception,
        StackTrace? stackTrace,
      ) {
        return Container(
          color: Colors.grey[400],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black54],
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, double titleWidth) {
    return Positioned(
      bottom: bottomPadding,
      left: leftRightPadding,
      right: leftRightPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(titleWidth),
          if ((item.subTitle ?? '').isNotEmpty) _buildSubTitle(),
        ],
      ),
    );
  }

  Widget _buildTitle(double titleWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: titleWidth),
      child: Text(
        item.title ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubTitle() {
    return Column(
      children: [
        const SizedBox(height: titleSubtitleSpacing),
        Text(
          item.subTitle ?? "",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: subTitleFontSize,
            fontWeight: FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _handleTap() {
    if (item.relatedId != null) {
      Get.toNamed("/video_detail", arguments: {"id": item.relatedId});
    }
  }
}
