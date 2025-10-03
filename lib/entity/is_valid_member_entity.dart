import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/is_valid_member_entity.g.dart';

export 'package:flutter_app/generated/json/is_valid_member_entity.g.dart';

@JsonSerializable()
class IsValidMemberEntity {
  int? code;
  String? message;
  IsValidMemberData? data;

  IsValidMemberEntity();

  factory IsValidMemberEntity.fromJson(Map<String, dynamic> json) =>
      $IsValidMemberEntityFromJson(json);

  Map<String, dynamic> toJson() => $IsValidMemberEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class IsValidMemberData {
  bool? isValidMember;

  IsValidMemberData();

  factory IsValidMemberData.fromJson(Map<String, dynamic> json) =>
      $IsValidMemberDataFromJson(json);

  Map<String, dynamic> toJson() => $IsValidMemberDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
