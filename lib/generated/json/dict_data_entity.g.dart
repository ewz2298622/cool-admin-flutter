import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/dict_data_entity.dart';

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
  DictDataEntity copyWith({
    int? code,
    String? message,
    DictDataData? data,
  }) {
    return DictDataEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

DictDataData $DictDataDataFromJson(Map<String, dynamic> json) {
  final DictDataData dictDataData = DictDataData();
  final List<
      DictDataDataLiveCategory>? liveCategory = (json['live_category'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataLiveCategory>(
          e) as DictDataDataLiveCategory).toList();
  if (liveCategory != null) {
    dictDataData.liveCategory = liveCategory;
  }
  final List<DictDataDataLiveTags>? liveTags = (json['liveTags'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataLiveTags>(e) as DictDataDataLiveTags)
      .toList();
  if (liveTags != null) {
    dictDataData.liveTags = liveTags;
  }
  final List<DictDataDataWeek>? week = (json['week'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<DictDataDataWeek>(e) as DictDataDataWeek)
      .toList();
  if (week != null) {
    dictDataData.week = week;
  }
  final List<DictDataDataArea>? area = (json['area'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<DictDataDataArea>(e) as DictDataDataArea)
      .toList();
  if (area != null) {
    dictDataData.area = area;
  }
  final List<DictDataDataLanguage>? language = (json['language'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataLanguage>(e) as DictDataDataLanguage)
      .toList();
  if (language != null) {
    dictDataData.language = language;
  }
  final List<
      DictDataDataVideoCategory>? videoCategory = (json['video_category'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataVideoCategory>(
          e) as DictDataDataVideoCategory).toList();
  if (videoCategory != null) {
    dictDataData.videoCategory = videoCategory;
  }
  final List<DictDataDataNoticeType>? noticeType = (json['notice_type'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataNoticeType>(e) as DictDataDataNoticeType)
      .toList();
  if (noticeType != null) {
    dictDataData.noticeType = noticeType;
  }
  final List<
      DictDataDataFeedbackType>? feedbackType = (json['feedback_type'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataFeedbackType>(
          e) as DictDataDataFeedbackType).toList();
  if (feedbackType != null) {
    dictDataData.feedbackType = feedbackType;
  }
  return dictDataData;
}

Map<String, dynamic> $DictDataDataToJson(DictDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['live_category'] = entity.liveCategory?.map((v) => v.toJson()).toList();
  data['liveTags'] = entity.liveTags?.map((v) => v.toJson()).toList();
  data['week'] = entity.week?.map((v) => v.toJson()).toList();
  data['area'] = entity.area?.map((v) => v.toJson()).toList();
  data['language'] = entity.language?.map((v) => v.toJson()).toList();
  data['video_category'] =
      entity.videoCategory?.map((v) => v.toJson()).toList();
  data['notice_type'] = entity.noticeType?.map((v) => v.toJson()).toList();
  data['feedback_type'] = entity.feedbackType?.map((v) => v.toJson()).toList();
  return data;
}

extension DictDataDataExtension on DictDataData {
  DictDataData copyWith({
    List<DictDataDataLiveCategory>? liveCategory,
    List<DictDataDataLiveTags>? liveTags,
    List<DictDataDataWeek>? week,
    List<DictDataDataArea>? area,
    List<DictDataDataLanguage>? language,
    List<DictDataDataVideoCategory>? videoCategory,
    List<DictDataDataNoticeType>? noticeType,
    List<DictDataDataFeedbackType>? feedbackType,
  }) {
    return DictDataData()
      ..liveCategory = liveCategory ?? this.liveCategory
      ..liveTags = liveTags ?? this.liveTags
      ..week = week ?? this.week
      ..area = area ?? this.area
      ..language = language ?? this.language
      ..videoCategory = videoCategory ?? this.videoCategory
      ..noticeType = noticeType ?? this.noticeType
      ..feedbackType = feedbackType ?? this.feedbackType;
  }
}

DictDataDataLiveCategory $DictDataDataLiveCategoryFromJson(
    Map<String, dynamic> json) {
  final DictDataDataLiveCategory dictDataDataLiveCategory = DictDataDataLiveCategory();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataLiveCategory.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataLiveCategory.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataLiveCategory.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataLiveCategory.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataLiveCategory.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataLiveCategory.status = status;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataLiveCategory.parentId = parentId;
  }
  return dictDataDataLiveCategory;
}

Map<String, dynamic> $DictDataDataLiveCategoryToJson(
    DictDataDataLiveCategory entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataLiveCategoryExtension on DictDataDataLiveCategory {
  DictDataDataLiveCategory copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic parentId,
  }) {
    return DictDataDataLiveCategory()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataLiveTags $DictDataDataLiveTagsFromJson(Map<String, dynamic> json) {
  final DictDataDataLiveTags dictDataDataLiveTags = DictDataDataLiveTags();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataLiveTags.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataLiveTags.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataLiveTags.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataLiveTags.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataLiveTags.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataLiveTags.status = status;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataLiveTags.parentId = parentId;
  }
  return dictDataDataLiveTags;
}

Map<String, dynamic> $DictDataDataLiveTagsToJson(DictDataDataLiveTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataLiveTagsExtension on DictDataDataLiveTags {
  DictDataDataLiveTags copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic parentId,
  }) {
    return DictDataDataLiveTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataWeek $DictDataDataWeekFromJson(Map<String, dynamic> json) {
  final DictDataDataWeek dictDataDataWeek = DictDataDataWeek();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataWeek.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataWeek.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataWeek.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataWeek.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataWeek.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataWeek.status = status;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataWeek.parentId = parentId;
  }
  return dictDataDataWeek;
}

Map<String, dynamic> $DictDataDataWeekToJson(DictDataDataWeek entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataWeekExtension on DictDataDataWeek {
  DictDataDataWeek copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic parentId,
  }) {
    return DictDataDataWeek()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataArea $DictDataDataAreaFromJson(Map<String, dynamic> json) {
  final DictDataDataArea dictDataDataArea = DictDataDataArea();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataArea.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataArea.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataArea.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataArea.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataArea.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataArea.status = status;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataArea.parentId = parentId;
  }
  return dictDataDataArea;
}

Map<String, dynamic> $DictDataDataAreaToJson(DictDataDataArea entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataAreaExtension on DictDataDataArea {
  DictDataDataArea copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic parentId,
  }) {
    return DictDataDataArea()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataLanguage $DictDataDataLanguageFromJson(Map<String, dynamic> json) {
  final DictDataDataLanguage dictDataDataLanguage = DictDataDataLanguage();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataLanguage.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataLanguage.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataLanguage.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataLanguage.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataLanguage.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataLanguage.status = status;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataLanguage.parentId = parentId;
  }
  return dictDataDataLanguage;
}

Map<String, dynamic> $DictDataDataLanguageToJson(DictDataDataLanguage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataLanguageExtension on DictDataDataLanguage {
  DictDataDataLanguage copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic parentId,
  }) {
    return DictDataDataLanguage()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataVideoCategory $DictDataDataVideoCategoryFromJson(
    Map<String, dynamic> json) {
  final DictDataDataVideoCategory dictDataDataVideoCategory = DictDataDataVideoCategory();
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
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataVideoCategory.status = status;
  }
  final int? parentId = jsonConvert.convert<int>(json['parentId']);
  if (parentId != null) {
    dictDataDataVideoCategory.parentId = parentId;
  }
  return dictDataDataVideoCategory;
}

Map<String, dynamic> $DictDataDataVideoCategoryToJson(
    DictDataDataVideoCategory entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
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
    int? status,
    int? parentId,
  }) {
    return DictDataDataVideoCategory()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataNoticeType $DictDataDataNoticeTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataNoticeType dictDataDataNoticeType = DictDataDataNoticeType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataNoticeType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataNoticeType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataNoticeType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataNoticeType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataNoticeType.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataNoticeType.status = status;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataNoticeType.parentId = parentId;
  }
  return dictDataDataNoticeType;
}

Map<String, dynamic> $DictDataDataNoticeTypeToJson(
    DictDataDataNoticeType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataNoticeTypeExtension on DictDataDataNoticeType {
  DictDataDataNoticeType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic parentId,
  }) {
    return DictDataDataNoticeType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataFeedbackType $DictDataDataFeedbackTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataFeedbackType dictDataDataFeedbackType = DictDataDataFeedbackType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataFeedbackType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataFeedbackType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataFeedbackType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataFeedbackType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataFeedbackType.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataFeedbackType.status = status;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataFeedbackType.parentId = parentId;
  }
  return dictDataDataFeedbackType;
}

Map<String, dynamic> $DictDataDataFeedbackTypeToJson(
    DictDataDataFeedbackType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataFeedbackTypeExtension on DictDataDataFeedbackType {
  DictDataDataFeedbackType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic parentId,
  }) {
    return DictDataDataFeedbackType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..parentId = parentId ?? this.parentId;
  }
}