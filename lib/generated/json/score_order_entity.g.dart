import 'package:flutter_app/entity/score_order_entity.dart';

import 'base/json_convert_content.dart';

ScoreOrderEntity $ScoreOrderEntityFromJson(Map<String, dynamic> json) {
  final ScoreOrderEntity scoreOrderEntity = ScoreOrderEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    scoreOrderEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    scoreOrderEntity.message = message;
  }
  final ScoreOrderData? data = jsonConvert.convert<ScoreOrderData>(
    json['data'],
  );
  if (data != null) {
    scoreOrderEntity.data = data;
  }
  return scoreOrderEntity;
}

Map<String, dynamic> $ScoreOrderEntityToJson(ScoreOrderEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension ScoreOrderEntityExtension on ScoreOrderEntity {
  ScoreOrderEntity copyWith({
    int? code,
    String? message,
    ScoreOrderData? data,
  }) {
    return ScoreOrderEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

ScoreOrderData $ScoreOrderDataFromJson(Map<String, dynamic> json) {
  final ScoreOrderData scoreOrderData = ScoreOrderData();
  final List<ScoreOrderDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<ScoreOrderDataList>(e)
                    as ScoreOrderDataList,
          )
          .toList();
  if (list != null) {
    scoreOrderData.list = list;
  }
  final ScoreOrderDataPagination? pagination = jsonConvert
      .convert<ScoreOrderDataPagination>(json['pagination']);
  if (pagination != null) {
    scoreOrderData.pagination = pagination;
  }
  return scoreOrderData;
}

Map<String, dynamic> $ScoreOrderDataToJson(ScoreOrderData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension ScoreOrderDataExtension on ScoreOrderData {
  ScoreOrderData copyWith({
    List<ScoreOrderDataList>? list,
    ScoreOrderDataPagination? pagination,
  }) {
    return ScoreOrderData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

ScoreOrderDataList $ScoreOrderDataListFromJson(Map<String, dynamic> json) {
  final ScoreOrderDataList scoreOrderDataList = ScoreOrderDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    scoreOrderDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    scoreOrderDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    scoreOrderDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    scoreOrderDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    scoreOrderDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    scoreOrderDataList.updateUserId = updateUserId;
  }
  final int? score = jsonConvert.convert<int>(json['score']);
  if (score != null) {
    scoreOrderDataList.score = score;
  }
  final String? reason = jsonConvert.convert<String>(json['reason']);
  if (reason != null) {
    scoreOrderDataList.reason = reason;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    scoreOrderDataList.type = type;
  }
  final int? businessId = jsonConvert.convert<int>(json['businessId']);
  if (businessId != null) {
    scoreOrderDataList.businessId = businessId;
  }
  final int? businessType = jsonConvert.convert<int>(json['businessType']);
  if (businessType != null) {
    scoreOrderDataList.businessType = businessType;
  }
  return scoreOrderDataList;
}

Map<String, dynamic> $ScoreOrderDataListToJson(ScoreOrderDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['score'] = entity.score;
  data['reason'] = entity.reason;
  data['type'] = entity.type;
  data['businessId'] = entity.businessId;
  data['businessType'] = entity.businessType;
  return data;
}

extension ScoreOrderDataListExtension on ScoreOrderDataList {
  ScoreOrderDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    dynamic updateUserId,
    int? score,
    String? reason,
    int? type,
    int? businessId,
    int? businessType,
  }) {
    return ScoreOrderDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..score = score ?? this.score
      ..reason = reason ?? this.reason
      ..type = type ?? this.type
      ..businessId = businessId ?? this.businessId
      ..businessType = businessType ?? this.businessType;
  }
}

ScoreOrderDataPagination $ScoreOrderDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final ScoreOrderDataPagination scoreOrderDataPagination =
      ScoreOrderDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    scoreOrderDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    scoreOrderDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    scoreOrderDataPagination.total = total;
  }
  return scoreOrderDataPagination;
}

Map<String, dynamic> $ScoreOrderDataPaginationToJson(
  ScoreOrderDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension ScoreOrderDataPaginationExtension on ScoreOrderDataPagination {
  ScoreOrderDataPagination copyWith({int? page, int? size, int? total}) {
    return ScoreOrderDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
