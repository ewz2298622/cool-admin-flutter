import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/video.dart';

class HorizontalVideoList extends StatelessWidget {
  static const double itemHeight = 160.0;
  static const double itemWidth = 120.0;
  static const double rightPadding = 10.0;
  static const double borderRadius = 5.0;
  static const double cacheExtent = 200.0;
  static const double tagRightMargin = 10.0;
  static const double tagTopMargin = 5.0;
  static const double tagHorizontalPadding = 4.0;
  static const double tagVerticalPadding = 2.0;
  static const double titleHorizontalPadding = 5.0;

  final List<dynamic> videoPageData;
  final Function()? onTap;

  const HorizontalVideoList({
    super.key,
    required this.videoPageData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videoPageData.length,
        cacheExtent: cacheExtent,
        itemBuilder: (context, index) => RepaintBoundary(
          key: ValueKey('video_scroll_$index'),
          child: GestureDetector(
            onTap: () => _handleItemTap(videoPageData[index]),
            child: Container(
              width: itemWidth,
              height: itemHeight,
              padding: const EdgeInsets.only(right: rightPadding),
              child: Stack(
                children: [
                  _buildVideoImage(videoPageData[index]),
                  _buildVideoItemHDTag(videoPageData[index]),
                  _buildVideoTitle(videoPageData[index], context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoImage(dynamic item) {
    return Positioned.fill(
      child: TDImage(
        width: itemWidth,
        height: itemHeight,
        fit: BoxFit.cover,
        imgUrl: item.surfacePlot ?? "",
        errorWidget: const TDImage(
          width: itemWidth,
          height: itemHeight,
          fit: BoxFit.cover,
          assetUrl: 'assets/images/loading.gif',
        ),
      ),
    );
  }

  Widget _buildVideoItemHDTag(dynamic item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: tagRightMargin, top: tagTopMargin),
          padding: const EdgeInsets.only(
            top: tagVerticalPadding,
            bottom: tagVerticalPadding,
            left: tagHorizontalPadding,
            right: tagHorizontalPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFA35C),
                Color(0xFFFF5821),
              ],
            ),
          ),
          child: Text(
            VideoUtil.formatTag(item.pubdate ?? ""),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoTitle(dynamic item, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            left: titleHorizontalPadding,
            right: titleHorizontalPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(217, 217, 217, 0),
                Color.fromRGBO(88, 88, 88, 1),
              ],
            ),
          ),
          child: Text(
            item.title ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _handleItemTap(dynamic item) {
    if (onTap != null) {
      onTap!();
    }
    Get.toNamed(
      "/video_detail",
      arguments: {"id": item.id},
      preventDuplicates: false,
    );
  }
}
