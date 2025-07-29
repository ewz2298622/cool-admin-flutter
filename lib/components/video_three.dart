import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/video.dart';
import '../views/short_drama/short_drama.dart';
import '../views/video_detail/detail.dart';

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
    double doubanScore = item.doubanScore!.toDouble() / 100;
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
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            doubanScore.toString(),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Color.fromRGBO(255, 102, 0, 1),
              fontWeight: FontWeight.w400,
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
                Color.fromRGBO(59, 101, 244, 1),
                Color.fromRGBO(64, 177, 254, 1),
              ],
            ),
          ),
          alignment: Alignment.center, // 关键：强制内容居中
          child: Text(
            VideoUtil.formatTag(item?.pubdate ?? ""),
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              height: 1.0, // 关键：避免行高影响垂直对齐
            ),
          ),
        ),
      ],
    );
  }

  void _buildvideo_onClick(dynamic item, BuildContext context) {
    if (item.categoryPid == 551) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShortDrama(id: item.id)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Video_Detail(id: item.id)),
      );
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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
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
