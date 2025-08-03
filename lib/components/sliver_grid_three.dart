import 'package:flutter/material.dart';

import '../entity/video_page_entity.dart';

class SliverGridThree extends StatelessWidget {
  // final List<VideoPageDataList> videoPageData;
  final VideoPageDataList videoPageData; // 使用 dynamic 类型

  const SliverGridThree({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, i) =>
            GridTile(child: Card(child: Container(color: Colors.green))),
        childCount: 9,
      ),
    );
  }
}
