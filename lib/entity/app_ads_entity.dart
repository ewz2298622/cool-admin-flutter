import 'dart:convert';

import 'package:flutter_app/generated/json/app_ads_entity.g.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

export 'package:flutter_app/generated/json/app_ads_entity.g.dart';

@JsonSerializable()
class AppAdsEntity {
  int? code;
  String? message;
  AppAdsData? data;

  AppAdsEntity();

  factory AppAdsEntity.fromJson(Map<String, dynamic> json) =>
      $AppAdsEntityFromJson(json);

  Map<String, dynamic> toJson() => $AppAdsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AppAdsData {
  List<AppAdsDataList>? list;
  AppAdsDataPagination? pagination;

  AppAdsData();

  factory AppAdsData.fromJson(Map<String, dynamic> json) =>
      $AppAdsDataFromJson(json);

  Map<String, dynamic> toJson() => $AppAdsDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AppAdsDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  int? updateUserId;
  String? appId;
  String? adsId;
  int? type;
  int? status;
  int? adsPage;
  int? score;

  AppAdsDataList();

  factory AppAdsDataList.fromJson(Map<String, dynamic> json) =>
      $AppAdsDataListFromJson(json);

  Map<String, dynamic> toJson() => $AppAdsDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AppAdsDataPagination {
  int? page;
  int? size;
  int? total;

  AppAdsDataPagination();

  factory AppAdsDataPagination.fromJson(Map<String, dynamic> json) =>
      $AppAdsDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $AppAdsDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
