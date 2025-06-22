import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/video.dart';
import '../views/video_detail/detail.dart';

class Video extends StatelessWidget {
  final dynamic videoData; // 使用 dynamic 类型

  const Video({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 205,
      child: Column(
        children: [
          Stack(
            children: [
              TDImage(
                fit: BoxFit.cover,
                width: 120,
                height: 180,
                imgUrl: videoData.surfacePlot ?? "",
                errorWidget: const TDImage(
                  fit: BoxFit.fill,
                  width: 120,
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
      onTap: () => {_buildvideo_onClick(item.id ?? 0, context)},
      child: Container(
        width: 130,
        height: 175,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromRGBO(0, 0, 0, 0.302),
          ),
          child: Text(item?.remarks ?? '', style: _videoNoteTextStyle),
        ),
      ],
    );
  }

  Widget _buildVideoItemHDTag(dynamic item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(59, 101, 244, 1),
                Color.fromRGBO(64, 177, 254, 1),
              ],
            ),
          ),
          child: Text(
            VideoUtil.formatTag(item?.pubdate ?? ""),
            style: _hdTagTextStyle,
          ),
        ),
      ],
    );
  }

  static const _hdTagTextStyle = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static const _videoNoteTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  void _buildvideo_onClick(int id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }
}

class VideoThree extends StatelessWidget {
  // final List<VideoPageDataList> videoPageData;
  final dynamic videoPageData; // 使用 dynamic 类型

  const VideoThree({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: (MediaQuery.of(context).size.width - 380) / 2,
      runSpacing: 10,
      children: List<Widget>.generate(videoPageData.length, (i) {
        return SizedBox(
          width: 120,
          height: 205,
          child: Column(
            children: [
              Stack(
                children: [
                  TDImage(
                    fit: BoxFit.cover,
                    width: 120,
                    height: 180,
                    imgUrl: videoPageData[i].surfacePlot ?? "",
                    errorWidget: const TDImage(
                      fit: BoxFit.fill,
                      width: 120,
                      height: 180,
                      assetUrl: 'assets/images/loading.gif',
                    ),
                  ),
                  _buildVideoItemOverlay(videoPageData[i], context),
                ],
              ),
              Text(
                videoPageData[i].title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _buildvideo_onClick(int id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  Widget _buildVideoItemOverlay(dynamic item, BuildContext context) {
    return GestureDetector(
      onTap: () => {_buildvideo_onClick(item.id ?? 0, context)},
      child: Container(
        width: 130,
        height: 175,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromRGBO(0, 0, 0, 0.302),
          ),
          child: Text(item?.remarks ?? '', style: _videoNoteTextStyle),
        ),
      ],
    );
  }

  Widget _buildVideoItemHDTag(dynamic item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(59, 101, 244, 1),
                Color.fromRGBO(64, 177, 254, 1),
              ],
            ),
          ),
          child: Text(
            VideoUtil.formatTag(item?.pubdate ?? ""),
            style: _hdTagTextStyle,
          ),
        ),
      ],
    );
  }

  static const _hdTagTextStyle = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static const _videoNoteTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
}
