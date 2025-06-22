import 'package:flutter/material.dart';

import '../entity/video_page_entity.dart';
import '../utils/video.dart';
import '../views/video_detail/detail.dart';

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

  void _buildvideo_onClick(int id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  Widget _buildVideoItemOverlay(dynamic item, BuildContext context) {
    return GestureDetector(
      onTap: () => {_buildvideo_onClick(item.id ?? 0, context)},
      child: Container(
        width: 130,
        height: 175,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildVideoItemHDTag(item), _buildVideoItemNote(item)],
        ),
      ),
    );
  }

  Widget _buildVideoItemNote(dynamic item) {
    if (item?.remarks == null) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromRGBO(0, 0, 0, 0.302),
          ),
          child: Text(item?.remarks ?? '', style: _videoNoteTextStyle),
        ),
      ],
    );
  }

  Widget _buildVideoItemHDTag(dynamic item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4, top: 2),
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
            VideoUtil.formatTag(item?.pubdate ?? ""),
            style: _hdTagTextStyle,
          ),
        ),
      ],
    );
  }

  static const _hdTagTextStyle = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static const _videoNoteTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
}
