import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/score_order_entity.g.dart';

export 'package:flutter_app/generated/json/score_order_entity.g.dart';

@JsonSerializable()
class ScoreOrderEntity {
  int? code;
  String? message;
  ScoreOrderData? data;

  ScoreOrderEntity();

  factory ScoreOrderEntity.fromJson(Map<String, dynamic> json) =>
      $ScoreOrderEntityFromJson(json);

  Map<String, dynamic> toJson() => $ScoreOrderEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ScoreOrderData {
  List<ScoreOrderDataList>? list;
  ScoreOrderDataPagination? pagination;

  ScoreOrderData();

  factory ScoreOrderData.fromJson(Map<String, dynamic> json) =>
      $ScoreOrderDataFromJson(json);

  Map<String, dynamic> toJson() => $ScoreOrderDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ScoreOrderDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  dynamic updateUserId;
  int? score;
  String? reason;
  int? type;
  int? businessId;
  int? businessType;

  ScoreOrderDataList();

  factory ScoreOrderDataList.fromJson(Map<String, dynamic> json) =>
      $ScoreOrderDataListFromJson(json);

  Map<String, dynamic> toJson() => $ScoreOrderDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ScoreOrderDataPagination {
  int? page;
  int? size;
  int? total;

  ScoreOrderDataPagination();

  factory ScoreOrderDataPagination.fromJson(Map<String, dynamic> json) =>
      $ScoreOrderDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $ScoreOrderDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
