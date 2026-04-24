import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/video_album_entity.dart';

VideoAlbumEntity $VideoAlbumEntityFromJson(Map<String, dynamic> json) {
  final VideoAlbumEntity videoAlbumEntity = VideoAlbumEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoAlbumEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoAlbumEntity.message = message;
  }
  final VideoAlbumData? data = jsonConvert.convert<VideoAlbumData>(
      json['data']);
  if (data != null) {
    videoAlbumEntity.data = data;
  }
  return videoAlbumEntity;
}

Map<String, dynamic> $VideoAlbumEntityToJson(VideoAlbumEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoAlbumEntityExtension on VideoAlbumEntity {
  VideoAlbumEntity copyWith({
    int? code,
    String? message,
    VideoAlbumData? data,
  }) {
    return VideoAlbumEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoAlbumData $VideoAlbumDataFromJson(Map<String, dynamic> json) {
  final VideoAlbumData videoAlbumData = VideoAlbumData();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoAlbumData.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoAlbumData.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoAlbumData.updateTime = updateTime;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoAlbumData.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoAlbumData.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    videoAlbumData.title = title;
  }
  final dynamic name = json['name'];
  if (name != null) {
    videoAlbumData.name = name;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoAlbumData.surfacePlot = surfacePlot;
  }
  final String? recommend = jsonConvert.convert<String>(json['recommend']);
  if (recommend != null) {
    videoAlbumData.recommend = recommend;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoAlbumData.status = status;
  }
  final dynamic introduce = json['introduce'];
  if (introduce != null) {
    videoAlbumData.introduce = introduce;
  }
  final String? popularityDay = jsonConvert.convert<String>(
      json['popularity_day']);
  if (popularityDay != null) {
    videoAlbumData.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
      json['popularity_week']);
  if (popularityWeek != null) {
    videoAlbumData.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
      json['popularity_month']);
  if (popularityMonth != null) {
    videoAlbumData.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
      json['popularity_sum']);
  if (popularitySum != null) {
    videoAlbumData.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    videoAlbumData.note = note;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    videoAlbumData.sort = sort;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    videoAlbumData.type = type;
  }
  final dynamic createAt = json['create_at'];
  if (createAt != null) {
    videoAlbumData.createAt = createAt;
  }
  final dynamic updateAt = json['update_at'];
  if (updateAt != null) {
    videoAlbumData.updateAt = updateAt;
  }
  final dynamic siteId = json['site_id'];
  if (siteId != null) {
    videoAlbumData.siteId = siteId;
  }
  return videoAlbumData;
}

Map<String, dynamic> $VideoAlbumDataToJson(VideoAlbumData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
  data['name'] = entity.name;
  data['surface_plot'] = entity.surfacePlot;
  data['recommend'] = entity.recommend;
  data['status'] = entity.status;
  data['introduce'] = entity.introduce;
  data['popularity_day'] = entity.popularityDay;
  data['popularity_week'] = entity.popularityWeek;
  data['popularity_month'] = entity.popularityMonth;
  data['popularity_sum'] = entity.popularitySum;
  data['note'] = entity.note;
  data['sort'] = entity.sort;
  data['type'] = entity.type;
  data['create_at'] = entity.createAt;
  data['update_at'] = entity.updateAt;
  data['site_id'] = entity.siteId;
  return data;
}

extension VideoAlbumDataExtension on VideoAlbumData {
  VideoAlbumData copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic createUserId,
    dynamic updateUserId,
    String? title,
    dynamic name,
    String? surfacePlot,
    String? recommend,
    String? status,
    dynamic introduce,
    String? popularityDay,
    String? popularityWeek,
    String? popularityMonth,
    String? popularitySum,
    dynamic note,
    int? sort,
    int? type,
    dynamic createAt,
    dynamic updateAt,
    dynamic siteId,
  }) {
    return VideoAlbumData()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..name = name ?? this.name
      ..surfacePlot = surfacePlot ?? this.surfacePlot
      ..recommend = recommend ?? this.recommend
      ..status = status ?? this.status
      ..introduce = introduce ?? this.introduce
      ..popularityDay = popularityDay ?? this.popularityDay
      ..popularityWeek = popularityWeek ?? this.popularityWeek
      ..popularityMonth = popularityMonth ?? this.popularityMonth
      ..popularitySum = popularitySum ?? this.popularitySum
      ..note = note ?? this.note
      ..sort = sort ?? this.sort
      ..type = type ?? this.type
      ..createAt = createAt ?? this.createAt
      ..updateAt = updateAt ?? this.updateAt
      ..siteId = siteId ?? this.siteId;
  }
}