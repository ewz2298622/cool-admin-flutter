import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/user_info_entity.g.dart';
import 'dart:convert';
export 'package:flutter_app/generated/json/user_info_entity.g.dart';

@JsonSerializable()
class UserInfoEntity {
	int? code;
	String? message;
	UserInfoData? data;

	UserInfoEntity();

	factory UserInfoEntity.fromJson(Map<String, dynamic> json) => $UserInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UserInfoData {
	int? id;
	String? createTime;
	String? updateTime;
	dynamic unionid;
	String? avatarUrl;
	String? nickName;
	String? phone;
	int? gender;
	int? status;
	int? loginType;
	String? password;

	UserInfoData();

	factory UserInfoData.fromJson(Map<String, dynamic> json) => $UserInfoDataFromJson(json);

	Map<String, dynamic> toJson() => $UserInfoDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}