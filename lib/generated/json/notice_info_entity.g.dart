import 'package:flutter_app/entity/notice_info_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

NoticeInfoEntity $NoticeInfoEntityFromJson(Map<String, dynamic> json) {
  final NoticeInfoEntity noticeInfoEntity = NoticeInfoEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    noticeInfoEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    noticeInfoEntity.message = message;
  }
  final NoticeInfoData? data = jsonConvert.convert<NoticeInfoData>(
    json['data'],
  );
  if (data != null) {
    noticeInfoEntity.data = data;
  }
  return noticeInfoEntity;
}

Map<String, dynamic> $NoticeInfoEntityToJson(NoticeInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension NoticeInfoEntityExtension on NoticeInfoEntity {
  NoticeInfoEntity copyWith({
    int? code,
    String? message,
    NoticeInfoData? data,
  }) {
    return NoticeInfoEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

NoticeInfoData $NoticeInfoDataFromJson(Map<String, dynamic> json) {
  final NoticeInfoData noticeInfoData = NoticeInfoData();
  final List<NoticeInfoDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<NoticeInfoDataList>(e)
                    as NoticeInfoDataList,
          )
          .toList();
  if (list != null) {
    noticeInfoData.list = list;
  }
  final NoticeInfoDataPagination? pagination = jsonConvert
      .convert<NoticeInfoDataPagination>(json['pagination']);
  if (pagination != null) {
    noticeInfoData.pagination = pagination;
  }
  return noticeInfoData;
}

Map<String, dynamic> $NoticeInfoDataToJson(NoticeInfoData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension NoticeInfoDataExtension on NoticeInfoData {
  NoticeInfoData copyWith({
    List<NoticeInfoDataList>? list,
    NoticeInfoDataPagination? pagination,
  }) {
    return NoticeInfoData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

NoticeInfoDataList $NoticeInfoDataListFromJson(Map<String, dynamic> json) {
  final NoticeInfoDataList noticeInfoDataList = NoticeInfoDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    noticeInfoDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    noticeInfoDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    noticeInfoDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    noticeInfoDataList.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    noticeInfoDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    noticeInfoDataList.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    noticeInfoDataList.title = title;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    noticeInfoDataList.content = content;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    noticeInfoDataList.type = type;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    noticeInfoDataList.status = status;
  }
  return noticeInfoDataList;
}

Map<String, dynamic> $NoticeInfoDataListToJson(NoticeInfoDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
  data['content'] = entity.content;
  data['type'] = entity.type;
  data['status'] = entity.status;
  return data;
}

extension NoticeInfoDataListExtension on NoticeInfoDataList {
  NoticeInfoDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? title,
    String? content,
    int? type,
    int? status,
  }) {
    return NoticeInfoDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..content = content ?? this.content
      ..type = type ?? this.type
      ..status = status ?? this.status;
  }
}

NoticeInfoDataPagination $NoticeInfoDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final NoticeInfoDataPagination noticeInfoDataPagination =
      NoticeInfoDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    noticeInfoDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    noticeInfoDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    noticeInfoDataPagination.total = total;
  }
  return noticeInfoDataPagination;
}

Map<String, dynamic> $NoticeInfoDataPaginationToJson(
  NoticeInfoDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension NoticeInfoDataPaginationExtension on NoticeInfoDataPagination {
  NoticeInfoDataPagination copyWith({int? page, int? size, int? total}) {
    return NoticeInfoDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
