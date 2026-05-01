import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/play_line_entity.dart';
import '../../entity/video_detail_data_entity.dart';
import '../../entity/video_page_entity.dart';

class VideoItem {
  final String title;
  final String url;
  final String subTitle;

  VideoItem({required this.title, required this.url, required this.subTitle});
}

class VideoDetailService {
  final String id;
  final ValueNotifier<int> currentLine;
  final ValueNotifier<int> currentPlay;
  final Player player;

  VideoDetailService({
    required this.id,
    required this.currentLine,
    required this.currentPlay,
    required this.player,
  });

  Future<List<DictDataDataArea>?> getDictAreaData() async {
    try {
      final response = await Api.getDictData({
        "types": ["area"],
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get dict area data timeout'),
      );
      final dictData = response.data as DictDataData;
      debugPrint('Get dict area data success, count: ${dictData.area?.length ?? 0}');
      return dictData.area;
    } catch (e) {
      debugPrint('Get dict area data failed: $e');
      return [];
    }
  }

  Future<List<DictDataDataVideoCategory>?> getDictVideoCategoryData() async {
    try {
      final response = await Api.getDictData({
        "types": ["video_category"],
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get dict video category data timeout'),
      );
      final dictData = response.data as DictDataData;
      debugPrint('Get dict video category data success, count: ${dictData.videoCategory?.length ?? 0}');
      return dictData.videoCategory;
    } catch (e) {
      debugPrint('Get dict video category data failed: $e');
      return [];
    }
  }

  Future<List<DictDataDataLanguage>?> getDictLanguageData() async {
    try {
      final response = await Api.getDictData({
        "types": ["language"],
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get dict language data timeout'),
      );
      final dictData = response.data as DictDataData;
      debugPrint('Get dict language data success, count: ${dictData.language?.length ?? 0}');
      return dictData.language;
    } catch (e) {
      debugPrint('Get dict language data failed: $e');
      return [];
    }
  }

  Future<VideoDetailDataData> getVideoDetail() async {
    try {
      final response = await Api.getVideoDetail({"id": id}).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Get video detail timeout'),
      );
      return response.data as VideoDetailDataData;
    } catch (e) {
      debugPrint('Get video detail failed: $e');
      return VideoDetailDataData();
    }
  }

  Future<List<VideoPageDataList>> getVideoPages(int categoryId) async {
    try {
      final response = await Api.getVideoPages({
        "category_id": categoryId,
        "page": Random().nextInt(2) + 1,
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get video pages timeout'),
      );
      final list = response.data?.list ?? [];
      debugPrint('Get video pages success, count: ${list.length}');
      return list;
    } catch (e) {
      debugPrint('Get video pages failed: $e');
      return [];
    }
  }

  Future<List<VideoPageDataList>> getSelectVideoPages(Map<String, dynamic> params) async {
    try {
      final response = await Api.getVideoPages(params).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Get select video pages timeout'),
      );
      return response.data?.list ?? [];
    } catch (e) {
      debugPrint('Get select video pages failed: $e');
      return [];
    }
  }

  Future<void> addViews({
    required VideoDetailDataData videoInfoData,
    required int progress,
  }) async {
    try {
      if (videoInfoData.video?.id != null) {
        int videoDuration = 0;
        final duration = player.state.duration;
        if (duration.inMilliseconds > 0) {
          videoDuration = duration.inMilliseconds ~/ 1000;
        }

        await Api.addViews({
          "title": videoInfoData.video?.title,
          "associationId": videoInfoData.video?.id ?? 1,
          "viewingDuration": progress,
          "duration": videoDuration,
          "type": 19,
          "cover": videoInfoData.video?.surfacePlot ?? "",
          "videoIndex": currentPlay.value,
        }).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Add views timeout'),
        );
        debugPrint('Add views success');
      }
    } catch (e) {
      debugPrint('Add views failed: $e');
    }
  }

  Future<String> initialize({
    required VideoDetailDataData videoInfoData,
    required List<TDTab> tabs,
    required List<VideoItem> videoList,
    required Function(String) setVideoUrl,
    required Function() errorListener,
    required Function() loadAd,
    required Function() videoListener,
  }) async {
    try {
      tabs.clear();
      videoList.clear();

      final data = await getVideoDetail().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Video detail initialization timeout'),
      );

      videoInfoData.lines = data.lines;
      videoInfoData.video = data.video;

      if (videoInfoData.lines != null && videoInfoData.lines!.isNotEmpty) {
        for (var element in videoInfoData.lines!) {
          tabs.add(TDTab(text: element.collectionName ?? '线路'));
        }

        final selectedLine = videoInfoData.lines?[currentLine.value];
        final selectedPlayLine = selectedLine?.playLines?[currentPlay.value];
        setVideoUrl(selectedPlayLine?.file ?? "");

        if (selectedLine?.playLines != null) {
          final playerLineData = selectedLine?.playLines ?? [];
          if (playerLineData.isNotEmpty) {
            videoList.addAll(
              playerLineData.map((playLine) => VideoItem(
                title: playLine.videoName ?? "",
                url: playLine.file ?? "",
                subTitle: playLine.subTitle ?? "",
              )),
            );
          }
        }
      } else {
        tabs.add(TDTab(text: "默认线路"));
        videoList.add(VideoItem(
          title: videoInfoData.video?.title ?? "视频",
          url: "",
          subTitle: "暂无播放链接",
        ));
      }

      await Future.wait([
        getDictVideoCategoryData().then((data) {}),
        getDictLanguageData().then((data) {}),
        getDictAreaData().then((data) {}),
        getVideoPages(videoInfoData.video?.categoryId ?? 0).then((data) {}),
      ]).timeout(
        const Duration(seconds: 10),
        onTimeout: () => [],
      );

      errorListener();
      loadAd();
      videoListener();

      return "init success";
    } catch (e) {
      debugPrint('Initialization error: $e');
      return "init success";
    }
  }
}
