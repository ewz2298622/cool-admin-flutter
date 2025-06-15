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
  @JSONField(name: 'category_pid')
  int? categoryPid;
  @JSONField(name: 'surface_plot')
  String? surfacePlot;
  String? cycle;
  @JSONField(name: 'cycle_img')
  dynamic cycleImg;
  dynamic directors;
  dynamic actors;
  @JSONField(name: 'imdb_score')
  String? imdbScore;
  @JSONField(name: 'imdb_score_id')
  String? imdbScoreId;
  @JSONField(name: 'douban_score')
  int? doubanScore;
  @JSONField(name: 'douban_score_id')
  String? doubanScoreId;
  String? introduce;
  String? popularity;
  @JSONField(name: 'popularity_day')
  String? popularityDay;
  @JSONField(name: 'popularity_week')
  String? popularityWeek;
  @JSONField(name: 'popularity_month')
  String? popularityMonth;
  @JSONField(name: 'popularity_sum')
  String? popularitySum;
  dynamic note;
  int? year;
  String? status;
  dynamic duration;
  int? region;
  int? language;
  String? number;
  String? total;
  @JSONField(name: 'horizontal_poster')
  String? horizontalPoster;
  String? remarks;
  @JSONField(name: 'vertical_poster')
  dynamic verticalPoster;
  dynamic publish;
  String? pubdate;
  @JSONField(name: 'serial_number')
  dynamic serialNumber;
  dynamic screenshot;
  int? end;
  dynamic unit;
  @JSONField(name: 'play_url')
  String? playUrl;
  @JSONField(name: 'play_url_put_in')
  int? playUrlPutIn;
  @JSONField(name: 'collection_id')
  int? collectionId;
  dynamic up;
  dynamic down;
  @JSONField(name: 'collection_name')
  String? collectionName;

  VideoDetailData();

  factory VideoDetailData.fromJson(Map<String, dynamic> json) =>
      $VideoDetailDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoDetailDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
