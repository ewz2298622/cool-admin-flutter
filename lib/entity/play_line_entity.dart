import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/play_line_entity.g.dart';

export 'package:flutter_app/generated/json/play_line_entity.g.dart';

@JsonSerializable()
class PlayLineEntity {
  int? code;
  String? message;
  PlayLineData? data;

  PlayLineEntity();

  factory PlayLineEntity.fromJson(Map<String, dynamic> json) =>
      $PlayLineEntityFromJson(json);

  Map<String, dynamic> toJson() => $PlayLineEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PlayLineData {
  List<PlayLineDataList>? list;
  PlayLineDataPagination? pagination;

  PlayLineData();

  factory PlayLineData.fromJson(Map<String, dynamic> json) =>
      $PlayLineDataFromJson(json);

  Map<String, dynamic> toJson() => $PlayLineDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PlayLineDataList {
  @JSONField(name: 'video_line_id')
  String? videoLineId;
  @JSONField(name: 'video_id')
  String? videoId;
  String? name;
  String? file;
  @JSONField(name: 'charging_mode')
  String? chargingMode;
  String? currency;
  @JSONField(name: 'sub_title')
  String? subTitle;
  @JSONField(name: 'create_at')
  String? createAt;
  @JSONField(name: 'update_at')
  String? updateAt;
  @JSONField(name: 'site_id')
  int? siteId;
  String? tag;
  @JSONField(name: 'live_source')
  int? liveSource;
  String? createTime;
  String? updateTime;
  dynamic createUserId;
  dynamic updateUserId;
  int? id;
  int? status;
  int? sort;

  PlayLineDataList();

  factory PlayLineDataList.fromJson(Map<String, dynamic> json) =>
      $PlayLineDataListFromJson(json);

  Map<String, dynamic> toJson() => $PlayLineDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PlayLineDataPagination {
  int? page;
  int? size;
  int? total;

  PlayLineDataPagination();

  factory PlayLineDataPagination.fromJson(Map<String, dynamic> json) =>
      $PlayLineDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $PlayLineDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
