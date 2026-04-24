import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/dict_info_list_entity.dart';

DictInfoListEntity $DictInfoListEntityFromJson(Map<String, dynamic> json) {
  final DictInfoListEntity dictInfoListEntity = DictInfoListEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    dictInfoListEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    dictInfoListEntity.message = message;
  }
  final List<DictInfoListData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<DictInfoListData>(e) as DictInfoListData)
      .toList();
  if (data != null) {
    dictInfoListEntity.data = data;
  }
  return dictInfoListEntity;
}

Map<String, dynamic> $DictInfoListEntityToJson(DictInfoListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.map((v) => v.toJson()).toList();
  return data;
}

extension DictInfoListEntityExtension on DictInfoListEntity {
  DictInfoListEntity copyWith({
    int? code,
    String? message,
    List<DictInfoListData>? data,
  }) {
    return DictInfoListEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

DictInfoListData $DictInfoListDataFromJson(Map<String, dynamic> json) {
  final DictInfoListData dictInfoListData = DictInfoListData();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictInfoListData.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    dictInfoListData.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    dictInfoListData.updateTime = updateTime;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictInfoListData.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictInfoListData.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictInfoListData.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictInfoListData.orderNum = orderNum;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictInfoListData.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictInfoListData.parentId = parentId;
  }
  return dictInfoListData;
}

Map<String, dynamic> $DictInfoListDataToJson(DictInfoListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['remark'] = entity.remark;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictInfoListDataExtension on DictInfoListData {
  DictInfoListData copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictInfoListData()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
  }
}