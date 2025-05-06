import 'package:flutter_app/entity/views_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

ViewsEntity $ViewsEntityFromJson(Map<String, dynamic> json) {
  final ViewsEntity viewsEntity = ViewsEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    viewsEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    viewsEntity.message = message;
  }
  final ViewsData? data = jsonConvert.convert<ViewsData>(json['data']);
  if (data != null) {
    viewsEntity.data = data;
  }
  return viewsEntity;
}

Map<String, dynamic> $ViewsEntityToJson(ViewsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension ViewsEntityExtension on ViewsEntity {
  ViewsEntity copyWith({int? code, String? message, ViewsData? data}) {
    return ViewsEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

ViewsData $ViewsDataFromJson(Map<String, dynamic> json) {
  final ViewsData viewsData = ViewsData();
  final List<ViewsDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map((e) => jsonConvert.convert<ViewsDataList>(e) as ViewsDataList)
          .toList();
  if (list != null) {
    viewsData.list = list;
  }
  final ViewsDataPagination? pagination = jsonConvert
      .convert<ViewsDataPagination>(json['pagination']);
  if (pagination != null) {
    viewsData.pagination = pagination;
  }
  return viewsData;
}

Map<String, dynamic> $ViewsDataToJson(ViewsData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension ViewsDataExtension on ViewsData {
  ViewsData copyWith({
    List<ViewsDataList>? list,
    ViewsDataPagination? pagination,
  }) {
    return ViewsData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

ViewsDataList $ViewsDataListFromJson(Map<String, dynamic> json) {
  final ViewsDataList viewsDataList = ViewsDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    viewsDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    viewsDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    viewsDataList.updateTime = updateTime;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    viewsDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    viewsDataList.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    viewsDataList.title = title;
  }
  final int? associationId = jsonConvert.convert<int>(json['associationId']);
  if (associationId != null) {
    viewsDataList.associationId = associationId;
  }
  final dynamic cover = json['cover'];
  if (cover != null) {
    viewsDataList.cover = cover;
  }
  final dynamic type = json['type'];
  if (type != null) {
    viewsDataList.type = type;
  }
  return viewsDataList;
}

Map<String, dynamic> $ViewsDataListToJson(ViewsDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
  data['associationId'] = entity.associationId;
  data['cover'] = entity.cover;
  data['type'] = entity.type;
  return data;
}

extension ViewsDataListExtension on ViewsDataList {
  ViewsDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    int? createUserId,
    dynamic updateUserId,
    String? title,
    int? associationId,
    dynamic cover,
    dynamic type,
  }) {
    return ViewsDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..associationId = associationId ?? this.associationId
      ..cover = cover ?? this.cover
      ..type = type ?? this.type;
  }
}

ViewsDataPagination $ViewsDataPaginationFromJson(Map<String, dynamic> json) {
  final ViewsDataPagination viewsDataPagination = ViewsDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    viewsDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    viewsDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    viewsDataPagination.total = total;
  }
  return viewsDataPagination;
}

Map<String, dynamic> $ViewsDataPaginationToJson(ViewsDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension ViewsDataPaginationExtension on ViewsDataPagination {
  ViewsDataPagination copyWith({int? page, int? size, int? total}) {
    return ViewsDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
