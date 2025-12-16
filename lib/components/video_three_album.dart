import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/album_video_list_entity.dart';
import '../utils/video.dart';

class Video extends StatelessWidget {
  final AlbumVideoListDataList videoData; // 使用 dynamic 类型

  const Video({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 205,
      child: Column(
        children: [
          Stack(
            children: [
              TDImage(
                fit: BoxFit.cover,
                width: 130,
                height: 180,
                imgUrl: videoData.surfacePlot ?? "",
                errorWidget: const TDImage(
                  fit: BoxFit.fill,
                  width: 130,
                  height: 180,
                  assetUrl: 'assets/images/loading.gif',
                ),
              ),
              _buildVideoItemOverlay(videoData, context),
            ],
          ),
          Text(
            videoData.title ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItemOverlay(dynamic item, BuildContext context) {
    return GestureDetector(
      onTap: () => {_buildvideo_onClick(item, context)},
      child: Container(
        width: 130,
        height: 180,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildVideoItemHDTag(item), _buildVideoItemNote(item)],
        ),
      ),
    );
  }

  Widget _buildVideoItemNote(AlbumVideoListDataList item) {
    if (item.remarks == null) {
      return Container();
    }
    return Container(
      width: 130,
      padding: const EdgeInsets.only(right: 4, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent, // 顶部透明
            Colors.black.withOpacity(0.7), // 底部黑色
          ],
        ),
      ),
      child: Row(
        //右对齐
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 5,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              item.remarks ?? '',
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
          SizedBox(
            width: 30,
            child: Text(
              VideoUtil.formatScore(item.doubanScore),
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

  Widget _buildVideoItemHDTag(AlbumVideoListDataList item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          margin: const EdgeInsets.only(right: 4, top: 4), // 调整内边距
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft, // 对应 90deg (从左到右)
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFA35C), // rgb(255, 163, 92)
                Color(0xFFFF5821), // rgb(255, 88, 33)
              ],
            ),
          ),
          alignment: Alignment.center, // 关键：强制内容居中
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

  void _buildvideo_onClick(AlbumVideoListDataList item, BuildContext context) {
    if (item.categoryPid == 551) {
      Get.toNamed("/short_drama", arguments: {"id": item.videosId});
    } else {
      Get.toNamed("/video_detail", arguments: {"id": item.videosId});
    }
  }
}

class VideoThreeAlbum extends StatelessWidget {
  // final List<VideoPageDataList> videoPageData;
  final List<AlbumVideoListDataList> videoPageData; // 使用 dynamic 类型

  const VideoThreeAlbum({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0, // 每个 item 的最大宽度
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        mainAxisExtent: 205,
      ),
      itemBuilder:
          (context, i) => RepaintBoundary(
            key: ValueKey('video_three_$i'),
            child: GridTile(
              child: Center(child: Video(videoData: videoPageData[i])),
            ),
          ),
      itemCount: videoPageData.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      cacheExtent: 200, // 优化缓存范围
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
    );
  }
}
