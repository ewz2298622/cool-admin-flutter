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
  List<DictDataDataWallpaperTags>? wallpaperTags;
  List<DictDataDataWallpaperType>? wallpaperType;
  List<DictDataDataSongTags>? songTags;
  List<DictDataDataSongAlbumType>? songAlbumType;
  List<DictDataDataGoodsTags>? goodsTags;
  List<DictDataDataGoodsType>? goodsType;
  List<DictDataDataAppType>? appType;
  List<DictDataDataAppTags>? appTags;
  List<DictDataDataAgreementType>? agreementType;
  List<DictDataDataOrderStatus>? orderStatus;
  List<DictDataDataIntegralType>? integralType;
  List<DictDataDataAppModule>? appModule;
  List<DictDataDataEmailType>? emailType;
  List<DictDataDataSpecialType>? specialType;
  List<DictDataDataFlix>? flix;
  List<DictDataDataDocumentType>? documentType;
  List<DictDataDataDocumentTags>? documentTags;
  List<DictDataDataUpdateType>? updateType;
  List<DictDataDataCommonType>? commonType;
  List<DictDataDataMessageType>? messageType;
  List<DictDataDataFriendApplyStatus>? friendApplyStatus;
  List<DictDataDataLiveStatus>? liveStatus;
  List<DictDataDataLiveType>? liveType;
  List<DictDataDataLiveTags>? liveTags;
  List<DictDataDataWeek>? week;
  @JSONField(name: 'index-tabs')
  List<DictDataDataIndexTabs>? indexTabs;
  List<DictDataDataComicTags>? comicTags;
  List<DictDataDataArea>? area;
  List<DictDataDataLanguage>? language;
  List<DictDataDataCloudDiskType>? cloudDiskType;
  List<DictDataDataPageType>? pageType;
  List<DictDataDataComicUpdateStatus>? comicUpdateStatus;
  List<DictDataDataComicType>? comicType;
  List<DictDataDataVideoM3u8SliceStatus>? videoM3u8SliceStatus;
  List<DictDataDataCloudDiskTags>? cloudDiskTags;
  List<DictDataDataSongType>? songType;
  @JSONField(name: 'video_category')
  List<DictDataDataVideoCategory>? videoCategory;
  @JSONField(name: 'notice_type')
  List<DictDataDataNoticeType>? noticeType;

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
class DictDataDataWallpaperTags {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataWallpaperTags();

  factory DictDataDataWallpaperTags.fromJson(Map<String, dynamic> json) =>
      $DictDataDataWallpaperTagsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataWallpaperTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataWallpaperType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? parentId;

  DictDataDataWallpaperType();

  factory DictDataDataWallpaperType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataWallpaperTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataWallpaperTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataSongTags {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataSongTags();

  factory DictDataDataSongTags.fromJson(Map<String, dynamic> json) =>
      $DictDataDataSongTagsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataSongTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataSongAlbumType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataSongAlbumType();

  factory DictDataDataSongAlbumType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataSongAlbumTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataSongAlbumTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataGoodsTags {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataGoodsTags();

  factory DictDataDataGoodsTags.fromJson(Map<String, dynamic> json) =>
      $DictDataDataGoodsTagsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataGoodsTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataGoodsType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataGoodsType();

  factory DictDataDataGoodsType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataGoodsTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataGoodsTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataAppType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataAppType();

  factory DictDataDataAppType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataAppTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataAppTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataAppTags {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataAppTags();

  factory DictDataDataAppTags.fromJson(Map<String, dynamic> json) =>
      $DictDataDataAppTagsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataAppTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataAgreementType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataAgreementType();

  factory DictDataDataAgreementType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataAgreementTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataAgreementTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataOrderStatus {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataOrderStatus();

  factory DictDataDataOrderStatus.fromJson(Map<String, dynamic> json) =>
      $DictDataDataOrderStatusFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataOrderStatusToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataIntegralType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataIntegralType();

  factory DictDataDataIntegralType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataIntegralTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataIntegralTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataAppModule {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataAppModule();

  factory DictDataDataAppModule.fromJson(Map<String, dynamic> json) =>
      $DictDataDataAppModuleFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataAppModuleToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataEmailType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataEmailType();

  factory DictDataDataEmailType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataEmailTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataEmailTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataSpecialType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataSpecialType();

  factory DictDataDataSpecialType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataSpecialTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataSpecialTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataFlix {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? parentId;

  DictDataDataFlix();

  factory DictDataDataFlix.fromJson(Map<String, dynamic> json) =>
      $DictDataDataFlixFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataFlixToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataDocumentType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataDocumentType();

  factory DictDataDataDocumentType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataDocumentTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataDocumentTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataDocumentTags {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataDocumentTags();

  factory DictDataDataDocumentTags.fromJson(Map<String, dynamic> json) =>
      $DictDataDataDocumentTagsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataDocumentTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataUpdateType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataUpdateType();

  factory DictDataDataUpdateType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataUpdateTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataUpdateTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataCommonType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataCommonType();

  factory DictDataDataCommonType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataCommonTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataCommonTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataMessageType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataMessageType();

  factory DictDataDataMessageType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataMessageTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataMessageTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataFriendApplyStatus {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataFriendApplyStatus();

  factory DictDataDataFriendApplyStatus.fromJson(Map<String, dynamic> json) =>
      $DictDataDataFriendApplyStatusFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataFriendApplyStatusToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataLiveStatus {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataLiveStatus();

  factory DictDataDataLiveStatus.fromJson(Map<String, dynamic> json) =>
      $DictDataDataLiveStatusFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataLiveStatusToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataLiveType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataLiveType();

  factory DictDataDataLiveType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataLiveTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataLiveTypeToJson(this);

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
class DictDataDataIndexTabs {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataIndexTabs();

  factory DictDataDataIndexTabs.fromJson(Map<String, dynamic> json) =>
      $DictDataDataIndexTabsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataIndexTabsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataComicTags {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataComicTags();

  factory DictDataDataComicTags.fromJson(Map<String, dynamic> json) =>
      $DictDataDataComicTagsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataComicTagsToJson(this);

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
class DictDataDataCloudDiskType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataCloudDiskType();

  factory DictDataDataCloudDiskType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataCloudDiskTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataCloudDiskTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataPageType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataPageType();

  factory DictDataDataPageType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataPageTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataPageTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataComicUpdateStatus {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataComicUpdateStatus();

  factory DictDataDataComicUpdateStatus.fromJson(Map<String, dynamic> json) =>
      $DictDataDataComicUpdateStatusFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataComicUpdateStatusToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataComicType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataComicType();

  factory DictDataDataComicType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataComicTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataComicTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataVideoM3u8SliceStatus {
  int? id;
  int? typeId;
  String? name;
  String? value;
  int? orderNum;
  dynamic parentId;

  DictDataDataVideoM3u8SliceStatus();

  factory DictDataDataVideoM3u8SliceStatus.fromJson(
    Map<String, dynamic> json,
  ) => $DictDataDataVideoM3u8SliceStatusFromJson(json);

  Map<String, dynamic> toJson() =>
      $DictDataDataVideoM3u8SliceStatusToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataCloudDiskTags {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataCloudDiskTags();

  factory DictDataDataCloudDiskTags.fromJson(Map<String, dynamic> json) =>
      $DictDataDataCloudDiskTagsFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataCloudDiskTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DictDataDataSongType {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  dynamic parentId;

  DictDataDataSongType();

  factory DictDataDataSongType.fromJson(Map<String, dynamic> json) =>
      $DictDataDataSongTypeFromJson(json);

  Map<String, dynamic> toJson() => $DictDataDataSongTypeToJson(this);

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
