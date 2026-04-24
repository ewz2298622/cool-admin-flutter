import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/login_entity.dart';

LoginEntity $LoginEntityFromJson(Map<String, dynamic> json) {
  final LoginEntity loginEntity = LoginEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    loginEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    loginEntity.message = message;
  }
  final LoginData? data = jsonConvert.convert<LoginData>(json['data']);
  if (data != null) {
    loginEntity.data = data;
  }
  return loginEntity;
}

Map<String, dynamic> $LoginEntityToJson(LoginEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension LoginEntityExtension on LoginEntity {
  LoginEntity copyWith({
    int? code,
    String? message,
    LoginData? data,
  }) {
    return LoginEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

LoginData $LoginDataFromJson(Map<String, dynamic> json) {
  final LoginData loginData = LoginData();
  final int? expire = jsonConvert.convert<int>(json['expire']);
  if (expire != null) {
    loginData.expire = expire;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    loginData.token = token;
  }
  final int? refreshExpire = jsonConvert.convert<int>(json['refreshExpire']);
  if (refreshExpire != null) {
    loginData.refreshExpire = refreshExpire;
  }
  final String? refreshToken = jsonConvert.convert<String>(
      json['refreshToken']);
  if (refreshToken != null) {
    loginData.refreshToken = refreshToken;
  }
  return loginData;
}

Map<String, dynamic> $LoginDataToJson(LoginData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['expire'] = entity.expire;
  data['token'] = entity.token;
  data['refreshExpire'] = entity.refreshExpire;
  data['refreshToken'] = entity.refreshToken;
  return data;
}

extension LoginDataExtension on LoginData {
  LoginData copyWith({
    int? expire,
    String? token,
    int? refreshExpire,
    String? refreshToken,
  }) {
    return LoginData()
      ..expire = expire ?? this.expire
      ..token = token ?? this.token
      ..refreshExpire = refreshExpire ?? this.refreshExpire
      ..refreshToken = refreshToken ?? this.refreshToken;
  }
}