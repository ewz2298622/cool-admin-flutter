import 'package:flutter_app/entity/video_category_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

VideoCategoryEntity $VideoCategoryEntityFromJson(Map<String, dynamic> json) {
  final VideoCategoryEntity videoCategoryEntity = VideoCategoryEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoCategoryEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoCategoryEntity.message = message;
  }
  final VideoCategoryData? data = jsonConvert.convert<VideoCategoryData>(
    json['data'],
  );
  if (data != null) {
    videoCategoryEntity.data = data;
  }
  return videoCategoryEntity;
}

Map<String, dynamic> $VideoCategoryEntityToJson(VideoCategoryEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoCategoryEntityExtension on VideoCategoryEntity {
  VideoCategoryEntity copyWith({
    int? code,
    String? message,
    VideoCategoryData? data,
  }) {
    return VideoCategoryEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoCategoryData $VideoCategoryDataFromJson(Map<String, dynamic> json) {
  final VideoCategoryData videoCategoryData = VideoCategoryData();
  final List<VideoCategoryDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoCategoryDataList>(e)
                    as VideoCategoryDataList,
          )
          .toList();
  if (list != null) {
    videoCategoryData.list = list;
  }
  final VideoCategoryDataPagination? pagination = jsonConvert
      .convert<VideoCategoryDataPagination>(json['pagination']);
  if (pagination != null) {
    videoCategoryData.pagination = pagination;
  }
  return videoCategoryData;
}

Map<String, dynamic> $VideoCategoryDataToJson(VideoCategoryData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension VideoCategoryDataExtension on VideoCategoryData {
  VideoCategoryData copyWith({
    List<VideoCategoryDataList>? list,
    VideoCategoryDataPagination? pagination,
  }) {
    return VideoCategoryData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

VideoCategoryDataList $VideoCategoryDataListFromJson(
  Map<String, dynamic> json,
) {
  final VideoCategoryDataList videoCategoryDataList = VideoCategoryDataList();
  final String? parentId = jsonConvert.convert<String>(json['parent_id']);
  if (parentId != null) {
    videoCategoryDataList.parentId = parentId;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    videoCategoryDataList.type = type;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    videoCategoryDataList.name = name;
  }
  final String? sort = jsonConvert.convert<String>(json['sort']);
  if (sort != null) {
    videoCategoryDataList.sort = sort;
  }
  final String? createAt = jsonConvert.convert<String>(json['create_at']);
  if (createAt != null) {
    videoCategoryDataList.createAt = createAt;
  }
  final String? updateAt = jsonConvert.convert<String>(json['update_at']);
  if (updateAt != null) {
    videoCategoryDataList.updateAt = updateAt;
  }
  final int? isVertical = jsonConvert.convert<int>(json['is_vertical']);
  if (isVertical != null) {
    videoCategoryDataList.isVertical = isVertical;
  }
  final int? isFont = jsonConvert.convert<int>(json['is_font']);
  if (isFont != null) {
    videoCategoryDataList.isFont = isFont;
  }
  final int? siteId = jsonConvert.convert<int>(json['site_id']);
  if (siteId != null) {
    videoCategoryDataList.siteId = siteId;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    videoCategoryDataList.status = status;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoCategoryDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoCategoryDataList.updateTime = updateTime;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoCategoryDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoCategoryDataList.updateUserId = updateUserId;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoCategoryDataList.id = id;
  }
  return videoCategoryDataList;
}

Map<String, dynamic> $VideoCategoryDataListToJson(
  VideoCategoryDataList entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['parent_id'] = entity.parentId;
  data['type'] = entity.type;
  data['name'] = entity.name;
  data['sort'] = entity.sort;
  data['create_at'] = entity.createAt;
  data['update_at'] = entity.updateAt;
  data['is_vertical'] = entity.isVertical;
  data['is_font'] = entity.isFont;
  data['site_id'] = entity.siteId;
  data['status'] = entity.status;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['id'] = entity.id;
  return data;
}

extension VideoCategoryDataListExtension on VideoCategoryDataList {
  VideoCategoryDataList copyWith({
    String? parentId,
    String? type,
    String? name,
    String? sort,
    String? createAt,
    String? updateAt,
    int? isVertical,
    int? isFont,
    int? siteId,
    int? status,
    String? createTime,
    String? updateTime,
    dynamic createUserId,
    dynamic updateUserId,
    int? id,
  }) {
    return VideoCategoryDataList()
      ..parentId = parentId ?? this.parentId
      ..type = type ?? this.type
      ..name = name ?? this.name
      ..sort = sort ?? this.sort
      ..createAt = createAt ?? this.createAt
      ..updateAt = updateAt ?? this.updateAt
      ..isVertical = isVertical ?? this.isVertical
      ..isFont = isFont ?? this.isFont
      ..siteId = siteId ?? this.siteId
      ..status = status ?? this.status
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..id = id ?? this.id;
  }
}

VideoCategoryDataPagination $VideoCategoryDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final VideoCategoryDataPagination videoCategoryDataPagination =
      VideoCategoryDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    videoCategoryDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    videoCategoryDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    videoCategoryDataPagination.total = total;
  }
  return videoCategoryDataPagination;
}

Map<String, dynamic> $VideoCategoryDataPaginationToJson(
  VideoCategoryDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension VideoCategoryDataPaginationExtension on VideoCategoryDataPagination {
  VideoCategoryDataPagination copyWith({int? page, int? size, int? total}) {
    return VideoCategoryDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
