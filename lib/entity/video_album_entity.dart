import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_album_entity.g.dart';

export 'package:flutter_app/generated/json/video_album_entity.g.dart';

@JsonSerializable()
class VideoAlbumEntity {
  int? code;
  String? message;
  VideoAlbumData? data;

  VideoAlbumEntity();

  factory VideoAlbumEntity.fromJson(Map<String, dynamic> json) =>
      $VideoAlbumEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoAlbumEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoAlbumData {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic createUserId;
  dynamic updateUserId;
  String? title;
  dynamic name;
  @JSONField(name: 'surface_plot')
  String? surfacePlot;
  String? recommend;
  String? status;
  dynamic introduce;
  @JSONField(name: 'popularity_day')
  String? popularityDay;
  @JSONField(name: 'popularity_week')
  String? popularityWeek;
  @JSONField(name: 'popularity_month')
  String? popularityMonth;
  @JSONField(name: 'popularity_sum')
  String? popularitySum;
  dynamic note;
  int? sort;
  int? type;
  @JSONField(name: 'create_at')
  dynamic createAt;
  @JSONField(name: 'update_at')
  dynamic updateAt;
  @JSONField(name: 'site_id')
  dynamic siteId;

  VideoAlbumData();

  factory VideoAlbumData.fromJson(Map<String, dynamic> json) =>
      $VideoAlbumDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoAlbumDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
