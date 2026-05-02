import 'package:flutter/material.dart';

import '../../../../api/api.dart';
import '../../../../entity/video_page_entity.dart';
import '../../../../entity/dict_data_entity.dart';
import '../../../../components/select_option_detail.dart';
import '../../../../utils/video_player_utils.dart';
import 'video_info_card.dart';
import 'plot_section.dart';

/// 视频简介视图组件
/// 包含视频信息卡片、导演、演员和剧情简介
class VideoInfoView extends StatelessWidget {
  final dynamic videoInfoData;
  final List<DictDataDataArea>? area;
  final List<DictDataDataVideoCategory>? videoCategory;
  final List<DictDataDataLanguage>? language;

  const VideoInfoView({
    super.key,
    required this.videoInfoData,
    this.area,
    this.videoCategory,
    this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          VideoInfoCard(
            videoInfoData: videoInfoData,
            area: area,
            videoCategory: videoCategory,
            language: language,
          ),
          DynamicSelectOption(
            title: '导演',
            items: VideoPlayerUtils.formatString(videoInfoData.video?.directors ?? ""),
            paramsKey: 'directors',
            loadData: _loadDirectorData,
          ),
          DynamicSelectOption(
            title: '演员',
            items: VideoPlayerUtils.formatString(videoInfoData.video?.actors ?? ""),
            paramsKey: 'actors',
            loadData: _loadActorData,
          ),
          PlotSection(introduce: videoInfoData.video?.introduce),
        ],
      ),
    );
  }

  /// 加载导演数据
  Future<List<VideoPageDataList>> _loadDirectorData(Map<String, dynamic> params) async {
    List<VideoPageDataList> list =
        (await Api.getVideoPages(params)).data?.list ??
        [] as List<VideoPageDataList>;
    return list;
  }

  /// 加载演员数据
  Future<List<VideoPageDataList>> _loadActorData(Map<String, dynamic> params) async {
    List<VideoPageDataList> list =
        (await Api.getVideoPages(params)).data?.list ??
        [] as List<VideoPageDataList>;
    return list;
  }
}
