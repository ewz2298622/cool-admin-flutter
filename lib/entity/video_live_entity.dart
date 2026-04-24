import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_live_entity.g.dart';

export 'package:flutter_app/generated/json/video_live_entity.g.dart';

@JsonSerializable()
class VideoLiveEntity {
  int? code;
  String? message;
  VideoLiveData? data;

  VideoLiveEntity();

  factory VideoLiveEntity.fromJson(Map<String, dynamic> json) =>
      $VideoLiveEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoLiveEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoLiveData {
  List<VideoLiveDataList>? list;
  VideoLiveDataPagination? pagination;

  VideoLiveData();

  factory VideoLiveData.fromJson(Map<String, dynamic> json) =>
      $VideoLiveDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoLiveDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoLiveDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic createUserId;
  dynamic updateUserId;
  String? image;
  String? title;
  dynamic roomId;
  int? type;
  List<int>? types;
  dynamic pushUrl;
  String? pullUrl;
  dynamic pushCode;
  int? status;

  VideoLiveDataList();

  factory VideoLiveDataList.fromJson(Map<String, dynamic> json) =>
      $VideoLiveDataListFromJson(json);

  Map<String, dynamic> toJson() => $VideoLiveDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoLiveDataPagination {
  int? page;
  int? size;
  int? total;

  VideoLiveDataPagination();

  factory VideoLiveDataPagination.fromJson(Map<String, dynamic> json) =>
      $VideoLiveDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $VideoLiveDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
