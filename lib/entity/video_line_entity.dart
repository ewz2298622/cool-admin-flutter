import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_line_entity.g.dart';

export 'package:flutter_app/generated/json/video_line_entity.g.dart';

@JsonSerializable()
class VideoLineEntity {
  int? code;
  String? message;
  VideoLineData? data;

  VideoLineEntity();

  factory VideoLineEntity.fromJson(Map<String, dynamic> json) =>
      $VideoLineEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoLineEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoLineData {
  List<VideoLineDataList>? list;
  VideoLineDataPagination? pagination;

  VideoLineData();

  factory VideoLineData.fromJson(Map<String, dynamic> json) =>
      $VideoLineDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoLineDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoLineDataList {
  @JSONField(name: 'video_id')
  String? videoId;
  String? name;
  @JSONField(name: 'create_at')
  String? createAt;
  @JSONField(name: 'update_at')
  String? updateAt;
  @JSONField(name: 'site_id')
  int? siteId;
  String? tag;
  String? createTime;
  String? updateTime;
  dynamic createUserId;
  dynamic updateUserId;
  int? id;
  @JSONField(name: 'player_id')
  int? playerId;
  int? sort;

  VideoLineDataList();

  factory VideoLineDataList.fromJson(Map<String, dynamic> json) =>
      $VideoLineDataListFromJson(json);

  Map<String, dynamic> toJson() => $VideoLineDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoLineDataPagination {
  int? page;
  int? size;
  int? total;

  VideoLineDataPagination();

  factory VideoLineDataPagination.fromJson(Map<String, dynamic> json) =>
      $VideoLineDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $VideoLineDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
