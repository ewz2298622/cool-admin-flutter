import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/album_entity.dart';
import '../utils/video.dart';
import '../views/video_detail/detail.dart';

class HomeTwoVideo extends StatelessWidget {
  final AlbumDataList videoPageData;

  const HomeTwoVideo({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return _buildAlbumItems(videoPageData, context);
  }

  Widget _buildAlbumItems(AlbumDataList album, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List<Widget>.generate(
          album.list?.length ?? 0,
          (index) => _buildAlbumItem(
            album.list?[index] ?? AlbumDataListList(),
            context,
          ),
        ),
      ),
    );
  }

  void _buildAlbumItem_onClick(int id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  Widget _buildAlbumItemImage(AlbumDataListList item) {
    return SizedBox(
      width: 180,
      height: 100,
      child: TDImage(
        fit: BoxFit.cover,
        width: 200,
        imgUrl: item.surfacePlot ?? '',
        errorWidget: const TDImage(
          fit: BoxFit.cover,
          width: 180,
          assetUrl: 'assets/images/loading.gif',
        ),
      ),
    );
  }

  Widget _buildAlbumItemOverlay(AlbumDataListList item) {
    return SizedBox(
      width: 180,
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildAlbumItemHDTag(item), _buildAlbumItemNote(item)],
        ),
      ),
    );
  }

  Widget _buildAlbumItemHDTag(AlbumDataListList item) {
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
            VideoUtil.formatTag(item.pubdate ?? ""),
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

  Widget _buildAlbumItemNote(AlbumDataListList item) {
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
          child: Text(
            item.remarks ?? "",
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumItemTitle(dynamic item) {
    return SizedBox(
      width: 180,
      child: Text(
        item?.title ?? '',
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildAlbumItem(AlbumDataListList item, BuildContext context) {
    return GestureDetector(
      onTap:
          () => _buildAlbumItem_onClick(
            item.id ?? 0,
            context,
          ), //写入方法名称就可以了，但是是无参的
      child: Column(
        //添加点击事件
        children: [
          Stack(
            children: [
              _buildAlbumItemImage(item),
              _buildAlbumItemOverlay(item),
            ],
            //添加点击事件
          ),
          _buildAlbumItemTitle(item),
        ],
      ),
    );
  }
}
