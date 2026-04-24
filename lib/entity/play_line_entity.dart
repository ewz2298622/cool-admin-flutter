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
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  dynamic updateUserId;
  @JSONField(name: 'video_id')
  String? videoId;
  @JSONField(name: 'video_line_id')
  String? videoLineId;
  String? name;
  @JSONField(name: 'sub_title')
  String? subTitle;
  int? sort;
  String? tag;
  String? file;
  @JSONField(name: 'collection_id')
  int? collectionId;
  @JSONField(name: 'video_name')
  String? videoName;
  @JSONField(name: 'collection_name')
  String? collectionName;
  int? status;

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
set tenantId(tenantId) {}

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
