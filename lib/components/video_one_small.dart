import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_page_entity.dart';
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
              children: [
                Stack(
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: 100,
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
                      children: [
                        Text(
                          videoPageData[i].title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${videoPageData[i].year ?? ''} / ${videoPageData[i].actors}",
                          maxLines: 2,
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
                          child: Html(
                            data: videoPageData[i].introduce ?? "",
                            style: {
                              "body": Style(
                                maxLines: 2, // 限制最大行数
                                textOverflow: TextOverflow.ellipsis, // 溢出显示省略号
                                color: Color.fromRGBO(153, 153, 153, 1),
                                backgroundColor: Colors.transparent,
                              ),
                              "p": Style(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                backgroundColor: Colors.transparent,
                              ),
                              //设置所有html元素字体的颜色
                              "span": Style(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                backgroundColor: Colors.transparent,
                              ),
                            },
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

  Widget _buildVideoItemOverlay(dynamic item) {
    return Container(
      width: 110,
      height: 175,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildVideoItemHDTag(), _buildVideoItemNote(item)],
      ),
    );
  }

  Widget _buildVideoItemNote(dynamic item) {
    if (item?.note == null) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 15, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromRGBO(0, 0, 0, 0.302),
          ),
          child: Text(
            item?.note ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoItemHDTag() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12, top: 5),
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
          child: const Text(
            "高清",
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
