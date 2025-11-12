import 'dart:async';

import '../api/api.dart';
import '../entity/album_entity.dart';
import '../entity/dict_data_entity.dart';
import '../entity/notice_Info_entity.dart';
import '../entity/swiper_entity.dart';

class HomePrefetchData {
  HomePrefetchData({
    required this.categories,
    required this.videoCategoryIds,
    required this.swiperMap,
    required this.albumMap,
    required this.noticeInfo,
  });

  final List<DictDataDataVideoCategory> categories;
  final List<int> videoCategoryIds;
  final Map<int, List<SwiperDataList>> swiperMap;
  final Map<int, List<AlbumDataList>> albumMap;
  final List<NoticeInfoDataList> noticeInfo;

  bool get isValid => categories.isNotEmpty && videoCategoryIds.isNotEmpty;
}

class HomePrefetchService {
  HomePrefetchService._();

  static final HomePrefetchService instance = HomePrefetchService._();

  HomePrefetchData? _cachedData;
  bool _isPreloading = false;

  HomePrefetchData? get cachedData => _cachedData;

  Future<HomePrefetchData?> preload({bool force = false}) async {
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
      final dictResponse = await Api.getDictData({
        "types": ["video_category"],
      });
      final dictData = dictResponse.data as DictDataData?;

      final categories = dictData?.videoCategory
              ?.where((element) => element.parentId == null)
              .toList(growable: false) ??
          <DictDataDataVideoCategory>[];

      if (categories.isEmpty) {
        _cachedData = HomePrefetchData(
          categories: const [],
          videoCategoryIds: const [],
          swiperMap: const {},
          albumMap: const {},
          noticeInfo: const [],
        );
        return _cachedData;
      }

      final categoryIds = categories
          .map((e) => e.id)
          .whereType<int>()
          .toList(growable: false);

      final results = await Future.wait<dynamic>([
        Api.getSwiperListByCategoryIds(categoryIds),
        Api.getAlbumListByCategoryIds(categoryIds),
        Api.noticeInfo({
          "page": 1,
          "size": 1,
          "type": 637,
          "status": 1,
        }),
      ]);

      final swiperMap =
          results[0] as Map<int, List<SwiperDataList>>? ?? <int, List<SwiperDataList>>{};
      final albumMap =
          results[1] as Map<int, List<AlbumDataList>>? ?? <int, List<AlbumDataList>>{};
      final noticeResponse = results[2];
      final noticeInfo = (noticeResponse.data?.list ?? <NoticeInfoDataList>[])
          .toList(growable: false);

      _cachedData = HomePrefetchData(
        categories: categories,
        videoCategoryIds: categoryIds,
        swiperMap: swiperMap,
        albumMap: albumMap,
        noticeInfo: noticeInfo,
      );
      return _cachedData;
    } catch (_) {
      _cachedData = null;
      rethrow;
    } finally {
      _isPreloading = false;
    }
  }

  void cache(HomePrefetchData data) => _cachedData = data;

  void clear() {
    _cachedData = null;
  }
}

