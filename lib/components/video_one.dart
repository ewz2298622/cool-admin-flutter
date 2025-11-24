import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_page_entity.dart';
import '../utils/video.dart';

class VideoItem extends StatelessWidget {
  static const double _posterWidth = 130;
  static const double _posterHeight = 180;
  static const BorderRadius _posterBorderRadius = BorderRadius.all(Radius.circular(5));
  static const BorderRadius _tagBorderRadius = BorderRadius.all(Radius.circular(15));
  static const Color _tagTextColor = Color.fromRGBO(195, 161, 101, 1);
  static const Color _tagBackgroundColor = Color.fromRGBO(195, 161, 101, 0.1);
  static const double _hotIconSize = 20;
  static const LinearGradient _hdTagGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(59, 101, 244, 1),
      Color.fromRGBO(64, 177, 254, 1),
    ],
  );
  static const LinearGradient _overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color.fromRGBO(0, 0, 0, 0.7),
    ],
  );
  static const EdgeInsets _hdTagPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);

  final VideoPageDataList videoData;
  const VideoItem({super.key, required this.videoData});

  Widget _buildAlbumItems(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap:
            () => Get.toNamed("/video_detail", arguments: {"id": videoData.id}),

        child: Container(
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
        child: Row(
          spacing: 5,
          children: [
            ClipRRect(
              borderRadius: _posterBorderRadius,
              child: SizedBox(
                width: _posterWidth,
                height: _posterHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: _posterWidth,
                      height: _posterHeight,
                      imgUrl: videoData.surfacePlot ?? "",
                      errorWidget: const TDImage(
                        width: _posterWidth,
                        height: _posterHeight,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    _buildVideoItemOverlay(videoData),
                  ],
                ),
              ),
            ),
            Expanded(
              // 使用 Expanded 替代 SizedBox
              child: SizedBox(
                height: _posterHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            videoData.title ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Row(
                            //右对齐
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _formatCount((videoData.up ?? 0).toString()),
                                //最长四个 字
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(255, 101, 39, 1),
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/images/hot_surface.svg',
                                width: _hotIconSize,
                                height: _hotIconSize,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "${videoData.videoClass ?? ''} / ${videoData.videoTag ?? ''}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "${videoData.year ?? ''} / ${videoData.actors ?? ''}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // 修改: 使用Expanded包装Html组件以防止溢出
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          VideoUtil.extractPlainText(videoData.introduce ?? ""),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(153, 153, 153, 1),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        TDTag(
                          '${videoData.popularity ?? 0}万热度',
                          isLight: true,
                          backgroundColor: _tagBackgroundColor,
                          textColor: _tagTextColor,
                          shape: TDTagShape.round,
                          isOutline: true,
                          style: TDTagStyle(
                            borderColor: Colors.transparent,
                            borderRadius: _tagBorderRadius,
                          ),
                        ),
                        TDTag(
                          '${videoData.popularitySum ?? 0}万点赞',
                          isLight: true,
                          backgroundColor: _tagBackgroundColor,
                          textColor: _tagTextColor,
                          shape: TDTagShape.round,
                          isOutline: true,
                          style: TDTagStyle(
                            borderColor: Colors.transparent,
                            borderRadius: _tagBorderRadius,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
  //实现一个字符串格式化函数 最长截取四个字
  String _formatCount(String str) {
    return str.length > 4 ? str.substring(0, 4) : str;
  }

  Widget _buildVideoItemOverlay(VideoPageDataList item) {
    return IgnorePointer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildVideoItemHDTag(item),
          Container(
            decoration: const BoxDecoration(
              gradient: _overlayGradient,
            ),
            child: _buildVideoItemNote(item),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItemNote(VideoPageDataList item) {
    final remarks = item.remarks?.trim();
    if (remarks == null || remarks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      child: Text(
        remarks,
        textAlign: TextAlign.right,
        //缩进
        maxLines: 1, // 限制最大显示一行
        overflow: TextOverflow.ellipsis, // 溢出时显示省略号
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          //文字缩进
        ),
      ),
    );
  }

  Widget _buildVideoItemHDTag(VideoPageDataList item) {
    final tag = VideoUtil.formatTag(item.pubdate ?? "");
    if (tag.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10, top: 5),
          padding: _hdTagPadding,
          decoration: const BoxDecoration(
            borderRadius: _posterBorderRadius,
            gradient: _hdTagGradient,
          ),
          child: Text(
            tag,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAlbumItems(context);
  }
}

class VideoOne extends StatelessWidget {
  final VideoPageDataList videoData;

  const VideoOne({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return VideoItem(videoData: videoData);
  }
}
