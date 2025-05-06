import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/video_live_entity.dart';

VideoLiveEntity $VideoLiveEntityFromJson(Map<String, dynamic> json) {
  final VideoLiveEntity videoLiveEntity = VideoLiveEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoLiveEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoLiveEntity.message = message;
  }
  final VideoLiveData? data = jsonConvert.convert<VideoLiveData>(json['data']);
  if (data != null) {
    videoLiveEntity.data = data;
  }
  return videoLiveEntity;
}

Map<String, dynamic> $VideoLiveEntityToJson(VideoLiveEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoLiveEntityExtension on VideoLiveEntity {
  VideoLiveEntity copyWith({
    int? code,
    String? message,
    VideoLiveData? data,
  }) {
    return VideoLiveEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoLiveData $VideoLiveDataFromJson(Map<String, dynamic> json) {
  final VideoLiveData videoLiveData = VideoLiveData();
  final List<VideoLiveDataList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<VideoLiveDataList>(e) as VideoLiveDataList)
      .toList();
  if (list != null) {
    videoLiveData.list = list;
  }
  final VideoLiveDataPagination? pagination = jsonConvert.convert<
      VideoLiveDataPagination>(json['pagination']);
  if (pagination != null) {
    videoLiveData.pagination = pagination;
  }
  return videoLiveData;
}

Map<String, dynamic> $VideoLiveDataToJson(VideoLiveData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension VideoLiveDataExtension on VideoLiveData {
  VideoLiveData copyWith({
    List<VideoLiveDataList>? list,
    VideoLiveDataPagination? pagination,
  }) {
    return VideoLiveData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

VideoLiveDataList $VideoLiveDataListFromJson(Map<String, dynamic> json) {
  final VideoLiveDataList videoLiveDataList = VideoLiveDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoLiveDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoLiveDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoLiveDataList.updateTime = updateTime;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoLiveDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoLiveDataList.updateUserId = updateUserId;
  }
  final String? image = jsonConvert.convert<String>(json['image']);
  if (image != null) {
    videoLiveDataList.image = image;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    videoLiveDataList.title = title;
  }
  final dynamic roomId = json['roomId'];
  if (roomId != null) {
    videoLiveDataList.roomId = roomId;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    videoLiveDataList.type = type;
  }
  final List<int>? types = (json['types'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<int>(e) as int).toList();
  if (types != null) {
    videoLiveDataList.types = types;
  }
  final dynamic pushUrl = json['pushUrl'];
  if (pushUrl != null) {
    videoLiveDataList.pushUrl = pushUrl;
  }
  final String? pullUrl = jsonConvert.convert<String>(json['pullUrl']);
  if (pullUrl != null) {
    videoLiveDataList.pullUrl = pullUrl;
  }
  final dynamic pushCode = json['pushCode'];
  if (pushCode != null) {
    videoLiveDataList.pushCode = pushCode;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    videoLiveDataList.status = status;
  }
  return videoLiveDataList;
}

Map<String, dynamic> $VideoLiveDataListToJson(VideoLiveDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['image'] = entity.image;
  data['title'] = entity.title;
  data['roomId'] = entity.roomId;
  data['type'] = entity.type;
  data['types'] = entity.types;
  data['pushUrl'] = entity.pushUrl;
  data['pullUrl'] = entity.pullUrl;
  data['pushCode'] = entity.pushCode;
  data['status'] = entity.status;
  return data;
}

extension VideoLiveDataListExtension on VideoLiveDataList {
  VideoLiveDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic createUserId,
    dynamic updateUserId,
    String? image,
    String? title,
    dynamic roomId,
    int? type,
    List<int>? types,
    dynamic pushUrl,
    String? pullUrl,
    dynamic pushCode,
    int? status,
  }) {
    return VideoLiveDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..image = image ?? this.image
      ..title = title ?? this.title
      ..roomId = roomId ?? this.roomId
      ..type = type ?? this.type
      ..types = types ?? this.types
      ..pushUrl = pushUrl ?? this.pushUrl
      ..pullUrl = pullUrl ?? this.pullUrl
      ..pushCode = pushCode ?? this.pushCode
      ..status = status ?? this.status;
  }
}

VideoLiveDataPagination $VideoLiveDataPaginationFromJson(
    Map<String, dynamic> json) {
  final VideoLiveDataPagination videoLiveDataPagination = VideoLiveDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    videoLiveDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    videoLiveDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    videoLiveDataPagination.total = total;
  }
  return videoLiveDataPagination;
}

Map<String, dynamic> $VideoLiveDataPaginationToJson(
    VideoLiveDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension VideoLiveDataPaginationExtension on VideoLiveDataPagination {
  VideoLiveDataPagination copyWith({
    int? page,
    int? size,
    int? total,
  }) {
    return VideoLiveDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}