import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_hot_words_entity.g.dart';

export 'package:flutter_app/generated/json/video_hot_words_entity.g.dart';

@JsonSerializable()
class VideoHotWordsEntity {
  int? code;
  String? message;
  VideoHotWordsData? data;

  VideoHotWordsEntity();

  factory VideoHotWordsEntity.fromJson(Map<String, dynamic> json) =>
      $VideoHotWordsEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoHotWordsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoHotWordsData {
  List<VideoHotWordsDataList>? list;

  VideoHotWordsData();

  factory VideoHotWordsData.fromJson(Map<String, dynamic> json) =>
      $VideoHotWordsDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoHotWordsDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoHotWordsDataList {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  String? remark;
  dynamic parentId;
  List<VideoHotWordsDataListList>? list;

  VideoHotWordsDataList();

  factory VideoHotWordsDataList.fromJson(Map<String, dynamic> json) =>
      $VideoHotWordsDataListFromJson(json);

  Map<String, dynamic> toJson() => $VideoHotWordsDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoHotWordsDataListList {
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
  String? bgColor;
  String? fontColor;
  int? sort;

  VideoHotWordsDataListList();

  factory VideoHotWordsDataListList.fromJson(Map<String, dynamic> json) =>
      $VideoHotWordsDataListListFromJson(json);

  Map<String, dynamic> toJson() => $VideoHotWordsDataListListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
