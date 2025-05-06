import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/play_line_entity.dart';

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
  PlayLineEntity copyWith({
    int? code,
    String? message,
    PlayLineData? data,
  }) {
    return PlayLineEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

PlayLineData $PlayLineDataFromJson(Map<String, dynamic> json) {
  final PlayLineData playLineData = PlayLineData();
  final List<PlayLineDataList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<PlayLineDataList>(e) as PlayLineDataList)
      .toList();
  if (list != null) {
    playLineData.list = list;
  }
  final PlayLineDataPagination? pagination = jsonConvert.convert<
      PlayLineDataPagination>(json['pagination']);
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
  final String? videoLineId = jsonConvert.convert<String>(
      json['video_line_id']);
  if (videoLineId != null) {
    playLineDataList.videoLineId = videoLineId;
  }
  final String? videoId = jsonConvert.convert<String>(json['video_id']);
  if (videoId != null) {
    playLineDataList.videoId = videoId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    playLineDataList.name = name;
  }
  final String? file = jsonConvert.convert<String>(json['file']);
  if (file != null) {
    playLineDataList.file = file;
  }
  final String? chargingMode = jsonConvert.convert<String>(
      json['charging_mode']);
  if (chargingMode != null) {
    playLineDataList.chargingMode = chargingMode;
  }
  final String? currency = jsonConvert.convert<String>(json['currency']);
  if (currency != null) {
    playLineDataList.currency = currency;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    playLineDataList.subTitle = subTitle;
  }
  final String? createAt = jsonConvert.convert<String>(json['create_at']);
  if (createAt != null) {
    playLineDataList.createAt = createAt;
  }
  final String? updateAt = jsonConvert.convert<String>(json['update_at']);
  if (updateAt != null) {
    playLineDataList.updateAt = updateAt;
  }
  final int? siteId = jsonConvert.convert<int>(json['site_id']);
  if (siteId != null) {
    playLineDataList.siteId = siteId;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    playLineDataList.tag = tag;
  }
  final int? liveSource = jsonConvert.convert<int>(json['live_source']);
  if (liveSource != null) {
    playLineDataList.liveSource = liveSource;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    playLineDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    playLineDataList.updateTime = updateTime;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    playLineDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    playLineDataList.updateUserId = updateUserId;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    playLineDataList.id = id;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    playLineDataList.status = status;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    playLineDataList.sort = sort;
  }
  return playLineDataList;
}

Map<String, dynamic> $PlayLineDataListToJson(PlayLineDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['video_line_id'] = entity.videoLineId;
  data['video_id'] = entity.videoId;
  data['name'] = entity.name;
  data['file'] = entity.file;
  data['charging_mode'] = entity.chargingMode;
  data['currency'] = entity.currency;
  data['sub_title'] = entity.subTitle;
  data['create_at'] = entity.createAt;
  data['update_at'] = entity.updateAt;
  data['site_id'] = entity.siteId;
  data['tag'] = entity.tag;
  data['live_source'] = entity.liveSource;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['id'] = entity.id;
  data['status'] = entity.status;
  data['sort'] = entity.sort;
  return data;
}

extension PlayLineDataListExtension on PlayLineDataList {
  PlayLineDataList copyWith({
    String? videoLineId,
    String? videoId,
    String? name,
    String? file,
    String? chargingMode,
    String? currency,
    String? subTitle,
    String? createAt,
    String? updateAt,
    int? siteId,
    String? tag,
    int? liveSource,
    String? createTime,
    String? updateTime,
    dynamic createUserId,
    dynamic updateUserId,
    int? id,
    int? status,
    int? sort,
  }) {
    return PlayLineDataList()
      ..videoLineId = videoLineId ?? this.videoLineId
      ..videoId = videoId ?? this.videoId
      ..name = name ?? this.name
      ..file = file ?? this.file
      ..chargingMode = chargingMode ?? this.chargingMode
      ..currency = currency ?? this.currency
      ..subTitle = subTitle ?? this.subTitle
      ..createAt = createAt ?? this.createAt
      ..updateAt = updateAt ?? this.updateAt
      ..siteId = siteId ?? this.siteId
      ..tag = tag ?? this.tag
      ..liveSource = liveSource ?? this.liveSource
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..id = id ?? this.id
      ..status = status ?? this.status
      ..sort = sort ?? this.sort;
  }
}

PlayLineDataPagination $PlayLineDataPaginationFromJson(
    Map<String, dynamic> json) {
  final PlayLineDataPagination playLineDataPagination = PlayLineDataPagination();
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
    PlayLineDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension PlayLineDataPaginationExtension on PlayLineDataPagination {
  PlayLineDataPagination copyWith({
    int? page,
    int? size,
    int? total,
  }) {
    return PlayLineDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}