import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_category_entity.g.dart';

export 'package:flutter_app/generated/json/video_category_entity.g.dart';

@JsonSerializable()
class VideoCategoryEntity {
  int? code;
  String? message;
  VideoCategoryData? data;

  VideoCategoryEntity();

  factory VideoCategoryEntity.fromJson(Map<String, dynamic> json) =>
      $VideoCategoryEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoCategoryEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoCategoryData {
  List<VideoCategoryDataList>? list;
  VideoCategoryDataPagination? pagination;

  VideoCategoryData();

  factory VideoCategoryData.fromJson(Map<String, dynamic> json) =>
      $VideoCategoryDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoCategoryDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoCategoryDataList {
  @JSONField(name: 'parent_id')
  String? parentId;
  String? type;
  String? name;
  String? sort;
  @JSONField(name: 'create_at')
  String? createAt;
  @JSONField(name: 'update_at')
  String? updateAt;
  @JSONField(name: 'is_vertical')
  int? isVertical;
  @JSONField(name: 'is_font')
  int? isFont;
  @JSONField(name: 'site_id')
  int? siteId;
  int? status;
  String? createTime;
  String? updateTime;
  dynamic createUserId;
  dynamic updateUserId;
  int? id;

  VideoCategoryDataList();

  factory VideoCategoryDataList.fromJson(Map<String, dynamic> json) =>
      $VideoCategoryDataListFromJson(json);

  get items => null;

  Map<String, dynamic> toJson() => $VideoCategoryDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoCategoryDataPagination {
  int? page;
  int? size;
  int? total;

  VideoCategoryDataPagination();

  factory VideoCategoryDataPagination.fromJson(Map<String, dynamic> json) =>
      $VideoCategoryDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $VideoCategoryDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
