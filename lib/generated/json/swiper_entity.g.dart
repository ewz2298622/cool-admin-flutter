import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/swiper_entity.dart';

SwiperEntity $SwiperEntityFromJson(Map<String, dynamic> json) {
  final SwiperEntity swiperEntity = SwiperEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    swiperEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    swiperEntity.message = message;
  }
  final SwiperData? data = jsonConvert.convert<SwiperData>(json['data']);
  if (data != null) {
    swiperEntity.data = data;
  }
  return swiperEntity;
}

Map<String, dynamic> $SwiperEntityToJson(SwiperEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension SwiperEntityExtension on SwiperEntity {
  SwiperEntity copyWith({
    int? code,
    String? message,
    SwiperData? data,
  }) {
    return SwiperEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

SwiperData $SwiperDataFromJson(Map<String, dynamic> json) {
  final SwiperData swiperData = SwiperData();
  final List<SwiperDataList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<SwiperDataList>(e) as SwiperDataList)
      .toList();
  if (list != null) {
    swiperData.list = list;
  }
  final SwiperDataPagination? pagination = jsonConvert.convert<
      SwiperDataPagination>(json['pagination']);
  if (pagination != null) {
    swiperData.pagination = pagination;
  }
  return swiperData;
}

Map<String, dynamic> $SwiperDataToJson(SwiperData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension SwiperDataExtension on SwiperData {
  SwiperData copyWith({
    List<SwiperDataList>? list,
    SwiperDataPagination? pagination,
  }) {
    return SwiperData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

SwiperDataList $SwiperDataListFromJson(Map<String, dynamic> json) {
  final SwiperDataList swiperDataList = SwiperDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    swiperDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    swiperDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    swiperDataList.updateTime = updateTime;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    swiperDataList.createUserId = createUserId;
  }
  final int? updateUserId = jsonConvert.convert<int>(json['updateUserId']);
  if (updateUserId != null) {
    swiperDataList.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    swiperDataList.title = title;
  }
  final String? image = jsonConvert.convert<String>(json['image']);
  if (image != null) {
    swiperDataList.image = image;
  }
  final dynamic path = json['path'];
  if (path != null) {
    swiperDataList.path = path;
  }
  final dynamic relatedId = json['relatedId'];
  if (relatedId != null) {
    swiperDataList.relatedId = relatedId;
  }
  final int? appid = jsonConvert.convert<int>(json['appid']);
  if (appid != null) {
    swiperDataList.appid = appid;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    swiperDataList.type = type;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    swiperDataList.sort = sort;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    swiperDataList.status = status;
  }
  return swiperDataList;
}

Map<String, dynamic> $SwiperDataListToJson(SwiperDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
  data['image'] = entity.image;
  data['path'] = entity.path;
  data['relatedId'] = entity.relatedId;
  data['appid'] = entity.appid;
  data['type'] = entity.type;
  data['sort'] = entity.sort;
  data['status'] = entity.status;
  return data;
}

extension SwiperDataListExtension on SwiperDataList {
  SwiperDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    int? createUserId,
    int? updateUserId,
    String? title,
    String? image,
    dynamic path,
    dynamic relatedId,
    int? appid,
    int? type,
    int? sort,
    int? status,
  }) {
    return SwiperDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..image = image ?? this.image
      ..path = path ?? this.path
      ..relatedId = relatedId ?? this.relatedId
      ..appid = appid ?? this.appid
      ..type = type ?? this.type
      ..sort = sort ?? this.sort
      ..status = status ?? this.status;
  }
}

SwiperDataPagination $SwiperDataPaginationFromJson(Map<String, dynamic> json) {
  final SwiperDataPagination swiperDataPagination = SwiperDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    swiperDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    swiperDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    swiperDataPagination.total = total;
  }
  return swiperDataPagination;
}

Map<String, dynamic> $SwiperDataPaginationToJson(SwiperDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension SwiperDataPaginationExtension on SwiperDataPagination {
  SwiperDataPagination copyWith({
    int? page,
    int? size,
    int? total,
  }) {
    return SwiperDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}