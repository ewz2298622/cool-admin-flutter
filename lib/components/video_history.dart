import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/views_entity.dart';
import '../views/video_detail/detail.dart';

class VideoHistory extends StatelessWidget {
  final List<ViewsDataList> videoPageData;

  const VideoHistory({super.key, required this.videoPageData});

  //实现一个毫秒转00:00:00格式
  String _formatDuration(int milliseconds) {
    final int seconds = milliseconds ~/ 1000;
    final int minutes = seconds ~/ 60;
    final int hours = minutes ~/ 60;

    final String twoDigitMinutes = minutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final String twoDigitSeconds = seconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(videoPageData.length, (i) {
        return GestureDetector(
          onTap: () => _buildvideo_onClick(videoPageData[i].id ?? 0, context),
          child: Container(
            height: 80,
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
                      imgUrl: videoPageData[i].cover ?? "",
                      errorWidget: const TDImage(
                        width: 150,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    _buildVideoItemOverlay(videoPageData[i]),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      videoPageData[i].title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "剩余${_formatDuration((videoPageData[i].duration ?? 0) - (videoPageData[i].viewingDuration ?? 0))}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _buildvideo_onClick(int id, BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
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
    String duration = _formatDuration(item.viewingDuration ?? 0);
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
