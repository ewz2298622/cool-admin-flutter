import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/views_entity.dart';

class VideoHistory extends StatelessWidget {
  final List<ViewsDataList> videoPageData;

  const VideoHistory({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          videoPageData
              .map((item) => VideoHistoryItem(videoData: item))
              .toList(),
    );
  }
}

class VideoHistoryItem extends StatelessWidget {
  final ViewsDataList videoData;

  const VideoHistoryItem({super.key, required this.videoData});

  //实现一个毫秒转00:00:00格式
  String formatSeconds(int seconds) {
    final int hours = seconds ~/ 3600;
    final int remainingSeconds = seconds % 3600;
    final int minutes = remainingSeconds ~/ 60;
    final int secs = remainingSeconds % 60;

    final String twoDigitHours = hours.toString().padLeft(2, '0');
    final String twoDigitMinutes = minutes.toString().padLeft(2, '0');
    final String twoDigitSeconds = secs.toString().padLeft(2, '0');

    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Get.toNamed(
            "/video_detail",
            arguments: {
              "id": videoData.associationId,
              "viewingDuration": videoData.viewingDuration,
            },
          ),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 15),
        child: Row(
          spacing: 10,
          children: [
            Stack(
              children: [
                TDImage(
                  fit: BoxFit.cover,
                  width: 150,
                  height: 80,
                  imgUrl: videoData.cover ?? "",
                  errorWidget: const TDImage(
                    width: 150,
                    assetUrl: 'assets/images/loading.gif',
                  ),
                ),
                _buildVideoItemOverlay(videoData),
              ],
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    videoData.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "剩余${formatSeconds((videoData.duration ?? 0) - (videoData.viewingDuration ?? 0))}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoItemOverlay(ViewsDataList item) {
    return Container(
      width: 150,
      height: 80,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: _buildVideoItemHDTag(item),
    );
  }

  Widget _buildVideoItemHDTag(ViewsDataList item) {
    String duration = formatSeconds(item.viewingDuration ?? 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 2, bottom: 5),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: Text(
            duration,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
