import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/dict_data_entity.g.dart';

export 'package:flutter_app/generated/json/dict_data_entity.g.dart';

@JsonSerializable()
class DictDataEntity {
  int? code;
  String? message;
  DictDataData? data;

  DictDataEntity();

  factory DictDataEntity.fromJson(Map<String, dynamic> json) =>
      $DictDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $DictDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataData {
  @JSONField(name: 'video_category')
  List<DictDataDataVideoCategory>? videoCategory;

  DictDataData();

  factory DictDataData.fromJson(Map<String, dynamic> json) =>
      $DictDataDataFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataVideoCategory {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? parentId;

  DictDataDataVideoCategory();

  factory DictDataDataVideoCategory.fromJson(Map<String, dynamic> json) =>
      $DictDataDataVideoCategoryFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataVideoCategoryToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
