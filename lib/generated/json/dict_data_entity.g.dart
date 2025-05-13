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
      DictDataDataWallpaperTags>? wallpaperTags = (json['wallpaperTags'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataWallpaperTags>(
          e) as DictDataDataWallpaperTags).toList();
  if (wallpaperTags != null) {
    dictDataData.wallpaperTags = wallpaperTags;
  }
  final List<
      DictDataDataWallpaperType>? wallpaperType = (json['wallpaperType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataWallpaperType>(
          e) as DictDataDataWallpaperType).toList();
  if (wallpaperType != null) {
    dictDataData.wallpaperType = wallpaperType;
  }
  final List<DictDataDataSongTags>? songTags = (json['songTags'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataSongTags>(e) as DictDataDataSongTags)
      .toList();
  if (songTags != null) {
    dictDataData.songTags = songTags;
  }
  final List<
      DictDataDataSongAlbumType>? songAlbumType = (json['songAlbumType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataSongAlbumType>(
          e) as DictDataDataSongAlbumType).toList();
  if (songAlbumType != null) {
    dictDataData.songAlbumType = songAlbumType;
  }
  final List<DictDataDataGoodsTags>? goodsTags = (json['goodsTags'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataGoodsTags>(e) as DictDataDataGoodsTags)
      .toList();
  if (goodsTags != null) {
    dictDataData.goodsTags = goodsTags;
  }
  final List<DictDataDataGoodsType>? goodsType = (json['goodsType'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataGoodsType>(e) as DictDataDataGoodsType)
      .toList();
  if (goodsType != null) {
    dictDataData.goodsType = goodsType;
  }
  final List<DictDataDataAppType>? appType = (json['appType'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataAppType>(e) as DictDataDataAppType)
      .toList();
  if (appType != null) {
    dictDataData.appType = appType;
  }
  final List<DictDataDataAppTags>? appTags = (json['appTags'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataAppTags>(e) as DictDataDataAppTags)
      .toList();
  if (appTags != null) {
    dictDataData.appTags = appTags;
  }
  final List<
      DictDataDataAgreementType>? agreementType = (json['agreementType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataAgreementType>(
          e) as DictDataDataAgreementType).toList();
  if (agreementType != null) {
    dictDataData.agreementType = agreementType;
  }
  final List<
      DictDataDataOrderStatus>? orderStatus = (json['orderStatus'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataOrderStatus>(
          e) as DictDataDataOrderStatus).toList();
  if (orderStatus != null) {
    dictDataData.orderStatus = orderStatus;
  }
  final List<
      DictDataDataIntegralType>? integralType = (json['integralType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataIntegralType>(
          e) as DictDataDataIntegralType).toList();
  if (integralType != null) {
    dictDataData.integralType = integralType;
  }
  final List<DictDataDataAppModule>? appModule = (json['appModule'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataAppModule>(e) as DictDataDataAppModule)
      .toList();
  if (appModule != null) {
    dictDataData.appModule = appModule;
  }
  final List<DictDataDataEmailType>? emailType = (json['emailType'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataEmailType>(e) as DictDataDataEmailType)
      .toList();
  if (emailType != null) {
    dictDataData.emailType = emailType;
  }
  final List<
      DictDataDataSpecialType>? specialType = (json['specialType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataSpecialType>(
          e) as DictDataDataSpecialType).toList();
  if (specialType != null) {
    dictDataData.specialType = specialType;
  }
  final List<DictDataDataFlix>? flix = (json['flix'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<DictDataDataFlix>(e) as DictDataDataFlix)
      .toList();
  if (flix != null) {
    dictDataData.flix = flix;
  }
  final List<
      DictDataDataDocumentType>? documentType = (json['documentType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataDocumentType>(
          e) as DictDataDataDocumentType).toList();
  if (documentType != null) {
    dictDataData.documentType = documentType;
  }
  final List<
      DictDataDataDocumentTags>? documentTags = (json['documentTags'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataDocumentTags>(
          e) as DictDataDataDocumentTags).toList();
  if (documentTags != null) {
    dictDataData.documentTags = documentTags;
  }
  final List<DictDataDataUpdateType>? updateType = (json['updateType'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataUpdateType>(e) as DictDataDataUpdateType)
      .toList();
  if (updateType != null) {
    dictDataData.updateType = updateType;
  }
  final List<DictDataDataCommonType>? commonType = (json['commonType'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataCommonType>(e) as DictDataDataCommonType)
      .toList();
  if (commonType != null) {
    dictDataData.commonType = commonType;
  }
  final List<
      DictDataDataMessageType>? messageType = (json['messageType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataMessageType>(
          e) as DictDataDataMessageType).toList();
  if (messageType != null) {
    dictDataData.messageType = messageType;
  }
  final List<
      DictDataDataFriendApplyStatus>? friendApplyStatus = (json['friendApplyStatus'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataFriendApplyStatus>(
          e) as DictDataDataFriendApplyStatus).toList();
  if (friendApplyStatus != null) {
    dictDataData.friendApplyStatus = friendApplyStatus;
  }
  final List<DictDataDataLiveStatus>? liveStatus = (json['liveStatus'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataLiveStatus>(e) as DictDataDataLiveStatus)
      .toList();
  if (liveStatus != null) {
    dictDataData.liveStatus = liveStatus;
  }
  final List<DictDataDataLiveType>? liveType = (json['liveType'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataLiveType>(e) as DictDataDataLiveType)
      .toList();
  if (liveType != null) {
    dictDataData.liveType = liveType;
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
  final List<DictDataDataIndexTabs>? indexTabs = (json['index-tabs'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataIndexTabs>(e) as DictDataDataIndexTabs)
      .toList();
  if (indexTabs != null) {
    dictDataData.indexTabs = indexTabs;
  }
  final List<DictDataDataComicTags>? comicTags = (json['comicTags'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataComicTags>(e) as DictDataDataComicTags)
      .toList();
  if (comicTags != null) {
    dictDataData.comicTags = comicTags;
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
      DictDataDataCloudDiskType>? cloudDiskType = (json['cloudDiskType'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataCloudDiskType>(
          e) as DictDataDataCloudDiskType).toList();
  if (cloudDiskType != null) {
    dictDataData.cloudDiskType = cloudDiskType;
  }
  final List<DictDataDataPageType>? pageType = (json['pageType'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataPageType>(e) as DictDataDataPageType)
      .toList();
  if (pageType != null) {
    dictDataData.pageType = pageType;
  }
  final List<
      DictDataDataComicUpdateStatus>? comicUpdateStatus = (json['comicUpdateStatus'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataComicUpdateStatus>(
          e) as DictDataDataComicUpdateStatus).toList();
  if (comicUpdateStatus != null) {
    dictDataData.comicUpdateStatus = comicUpdateStatus;
  }
  final List<DictDataDataComicType>? comicType = (json['comicType'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataComicType>(e) as DictDataDataComicType)
      .toList();
  if (comicType != null) {
    dictDataData.comicType = comicType;
  }
  final List<
      DictDataDataVideoM3u8SliceStatus>? videoM3u8SliceStatus = (json['videoM3u8SliceStatus'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataVideoM3u8SliceStatus>(
          e) as DictDataDataVideoM3u8SliceStatus).toList();
  if (videoM3u8SliceStatus != null) {
    dictDataData.videoM3u8SliceStatus = videoM3u8SliceStatus;
  }
  final List<
      DictDataDataCloudDiskTags>? cloudDiskTags = (json['cloudDiskTags'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<DictDataDataCloudDiskTags>(
          e) as DictDataDataCloudDiskTags).toList();
  if (cloudDiskTags != null) {
    dictDataData.cloudDiskTags = cloudDiskTags;
  }
  final List<DictDataDataSongType>? songType = (json['songType'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<DictDataDataSongType>(e) as DictDataDataSongType)
      .toList();
  if (songType != null) {
    dictDataData.songType = songType;
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
  return dictDataData;
}

Map<String, dynamic> $DictDataDataToJson(DictDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['wallpaperTags'] = entity.wallpaperTags?.map((v) => v.toJson()).toList();
  data['wallpaperType'] = entity.wallpaperType?.map((v) => v.toJson()).toList();
  data['songTags'] = entity.songTags?.map((v) => v.toJson()).toList();
  data['songAlbumType'] = entity.songAlbumType?.map((v) => v.toJson()).toList();
  data['goodsTags'] = entity.goodsTags?.map((v) => v.toJson()).toList();
  data['goodsType'] = entity.goodsType?.map((v) => v.toJson()).toList();
  data['appType'] = entity.appType?.map((v) => v.toJson()).toList();
  data['appTags'] = entity.appTags?.map((v) => v.toJson()).toList();
  data['agreementType'] = entity.agreementType?.map((v) => v.toJson()).toList();
  data['orderStatus'] = entity.orderStatus?.map((v) => v.toJson()).toList();
  data['integralType'] = entity.integralType?.map((v) => v.toJson()).toList();
  data['appModule'] = entity.appModule?.map((v) => v.toJson()).toList();
  data['emailType'] = entity.emailType?.map((v) => v.toJson()).toList();
  data['specialType'] = entity.specialType?.map((v) => v.toJson()).toList();
  data['flix'] = entity.flix?.map((v) => v.toJson()).toList();
  data['documentType'] = entity.documentType?.map((v) => v.toJson()).toList();
  data['documentTags'] = entity.documentTags?.map((v) => v.toJson()).toList();
  data['updateType'] = entity.updateType?.map((v) => v.toJson()).toList();
  data['commonType'] = entity.commonType?.map((v) => v.toJson()).toList();
  data['messageType'] = entity.messageType?.map((v) => v.toJson()).toList();
  data['friendApplyStatus'] =
      entity.friendApplyStatus?.map((v) => v.toJson()).toList();
  data['liveStatus'] = entity.liveStatus?.map((v) => v.toJson()).toList();
  data['liveType'] = entity.liveType?.map((v) => v.toJson()).toList();
  data['liveTags'] = entity.liveTags?.map((v) => v.toJson()).toList();
  data['week'] = entity.week?.map((v) => v.toJson()).toList();
  data['index-tabs'] = entity.indexTabs?.map((v) => v.toJson()).toList();
  data['comicTags'] = entity.comicTags?.map((v) => v.toJson()).toList();
  data['area'] = entity.area?.map((v) => v.toJson()).toList();
  data['language'] = entity.language?.map((v) => v.toJson()).toList();
  data['cloudDiskType'] = entity.cloudDiskType?.map((v) => v.toJson()).toList();
  data['pageType'] = entity.pageType?.map((v) => v.toJson()).toList();
  data['comicUpdateStatus'] =
      entity.comicUpdateStatus?.map((v) => v.toJson()).toList();
  data['comicType'] = entity.comicType?.map((v) => v.toJson()).toList();
  data['videoM3u8SliceStatus'] =
      entity.videoM3u8SliceStatus?.map((v) => v.toJson()).toList();
  data['cloudDiskTags'] = entity.cloudDiskTags?.map((v) => v.toJson()).toList();
  data['songType'] = entity.songType?.map((v) => v.toJson()).toList();
  data['video_category'] =
      entity.videoCategory?.map((v) => v.toJson()).toList();
  data['notice_type'] = entity.noticeType?.map((v) => v.toJson()).toList();
  return data;
}

extension DictDataDataExtension on DictDataData {
  DictDataData copyWith({
    List<DictDataDataWallpaperTags>? wallpaperTags,
    List<DictDataDataWallpaperType>? wallpaperType,
    List<DictDataDataSongTags>? songTags,
    List<DictDataDataSongAlbumType>? songAlbumType,
    List<DictDataDataGoodsTags>? goodsTags,
    List<DictDataDataGoodsType>? goodsType,
    List<DictDataDataAppType>? appType,
    List<DictDataDataAppTags>? appTags,
    List<DictDataDataAgreementType>? agreementType,
    List<DictDataDataOrderStatus>? orderStatus,
    List<DictDataDataIntegralType>? integralType,
    List<DictDataDataAppModule>? appModule,
    List<DictDataDataEmailType>? emailType,
    List<DictDataDataSpecialType>? specialType,
    List<DictDataDataFlix>? flix,
    List<DictDataDataDocumentType>? documentType,
    List<DictDataDataDocumentTags>? documentTags,
    List<DictDataDataUpdateType>? updateType,
    List<DictDataDataCommonType>? commonType,
    List<DictDataDataMessageType>? messageType,
    List<DictDataDataFriendApplyStatus>? friendApplyStatus,
    List<DictDataDataLiveStatus>? liveStatus,
    List<DictDataDataLiveType>? liveType,
    List<DictDataDataLiveTags>? liveTags,
    List<DictDataDataWeek>? week,
    List<DictDataDataIndexTabs>? indexTabs,
    List<DictDataDataComicTags>? comicTags,
    List<DictDataDataArea>? area,
    List<DictDataDataLanguage>? language,
    List<DictDataDataCloudDiskType>? cloudDiskType,
    List<DictDataDataPageType>? pageType,
    List<DictDataDataComicUpdateStatus>? comicUpdateStatus,
    List<DictDataDataComicType>? comicType,
    List<DictDataDataVideoM3u8SliceStatus>? videoM3u8SliceStatus,
    List<DictDataDataCloudDiskTags>? cloudDiskTags,
    List<DictDataDataSongType>? songType,
    List<DictDataDataVideoCategory>? videoCategory,
    List<DictDataDataNoticeType>? noticeType,
  }) {
    return DictDataData()
      ..wallpaperTags = wallpaperTags ?? this.wallpaperTags
      ..wallpaperType = wallpaperType ?? this.wallpaperType
      ..songTags = songTags ?? this.songTags
      ..songAlbumType = songAlbumType ?? this.songAlbumType
      ..goodsTags = goodsTags ?? this.goodsTags
      ..goodsType = goodsType ?? this.goodsType
      ..appType = appType ?? this.appType
      ..appTags = appTags ?? this.appTags
      ..agreementType = agreementType ?? this.agreementType
      ..orderStatus = orderStatus ?? this.orderStatus
      ..integralType = integralType ?? this.integralType
      ..appModule = appModule ?? this.appModule
      ..emailType = emailType ?? this.emailType
      ..specialType = specialType ?? this.specialType
      ..flix = flix ?? this.flix
      ..documentType = documentType ?? this.documentType
      ..documentTags = documentTags ?? this.documentTags
      ..updateType = updateType ?? this.updateType
      ..commonType = commonType ?? this.commonType
      ..messageType = messageType ?? this.messageType
      ..friendApplyStatus = friendApplyStatus ?? this.friendApplyStatus
      ..liveStatus = liveStatus ?? this.liveStatus
      ..liveType = liveType ?? this.liveType
      ..liveTags = liveTags ?? this.liveTags
      ..week = week ?? this.week
      ..indexTabs = indexTabs ?? this.indexTabs
      ..comicTags = comicTags ?? this.comicTags
      ..area = area ?? this.area
      ..language = language ?? this.language
      ..cloudDiskType = cloudDiskType ?? this.cloudDiskType
      ..pageType = pageType ?? this.pageType
      ..comicUpdateStatus = comicUpdateStatus ?? this.comicUpdateStatus
      ..comicType = comicType ?? this.comicType
      ..videoM3u8SliceStatus = videoM3u8SliceStatus ?? this.videoM3u8SliceStatus
      ..cloudDiskTags = cloudDiskTags ?? this.cloudDiskTags
      ..songType = songType ?? this.songType
      ..videoCategory = videoCategory ?? this.videoCategory
      ..noticeType = noticeType ?? this.noticeType;
  }
}

DictDataDataWallpaperTags $DictDataDataWallpaperTagsFromJson(
    Map<String, dynamic> json) {
  final DictDataDataWallpaperTags dictDataDataWallpaperTags = DictDataDataWallpaperTags();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataWallpaperTags.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataWallpaperTags.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataWallpaperTags.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataWallpaperTags.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataWallpaperTags.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataWallpaperTags.parentId = parentId;
  }
  return dictDataDataWallpaperTags;
}

Map<String, dynamic> $DictDataDataWallpaperTagsToJson(
    DictDataDataWallpaperTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataWallpaperTagsExtension on DictDataDataWallpaperTags {
  DictDataDataWallpaperTags copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataWallpaperTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataWallpaperType $DictDataDataWallpaperTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataWallpaperType dictDataDataWallpaperType = DictDataDataWallpaperType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataWallpaperType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataWallpaperType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataWallpaperType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataWallpaperType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataWallpaperType.orderNum = orderNum;
  }
  final int? parentId = jsonConvert.convert<int>(json['parentId']);
  if (parentId != null) {
    dictDataDataWallpaperType.parentId = parentId;
  }
  return dictDataDataWallpaperType;
}

Map<String, dynamic> $DictDataDataWallpaperTypeToJson(
    DictDataDataWallpaperType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataWallpaperTypeExtension on DictDataDataWallpaperType {
  DictDataDataWallpaperType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? parentId,
  }) {
    return DictDataDataWallpaperType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataSongTags $DictDataDataSongTagsFromJson(Map<String, dynamic> json) {
  final DictDataDataSongTags dictDataDataSongTags = DictDataDataSongTags();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataSongTags.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataSongTags.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataSongTags.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataSongTags.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataSongTags.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataSongTags.parentId = parentId;
  }
  return dictDataDataSongTags;
}

Map<String, dynamic> $DictDataDataSongTagsToJson(DictDataDataSongTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataSongTagsExtension on DictDataDataSongTags {
  DictDataDataSongTags copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataSongTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataSongAlbumType $DictDataDataSongAlbumTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataSongAlbumType dictDataDataSongAlbumType = DictDataDataSongAlbumType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataSongAlbumType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataSongAlbumType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataSongAlbumType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataSongAlbumType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataSongAlbumType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataSongAlbumType.parentId = parentId;
  }
  return dictDataDataSongAlbumType;
}

Map<String, dynamic> $DictDataDataSongAlbumTypeToJson(
    DictDataDataSongAlbumType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataSongAlbumTypeExtension on DictDataDataSongAlbumType {
  DictDataDataSongAlbumType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataSongAlbumType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataGoodsTags $DictDataDataGoodsTagsFromJson(
    Map<String, dynamic> json) {
  final DictDataDataGoodsTags dictDataDataGoodsTags = DictDataDataGoodsTags();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataGoodsTags.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataGoodsTags.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataGoodsTags.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataGoodsTags.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataGoodsTags.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataGoodsTags.parentId = parentId;
  }
  return dictDataDataGoodsTags;
}

Map<String, dynamic> $DictDataDataGoodsTagsToJson(
    DictDataDataGoodsTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataGoodsTagsExtension on DictDataDataGoodsTags {
  DictDataDataGoodsTags copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataGoodsTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataGoodsType $DictDataDataGoodsTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataGoodsType dictDataDataGoodsType = DictDataDataGoodsType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataGoodsType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataGoodsType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataGoodsType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataGoodsType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataGoodsType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataGoodsType.parentId = parentId;
  }
  return dictDataDataGoodsType;
}

Map<String, dynamic> $DictDataDataGoodsTypeToJson(
    DictDataDataGoodsType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataGoodsTypeExtension on DictDataDataGoodsType {
  DictDataDataGoodsType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataGoodsType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataAppType $DictDataDataAppTypeFromJson(Map<String, dynamic> json) {
  final DictDataDataAppType dictDataDataAppType = DictDataDataAppType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataAppType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataAppType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataAppType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataAppType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataAppType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataAppType.parentId = parentId;
  }
  return dictDataDataAppType;
}

Map<String, dynamic> $DictDataDataAppTypeToJson(DictDataDataAppType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataAppTypeExtension on DictDataDataAppType {
  DictDataDataAppType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataAppType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataAppTags $DictDataDataAppTagsFromJson(Map<String, dynamic> json) {
  final DictDataDataAppTags dictDataDataAppTags = DictDataDataAppTags();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataAppTags.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataAppTags.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataAppTags.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataAppTags.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataAppTags.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataAppTags.parentId = parentId;
  }
  return dictDataDataAppTags;
}

Map<String, dynamic> $DictDataDataAppTagsToJson(DictDataDataAppTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataAppTagsExtension on DictDataDataAppTags {
  DictDataDataAppTags copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataAppTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataAgreementType $DictDataDataAgreementTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataAgreementType dictDataDataAgreementType = DictDataDataAgreementType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataAgreementType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataAgreementType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataAgreementType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataAgreementType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataAgreementType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataAgreementType.parentId = parentId;
  }
  return dictDataDataAgreementType;
}

Map<String, dynamic> $DictDataDataAgreementTypeToJson(
    DictDataDataAgreementType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataAgreementTypeExtension on DictDataDataAgreementType {
  DictDataDataAgreementType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataAgreementType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataOrderStatus $DictDataDataOrderStatusFromJson(
    Map<String, dynamic> json) {
  final DictDataDataOrderStatus dictDataDataOrderStatus = DictDataDataOrderStatus();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataOrderStatus.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataOrderStatus.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataOrderStatus.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataOrderStatus.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataOrderStatus.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataOrderStatus.parentId = parentId;
  }
  return dictDataDataOrderStatus;
}

Map<String, dynamic> $DictDataDataOrderStatusToJson(
    DictDataDataOrderStatus entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataOrderStatusExtension on DictDataDataOrderStatus {
  DictDataDataOrderStatus copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataOrderStatus()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataIntegralType $DictDataDataIntegralTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataIntegralType dictDataDataIntegralType = DictDataDataIntegralType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataIntegralType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataIntegralType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataIntegralType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataIntegralType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataIntegralType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataIntegralType.parentId = parentId;
  }
  return dictDataDataIntegralType;
}

Map<String, dynamic> $DictDataDataIntegralTypeToJson(
    DictDataDataIntegralType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataIntegralTypeExtension on DictDataDataIntegralType {
  DictDataDataIntegralType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataIntegralType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataAppModule $DictDataDataAppModuleFromJson(
    Map<String, dynamic> json) {
  final DictDataDataAppModule dictDataDataAppModule = DictDataDataAppModule();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataAppModule.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataAppModule.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataAppModule.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataAppModule.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataAppModule.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataAppModule.parentId = parentId;
  }
  return dictDataDataAppModule;
}

Map<String, dynamic> $DictDataDataAppModuleToJson(
    DictDataDataAppModule entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataAppModuleExtension on DictDataDataAppModule {
  DictDataDataAppModule copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataAppModule()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataEmailType $DictDataDataEmailTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataEmailType dictDataDataEmailType = DictDataDataEmailType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataEmailType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataEmailType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataEmailType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataEmailType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataEmailType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataEmailType.parentId = parentId;
  }
  return dictDataDataEmailType;
}

Map<String, dynamic> $DictDataDataEmailTypeToJson(
    DictDataDataEmailType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataEmailTypeExtension on DictDataDataEmailType {
  DictDataDataEmailType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataEmailType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataSpecialType $DictDataDataSpecialTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataSpecialType dictDataDataSpecialType = DictDataDataSpecialType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataSpecialType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataSpecialType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataSpecialType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataSpecialType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataSpecialType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataSpecialType.parentId = parentId;
  }
  return dictDataDataSpecialType;
}

Map<String, dynamic> $DictDataDataSpecialTypeToJson(
    DictDataDataSpecialType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataSpecialTypeExtension on DictDataDataSpecialType {
  DictDataDataSpecialType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataSpecialType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataFlix $DictDataDataFlixFromJson(Map<String, dynamic> json) {
  final DictDataDataFlix dictDataDataFlix = DictDataDataFlix();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataFlix.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataFlix.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataFlix.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataFlix.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataFlix.orderNum = orderNum;
  }
  final int? parentId = jsonConvert.convert<int>(json['parentId']);
  if (parentId != null) {
    dictDataDataFlix.parentId = parentId;
  }
  return dictDataDataFlix;
}

Map<String, dynamic> $DictDataDataFlixToJson(DictDataDataFlix entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataFlixExtension on DictDataDataFlix {
  DictDataDataFlix copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? parentId,
  }) {
    return DictDataDataFlix()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataDocumentType $DictDataDataDocumentTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataDocumentType dictDataDataDocumentType = DictDataDataDocumentType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataDocumentType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataDocumentType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataDocumentType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataDocumentType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataDocumentType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataDocumentType.parentId = parentId;
  }
  return dictDataDataDocumentType;
}

Map<String, dynamic> $DictDataDataDocumentTypeToJson(
    DictDataDataDocumentType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataDocumentTypeExtension on DictDataDataDocumentType {
  DictDataDataDocumentType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataDocumentType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataDocumentTags $DictDataDataDocumentTagsFromJson(
    Map<String, dynamic> json) {
  final DictDataDataDocumentTags dictDataDataDocumentTags = DictDataDataDocumentTags();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataDocumentTags.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataDocumentTags.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataDocumentTags.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataDocumentTags.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataDocumentTags.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataDocumentTags.parentId = parentId;
  }
  return dictDataDataDocumentTags;
}

Map<String, dynamic> $DictDataDataDocumentTagsToJson(
    DictDataDataDocumentTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataDocumentTagsExtension on DictDataDataDocumentTags {
  DictDataDataDocumentTags copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataDocumentTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataUpdateType $DictDataDataUpdateTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataUpdateType dictDataDataUpdateType = DictDataDataUpdateType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataUpdateType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataUpdateType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataUpdateType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataUpdateType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataUpdateType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataUpdateType.parentId = parentId;
  }
  return dictDataDataUpdateType;
}

Map<String, dynamic> $DictDataDataUpdateTypeToJson(
    DictDataDataUpdateType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataUpdateTypeExtension on DictDataDataUpdateType {
  DictDataDataUpdateType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataUpdateType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataCommonType $DictDataDataCommonTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataCommonType dictDataDataCommonType = DictDataDataCommonType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataCommonType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataCommonType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataCommonType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataCommonType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataCommonType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataCommonType.parentId = parentId;
  }
  return dictDataDataCommonType;
}

Map<String, dynamic> $DictDataDataCommonTypeToJson(
    DictDataDataCommonType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataCommonTypeExtension on DictDataDataCommonType {
  DictDataDataCommonType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataCommonType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataMessageType $DictDataDataMessageTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataMessageType dictDataDataMessageType = DictDataDataMessageType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataMessageType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataMessageType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataMessageType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataMessageType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataMessageType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataMessageType.parentId = parentId;
  }
  return dictDataDataMessageType;
}

Map<String, dynamic> $DictDataDataMessageTypeToJson(
    DictDataDataMessageType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataMessageTypeExtension on DictDataDataMessageType {
  DictDataDataMessageType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataMessageType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataFriendApplyStatus $DictDataDataFriendApplyStatusFromJson(
    Map<String, dynamic> json) {
  final DictDataDataFriendApplyStatus dictDataDataFriendApplyStatus = DictDataDataFriendApplyStatus();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataFriendApplyStatus.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataFriendApplyStatus.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataFriendApplyStatus.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataFriendApplyStatus.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataFriendApplyStatus.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataFriendApplyStatus.parentId = parentId;
  }
  return dictDataDataFriendApplyStatus;
}

Map<String, dynamic> $DictDataDataFriendApplyStatusToJson(
    DictDataDataFriendApplyStatus entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataFriendApplyStatusExtension on DictDataDataFriendApplyStatus {
  DictDataDataFriendApplyStatus copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataFriendApplyStatus()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataLiveStatus $DictDataDataLiveStatusFromJson(
    Map<String, dynamic> json) {
  final DictDataDataLiveStatus dictDataDataLiveStatus = DictDataDataLiveStatus();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataLiveStatus.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataLiveStatus.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataLiveStatus.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataLiveStatus.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataLiveStatus.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataLiveStatus.parentId = parentId;
  }
  return dictDataDataLiveStatus;
}

Map<String, dynamic> $DictDataDataLiveStatusToJson(
    DictDataDataLiveStatus entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataLiveStatusExtension on DictDataDataLiveStatus {
  DictDataDataLiveStatus copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataLiveStatus()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataLiveType $DictDataDataLiveTypeFromJson(Map<String, dynamic> json) {
  final DictDataDataLiveType dictDataDataLiveType = DictDataDataLiveType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataLiveType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataLiveType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataLiveType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataLiveType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataLiveType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataLiveType.parentId = parentId;
  }
  return dictDataDataLiveType;
}

Map<String, dynamic> $DictDataDataLiveTypeToJson(DictDataDataLiveType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataLiveTypeExtension on DictDataDataLiveType {
  DictDataDataLiveType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataLiveType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
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
    dynamic parentId,
  }) {
    return DictDataDataLiveTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
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
    dynamic parentId,
  }) {
    return DictDataDataWeek()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataIndexTabs $DictDataDataIndexTabsFromJson(
    Map<String, dynamic> json) {
  final DictDataDataIndexTabs dictDataDataIndexTabs = DictDataDataIndexTabs();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataIndexTabs.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataIndexTabs.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataIndexTabs.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataIndexTabs.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataIndexTabs.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataIndexTabs.parentId = parentId;
  }
  return dictDataDataIndexTabs;
}

Map<String, dynamic> $DictDataDataIndexTabsToJson(
    DictDataDataIndexTabs entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataIndexTabsExtension on DictDataDataIndexTabs {
  DictDataDataIndexTabs copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataIndexTabs()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataComicTags $DictDataDataComicTagsFromJson(
    Map<String, dynamic> json) {
  final DictDataDataComicTags dictDataDataComicTags = DictDataDataComicTags();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataComicTags.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataComicTags.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataComicTags.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataComicTags.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataComicTags.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataComicTags.parentId = parentId;
  }
  return dictDataDataComicTags;
}

Map<String, dynamic> $DictDataDataComicTagsToJson(
    DictDataDataComicTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataComicTagsExtension on DictDataDataComicTags {
  DictDataDataComicTags copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataComicTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
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
    dynamic parentId,
  }) {
    return DictDataDataArea()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
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
    dynamic parentId,
  }) {
    return DictDataDataLanguage()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataCloudDiskType $DictDataDataCloudDiskTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataCloudDiskType dictDataDataCloudDiskType = DictDataDataCloudDiskType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataCloudDiskType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataCloudDiskType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataCloudDiskType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataCloudDiskType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataCloudDiskType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataCloudDiskType.parentId = parentId;
  }
  return dictDataDataCloudDiskType;
}

Map<String, dynamic> $DictDataDataCloudDiskTypeToJson(
    DictDataDataCloudDiskType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataCloudDiskTypeExtension on DictDataDataCloudDiskType {
  DictDataDataCloudDiskType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataCloudDiskType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataPageType $DictDataDataPageTypeFromJson(Map<String, dynamic> json) {
  final DictDataDataPageType dictDataDataPageType = DictDataDataPageType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataPageType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataPageType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataPageType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataPageType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataPageType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataPageType.parentId = parentId;
  }
  return dictDataDataPageType;
}

Map<String, dynamic> $DictDataDataPageTypeToJson(DictDataDataPageType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataPageTypeExtension on DictDataDataPageType {
  DictDataDataPageType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataPageType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataComicUpdateStatus $DictDataDataComicUpdateStatusFromJson(
    Map<String, dynamic> json) {
  final DictDataDataComicUpdateStatus dictDataDataComicUpdateStatus = DictDataDataComicUpdateStatus();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataComicUpdateStatus.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataComicUpdateStatus.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataComicUpdateStatus.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataComicUpdateStatus.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataComicUpdateStatus.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataComicUpdateStatus.parentId = parentId;
  }
  return dictDataDataComicUpdateStatus;
}

Map<String, dynamic> $DictDataDataComicUpdateStatusToJson(
    DictDataDataComicUpdateStatus entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataComicUpdateStatusExtension on DictDataDataComicUpdateStatus {
  DictDataDataComicUpdateStatus copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataComicUpdateStatus()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataComicType $DictDataDataComicTypeFromJson(
    Map<String, dynamic> json) {
  final DictDataDataComicType dictDataDataComicType = DictDataDataComicType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataComicType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataComicType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataComicType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataComicType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataComicType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataComicType.parentId = parentId;
  }
  return dictDataDataComicType;
}

Map<String, dynamic> $DictDataDataComicTypeToJson(
    DictDataDataComicType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataComicTypeExtension on DictDataDataComicType {
  DictDataDataComicType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataComicType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataVideoM3u8SliceStatus $DictDataDataVideoM3u8SliceStatusFromJson(
    Map<String, dynamic> json) {
  final DictDataDataVideoM3u8SliceStatus dictDataDataVideoM3u8SliceStatus = DictDataDataVideoM3u8SliceStatus();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataVideoM3u8SliceStatus.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataVideoM3u8SliceStatus.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataVideoM3u8SliceStatus.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    dictDataDataVideoM3u8SliceStatus.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataVideoM3u8SliceStatus.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataVideoM3u8SliceStatus.parentId = parentId;
  }
  return dictDataDataVideoM3u8SliceStatus;
}

Map<String, dynamic> $DictDataDataVideoM3u8SliceStatusToJson(
    DictDataDataVideoM3u8SliceStatus entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataVideoM3u8SliceStatusExtension on DictDataDataVideoM3u8SliceStatus {
  DictDataDataVideoM3u8SliceStatus copyWith({
    int? id,
    int? typeId,
    String? name,
    String? value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataVideoM3u8SliceStatus()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataCloudDiskTags $DictDataDataCloudDiskTagsFromJson(
    Map<String, dynamic> json) {
  final DictDataDataCloudDiskTags dictDataDataCloudDiskTags = DictDataDataCloudDiskTags();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataCloudDiskTags.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataCloudDiskTags.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataCloudDiskTags.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataCloudDiskTags.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataCloudDiskTags.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataCloudDiskTags.parentId = parentId;
  }
  return dictDataDataCloudDiskTags;
}

Map<String, dynamic> $DictDataDataCloudDiskTagsToJson(
    DictDataDataCloudDiskTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataCloudDiskTagsExtension on DictDataDataCloudDiskTags {
  DictDataDataCloudDiskTags copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataCloudDiskTags()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}

DictDataDataSongType $DictDataDataSongTypeFromJson(Map<String, dynamic> json) {
  final DictDataDataSongType dictDataDataSongType = DictDataDataSongType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    dictDataDataSongType.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    dictDataDataSongType.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    dictDataDataSongType.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    dictDataDataSongType.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    dictDataDataSongType.orderNum = orderNum;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    dictDataDataSongType.parentId = parentId;
  }
  return dictDataDataSongType;
}

Map<String, dynamic> $DictDataDataSongTypeToJson(DictDataDataSongType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['parentId'] = entity.parentId;
  return data;
}

extension DictDataDataSongTypeExtension on DictDataDataSongType {
  DictDataDataSongType copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    dynamic parentId,
  }) {
    return DictDataDataSongType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
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
    dynamic parentId,
  }) {
    return DictDataDataNoticeType()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..parentId = parentId ?? this.parentId;
  }
}