import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/cash_order_entity.g.dart';

export 'package:flutter_app/generated/json/cash_order_entity.g.dart';

@JsonSerializable()
class CashOrderEntity {
  int? code;
  String? message;
  CashOrderData? data;

  CashOrderEntity();

  factory CashOrderEntity.fromJson(Map<String, dynamic> json) =>
      $CashOrderEntityFromJson(json);

  Map<String, dynamic> toJson() => $CashOrderEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CashOrderData {
  List<CashOrderDataList>? list;
  CashOrderDataPagination? pagination;

  CashOrderData();

  factory CashOrderData.fromJson(Map<String, dynamic> json) =>
      $CashOrderDataFromJson(json);

  Map<String, dynamic> toJson() => $CashOrderDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CashOrderDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  dynamic updateUserId;
  int? score;
  String? amount;
  int? status;
  dynamic auditRemark;
  int? paymentType;
  String? paymentAccount;
  dynamic remark;
  String? ipAddress;

  CashOrderDataList();

  factory CashOrderDataList.fromJson(Map<String, dynamic> json) =>
      $CashOrderDataListFromJson(json);

  Map<String, dynamic> toJson() => $CashOrderDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CashOrderDataPagination {
  int? page;
  int? size;
  int? total;

  CashOrderDataPagination();

  factory CashOrderDataPagination.fromJson(Map<String, dynamic> json) =>
      $CashOrderDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $CashOrderDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
