import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../../entity/dict_data_entity.dart';
import '../../../../utils/dict.dart';

/// 视频信息卡片组件
/// 展示视频封面、标题、评分、分类、标签等基本信息
class VideoInfoCard extends StatelessWidget {
  final dynamic videoInfoData;
  final List<DictDataDataArea>? area;
  final List<DictDataDataVideoCategory>? videoCategory;
  final List<DictDataDataLanguage>? language;

  const VideoInfoCard({
    super.key,
    required this.videoInfoData,
    this.area,
    this.videoCategory,
    this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCoverImage(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 8,
            children: [
              _buildTitle(),
              _buildRating(),
              _buildClassAndTag(),
              _buildTags(),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建封面图片
  Widget _buildCoverImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: TDImage(
          width: 140,
          height: 100,
          fit: BoxFit.cover,
          imgUrl: videoInfoData.video?.surfacePlot ?? "",
          errorWidget: const TDImage(
            width: 140,
            height: 100,
            fit: BoxFit.cover,
            assetUrl: 'assets/images/loading.gif',
          ),
        ),
      ),
    );
  }

  /// 构建标题
  Widget _buildTitle() {
    return Text(
      videoInfoData.video?.title ?? "",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF111827),
        height: 1.3,
      ),
    );
  }

  /// 构建评分
  Widget _buildRating() {
    return TDRate(
      value: (videoInfoData.video?.doubanScore ?? 0).toDouble(),
      disabled: true,
    );
  }

  /// 构建分类和标签
  Widget _buildClassAndTag() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 6,
        children: [
          Text(
            videoInfoData.video?.videoClass ?? "暂无分类",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
          Text(
            (videoInfoData.video?.videoTag ?? "暂无标签")
                .replaceAll(",", "/"),
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建标签组
  Widget _buildTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          TDTag(
            videoInfoData.video?.year.toString() ?? "暂无上映时间",
            isLight: true,
            theme: TDTagTheme.primary,
          ),
          TDTag(
            Dict.getDictName(
              videoInfoData.video?.region ?? 0,
              area ?? [],
            ),
            isLight: true,
            theme: TDTagTheme.primary,
          ),
          TDTag(
            Dict.getDictName(
              videoInfoData.video?.categoryId ?? 0,
              videoCategory ?? [],
            ),
            isLight: true,
            theme: TDTagTheme.primary,
          ),
          TDTag(
            Dict.getDictName(
              videoInfoData.video?.language ?? 0,
              language ?? [],
            ),
            isLight: true,
            theme: TDTagTheme.primary,
          ),
        ],
      ),
    );
  }
}
