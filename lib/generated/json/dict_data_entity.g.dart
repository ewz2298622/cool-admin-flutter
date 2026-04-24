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
  final List<DictDataDataLiveCategory>? liveCategory =
      (json['live_category'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataLiveCategory>(e)
                    as DictDataDataLiveCategory,
          )
          .toList();
  if (liveCategory != null) {
    dictDataData.liveCategory = liveCategory;
  }
  final List<DictDataDataLiveTags>? liveTags =
      (json['liveTags'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataLiveTags>(e)
                    as DictDataDataLiveTags,
          )
          .toList();
  if (liveTags != null) {
    dictDataData.liveTags = liveTags;
  }
  final List<DictDataDataWeek>? week =
      (json['week'] as List<dynamic>?)
          ?.map(
            (e) => jsonConvert.convert<DictDataDataWeek>(e) as DictDataDataWeek,
          )
          .toList();
  if (week != null) {
    dictDataData.week = week;
  }
  final List<DictDataDataArea>? area =
      (json['area'] as List<dynamic>?)
          ?.map(
            (e) => jsonConvert.convert<DictDataDataArea>(e) as DictDataDataArea,
          )
          .toList();
  if (area != null) {
    dictDataData.area = area;
  }
  final List<DictDataDataLanguage>? language =
      (json['language'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataLanguage>(e)
                    as DictDataDataLanguage,
          )
          .toList();
  if (language != null) {
    dictDataData.language = language;
  }
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
  final List<DictDataDataNoticeType>? noticeType =
      (json['notice_type'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataNoticeType>(e)
                    as DictDataDataNoticeType,
          )
          .toList();
  if (noticeType != null) {
    dictDataData.noticeType = noticeType;
  }
  final List<DictDataDataFeedbackType>? feedbackType =
      (json['feedback_type'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataFeedbackType>(e)
                    as DictDataDataFeedbackType,
          )
          .toList();
  if (feedbackType != null) {
    dictDataData.feedbackType = feedbackType;
  }
  final List<DictDataDataAdsType>? adsType =
      (json['ads_type'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataAdsType>(e)
                    as DictDataDataAdsType,
          )
          .toList();
  if (adsType != null) {
    dictDataData.adsType = adsType;
  }
  final List<DictDataDataSearchType>? searchType =
      (json['search_type'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataSearchType>(e)
                    as DictDataDataSearchType,
          )
          .toList();
  if (searchType != null) {
    dictDataData.searchType = searchType;
  }
  final List<DictDataDataVideoTag>? videoTag =
      (json['video_tag'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataVideoTag>(e)
                    as DictDataDataVideoTag,
          )
          .toList();
  if (videoTag != null) {
    dictDataData.videoTag = videoTag;
  }
  final List<DictDataDataAdsPage>? adsPage =
      (json['ads_page'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<DictDataDataAdsPage>(e)
                    as DictDataDataAdsPage,
          )
          .toList();
  if (adsPage != null) {
    dictDataData.adsPage = adsPage;
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
  data['ads_type'] = entity.adsType?.map((v) => v.toJson()).toList();
  data['search_type'] = entity.searchType?.map((v) => v.toJson()).toList();
  data['video_tag'] = entity.videoTag?.map((v) => v.toJson()).toList();
  data['ads_page'] = entity.adsPage?.map((v) => v.toJson()).toList();
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
    List<DictDataDataAdsType>? adsType,
    List<DictDataDataSearchType>? searchType,
    List<DictDataDataVideoTag>? videoTag,
    List<DictDataDataAdsPage>? adsPage,
  }) {
    return DictDataData()
      ..liveCategory = liveCategory ?? this.liveCategory
      ..liveTags = liveTags ?? this.liveTags
      ..week = week ?? this.week
      ..area = area ?? this.area
      ..language = language ?? this.language
      ..videoCategory = videoCategory ?? this.videoCategory
      ..noticeType = noticeType ?? this.noticeType
      ..feedbackType = feedbackType ?? this.feedbackType
      ..adsType = adsType ?? this.adsType
      ..searchType = searchType ?? this.searchType
      ..videoTag = videoTag ?? this.videoTag
      ..adsPage = adsPage ?? this.adsPage;
  }
}

DictDataDataLiveCategory $DictDataDataLiveCategoryFromJson(
  Map<String, dynamic> json,
) {
  final DictDataDataLiveCategory dictDataDataLiveCategory =
      DictDataDataLiveCategory();
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
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataLiveCategory.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataLiveCategory.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataLiveCategory.parentId = parentId;
  }
  return dictDataDataLiveCategory;
}

Map<String, dynamic> $DictDataDataLiveCategoryToJson(
  DictDataDataLiveCategory entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
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
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataLiveCategory()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
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
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataLiveTags.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataLiveTags.remark = remark;
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
  data['color'] = entity.color;
  data['remark'] = entity.remark;
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
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataLiveTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
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
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataWeek.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataWeek.remark = remark;
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
  data['color'] = entity.color;
  data['remark'] = entity.remark;
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
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataWeek()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
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
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataArea.color = color;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    dictDataDataArea.remark = remark;
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
  data['color'] = entity.color;
  data['remark'] = entity.remark;
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
    dynamic color,
    String? remark,
    dynamic parentId,
  }) {
    return DictDataDataArea()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
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
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataLanguage.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataLanguage.remark = remark;
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
  data['color'] = entity.color;
  data['remark'] = entity.remark;
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
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataLanguage()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
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
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataVideoCategory.status = status;
  }
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataVideoCategory.color = color;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    dictDataDataVideoCategory.remark = remark;
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
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
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
    dynamic color,
    String? remark,
    int? parentId,
  }) {
    return DictDataDataVideoCategory()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataNoticeType $DictDataDataNoticeTypeFromJson(
  Map<String, dynamic> json,
) {
  final DictDataDataNoticeType dictDataDataNoticeType =
      DictDataDataNoticeType();
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
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataNoticeType.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataNoticeType.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataNoticeType.parentId = parentId;
  }
  return dictDataDataNoticeType;
}

Map<String, dynamic> $DictDataDataNoticeTypeToJson(
  DictDataDataNoticeType entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
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
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataNoticeType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataFeedbackType $DictDataDataFeedbackTypeFromJson(
  Map<String, dynamic> json,
) {
  final DictDataDataFeedbackType dictDataDataFeedbackType =
      DictDataDataFeedbackType();
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
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataFeedbackType.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataFeedbackType.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataFeedbackType.parentId = parentId;
  }
  return dictDataDataFeedbackType;
}

Map<String, dynamic> $DictDataDataFeedbackTypeToJson(
  DictDataDataFeedbackType entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
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
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataFeedbackType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataAdsType $DictDataDataAdsTypeFromJson(Map<String, dynamic> json) {
  final DictDataDataAdsType dictDataDataAdsType = DictDataDataAdsType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataAdsType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataAdsType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataAdsType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataAdsType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataAdsType.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataAdsType.status = status;
  }
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataAdsType.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataAdsType.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataAdsType.parentId = parentId;
  }
  return dictDataDataAdsType;
}

Map<String, dynamic> $DictDataDataAdsTypeToJson(DictDataDataAdsType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataAdsTypeExtension on DictDataDataAdsType {
  DictDataDataAdsType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataAdsType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataSearchType $DictDataDataSearchTypeFromJson(
  Map<String, dynamic> json,
) {
  final DictDataDataSearchType dictDataDataSearchType =
      DictDataDataSearchType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataSearchType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataSearchType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataSearchType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataSearchType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataSearchType.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataSearchType.status = status;
  }
  final String? color = jsonConvert.convert<String>(json['color']);
  if (color != null) {
    dictDataDataSearchType.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataSearchType.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataSearchType.parentId = parentId;
  }
  return dictDataDataSearchType;
}

Map<String, dynamic> $DictDataDataSearchTypeToJson(
  DictDataDataSearchType entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataSearchTypeExtension on DictDataDataSearchType {
  DictDataDataSearchType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    String? color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataSearchType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataVideoTag $DictDataDataVideoTagFromJson(Map<String, dynamic> json) {
  final DictDataDataVideoTag dictDataDataVideoTag = DictDataDataVideoTag();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataVideoTag.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataVideoTag.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataVideoTag.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataVideoTag.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataVideoTag.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataVideoTag.status = status;
  }
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataVideoTag.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataVideoTag.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataVideoTag.parentId = parentId;
  }
  return dictDataDataVideoTag;
}

Map<String, dynamic> $DictDataDataVideoTagToJson(DictDataDataVideoTag entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataVideoTagExtension on DictDataDataVideoTag {
  DictDataDataVideoTag copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataVideoTag()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataAdsPage $DictDataDataAdsPageFromJson(Map<String, dynamic> json) {
  final DictDataDataAdsPage dictDataDataAdsPage = DictDataDataAdsPage();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataAdsPage.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataAdsPage.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataAdsPage.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataAdsPage.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataAdsPage.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    dictDataDataAdsPage.status = status;
  }
  final dynamic color = json['color'];
  if (color != null) {
    dictDataDataAdsPage.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    dictDataDataAdsPage.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataAdsPage.parentId = parentId;
  }
  return dictDataDataAdsPage;
}

Map<String, dynamic> $DictDataDataAdsPageToJson(DictDataDataAdsPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataAdsPageExtension on DictDataDataAdsPage {
  DictDataDataAdsPage copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic color,
    dynamic remark,
    dynamic parentId,
  }) {
    return DictDataDataAdsPage()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId;
  }
}
