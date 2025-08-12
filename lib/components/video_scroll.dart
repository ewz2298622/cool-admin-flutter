import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/video.dart';
import '../views/video_detail/detail.dart';

class HorizontalVideoList extends StatelessWidget {
  final List<dynamic> videoPageData;

  const HorizontalVideoList({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videoPageData.length,
        itemBuilder:
            (context, i) => GestureDetector(
              onTap: () {
                _buildvideo_onClick(videoPageData[i].id, context);
              },
              child: Container(
                width: 120,
                height: 160,
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: TDImage(
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                        imgUrl: videoPageData[i].surfacePlot ?? "",
                        errorWidget: const TDImage(
                          width: 120,
                          height: 160,
                          fit: BoxFit.cover,
                          assetUrl: 'assets/images/loading.gif',
                        ),
                      ),
                    ),
                    _buildVideoItemHDTag(videoPageData[i]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(217, 217, 217, 0), // 顶部透明
                                Color.fromRGBO(88, 88, 88, 1), // 部黑
                              ],
                            ),
                          ),
                          child: Text(
                            videoPageData[i].title ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildVideoItemHDTag(dynamic item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10, top: 5),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(253, 221, 68, 0.80),
                Color.fromRGBO(253, 221, 68, 0.80),
              ],
            ),
          ),
          child: Text(
            VideoUtil.formatTag(item.pubdate ?? ""),
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

  void _buildvideo_onClick(int id, BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => Video_Detail(
              key: ValueKey(id), // 不同 id 对应不同 Key
              id: id,
            ),
      ),
    );
  }
}
