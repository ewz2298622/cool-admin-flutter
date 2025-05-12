import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_detail_entity.g.dart';

export 'package:flutter_app/generated/json/video_detail_entity.g.dart';

@JsonSerializable()
class VideoDetailEntity {
  int? code;
  String? message;
  VideoDetailData? data;

  VideoDetailEntity();

  factory VideoDetailEntity.fromJson(Map<String, dynamic> json) =>
      $VideoDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoDetailEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoDetailData {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  dynamic updateUserId;
  String? title;
  @JSONField(name: 'category_id')
  int? categoryId;
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
  int? region;
  int? language;
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

  VideoDetailData();

  factory VideoDetailData.fromJson(Map<String, dynamic> json) =>
      $VideoDetailDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoDetailDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
