import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/captcha_entity.g.dart';

export 'package:flutter_app/generated/json/captcha_entity.g.dart';

@JsonSerializable()
class CaptchaEntity {
  int? code;
  String? message;
  CaptchaData? data;

  CaptchaEntity();

  factory CaptchaEntity.fromJson(Map<String, dynamic> json) =>
      $CaptchaEntityFromJson(json);

  Map<String, dynamic> toJson() => $CaptchaEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CaptchaData {
  String? captchaId;
  String? data;

  CaptchaData();

  factory CaptchaData.fromJson(Map<String, dynamic> json) =>
      $CaptchaDataFromJson(json);

  Map<String, dynamic> toJson() => $CaptchaDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
