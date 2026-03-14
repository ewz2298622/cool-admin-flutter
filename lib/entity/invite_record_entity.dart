import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/invite_record_entity.g.dart';

export 'package:flutter_app/generated/json/invite_record_entity.g.dart';

@JsonSerializable()
class InviteRecordEntity {
  int? code;
  String? message;
  InviteRecordData? data;

  InviteRecordEntity();

  factory InviteRecordEntity.fromJson(Map<String, dynamic> json) =>
      $InviteRecordEntityFromJson(json);

  Map<String, dynamic> toJson() => $InviteRecordEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class InviteRecordData {
  List<InviteRecordDataList>? list;
  InviteRecordDataPagination? pagination;

  InviteRecordData();

  factory InviteRecordData.fromJson(Map<String, dynamic> json) =>
      $InviteRecordDataFromJson(json);

  Map<String, dynamic> toJson() => $InviteRecordDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class InviteRecordDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  dynamic updateUserId;
  String? code;
  int? loginType;
  String? ipAddress;
  dynamic remark;
  String? avatarUrl;
  String? nickName;
  String? phone;
  int? gender;

  InviteRecordDataList();

  factory InviteRecordDataList.fromJson(Map<String, dynamic> json) =>
      $InviteRecordDataListFromJson(json);

  Map<String, dynamic> toJson() => $InviteRecordDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class InviteRecordDataPagination {
  int? page;
  int? size;
  int? total;

  InviteRecordDataPagination();

  factory InviteRecordDataPagination.fromJson(Map<String, dynamic> json) =>
      $InviteRecordDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $InviteRecordDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
