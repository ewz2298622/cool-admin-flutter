import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/dict_data_entity.g.dart';

export 'package:flutter_app/generated/json/dict_data_entity.g.dart';

@JsonSerializable()
class DictDataEntity {
  int? code;
  String? message;
  DictDataData? data;

  DictDataEntity();

  factory DictDataEntity.fromJson(Map<String, dynamic> json) =>
      $DictDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $DictDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataData {
  @JSONField(name: 'live_category')
  List<DictDataDataLiveCategory>? liveCategory;
  List<DictDataDataLiveTags>? liveTags;
  List<DictDataDataWeek>? week;
  List<DictDataDataArea>? area;
  List<DictDataDataLanguage>? language;
  @JSONField(name: 'video_category')
  List<DictDataDataVideoCategory>? videoCategory;
  @JSONField(name: 'notice_type')
  List<DictDataDataNoticeType>? noticeType;
  @JSONField(name: 'feedback_type')
  List<DictDataDataFeedbackType>? feedbackType;
  @JSONField(name: 'ads_type')
  List<DictDataDataAdsType>? adsType;
  @JSONField(name: 'search_type')
  List<DictDataDataSearchType>? searchType;
  @JSONField(name: 'video_tag')
  List<DictDataDataVideoTag>? videoTag;

  DictDataData();

  factory DictDataData.fromJson(Map<String, dynamic> json) =>
      $DictDataDataFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataLiveCategory {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  dynamic remark;
  dynamic parentId;

  DictDataDataLiveCategory();

  factory DictDataDataLiveCategory.fromJson(Map<String, dynamic> json) =>
      $DictDataDataLiveCategoryFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataLiveCategoryToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataLiveTags {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  dynamic remark;
  dynamic parentId;

  DictDataDataLiveTags();

  factory DictDataDataLiveTags.fromJson(Map<String, dynamic> json) =>
      $DictDataDataLiveTagsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataLiveTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataWeek {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  dynamic remark;
  dynamic parentId;

  DictDataDataWeek();

  factory DictDataDataWeek.fromJson(Map<String, dynamic> json) =>
      $DictDataDataWeekFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataWeekToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataArea {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  String? remark;
  dynamic parentId;

  DictDataDataArea();

  factory DictDataDataArea.fromJson(Map<String, dynamic> json) =>
      $DictDataDataAreaFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataAreaToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataLanguage {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  dynamic remark;
  dynamic parentId;

  DictDataDataLanguage();

  factory DictDataDataLanguage.fromJson(Map<String, dynamic> json) =>
      $DictDataDataLanguageFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataLanguageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataVideoCategory {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  String? remark;
  int? parentId;

  DictDataDataVideoCategory();

  factory DictDataDataVideoCategory.fromJson(Map<String, dynamic> json) =>
      $DictDataDataVideoCategoryFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataVideoCategoryToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataNoticeType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  dynamic remark;
  dynamic parentId;

  DictDataDataNoticeType();

  factory DictDataDataNoticeType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataNoticeTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataNoticeTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataFeedbackType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  dynamic remark;
  dynamic parentId;

  DictDataDataFeedbackType();

  factory DictDataDataFeedbackType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataFeedbackTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataFeedbackTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataAdsType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  dynamic remark;
  dynamic parentId;

  DictDataDataAdsType();

  factory DictDataDataAdsType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataAdsTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataAdsTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataSearchType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  String? color;
  dynamic remark;
  dynamic parentId;

  DictDataDataSearchType();

  factory DictDataDataSearchType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataSearchTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataSearchTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataVideoTag {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  dynamic color;
  dynamic remark;
  dynamic parentId;

  DictDataDataVideoTag();

  factory DictDataDataVideoTag.fromJson(Map<String, dynamic> json) =>
      $DictDataDataVideoTagFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataVideoTagToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
