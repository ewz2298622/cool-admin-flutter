import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/captcha_entity.dart';

CaptchaEntity $CaptchaEntityFromJson(Map<String, dynamic> json) {
  final CaptchaEntity captchaEntity = CaptchaEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    captchaEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    captchaEntity.message = message;
  }
  final CaptchaData? data = jsonConvert.convert<CaptchaData>(json['data']);
  if (data != null) {
    captchaEntity.data = data;
  }
  return captchaEntity;
}

Map<String, dynamic> $CaptchaEntityToJson(CaptchaEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension CaptchaEntityExtension on CaptchaEntity {
  CaptchaEntity copyWith({
    int? code,
    String? message,
    CaptchaData? data,
  }) {
    return CaptchaEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

CaptchaData $CaptchaDataFromJson(Map<String, dynamic> json) {
  final CaptchaData captchaData = CaptchaData();
  final String? captchaId = jsonConvert.convert<String>(json['captchaId']);
  if (captchaId != null) {
    captchaData.captchaId = captchaId;
  }
  final String? data = jsonConvert.convert<String>(json['data']);
  if (data != null) {
    captchaData.data = data;
  }
  return captchaData;
}

Map<String, dynamic> $CaptchaDataToJson(CaptchaData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['captchaId'] = entity.captchaId;
  data['data'] = entity.data;
  return data;
}

extension CaptchaDataExtension on CaptchaData {
  CaptchaData copyWith({
    String? captchaId,
    String? data,
  }) {
    return CaptchaData()
      ..captchaId = captchaId ?? this.captchaId
      ..data = data ?? this.data;
  }
}