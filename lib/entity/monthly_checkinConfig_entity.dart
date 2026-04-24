import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/monthly_checkinConfig_entity.g.dart';

export 'package:flutter_app/generated/json/monthly_checkinConfig_entity.g.dart';

@JsonSerializable()
class MonthlyCheckinConfigEntity {
  int? code;
  String? message;
  MonthlyCheckinConfigData? data;

  MonthlyCheckinConfigEntity();

  factory MonthlyCheckinConfigEntity.fromJson(Map<String, dynamic> json) =>
      $MonthlyCheckinConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $MonthlyCheckinConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MonthlyCheckinConfigData {
  List<MonthlyCheckinConfigDataList>? list;

  MonthlyCheckinConfigData();

  factory MonthlyCheckinConfigData.fromJson(Map<String, dynamic> json) =>
      $MonthlyCheckinConfigDataFromJson(json);

  Map<String, dynamic> toJson() => $MonthlyCheckinConfigDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MonthlyCheckinConfigDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  dynamic updateUserId;
  int? month;
  int? day;
  int? score;
  int? enabled;
  dynamic remark;
  int? isSigned;

  MonthlyCheckinConfigDataList();

  factory MonthlyCheckinConfigDataList.fromJson(Map<String, dynamic> json) =>
      $MonthlyCheckinConfigDataListFromJson(json);

  Map<String, dynamic> toJson() => $MonthlyCheckinConfigDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
