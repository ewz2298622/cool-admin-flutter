import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/login_entity.g.dart';

export 'package:flutter_app/generated/json/login_entity.g.dart';

@JsonSerializable()
class LoginEntity {
  int? code;
  String? message;
  LoginData? data;

  LoginEntity();

  factory LoginEntity.fromJson(Map<String, dynamic> json) =>
      $LoginEntityFromJson(json);

  Map<String, dynamic> toJson() => $LoginEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LoginData {
  int? expire;
  String? token;
  int? refreshExpire;
  String? refreshToken;

  LoginData();

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      $LoginDataFromJson(json);

  Map<String, dynamic> toJson() => $LoginDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
