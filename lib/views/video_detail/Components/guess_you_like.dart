import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../../components/sectionWithMore.dart';
import '../../../../components/video_scroll.dart';
import '../../../../style/layout.dart';

/// 猜你喜欢组件
/// 用于展示视频详情页面的推荐视频列表
class GuessYouLike extends StatelessWidget {
  final List<dynamic> videoPageData;
  final VoidCallback? onVideoTap;

  const GuessYouLike({
    super.key,
    required this.videoPageData,
    this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: Layout.paddingL,
        right: Layout.paddingR,
        top: Layout.paddingT,
        bottom: Layout.paddingB,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          SectionWithMore(title: "猜你喜欢"),
          HorizontalVideoList(
            videoPageData: videoPageData,
            onTap: onVideoTap,
          ),
        ],
      ),
    );
  }
}
