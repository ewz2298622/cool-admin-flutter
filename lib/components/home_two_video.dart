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
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List<Widget>.generate(
        album.list?.length ?? 0,
        (index) =>
            _buildAlbumItem(album.list?[index] ?? AlbumDataListList(), context),
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
    return Container(
      width: 180,
      height: 100,
      decoration: BoxDecoration(
        //圆角
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAlbumItemHDTag(item),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent, // 顶部透明
                    Colors.black.withOpacity(0.7), // 底部黑色
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: _buildAlbumItemNote(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumItemHDTag(AlbumDataListList item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          margin: EdgeInsets.only(right: 4, top: 4), // 调整内边距
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(59, 101, 244, 1),
                Color.fromRGBO(64, 177, 254, 1),
              ],
            ),
          ),
          alignment: Alignment.center, // 关键：强制内容居中
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
    if (item.categoryPid != 537) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4, top: 2),
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: 4,
              right: 4,
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
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
    } else {
      double doubanScore = item.doubanScore!.toDouble() / 100;
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4, top: 2),
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: 4,
              right: 4,
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Text(
              doubanScore.toString(),
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromRGBO(255, 102, 0, 1),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildAlbumItemTitle(AlbumDataListList item) {
    return SizedBox(
      width: 180,
      child: Text(
        item.title ?? '',
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildAlbumItemSubTitle(AlbumDataListList item) {
    //定义一个变量如果item.subTitle不为空则显示item.subTitle，否则显示item.videoTag
    String subTitle = item.subTitle ?? '';
    subTitle = subTitle.isEmpty ? item.videoTag ?? '' : subTitle;
    return SizedBox(
      width: 180,
      child: Text(
        subTitle ?? '',
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          color: Colors.grey,
          fontSize: 12,
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
          _buildAlbumItemSubTitle(item),
        ],
      ),
    );
  }
}
