import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/video.dart';

class Video extends StatelessWidget {
  final dynamic videoData; // 使用 dynamic 类型

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

  Widget _buildVideoItemNote(dynamic item) {
    if (item?.remarks == null) {
      return Container();
    }
    return Container(
      width: double.infinity,
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
          Text(
            item?.remarks ?? '',
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
              fontSize: 11.0,
              color: Colors.white,
            ),
          ),
          Text(
            VideoUtil.formatScore(item?.doubanScore),
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
        ],
      ),
    );
  }

  Widget _buildVideoItemHDTag(dynamic item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          margin: EdgeInsets.only(right: 4, top: 4), // 调整内边距
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(253, 221, 68, 0.80),
                Color.fromRGBO(253, 221, 68, 0.80),
              ],
            ),
          ),
          alignment: Alignment.center, // 关键：强制内容居中
          child: Text(
            VideoUtil.formatTag(item?.pubdate ?? ""),
            style: TextStyle(
              fontSize: 11,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _buildvideo_onClick(dynamic item, BuildContext context) {
    if (item.categoryPid == 551) {
      Get.toNamed("/short_drama", arguments: {"id": item.id});
    } else {
      Get.toNamed("/video_detail", arguments: {"id": item.id});
    }
  }
}

class VideoThree extends StatelessWidget {
  // final List<VideoPageDataList> videoPageData;
  final dynamic videoPageData; // 使用 dynamic 类型

  const VideoThree({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0, // 每个 item 的最大宽度
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 0.7,
        mainAxisExtent: 205,
      ),
      itemBuilder:
          (context, i) => GridTile(
            child: Center(child: Video(videoData: videoPageData[i])),
          ),
      itemCount: videoPageData.length,
      padding: EdgeInsets.zero, // 如果需要可以添加 padding
      shrinkWrap: true, // 如果需要在可滚动组件中使用
      physics: NeverScrollableScrollPhysics(), // 如果需要禁用滚动
    );
  }
}
