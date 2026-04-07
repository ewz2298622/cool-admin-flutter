import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/album_video_list_entity.dart';
import '../utils/video.dart';

class Video extends StatelessWidget {
  static const double itemWidth = 130;
  static const double itemHeight = 205;
  static const double imageHeight = 180;
  static const double borderRadius = 5;
  static const double tagBorderRadius = 3;

  final AlbumVideoListDataList videoData;

  const Video({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      height: itemHeight,
      child: Column(
        children: [
          Stack(
            children: [
              _VideoImage(),
              _VideoOverlay(),
            ],
          ),
          _VideoTitle(),
        ],
      ),
    );
  }

  Widget _VideoImage() {
    return TDImage(
      fit: BoxFit.cover,
      width: itemWidth,
      height: imageHeight,
      imgUrl: videoData.surfacePlot ?? "",
      errorWidget: const TDImage(
        fit: BoxFit.fill,
        width: itemWidth,
        height: imageHeight,
        assetUrl: 'assets/images/loading.gif',
      ),
    );
  }

  Widget _VideoOverlay() {
    return GestureDetector(
      onTap: () => _onVideoClick(),
      child: Container(
        width: itemWidth,
        height: imageHeight,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildVideoItemHDTag(), _buildVideoItemNote()],
        ),
      ),
    );
  }

  Widget _VideoTitle() {
    return Text(
      videoData.title ?? "",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }

  Widget _buildVideoItemNote() {
    if (videoData.remarks == null) {
      return Container();
    }
    return Container(
      width: itemWidth,
      padding: const EdgeInsets.only(right: 4, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black38,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              videoData.remarks ?? '',
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                fontSize: 11.0,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: 30,
            child: Text(
              VideoUtil.formatScore(videoData.doubanScore),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                fontSize: 11.0,
                color: Color.fromRGBO(255, 102, 0, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItemHDTag() {
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
            VideoUtil.formatTag(videoData.pubdate ?? ""),
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

  void _onVideoClick() {
    if (videoData.categoryPid == 551) {
      Get.toNamed("/short_drama", arguments: {"id": videoData.videosId});
    } else {
      Get.toNamed("/video_detail", arguments: {"id": videoData.videosId});
    }
  }
}

class VideoThreeAlbum extends StatelessWidget {
  static const double maxCrossAxisExtent = 150.0;
  static const double crossAxisSpacing = 4.0;
  static const double mainAxisSpacing = 4.0;
  static const double mainAxisExtent = 205;
  static const int cacheExtent = 200;

  final List<AlbumVideoListDataList> videoPageData;

  const VideoThreeAlbum({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: (context, index) => RepaintBoundary(
        key: ValueKey('video_three_album_$index'),
        child: GridTile(
          child: Center(child: Video(videoData: videoPageData[index])),
        ),
      ),
      itemCount: videoPageData.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cacheExtent: cacheExtent.toDouble(),
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
    );
  }
}
