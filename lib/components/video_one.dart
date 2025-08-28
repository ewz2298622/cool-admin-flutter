import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_page_entity.dart';
import '../utils/video.dart';

class VideoItem extends StatelessWidget {
  final List<VideoPageDataList> videoData;
  const VideoItem({super.key, required this.videoData});

  Widget _buildAlbumItems(BuildContext context) {
    return ListView.builder(
      itemCount: videoData.length,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap:
              () => Get.toNamed(
                "/video_detail",
                arguments: {"id": videoData[index].id},
              ),

          child: Container(
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
            child: Row(
              spacing: 5,
              children: [
                Stack(
                  children: [
                    TDImage(
                      fit: BoxFit.cover,
                      width: 130,
                      height: 180,
                      imgUrl: videoData[index].surfacePlot ?? "",
                      errorWidget: const TDImage(
                        width: 130,
                        height: 180,
                        assetUrl: 'assets/images/loading.gif',
                      ),
                    ),
                    _buildVideoItemOverlay(videoData[index]),
                  ],
                ),
                Expanded(
                  // 使用 Expanded 替代 SizedBox
                  child: SizedBox(
                    height: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 250,
                              child: Text(
                                videoData[index].title ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${videoData[index].up ?? 0}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(255, 101, 39, 1),
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/images/hot_surface.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "${videoData[index].videoClass ?? ''} / ${videoData[index].videoTag ?? ''}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "${videoData[index].year ?? ''} / ${videoData[index].actors ?? ''}",
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
                              VideoUtil.extractPlainText(
                                videoData[index].introduce ?? "",
                              ),
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
                              '${videoData[index].popularity ?? 0}万热度',
                              isLight: true,
                              backgroundColor: Color.fromRGBO(
                                195,
                                161,
                                101,
                                0.1,
                              ),
                              textColor: Color.fromRGBO(195, 161, 101, 1),
                              shape: TDTagShape.round,
                              isOutline: true,
                              style: TDTagStyle(
                                borderColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            TDTag(
                              '${videoData[index].popularitySum ?? 0}万点赞',
                              isLight: true,
                              backgroundColor: Color.fromRGBO(
                                195,
                                161,
                                101,
                                0.1,
                              ),
                              textColor: Color.fromRGBO(195, 161, 101, 1),
                              shape: TDTagShape.round,
                              isOutline: true,
                              style: TDTagStyle(
                                borderColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
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
        );
      },
    );
  }

  Widget _buildVideoItemOverlay(VideoPageDataList item) {
    return Container(
      width: 130,
      height: 175,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildVideoItemHDTag(item),
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
            child: _buildVideoItemNote(item),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItemNote(VideoPageDataList item) {
    if (item.remarks == null) {
      return Container();
    }
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 5),
        child: Text(
          item.remarks ?? '',
          textAlign: TextAlign.right,
          //缩进
          maxLines: 1, // 限制最大显示一行
          overflow: TextOverflow.ellipsis, // 溢出时显示省略号
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            //文字缩进
          ),
        ),
      ),
    );
  }

  Widget _buildVideoItemHDTag(VideoPageDataList item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10, top: 5),
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

  @override
  Widget build(BuildContext context) {
    return _buildAlbumItems(context);
  }
}

class VideoOne extends StatelessWidget {
  final List<VideoPageDataList> videoData;

  const VideoOne({super.key, required this.videoData});

  @override
  Widget build(BuildContext context) {
    return VideoItem(videoData: videoData);
  }
}
