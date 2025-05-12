import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_page_entity.g.dart';

export 'package:flutter_app/generated/json/video_page_entity.g.dart';

@JsonSerializable()
class VideoPageEntity {
  int? code;
  String? message;
  VideoPageData? data;

  VideoPageEntity();

  factory VideoPageEntity.fromJson(Map<String, dynamic> json) =>
      $VideoPageEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoPageEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoPageData {
  List<VideoPageDataList>? list;
  VideoPageDataPagination? pagination;

  VideoPageData();

  factory VideoPageData.fromJson(Map<String, dynamic> json) =>
      $VideoPageDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoPageDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoPageDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  dynamic updateUserId;
  String? title;
  @JSONField(name: 'surface_plot')
  String? surfacePlot;
  dynamic recommend;
  String? cycle;
  @JSONField(name: 'cycle_img')
  dynamic cycleImg;
  @JSONField(name: 'charging_mode')
  String? chargingMode;
  @JSONField(name: 'buy_mode')
  dynamic buyMode;
  dynamic gold;
  String? directors;
  String? actors;
  @JSONField(name: 'imdb_score')
  String? imdbScore;
  @JSONField(name: 'imdb_score_id')
  String? imdbScoreId;
  @JSONField(name: 'douban_score')
  int? doubanScore;
  @JSONField(name: 'douban_score_id')
  String? doubanScoreId;
  String? introduce;
  @JSONField(name: 'popularity_day')
  String? popularityDay;
  @JSONField(name: 'popularity_week')
  String? popularityWeek;
  @JSONField(name: 'popularity_month')
  String? popularityMonth;
  @JSONField(name: 'popularity_sum')
  String? popularitySum;
  dynamic note;
  String? year;
  @JSONField(name: 'album_id')
  dynamic albumId;
  String? status;
  dynamic duration;
  dynamic label;
  String? number;
  String? total;
  @JSONField(name: 'horizontal_poster')
  String? horizontalPoster;
  @JSONField(name: 'vertical_poster')
  dynamic verticalPoster;
  dynamic publish;
  @JSONField(name: 'serial_number')
  dynamic serialNumber;
  dynamic screenshot;
  dynamic gif;
  dynamic alias;
  @JSONField(name: 'release_at')
  dynamic releaseAt;
  @JSONField(name: 'shelf_at')
  dynamic shelfAt;
  dynamic end;
  dynamic unit;
  dynamic watch;
  @JSONField(name: 'use_local_image')
  dynamic useLocalImage;
  @JSONField(name: 'titles_time')
  int? titlesTime;
  @JSONField(name: 'trailer_time')
  int? trailerTime;
  @JSONField(name: 'play_url')
  String? playUrl;
  @JSONField(name: 'play_url_put_in')
  int? playUrlPutIn;
  @JSONField(name: 'category_id')
  int? categoryId;
  int? region;
  int? language;

  VideoPageDataList();

  factory VideoPageDataList.fromJson(Map<String, dynamic> json) =>
      $VideoPageDataListFromJson(json);

  Map<String, dynamic> toJson() => $VideoPageDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoPageDataPagination {
  int? page;
  int? size;
  int? total;

  VideoPageDataPagination();

  factory VideoPageDataPagination.fromJson(Map<String, dynamic> json) =>
      $VideoPageDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $VideoPageDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
