import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class VideoViews extends StatelessWidget {
  final List<dynamic> videoPageData;

  const VideoViews({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          videoPageData.length,
          (i) => GestureDetector(
            onTap:
                () =>
                    () => Get.toNamed(
                      "/video_detail",
                      arguments: {"id": videoPageData[i].id},
                    ),
            child: Container(
              width: 120,
              height: 80,
              padding: const EdgeInsets.only(right: 4),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: TDImage(
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                      imgUrl: videoPageData[i].cover ?? "",
                      errorWidget: const TDImage(
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(0, 0, 0, 0.302),
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
}
