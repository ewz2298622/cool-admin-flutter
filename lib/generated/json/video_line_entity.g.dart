import 'package:flutter_app/entity/video_line_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

VideoLineEntity $VideoLineEntityFromJson(Map<String, dynamic> json) {
  final VideoLineEntity videoLineEntity = VideoLineEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoLineEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoLineEntity.message = message;
  }
  final VideoLineData? data = jsonConvert.convert<VideoLineData>(json['data']);
  if (data != null) {
    videoLineEntity.data = data;
  }
  return videoLineEntity;
}

Map<String, dynamic> $VideoLineEntityToJson(VideoLineEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoLineEntityExtension on VideoLineEntity {
  VideoLineEntity copyWith({int? code, String? message, VideoLineData? data}) {
    return VideoLineEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoLineData $VideoLineDataFromJson(Map<String, dynamic> json) {
  final VideoLineData videoLineData = VideoLineData();
  final List<VideoLineDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoLineDataList>(e) as VideoLineDataList,
          )
          .toList();
  if (list != null) {
    videoLineData.list = list;
  }
  final VideoLineDataPagination? pagination = jsonConvert
      .convert<VideoLineDataPagination>(json['pagination']);
  if (pagination != null) {
    videoLineData.pagination = pagination;
  }
  return videoLineData;
}

Map<String, dynamic> $VideoLineDataToJson(VideoLineData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension VideoLineDataExtension on VideoLineData {
  VideoLineData copyWith({
    List<VideoLineDataList>? list,
    VideoLineDataPagination? pagination,
  }) {
    return VideoLineData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

VideoLineDataList $VideoLineDataListFromJson(Map<String, dynamic> json) {
  final VideoLineDataList videoLineDataList = VideoLineDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoLineDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoLineDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoLineDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoLineDataList.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoLineDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoLineDataList.updateUserId = updateUserId;
  }
  final String? videoId = jsonConvert.convert<String>(json['video_id']);
  if (videoId != null) {
    videoLineDataList.videoId = videoId;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    videoLineDataList.collectionName = collectionName;
  }
  final int? playerId = jsonConvert.convert<int>(json['player_id']);
  if (playerId != null) {
    videoLineDataList.playerId = playerId;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    videoLineDataList.sort = sort;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    videoLineDataList.tag = tag;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    videoLineDataList.collectionId = collectionId;
  }
  final String? videoName = jsonConvert.convert<String>(json['video_name']);
  if (videoName != null) {
    videoLineDataList.videoName = videoName;
  }
  return videoLineDataList;
}

Map<String, dynamic> $VideoLineDataListToJson(VideoLineDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['video_id'] = entity.videoId;
  data['collection_name'] = entity.collectionName;
  data['player_id'] = entity.playerId;
  data['sort'] = entity.sort;
  data['tag'] = entity.tag;
  data['collection_id'] = entity.collectionId;
  data['video_name'] = entity.videoName;
  return data;
}

extension VideoLineDataListExtension on VideoLineDataList {
  VideoLineDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? videoId,
    String? collectionName,
    int? playerId,
    int? sort,
    String? tag,
    int? collectionId,
    String? videoName,
  }) {
    return VideoLineDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..videoId = videoId ?? this.videoId
      ..collectionName = collectionName ?? this.collectionName
      ..playerId = playerId ?? this.playerId
      ..sort = sort ?? this.sort
      ..tag = tag ?? this.tag
      ..collectionId = collectionId ?? this.collectionId
      ..videoName = videoName ?? this.videoName;
  }
}

VideoLineDataPagination $VideoLineDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final VideoLineDataPagination videoLineDataPagination =
      VideoLineDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    videoLineDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    videoLineDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    videoLineDataPagination.total = total;
  }
  return videoLineDataPagination;
}

Map<String, dynamic> $VideoLineDataPaginationToJson(
  VideoLineDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension VideoLineDataPaginationExtension on VideoLineDataPagination {
  VideoLineDataPagination copyWith({int? page, int? size, int? total}) {
    return VideoLineDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
