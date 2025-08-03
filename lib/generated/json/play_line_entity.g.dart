import 'package:flutter_app/entity/play_line_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

PlayLineEntity $PlayLineEntityFromJson(Map<String, dynamic> json) {
  final PlayLineEntity playLineEntity = PlayLineEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    playLineEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    playLineEntity.message = message;
  }
  final PlayLineData? data = jsonConvert.convert<PlayLineData>(json['data']);
  if (data != null) {
    playLineEntity.data = data;
  }
  return playLineEntity;
}

Map<String, dynamic> $PlayLineEntityToJson(PlayLineEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension PlayLineEntityExtension on PlayLineEntity {
  PlayLineEntity copyWith({int? code, String? message, PlayLineData? data}) {
    return PlayLineEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

PlayLineData $PlayLineDataFromJson(Map<String, dynamic> json) {
  final PlayLineData playLineData = PlayLineData();
  final List<PlayLineDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) => jsonConvert.convert<PlayLineDataList>(e) as PlayLineDataList,
          )
          .toList();
  if (list != null) {
    playLineData.list = list;
  }
  final PlayLineDataPagination? pagination = jsonConvert
      .convert<PlayLineDataPagination>(json['pagination']);
  if (pagination != null) {
    playLineData.pagination = pagination;
  }
  return playLineData;
}

Map<String, dynamic> $PlayLineDataToJson(PlayLineData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension PlayLineDataExtension on PlayLineData {
  PlayLineData copyWith({
    List<PlayLineDataList>? list,
    PlayLineDataPagination? pagination,
  }) {
    return PlayLineData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

PlayLineDataList $PlayLineDataListFromJson(Map<String, dynamic> json) {
  final PlayLineDataList playLineDataList = PlayLineDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    playLineDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    playLineDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    playLineDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    playLineDataList.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    playLineDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    playLineDataList.updateUserId = updateUserId;
  }
  final String? videoId = jsonConvert.convert<String>(json['video_id']);
  if (videoId != null) {
    playLineDataList.videoId = videoId;
  }
  final String? videoLineId = jsonConvert.convert<String>(
    json['video_line_id'],
  );
  if (videoLineId != null) {
    playLineDataList.videoLineId = videoLineId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    playLineDataList.name = name;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    playLineDataList.subTitle = subTitle;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    playLineDataList.sort = sort;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    playLineDataList.tag = tag;
  }
  final String? file = jsonConvert.convert<String>(json['file']);
  if (file != null) {
    playLineDataList.file = file;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    playLineDataList.collectionId = collectionId;
  }
  final String? videoName = jsonConvert.convert<String>(json['video_name']);
  if (videoName != null) {
    playLineDataList.videoName = videoName;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    playLineDataList.collectionName = collectionName;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    playLineDataList.status = status;
  }
  return playLineDataList;
}

Map<String, dynamic> $PlayLineDataListToJson(PlayLineDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['video_id'] = entity.videoId;
  data['video_line_id'] = entity.videoLineId;
  data['name'] = entity.name;
  data['sub_title'] = entity.subTitle;
  data['sort'] = entity.sort;
  data['tag'] = entity.tag;
  data['file'] = entity.file;
  data['collection_id'] = entity.collectionId;
  data['video_name'] = entity.videoName;
  data['collection_name'] = entity.collectionName;
  data['status'] = entity.status;
  return data;
}

extension PlayLineDataListExtension on PlayLineDataList {
  PlayLineDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? videoId,
    String? videoLineId,
    String? name,
    String? subTitle,
    int? sort,
    String? tag,
    String? file,
    int? collectionId,
    String? videoName,
    String? collectionName,
    int? status,
  }) {
    return PlayLineDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..videoId = videoId ?? this.videoId
      ..videoLineId = videoLineId ?? this.videoLineId
      ..name = name ?? this.name
      ..subTitle = subTitle ?? this.subTitle
      ..sort = sort ?? this.sort
      ..tag = tag ?? this.tag
      ..file = file ?? this.file
      ..collectionId = collectionId ?? this.collectionId
      ..videoName = videoName ?? this.videoName
      ..collectionName = collectionName ?? this.collectionName
      ..status = status ?? this.status;
  }
}

PlayLineDataPagination $PlayLineDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final PlayLineDataPagination playLineDataPagination =
      PlayLineDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    playLineDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    playLineDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    playLineDataPagination.total = total;
  }
  return playLineDataPagination;
}

Map<String, dynamic> $PlayLineDataPaginationToJson(
  PlayLineDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension PlayLineDataPaginationExtension on PlayLineDataPagination {
  PlayLineDataPagination copyWith({int? page, int? size, int? total}) {
    return PlayLineDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
