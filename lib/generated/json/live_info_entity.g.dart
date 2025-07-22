import 'package:flutter_app/entity/live_info_entity.dart';

import 'base/json_convert_content.dart';

LiveInfoEntity $LiveInfoEntityFromJson(Map<String, dynamic> json) {
  final LiveInfoEntity liveInfoEntity = LiveInfoEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    liveInfoEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    liveInfoEntity.message = message;
  }
  final LiveInfoData? data = jsonConvert.convert<LiveInfoData>(json['data']);
  if (data != null) {
    liveInfoEntity.data = data;
  }
  return liveInfoEntity;
}

Map<String, dynamic> $LiveInfoEntityToJson(LiveInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension LiveInfoEntityExtension on LiveInfoEntity {
  LiveInfoEntity copyWith({int? code, String? message, LiveInfoData? data}) {
    return LiveInfoEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

LiveInfoData $LiveInfoDataFromJson(Map<String, dynamic> json) {
  final LiveInfoData liveInfoData = LiveInfoData();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    liveInfoData.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    liveInfoData.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    liveInfoData.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    liveInfoData.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    liveInfoData.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    liveInfoData.updateUserId = updateUserId;
  }
  final String? image = jsonConvert.convert<String>(json['image']);
  if (image != null) {
    liveInfoData.image = image;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    liveInfoData.title = title;
  }
  final dynamic roomId = json['roomId'];
  if (roomId != null) {
    liveInfoData.roomId = roomId;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    liveInfoData.categoryId = categoryId;
  }
  final dynamic pushUrl = json['pushUrl'];
  if (pushUrl != null) {
    liveInfoData.pushUrl = pushUrl;
  }
  final String? pullUrl = jsonConvert.convert<String>(json['pullUrl']);
  if (pullUrl != null) {
    liveInfoData.pullUrl = pullUrl;
  }
  final dynamic pushCode = json['pushCode'];
  if (pushCode != null) {
    liveInfoData.pushCode = pushCode;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    liveInfoData.status = status;
  }
  return liveInfoData;
}

Map<String, dynamic> $LiveInfoDataToJson(LiveInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['image'] = entity.image;
  data['title'] = entity.title;
  data['roomId'] = entity.roomId;
  data['category_id'] = entity.categoryId;
  data['pushUrl'] = entity.pushUrl;
  data['pullUrl'] = entity.pullUrl;
  data['pushCode'] = entity.pushCode;
  data['status'] = entity.status;
  return data;
}

extension LiveInfoDataExtension on LiveInfoData {
  LiveInfoData copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    dynamic updateUserId,
    String? image,
    String? title,
    dynamic roomId,
    int? categoryId,
    dynamic pushUrl,
    String? pullUrl,
    dynamic pushCode,
    int? status,
  }) {
    return LiveInfoData()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..image = image ?? this.image
      ..title = title ?? this.title
      ..roomId = roomId ?? this.roomId
      ..categoryId = categoryId ?? this.categoryId
      ..pushUrl = pushUrl ?? this.pushUrl
      ..pullUrl = pullUrl ?? this.pullUrl
      ..pushCode = pushCode ?? this.pushCode
      ..status = status ?? this.status;
  }
}
