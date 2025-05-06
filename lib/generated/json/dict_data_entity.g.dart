import 'package:flutter_app/entity/dict_data_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

DictDataEntity $DictDataEntityFromJson(Map<String, dynamic> json) {
  final DictDataEntity dictDataEntity = DictDataEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    dictDataEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    dictDataEntity.message = message;
  }
  final DictDataData? data = jsonConvert.convert<DictDataData>(json['data']);
  if (data != null) {
    dictDataEntity.data = data;
  }
  return dictDataEntity;
}

Map<String, dynamic> $DictDataEntityToJson(DictDataEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension DictDataEntityExtension on DictDataEntity {
  DictDataEntity copyWith({int? code, String? message, DictDataData? data}) {
    return DictDataEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

DictDataData $DictDataDataFromJson(Map<String, dynamic> json) {
  final DictDataData dictDataData = DictDataData();
  final List<DictDataDataVideoCategory>? videoCategory =
      (json['video_category'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataVideoCategory>(e)
                    as DictDataDataVideoCategory,
          )
          .toList();
  if (videoCategory != null) {
    dictDataData.videoCategory = videoCategory;
  }
  return dictDataData;
}

Map<String, dynamic> $DictDataDataToJson(DictDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['video_category'] =
      entity.videoCategory?.map((v) => v.toJson()).toList();
  return data;
}

extension DictDataDataExtension on DictDataData {
  DictDataData copyWith({List<DictDataDataVideoCategory>? videoCategory}) {
    return DictDataData()..videoCategory = videoCategory ?? this.videoCategory;
  }
}

DictDataDataVideoCategory $DictDataDataVideoCategoryFromJson(
  Map<String, dynamic> json,
) {
  final DictDataDataVideoCategory dictDataDataVideoCategory =
      DictDataDataVideoCategory();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataVideoCategory.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataVideoCategory.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataVideoCategory.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataVideoCategory.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataVideoCategory.orderNum = orderNum;
  }
  final int? parentId = jsonConvert.convert<int>(json['parentId']);
  if (parentId != null) {
    dictDataDataVideoCategory.parentId = parentId;
  }
  return dictDataDataVideoCategory;
}

Map<String, dynamic> $DictDataDataVideoCategoryToJson(
  DictDataDataVideoCategory entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataVideoCategoryExtension on DictDataDataVideoCategory {
  DictDataDataVideoCategory copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? parentId,
  }) {
    return DictDataDataVideoCategory()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}
