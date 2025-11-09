import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 视频横向滚动列表组件
class VideoViews extends StatelessWidget {
  final List<dynamic> videoPageData;

  const VideoViews({super.key, required this.videoPageData});

  // 常量定义
  static const double _listHeight = 80.0;
  static const double _itemWidth = 120.0;
  static const double _itemHeight = 80.0;
  static const double _itemPaddingRight = 4.0;
  static const double _titlePaddingHorizontal = 5.0;
  static const double _borderRadius = 5.0;
  static const double _overlayOpacity = 0.302;

  @override
  Widget build(BuildContext context) {
    if (videoPageData.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: _listHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        cacheExtent: 200, // 缓存范围，提高滚动性能
        itemCount: videoPageData.length,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            child: _VideoViewItem(
              videoData: videoPageData[index],
            ),
          );
        },
      ),
    );
  }
}

/// 单个视频项组件
class _VideoViewItem extends StatelessWidget {
  final dynamic videoData;

  const _VideoViewItem({required this.videoData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        "/video_detail",
        arguments: {"id": videoData.id},
      ),
      child: Container(
        width: VideoViews._itemWidth,
        height: VideoViews._itemHeight,
        padding: const EdgeInsets.only(right: VideoViews._itemPaddingRight),
        child: Stack(
          children: [
            Positioned.fill(
              child: TDImage(
                width: VideoViews._itemWidth,
                height: VideoViews._itemHeight,
                fit: BoxFit.cover,
                imgUrl: videoData.cover ?? "",
                errorWidget: const TDImage(
                  width: VideoViews._itemWidth,
                  height: VideoViews._itemHeight,
                  fit: BoxFit.cover,
                  assetUrl: 'assets/images/loading.gif',
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: VideoViews._titlePaddingHorizontal,
                    right: VideoViews._titlePaddingHorizontal,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(VideoViews._borderRadius),
                    color: const Color.fromRGBO(0, 0, 0, VideoViews._overlayOpacity),
                  ),
                  child: Text(
                    videoData.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
