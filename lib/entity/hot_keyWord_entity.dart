import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/hot_keyWord_entity.g.dart';

export 'package:flutter_app/generated/json/hot_keyWord_entity.g.dart';

@JsonSerializable()
class HotKeyWordEntity {
  int? code;
  String? message;
  HotKeyWordData? data;

  HotKeyWordEntity();

  factory HotKeyWordEntity.fromJson(Map<String, dynamic> json) =>
      $HotKeyWordEntityFromJson(json);

  Map<String, dynamic> toJson() => $HotKeyWordEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class HotKeyWordData {
  List<HotKeyWordDataList>? list;
  HotKeyWordDataPagination? pagination;

  HotKeyWordData();

  factory HotKeyWordData.fromJson(Map<String, dynamic> json) =>
      $HotKeyWordDataFromJson(json);

  Map<String, dynamic> toJson() => $HotKeyWordDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class HotKeyWordDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  dynamic updateUserId;
  String? keyWord;
  @JSONField(name: 'category_id')
  int? categoryId;
  String? tag;
  String? color;

  HotKeyWordDataList();

  factory HotKeyWordDataList.fromJson(Map<String, dynamic> json) =>
      $HotKeyWordDataListFromJson(json);

  Map<String, dynamic> toJson() => $HotKeyWordDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class HotKeyWordDataPagination {
  int? page;
  int? size;
  int? total;

  HotKeyWordDataPagination();

  factory HotKeyWordDataPagination.fromJson(Map<String, dynamic> json) =>
      $HotKeyWordDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $HotKeyWordDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
