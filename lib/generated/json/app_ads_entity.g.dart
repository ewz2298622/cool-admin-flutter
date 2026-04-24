import 'package:flutter_app/entity/app_ads_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

AppAdsEntity $AppAdsEntityFromJson(Map<String, dynamic> json) {
  final AppAdsEntity appAdsEntity = AppAdsEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    appAdsEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    appAdsEntity.message = message;
  }
  final AppAdsData? data = jsonConvert.convert<AppAdsData>(json['data']);
  if (data != null) {
    appAdsEntity.data = data;
  }
  return appAdsEntity;
}

Map<String, dynamic> $AppAdsEntityToJson(AppAdsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension AppAdsEntityExtension on AppAdsEntity {
  AppAdsEntity copyWith({int? code, String? message, AppAdsData? data}) {
    return AppAdsEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

AppAdsData $AppAdsDataFromJson(Map<String, dynamic> json) {
  final AppAdsData appAdsData = AppAdsData();
  final List<AppAdsDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map((e) => jsonConvert.convert<AppAdsDataList>(e) as AppAdsDataList)
          .toList();
  if (list != null) {
    appAdsData.list = list;
  }
  final AppAdsDataPagination? pagination = jsonConvert
      .convert<AppAdsDataPagination>(json['pagination']);
  if (pagination != null) {
    appAdsData.pagination = pagination;
  }
  return appAdsData;
}

Map<String, dynamic> $AppAdsDataToJson(AppAdsData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension AppAdsDataExtension on AppAdsData {
  AppAdsData copyWith({
    List<AppAdsDataList>? list,
    AppAdsDataPagination? pagination,
  }) {
    return AppAdsData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

AppAdsDataList $AppAdsDataListFromJson(Map<String, dynamic> json) {
  final AppAdsDataList appAdsDataList = AppAdsDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    appAdsDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    appAdsDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    appAdsDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    appAdsDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    appAdsDataList.createUserId = createUserId;
  }
  final int? updateUserId = jsonConvert.convert<int>(json['updateUserId']);
  if (updateUserId != null) {
    appAdsDataList.updateUserId = updateUserId;
  }
  final String? appId = jsonConvert.convert<String>(json['appId']);
  if (appId != null) {
    appAdsDataList.appId = appId;
  }
  final String? adsId = jsonConvert.convert<String>(json['adsId']);
  if (adsId != null) {
    appAdsDataList.adsId = adsId;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    appAdsDataList.type = type;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    appAdsDataList.status = status;
  }
  final int? adsPage = jsonConvert.convert<int>(json['adsPage']);
  if (adsPage != null) {
    appAdsDataList.adsPage = adsPage;
  }
  final int? score = jsonConvert.convert<int>(json['score']);
  if (score != null) {
    appAdsDataList.score = score;
  }
  return appAdsDataList;
}

Map<String, dynamic> $AppAdsDataListToJson(AppAdsDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['appId'] = entity.appId;
  data['adsId'] = entity.adsId;
  data['type'] = entity.type;
  data['status'] = entity.status;
  data['adsPage'] = entity.adsPage;
  data['score'] = entity.score;
  return data;
}

extension AppAdsDataListExtension on AppAdsDataList {
  AppAdsDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    int? updateUserId,
    String? appId,
    String? adsId,
    int? type,
    int? status,
    int? adsPage,
    int? score,
  }) {
    return AppAdsDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..appId = appId ?? this.appId
      ..adsId = adsId ?? this.adsId
      ..type = type ?? this.type
      ..status = status ?? this.status
      ..adsPage = adsPage ?? this.adsPage
      ..score = score ?? this.score;
  }
}

AppAdsDataPagination $AppAdsDataPaginationFromJson(Map<String, dynamic> json) {
  final AppAdsDataPagination appAdsDataPagination = AppAdsDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    appAdsDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    appAdsDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    appAdsDataPagination.total = total;
  }
  return appAdsDataPagination;
}

Map<String, dynamic> $AppAdsDataPaginationToJson(AppAdsDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension AppAdsDataPaginationExtension on AppAdsDataPagination {
  AppAdsDataPagination copyWith({int? page, int? size, int? total}) {
    return AppAdsDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
