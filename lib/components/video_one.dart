import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../views/video_detail/detail.dart';

class VideoItem extends StatelessWidget {
  final dynamic videoData;
  const VideoItem({super.key, required this.videoData});

  Widget _buildAlbumItems(BuildContext context) {
    return Column(
      children: List<Widget>.generate(videoData.length, (i) {
        return GestureDetector(
          onTap: () => {_buildvideo_onClick(videoData[i].id ?? 0, context)},
          child: Container(
            height: 185,
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 15),
            child: Row(
              children: [
                Stack(
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: 120,
                      height: 180,
                      imgUrl: videoData?[i].surfacePlot ?? "",
                      errorWidget: const TDImage(
                        width: 120,
                        height: 180,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    _buildVideoItemOverlay(videoData?[i]),
                  ],
                ),
                Expanded(
                  // 使用 Expanded 替代 SizedBox
                  child: SizedBox(
                    height: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          videoData?[i].title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${videoData?[i].year ?? ''} / ${videoData?[i].actors}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 80,
                          child: Html(
                            data: videoData[i].introduce ?? "",
                            style: {
                              "body": Style(
                                maxLines: 3, // 限制最大行数
                                textOverflow: TextOverflow.ellipsis, // 溢出显示省略号
                                color: Color.fromRGBO(153, 153, 153, 1),
                              ),
                              "p": Style(
                                color: Color.fromRGBO(153, 153, 153, 1),
                              ),
                              //设置所有html元素字体的颜色
                              "span": Style(
                                color: Color.fromRGBO(153, 153, 153, 1),
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

  Widget _buildVideoItemOverlay(dynamic item) {
    return Container(
      width: 130,
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
    if (item.note == null) {
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
            maxLines: 1, // 限制最大显示一行
            overflow: TextOverflow.ellipsis, // 溢出时显示省略号
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
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
          margin: const EdgeInsets.only(right: 15, top: 5),
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

  void _buildvideo_onClick(int id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAlbumItems(context);
  }
}

class VideoOne extends StatelessWidget {
  final dynamic videoData;

  const VideoOne({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return VideoItem(videoData: videoData);
  }
}
