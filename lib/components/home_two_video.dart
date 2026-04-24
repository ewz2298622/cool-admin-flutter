import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/album_entity.dart';
import '../utils/video.dart';

class HomeTwoVideo extends StatelessWidget {
  static const double maxItemWidthPortrait = 150.0;
  static const double maxItemWidthLandscape = 200.0;
  static const double crossAxisSpacingPortrait = 10.0;
  static const double crossAxisSpacingLandscape = 15.0;
  static const double runSpacing = 5.0;
  static const double borderRadius = 5.0;
  static const double tagBorderRadius = 3.0;
  static const double imageHeight = 100.0;
  static const double containerBorderRadius = 8.0;

  final List<dynamic> videoPageData;

  const HomeTwoVideo({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return _buildAlbumItems(videoPageData, context);
  }

  Widget _buildAlbumItems(List<dynamic> album, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final isPortrait = mediaQuery.orientation == Orientation.portrait;

        final double maxItemWidth = isPortrait ? maxItemWidthPortrait : maxItemWidthLandscape;
        final double crossAxisSpacing = isPortrait ? crossAxisSpacingPortrait : crossAxisSpacingLandscape;

        final screenWidth = constraints.maxWidth;
        final crossAxisCount = (screenWidth / (maxItemWidth + crossAxisSpacing)).floor();
        final finalCrossAxisCount = crossAxisCount >= 1 ? crossAxisCount : 1;

        final itemCount = finalCrossAxisCount * 2;
        final actualItemCount = album.length > itemCount ? itemCount : album.length;
        final truncatedAlbum = album.sublist(0, actualItemCount);

        final itemWidth = (screenWidth - (finalCrossAxisCount - 1) * crossAxisSpacing) / finalCrossAxisCount;

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: crossAxisSpacing,
            runSpacing: runSpacing,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: List.generate(
              truncatedAlbum.length,
              (index) => RepaintBoundary(
                key: ValueKey('home_two_video_$index'),
                child: SizedBox(
                  width: itemWidth,
                  child: _buildAlbumItem(
                    truncatedAlbum[index] ?? AlbumDataListList(),
                    context,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumItemImage(AlbumDataListList item) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: imageHeight),
      child: SizedBox(
        child: TDImage(
          width: double.infinity,
          height: imageHeight,
          fit: BoxFit.cover,
          imgUrl: item.surfacePlot ?? '',
          errorWidget: const TDImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            assetUrl: 'assets/images/loading.gif',
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumItemOverlay(AlbumDataListList item) {
    return Container(
      width: double.infinity,
      height: imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAlbumItemHDTag(item),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(217, 217, 217, 0),
                  Color.fromRGBO(88, 88, 88, 1),
                ],
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: _buildAlbumItemNote(item),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumItemHDTag(AlbumDataListList item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          margin: const EdgeInsets.only(right: 4, top: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tagBorderRadius),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFA35C),
                Color(0xFFFF5821),
              ],
            ),
          ),
          alignment: Alignment.center,
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

  Widget _buildAlbumItemNote(AlbumDataListList item) {
    if (item.categoryPid != 537) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4, top: 2),
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: 4,
              right: 4,
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
            child: Text(
              item.remarks ?? "",
              style: const TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                fontSize: 11.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      final doubanScore = item.doubanScore!.toDouble() / 100;
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4, top: 2),
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: 4,
              right: 4,
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
            child: Text(
              doubanScore.toString(),
              style: const TextStyle(
                color: Color.fromRGBO(255, 102, 0, 1),
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                fontSize: 11.0,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildAlbumItemTitle(AlbumDataListList item) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        item.title ?? '',
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildAlbumItemSubTitle(AlbumDataListList item) {
    String subTitle = item.subTitle ?? VideoUtil.extractPlainText(item.introduce ?? "");
    subTitle = subTitle.isEmpty ? item.videoTag ?? '' : subTitle;
    return SizedBox(
      width: double.infinity,
      child: Text(
        subTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildAlbumItem(AlbumDataListList item, BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        "/video_detail",
        arguments: {"id": item.id},
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(containerBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                _buildAlbumItemImage(item),
                _buildAlbumItemOverlay(item),
              ],
            ),
            _buildAlbumItemTitle(item),
            _buildAlbumItemSubTitle(item),
          ],
        ),
      ),
    );
  }
}
