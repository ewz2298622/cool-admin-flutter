import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/album_entity.dart';
import '../utils/video.dart';
import '../views/video_detail/detail.dart';

class HomeTwoVideo extends StatelessWidget {
  final List<dynamic> videoPageData;

  const HomeTwoVideo({super.key, required this.videoPageData});

  @override
  Widget build(BuildContext context) {
    return _buildAlbumItems(videoPageData, context);
  }

  Widget _buildAlbumItems(List<dynamic> album, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 获取当前屏幕方向
        final mediaQuery = MediaQuery.of(context);
        final isPortrait = mediaQuery.orientation == Orientation.portrait;

        // 根据屏幕方向设置最大宽度和间距
        const double maxItemWidthPortrait = 150.0;
        const double maxItemWidthLandscape = 200.0;
        const double crossAxisSpacingPortrait = 10.0;
        const double crossAxisSpacingLandscape = 15.0;

        final double maxItemWidth =
            isPortrait ? maxItemWidthPortrait : maxItemWidthLandscape;
        final double crossAxisSpacing =
            isPortrait ? crossAxisSpacingPortrait : crossAxisSpacingLandscape;

        // 计算每行能放多少个 item
        final screenWidth = constraints.maxWidth;
        final crossAxisCount =
            (screenWidth / (maxItemWidth + crossAxisSpacing)).floor();
        final finalCrossAxisCount = crossAxisCount >= 1 ? crossAxisCount : 1;

        // 重构album 从0开始截取到finalCrossAxisCount的整数倍
        final itemCount = finalCrossAxisCount * 2;
        final actualItemCount =
            album.length > itemCount ? itemCount : album.length;
        album = album.sublist(0, actualItemCount);

        // 计算实际 item 宽度（考虑间距）
        final itemWidth =
            (screenWidth - (finalCrossAxisCount - 1) * crossAxisSpacing) /
            finalCrossAxisCount;

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            //添加自动换行
            spacing: crossAxisSpacing, // 横向间距
            runSpacing: 5, // 纵向间距（可调整）
            // 添加换行参数以解决换行报错问题
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            //自动换行
            children: List.generate(
              album.length,
              (index) => SizedBox(
                width: itemWidth, // 固定宽度
                child: _buildAlbumItem(
                  album[index] ?? AlbumDataListList(),
                  context,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _buildAlbumItem_onClick(int id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  Widget _buildAlbumItemImage(AlbumDataListList item) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 100),
      child: SizedBox(
        child: TDImage(
          width: double.infinity,
          height: 100,
          fit: BoxFit.cover,
          imgUrl: item.surfacePlot ?? '',
          errorWidget: const TDImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            assetUrl: 'assets/images/loading.gif',
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumItemOverlay(AlbumDataListList item) {
    return Container(
      width: double.infinity,
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
                    Color.fromRGBO(217, 217, 217, 0), // 顶部透明
                    Color.fromRGBO(88, 88, 88, 1), // 部黑色
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
                Color.fromRGBO(253, 221, 68, 0.80),
                Color.fromRGBO(253, 221, 68, 0.80),
              ],
            ),
          ),
          alignment: Alignment.center, // 关键：强制内容居中
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

  Widget _buildAlbumItemNote(AlbumDataListList item) {
    if (item.categoryPid != 537) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                fontSize: 11.0,
                color: Colors.white,
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
                color: Color.fromRGBO(255, 102, 0, 1),
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                fontSize: 11.0,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildAlbumItemTitle(AlbumDataListList item) {
    return SizedBox(
      width: double.infinity,
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
    String subTitle =
        item.subTitle ?? VideoUtil.extractPlainText(item.introduce ?? "");
    subTitle = subTitle.isEmpty ? item.videoTag ?? '' : subTitle;
    return SizedBox(
      width: double.infinity,
      child: Text(
        subTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // 可选：添加圆角
        ), // 可选：添加内边距
        child: Column(
          mainAxisSize: MainAxisSize.min, // 高度自适应
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
      ),
    );
  }
}
