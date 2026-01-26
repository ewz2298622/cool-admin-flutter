import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/swiper_entity.g.dart';

export 'package:flutter_app/generated/json/swiper_entity.g.dart';

@JsonSerializable()
class SwiperEntity {
  int? code;
  String? message;
  SwiperData? data;

  SwiperEntity();

  factory SwiperEntity.fromJson(Map<String, dynamic> json) =>
      $SwiperEntityFromJson(json);

  Map<String, dynamic> toJson() => $SwiperEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class SwiperData {
  List<SwiperDataList>? list;
  SwiperDataPagination? pagination;

  SwiperData();

  factory SwiperData.fromJson(Map<String, dynamic> json) =>
      $SwiperDataFromJson(json);

  Map<String, dynamic> toJson() => $SwiperDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class SwiperDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  int? updateUserId;
  String? image;
  dynamic path;
  int? relatedId;
  int? sort;
  int? status;
  int? category;
  String? title;
  String? color;
  String? subTitle;

  SwiperDataList();

  factory SwiperDataList.fromJson(Map<String, dynamic> json) =>
      $SwiperDataListFromJson(json);

  Map<String, dynamic> toJson() => $SwiperDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class SwiperDataPagination {
  int? page;
  int? size;
  int? total;

  SwiperDataPagination();

  factory SwiperDataPagination.fromJson(Map<String, dynamic> json) =>
      $SwiperDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $SwiperDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
