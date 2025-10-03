import 'package:flutter_app/entity/is_valid_member_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

IsValidMemberEntity $IsValidMemberEntityFromJson(Map<String, dynamic> json) {
  final IsValidMemberEntity isValidMemberEntity = IsValidMemberEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    isValidMemberEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    isValidMemberEntity.message = message;
  }
  final IsValidMemberData? data = jsonConvert.convert<IsValidMemberData>(
    json['data'],
  );
  if (data != null) {
    isValidMemberEntity.data = data;
  }
  return isValidMemberEntity;
}

Map<String, dynamic> $IsValidMemberEntityToJson(IsValidMemberEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension IsValidMemberEntityExtension on IsValidMemberEntity {
  IsValidMemberEntity copyWith({
    int? code,
    String? message,
    IsValidMemberData? data,
  }) {
    return IsValidMemberEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

IsValidMemberData $IsValidMemberDataFromJson(Map<String, dynamic> json) {
  final IsValidMemberData isValidMemberData = IsValidMemberData();
  final bool? isValidMember = jsonConvert.convert<bool>(json['isValidMember']);
  if (isValidMember != null) {
    isValidMemberData.isValidMember = isValidMember;
  }
  return isValidMemberData;
}

Map<String, dynamic> $IsValidMemberDataToJson(IsValidMemberData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['isValidMember'] = entity.isValidMember;
  return data;
}

extension IsValidMemberDataExtension on IsValidMemberData {
  IsValidMemberData copyWith({bool? isValidMember}) {
    return IsValidMemberData()
      ..isValidMember = isValidMember ?? this.isValidMember;
  }
}
