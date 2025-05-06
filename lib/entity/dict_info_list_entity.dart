import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/dict_info_list_entity.g.dart';

export 'package:flutter_app/generated/json/dict_info_list_entity.g.dart';

@JsonSerializable()
class DictInfoListEntity {
  int? code;
  String? message;
  List<DictInfoListData>? data;

  DictInfoListEntity();

  factory DictInfoListEntity.fromJson(Map<String, dynamic> json) =>
      $DictInfoListEntityFromJson(json);

  Map<String, dynamic> toJson() => $DictInfoListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictInfoListData {
  int? id;
  String? createTime;
  String? updateTime;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic remark;
  dynamic parentId;

  DictInfoListData();

  factory DictInfoListData.fromJson(Map<String, dynamic> json) =>
      $DictInfoListDataFromJson(json);

  Map<String, dynamic> toJson() => $DictInfoListDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
