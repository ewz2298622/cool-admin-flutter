import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/notice_info_entity.g.dart';

export 'package:flutter_app/generated/json/notice_info_entity.g.dart';

@JsonSerializable()
class NoticeInfoEntity {
  int? code;
  String? message;
  NoticeInfoData? data;

  NoticeInfoEntity();

  factory NoticeInfoEntity.fromJson(Map<String, dynamic> json) =>
      $NoticeInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $NoticeInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class NoticeInfoData {
  List<NoticeInfoDataList>? list;
  NoticeInfoDataPagination? pagination;

  NoticeInfoData();

  factory NoticeInfoData.fromJson(Map<String, dynamic> json) =>
      $NoticeInfoDataFromJson(json);

  Map<String, dynamic> toJson() => $NoticeInfoDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class NoticeInfoDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  dynamic updateUserId;
  String? title;
  String? content;
  int? type;
  int? status;

  NoticeInfoDataList();

  factory NoticeInfoDataList.fromJson(Map<String, dynamic> json) =>
      $NoticeInfoDataListFromJson(json);

  Map<String, dynamic> toJson() => $NoticeInfoDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class NoticeInfoDataPagination {
  int? page;
  int? size;
  int? total;

  NoticeInfoDataPagination();

  factory NoticeInfoDataPagination.fromJson(Map<String, dynamic> json) =>
      $NoticeInfoDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $NoticeInfoDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
