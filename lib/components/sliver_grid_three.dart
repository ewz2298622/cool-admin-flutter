import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_page_entity.dart';
import '../utils/video.dart';

/// 三列网格 Sliver 组件，用于展示视频海报
class SliverGridThree extends StatelessWidget {
  final List<VideoPageDataList> videoList;
  final EdgeInsetsGeometry padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final int crossAxisCount;

  const SliverGridThree({
    super.key,
    required this.videoList,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.childAspectRatio = 0.68,
    this.crossAxisCount = 3,
  }) : assert(crossAxisCount > 0, 'crossAxisCount 需大于 0');

  static const double _imageBorderRadius = 8;
  static const double _titleFontSize = 14;
  static const double _subTitleFontSize = 12;
  static const double _titleSpacing = 6;
  static const double _itemPadding = 6;

  @override
  Widget build(BuildContext context) {
    if (videoList.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: padding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= videoList.length) {
              return const SizedBox.shrink();
            }
            final item = videoList[index];
            return _GridVideoItem(videoData: item);
          },
          childCount: videoList.length,
        ),
      ),
    );
  }
}

class _GridVideoItem extends StatelessWidget {
  final VideoPageDataList videoData;

  const _GridVideoItem({required this.videoData});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          final id = videoData.id;
          if (id == null) return;
          Get.toNamed(
            "/video_detail",
            arguments: {"id": id},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SliverGridThree._imageBorderRadius),
                child: TDImage(
                  imgUrl: videoData.surfacePlot ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorWidget: const TDImage(
                    assetUrl: 'assets/images/loading.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: SliverGridThree._titleSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SliverGridThree._itemPadding),
              child: Text(
                videoData.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: SliverGridThree._titleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SliverGridThree._itemPadding),
              child: Text(
                VideoUtil.formatTag(videoData.pubdate ?? ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: SliverGridThree._subTitleFontSize,
                  color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.7) ??
                      const Color(0xB3FFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
