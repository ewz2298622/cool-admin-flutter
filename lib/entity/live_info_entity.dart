import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/live_info_entity.g.dart';

export 'package:flutter_app/generated/json/live_info_entity.g.dart';

@JsonSerializable()
class LiveInfoEntity {
  int? code;
  String? message;
  LiveInfoData? data;

  LiveInfoEntity();

  factory LiveInfoEntity.fromJson(Map<String, dynamic> json) =>
      $LiveInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $LiveInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LiveInfoData {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  dynamic updateUserId;
  String? image;
  String? title;
  dynamic roomId;
  @JSONField(name: 'category_id')
  int? categoryId;
  dynamic pushUrl;
  String? pullUrl;
  dynamic pushCode;
  int? status;

  LiveInfoData();

  factory LiveInfoData.fromJson(Map<String, dynamic> json) =>
      $LiveInfoDataFromJson(json);

  Map<String, dynamic> toJson() => $LiveInfoDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
