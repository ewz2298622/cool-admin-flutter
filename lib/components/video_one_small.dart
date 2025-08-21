import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_page_entity.dart';
import '../utils/video.dart';
import '../views/video_detail/detail.dart';

class VideoOneSmall extends StatelessWidget {
  final List<VideoPageDataList> videoPageData;

  const VideoOneSmall({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(videoPageData.length, (i) {
        return GestureDetector(
          onTap: () => _buildvideo_onClick(videoPageData[i].id ?? 0, context),
          child: Container(
            height: 140,
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 15),
            child: Row(
              spacing: 5,
              children: [
                Stack(
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: 110,
                      height: 140,
                      imgUrl: videoPageData[i].surfacePlot ?? "",
                      errorWidget: const TDImage(
                        width: 150,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    _buildVideoItemOverlay(videoPageData[i]),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    height: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          videoPageData[i].title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${videoPageData[i].year ?? ''} / ${videoPageData[i].actors}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${videoPageData[i].videoClass ?? ''} / ${videoPageData[i].videoClass}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Text(
                            VideoUtil.extractPlainText(
                              videoPageData[i].introduce ?? "",
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: const TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  Widget _buildVideoItemOverlay(VideoPageDataList item) {
    return Container(
      width: 110,
      height: 175,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildVideoItemHDTag(item),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent, // 顶部透明
                  Colors.black.withOpacity(0.7), // 底部黑色
                ],
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: _buildVideoItemNote(item),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItemNote(VideoPageDataList item) {
    if (item.remarks == null) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 110,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              item.remarks ?? '',
              maxLines: 1,
              //首行缩进两个字符
              //缩进2px
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                textBaseline: TextBaseline.alphabetic,
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoItemHDTag(VideoPageDataList item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5, top: 5),
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
            VideoUtil.formatTag(item.pubdate ?? ""),
            style: TextStyle(
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
