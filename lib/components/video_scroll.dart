import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/video.dart';

class HorizontalVideoList extends StatelessWidget {
  final List<dynamic> videoPageData;

  //接受一个可选回调函数
  final Function()? onTap;

  const HorizontalVideoList({
    super.key,
    required this.videoPageData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videoPageData.length,
        cacheExtent: 200, // 优化缓存范围
        itemBuilder: (context, i) => RepaintBoundary(
          key: ValueKey('video_scroll_$i'),
          child: GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                }
                Get.toNamed(
                  "/video_detail",
                  arguments: {"id": videoPageData[i].id},
                  preventDuplicates: false,
                );
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
              begin: Alignment.centerLeft, // 对应 90deg (从左到右)
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFA35C), // rgb(255, 163, 92)
                Color(0xFFFF5821), // rgb(255, 88, 33)
              ],
            ),
          ),
          child: Text(
            VideoUtil.formatTag(item.pubdate ?? ""),
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
