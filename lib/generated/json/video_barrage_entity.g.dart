import 'package:flutter_app/entity/video_barrage_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

VideoBarrageEntity $VideoBarrageEntityFromJson(Map<String, dynamic> json) {
  final VideoBarrageEntity videoBarrageEntity = VideoBarrageEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoBarrageEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoBarrageEntity.message = message;
  }
  final VideoBarrageData? data = jsonConvert.convert<VideoBarrageData>(
    json['data'],
  );
  if (data != null) {
    videoBarrageEntity.data = data;
  }
  return videoBarrageEntity;
}

Map<String, dynamic> $VideoBarrageEntityToJson(VideoBarrageEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoBarrageEntityExtension on VideoBarrageEntity {
  VideoBarrageEntity copyWith({
    int? code,
    String? message,
    VideoBarrageData? data,
  }) {
    return VideoBarrageEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoBarrageData $VideoBarrageDataFromJson(Map<String, dynamic> json) {
  final VideoBarrageData videoBarrageData = VideoBarrageData();
  final List<VideoBarrageDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoBarrageDataList>(e)
                    as VideoBarrageDataList,
          )
          .toList();
  if (list != null) {
    videoBarrageData.list = list;
  }
  final VideoBarrageDataPagination? pagination = jsonConvert
      .convert<VideoBarrageDataPagination>(json['pagination']);
  if (pagination != null) {
    videoBarrageData.pagination = pagination;
  }
  return videoBarrageData;
}

Map<String, dynamic> $VideoBarrageDataToJson(VideoBarrageData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension VideoBarrageDataExtension on VideoBarrageData {
  VideoBarrageData copyWith({
    List<VideoBarrageDataList>? list,
    VideoBarrageDataPagination? pagination,
  }) {
    return VideoBarrageData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

VideoBarrageDataList $VideoBarrageDataListFromJson(Map<String, dynamic> json) {
  final VideoBarrageDataList videoBarrageDataList = VideoBarrageDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoBarrageDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoBarrageDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoBarrageDataList.updateTime = updateTime;
  }
  final int? tenantId = jsonConvert.convert<int>(json['tenantId']);
  if (tenantId != null) {
    videoBarrageDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    videoBarrageDataList.createUserId = createUserId;
  }
  final int? updateUserId = jsonConvert.convert<int>(json['updateUserId']);
  if (updateUserId != null) {
    videoBarrageDataList.updateUserId = updateUserId;
  }
  final String? videoId = jsonConvert.convert<String>(json['video_id']);
  if (videoId != null) {
    videoBarrageDataList.videoId = videoId;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    videoBarrageDataList.text = text;
  }
  final int? fontSize = jsonConvert.convert<int>(json['fontSize']);
  if (fontSize != null) {
    videoBarrageDataList.fontSize = fontSize;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    videoBarrageDataList.type = type;
  }
  final String? color = jsonConvert.convert<String>(json['color']);
  if (color != null) {
    videoBarrageDataList.color = color;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    videoBarrageDataList.status = status;
  }
  final int? time = jsonConvert.convert<int>(json['time']);
  if (time != null) {
    videoBarrageDataList.time = time;
  }
  return videoBarrageDataList;
}

Map<String, dynamic> $VideoBarrageDataListToJson(VideoBarrageDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['video_id'] = entity.videoId;
  data['text'] = entity.text;
  data['fontSize'] = entity.fontSize;
  data['type'] = entity.type;
  data['color'] = entity.color;
  data['status'] = entity.status;
  data['time'] = entity.time;
  return data;
}

extension VideoBarrageDataListExtension on VideoBarrageDataList {
  VideoBarrageDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    int? tenantId,
    int? createUserId,
    int? updateUserId,
    String? videoId,
    String? text,
    int? fontSize,
    int? type,
    String? color,
    int? status,
    int? time,
  }) {
    return VideoBarrageDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..videoId = videoId ?? this.videoId
      ..text = text ?? this.text
      ..fontSize = fontSize ?? this.fontSize
      ..type = type ?? this.type
      ..color = color ?? this.color
      ..status = status ?? this.status
      ..time = time ?? this.time;
  }
}

VideoBarrageDataPagination $VideoBarrageDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final VideoBarrageDataPagination videoBarrageDataPagination =
      VideoBarrageDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    videoBarrageDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    videoBarrageDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    videoBarrageDataPagination.total = total;
  }
  return videoBarrageDataPagination;
}

Map<String, dynamic> $VideoBarrageDataPaginationToJson(
  VideoBarrageDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension VideoBarrageDataPaginationExtension on VideoBarrageDataPagination {
  VideoBarrageDataPagination copyWith({int? page, int? size, int? total}) {
    return VideoBarrageDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
