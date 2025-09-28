import 'package:flutter_app/entity/member_exchange_config_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

MemberExchangeConfigEntity $MemberExchangeConfigEntityFromJson(
  Map<String, dynamic> json,
) {
  final MemberExchangeConfigEntity memberExchangeConfigEntity =
      MemberExchangeConfigEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    memberExchangeConfigEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    memberExchangeConfigEntity.message = message;
  }
  final MemberExchangeConfigData? data = jsonConvert
      .convert<MemberExchangeConfigData>(json['data']);
  if (data != null) {
    memberExchangeConfigEntity.data = data;
  }
  return memberExchangeConfigEntity;
}

Map<String, dynamic> $MemberExchangeConfigEntityToJson(
  MemberExchangeConfigEntity entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension MemberExchangeConfigEntityExtension on MemberExchangeConfigEntity {
  MemberExchangeConfigEntity copyWith({
    int? code,
    String? message,
    MemberExchangeConfigData? data,
  }) {
    return MemberExchangeConfigEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

MemberExchangeConfigData $MemberExchangeConfigDataFromJson(
  Map<String, dynamic> json,
) {
  final MemberExchangeConfigData memberExchangeConfigData =
      MemberExchangeConfigData();
  final List<MemberExchangeConfigDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<MemberExchangeConfigDataList>(e)
                    as MemberExchangeConfigDataList,
          )
          .toList();
  if (list != null) {
    memberExchangeConfigData.list = list;
  }
  final MemberExchangeConfigDataPagination? pagination = jsonConvert
      .convert<MemberExchangeConfigDataPagination>(json['pagination']);
  if (pagination != null) {
    memberExchangeConfigData.pagination = pagination;
  }
  return memberExchangeConfigData;
}

Map<String, dynamic> $MemberExchangeConfigDataToJson(
  MemberExchangeConfigData entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension MemberExchangeConfigDataExtension on MemberExchangeConfigData {
  MemberExchangeConfigData copyWith({
    List<MemberExchangeConfigDataList>? list,
    MemberExchangeConfigDataPagination? pagination,
  }) {
    return MemberExchangeConfigData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

MemberExchangeConfigDataList $MemberExchangeConfigDataListFromJson(
  Map<String, dynamic> json,
) {
  final MemberExchangeConfigDataList memberExchangeConfigDataList =
      MemberExchangeConfigDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    memberExchangeConfigDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    memberExchangeConfigDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    memberExchangeConfigDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    memberExchangeConfigDataList.tenantId = tenantId;
  }
  final String? exchangeName = jsonConvert.convert<String>(
    json['exchangeName'],
  );
  if (exchangeName != null) {
    memberExchangeConfigDataList.exchangeName = exchangeName;
  }
  final int? requiredScore = jsonConvert.convert<int>(json['requiredScore']);
  if (requiredScore != null) {
    memberExchangeConfigDataList.requiredScore = requiredScore;
  }
  final int? days = jsonConvert.convert<int>(json['days']);
  if (days != null) {
    memberExchangeConfigDataList.days = days;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    memberExchangeConfigDataList.sort = sort;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    memberExchangeConfigDataList.remark = remark;
  }
  final int? enabled = jsonConvert.convert<int>(json['enabled']);
  if (enabled != null) {
    memberExchangeConfigDataList.enabled = enabled;
  }
  return memberExchangeConfigDataList;
}

Map<String, dynamic> $MemberExchangeConfigDataListToJson(
  MemberExchangeConfigDataList entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['exchangeName'] = entity.exchangeName;
  data['requiredScore'] = entity.requiredScore;
  data['days'] = entity.days;
  data['sort'] = entity.sort;
  data['remark'] = entity.remark;
  data['enabled'] = entity.enabled;
  return data;
}

extension MemberExchangeConfigDataListExtension
    on MemberExchangeConfigDataList {
  MemberExchangeConfigDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    String? exchangeName,
    int? requiredScore,
    int? days,
    int? sort,
    dynamic remark,
    int? enabled,
  }) {
    return MemberExchangeConfigDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..exchangeName = exchangeName ?? this.exchangeName
      ..requiredScore = requiredScore ?? this.requiredScore
      ..days = days ?? this.days
      ..sort = sort ?? this.sort
      ..remark = remark ?? this.remark
      ..enabled = enabled ?? this.enabled;
  }
}

MemberExchangeConfigDataPagination $MemberExchangeConfigDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final MemberExchangeConfigDataPagination memberExchangeConfigDataPagination =
      MemberExchangeConfigDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    memberExchangeConfigDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    memberExchangeConfigDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    memberExchangeConfigDataPagination.total = total;
  }
  return memberExchangeConfigDataPagination;
}

Map<String, dynamic> $MemberExchangeConfigDataPaginationToJson(
  MemberExchangeConfigDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension MemberExchangeConfigDataPaginationExtension
    on MemberExchangeConfigDataPagination {
  MemberExchangeConfigDataPagination copyWith({
    int? page,
    int? size,
    int? total,
  }) {
    return MemberExchangeConfigDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
