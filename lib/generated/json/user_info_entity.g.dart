import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/user_info_entity.dart';

UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
  final UserInfoEntity userInfoEntity = UserInfoEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    userInfoEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    userInfoEntity.message = message;
  }
  final UserInfoData? data = jsonConvert.convert<UserInfoData>(json['data']);
  if (data != null) {
    userInfoEntity.data = data;
  }
  return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension UserInfoEntityExtension on UserInfoEntity {
  UserInfoEntity copyWith({
    int? code,
    String? message,
    UserInfoData? data,
  }) {
    return UserInfoEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

UserInfoData $UserInfoDataFromJson(Map<String, dynamic> json) {
  final UserInfoData userInfoData = UserInfoData();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    userInfoData.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    userInfoData.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    userInfoData.updateTime = updateTime;
  }
  final dynamic unionid = json['unionid'];
  if (unionid != null) {
    userInfoData.unionid = unionid;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    userInfoData.avatarUrl = avatarUrl;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    userInfoData.nickName = nickName;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userInfoData.phone = phone;
  }
  final int? gender = jsonConvert.convert<int>(json['gender']);
  if (gender != null) {
    userInfoData.gender = gender;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    userInfoData.status = status;
  }
  final int? loginType = jsonConvert.convert<int>(json['loginType']);
  if (loginType != null) {
    userInfoData.loginType = loginType;
  }
  final String? password = jsonConvert.convert<String>(json['password']);
  if (password != null) {
    userInfoData.password = password;
  }
  return userInfoData;
}

Map<String, dynamic> $UserInfoDataToJson(UserInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['unionid'] = entity.unionid;
  data['avatarUrl'] = entity.avatarUrl;
  data['nickName'] = entity.nickName;
  data['phone'] = entity.phone;
  data['gender'] = entity.gender;
  data['status'] = entity.status;
  data['loginType'] = entity.loginType;
  data['password'] = entity.password;
  return data;
}

extension UserInfoDataExtension on UserInfoData {
  UserInfoData copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic unionid,
    String? avatarUrl,
    String? nickName,
    String? phone,
    int? gender,
    int? status,
    int? loginType,
    String? password,
  }) {
    return UserInfoData()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..unionid = unionid ?? this.unionid
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..nickName = nickName ?? this.nickName
      ..phone = phone ?? this.phone
      ..gender = gender ?? this.gender
      ..status = status ?? this.status
      ..loginType = loginType ?? this.loginType
      ..password = password ?? this.password;
  }
}