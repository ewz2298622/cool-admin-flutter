import 'dart:async';

import '../api/api.dart';
import '../entity/dict_data_entity.dart';
import '../entity/dict_info_list_entity.dart';

class VideoFilterPrefetchData {
  VideoFilterPrefetchData({
    required this.categoryData,
    required this.tagData,
    required this.areaData,
  });

  final List<DictDataDataVideoCategory> categoryData;
  final List<DictDataDataVideoTag> tagData;
  final List<DictInfoListData> areaData;

  bool get isValid =>
      categoryData.isNotEmpty || tagData.isNotEmpty || areaData.isNotEmpty;
}

class VideoFilterPrefetchService {
  VideoFilterPrefetchService._();

  static final VideoFilterPrefetchService instance =
      VideoFilterPrefetchService._();

  VideoFilterPrefetchData? _cachedData;
  bool _isPreloading = false;

  VideoFilterPrefetchData? get cachedData => _cachedData;

  Future<VideoFilterPrefetchData?> preload({bool force = false}) async {
    if (!force && _cachedData != null && _cachedData!.isValid) {
      return _cachedData;
    }

    if (_isPreloading) {
      while (_isPreloading) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      return _cachedData;
    }

    _isPreloading = true;
    try {
      // 并行执行所有预加载任务
      final results = await Future.wait([
        // 获取视频分类数据
        Api.getDictData({
          "types": ["video_category"],
        }),
        // 获取视频标签数据
        Api.getDictData({
          "types": ["video_tag"],
        }),
        // 获取地区数据
        Api.getDictInfoPages({
          "order": "orderNum",
          "sort": "desc",
          "typeId": 39,
        }),
      ]);

      final categoryResponse = results[0] as DictDataEntity;
      final tagResponse = results[1] as DictDataEntity;
      final areaResponse = results[2] as DictInfoListEntity;

      final categoryResponseData = categoryResponse.data;
      final tagResponseData = tagResponse.data;
      final areaResponseData = areaResponse.data;

      final DictDataData? categoryDictData =
          categoryResponseData is DictDataData ? categoryResponseData : null;
      final DictDataData? tagDictData =
          tagResponseData is DictDataData ? tagResponseData : null;
      final List<DictInfoListData>? areaListData =
          areaResponseData is List
              ? areaResponseData?.cast<DictInfoListData>()
              : null;

      final categoryData =
          categoryDictData?.videoCategory
              ?.where((element) => element.parentId == null)
              .toList(growable: false) ??
          <DictDataDataVideoCategory>[];

      final tagData =
          tagDictData?.videoTag?.toList(growable: false) ??
          <DictDataDataVideoTag>[];

      final areaData =
          areaListData
              ?.where((element) => element.parentId == null)
              .toList(growable: false) ??
          <DictInfoListData>[];

      _cachedData = VideoFilterPrefetchData(
        categoryData: categoryData,
        tagData: tagData,
        areaData: areaData,
      );

      return _cachedData;
    } catch (e) {
      print('VideoFilter prefetch failed: $e');
      _cachedData = null;
      rethrow;
    } finally {
      _isPreloading = false;
    }
  }

  void cache(VideoFilterPrefetchData data) => _cachedData = data;

  void clear() {
    _cachedData = null;
  }
}
