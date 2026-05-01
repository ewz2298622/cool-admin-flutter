import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../entity/video_detail_data_entity.dart';
import '../../../entity/dict_data_entity.dart';
import '../../../style/layout.dart';
import '../../../utils/dict.dart';
import '../../../utils/video.dart';
import 'sponsor_bar.dart';

class VideoInfoSection extends StatelessWidget {
  final VideoDetailDataData videoInfoData;
  final List<DictDataDataArea>? area;
  final List<DictDataDataVideoCategory>? videoCategory;
  final List<DictDataDataLanguage>? language;
  final ValueNotifier<int> currentLine;
  final ValueNotifier<int> currentPlay;
  final VoidCallback showModalBottomSheetList;
  final Function(String) setVideoUrl;

  const VideoInfoSection({
    super.key,
    required this.videoInfoData,
    required this.area,
    required this.videoCategory,
    required this.language,
    required this.currentLine,
    required this.currentPlay,
    required this.showModalBottomSheetList,
    required this.setVideoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Layout.paddingL, right: Layout.paddingR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          _buildTitle(),
          _buildTags(),
          const SponsorBar(),
          _buildEpisodeList(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            videoInfoData.video?.title ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(255, 153, 0, 0.1),
              Color.fromRGBO(255, 153, 0, 1),
            ],
          ).createShader(bounds),
          child: Text(
            VideoUtil.formatScore(videoInfoData.video?.doubanScore),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(255, 153, 0, 1),
              letterSpacing: -2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            videoInfoData.video?.year.toString() ?? "暂无数据",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
          Text(
            Dict.getDictName(videoInfoData.video?.region ?? 0, area ?? []),
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          Text(
            Dict.getDictName(videoInfoData.video?.categoryId ?? 0, videoCategory ?? []),
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          Text(
            Dict.getDictName(videoInfoData.video?.language ?? 0, language ?? []),
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          Text(
            (videoInfoData.video?.videoTag ?? "暂无标签").replaceAll(",", "/"),
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ]
            .map((e) => Padding(padding: const EdgeInsets.only(right: 12), child: e))
            .toList(),
      ),
    );
  }

  Widget _buildEpisodeList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      child: Column(
        spacing: 12,
        children: [
          _buildEpisodeHeader(),
          _buildPlayer(),
        ],
      ),
    );
  }

  Widget _buildEpisodeHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '选集',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: showModalBottomSheetList,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        videoInfoData.video?.remarks ?? "暂无描述",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayer() {
    if (videoInfoData.lines == null || videoInfoData.lines!.isEmpty) {
      return Container(
        height: 44,
        alignment: Alignment.centerLeft,
        child: const Text(
          "暂无播放线路",
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
        ),
      );
    }

    return ValueListenableBuilder<int>(
      valueListenable: currentLine,
      builder: (context, lineIndex, child) {
        final selectedLine = videoInfoData.lines?[lineIndex];
        final playLines = selectedLine?.playLines ?? [];

        if (playLines.isEmpty) {
          return Container(
            height: 44,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: showModalBottomSheetList,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TDLink(
                    linkClick: (url) => showModalBottomSheetList(),
                    style: TDLinkStyle.primary,
                    label: '当前线路暂无数据,建议切换线路',
                    type: TDLinkType.withSuffixIcon,
                    size: TDLinkSize.medium,
                  ),
                ],
              ),
            ),
          );
        }

        return ValueListenableBuilder<int>(
          valueListenable: currentPlay,
          builder: (context, playIndex, child) {
            return SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: playLines.length,
                itemBuilder: (context, index) {
                  final item = playLines[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        SizedBox(
                          width: 108,
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: playIndex == index
                                  ? const Color.fromRGBO(252, 119, 66, 1)
                                  : const Color(0xFFF3F4F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: playIndex == index ? 2 : 0,
                              shadowColor: playIndex == index
                                  ? const Color.fromRGBO(252, 119, 66, 0.3)
                                  : Colors.transparent,
                            ),
                            onPressed: () {
                              try {
                                if (item.vip == 1 && (item.file ?? "").isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "请开通VIP后重试",
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                  return;
                                }
                                currentPlay.value = index;
                                final currentSelectedLine =
                                    videoInfoData.lines?[currentLine.value];
                                final currentPlayLines =
                                    currentSelectedLine?.playLines ?? [];
                                if (index < currentPlayLines.length) {
                                  setVideoUrl(currentPlayLines[index].file ?? "");
                                }
                              } catch (e) {
                                debugPrint("切换选集：${e.toString()}");
                              }
                            },
                            child: Text(
                              item.name ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: playIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: playIndex == index
                                    ? Colors.white
                                    : const Color(0xFF111827),
                              ),
                            ),
                          ),
                        ),
                        if (item.vip == 1)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAB308),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'VIP',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
