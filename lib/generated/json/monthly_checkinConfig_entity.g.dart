import 'package:flutter_app/entity/monthly_checkinConfig_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

MonthlyCheckinConfigEntity $MonthlyCheckinConfigEntityFromJson(
  Map<String, dynamic> json,
) {
  final MonthlyCheckinConfigEntity monthlyCheckinConfigEntity =
      MonthlyCheckinConfigEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    monthlyCheckinConfigEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    monthlyCheckinConfigEntity.message = message;
  }
  final MonthlyCheckinConfigData? data = jsonConvert
      .convert<MonthlyCheckinConfigData>(json['data']);
  if (data != null) {
    monthlyCheckinConfigEntity.data = data;
  }
  return monthlyCheckinConfigEntity;
}

Map<String, dynamic> $MonthlyCheckinConfigEntityToJson(
  MonthlyCheckinConfigEntity entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension MonthlyCheckinConfigEntityExtension on MonthlyCheckinConfigEntity {
  MonthlyCheckinConfigEntity copyWith({
    int? code,
    String? message,
    MonthlyCheckinConfigData? data,
  }) {
    return MonthlyCheckinConfigEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

MonthlyCheckinConfigData $MonthlyCheckinConfigDataFromJson(
  Map<String, dynamic> json,
) {
  final MonthlyCheckinConfigData monthlyCheckinConfigData =
      MonthlyCheckinConfigData();
  final List<MonthlyCheckinConfigDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<MonthlyCheckinConfigDataList>(e)
                    as MonthlyCheckinConfigDataList,
          )
          .toList();
  if (list != null) {
    monthlyCheckinConfigData.list = list;
  }
  return monthlyCheckinConfigData;
}

Map<String, dynamic> $MonthlyCheckinConfigDataToJson(
  MonthlyCheckinConfigData entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension MonthlyCheckinConfigDataExtension on MonthlyCheckinConfigData {
  MonthlyCheckinConfigData copyWith({
    List<MonthlyCheckinConfigDataList>? list,
  }) {
    return MonthlyCheckinConfigData()..list = list ?? this.list;
  }
}

MonthlyCheckinConfigDataList $MonthlyCheckinConfigDataListFromJson(
  Map<String, dynamic> json,
) {
  final MonthlyCheckinConfigDataList monthlyCheckinConfigDataList =
      MonthlyCheckinConfigDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    monthlyCheckinConfigDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    monthlyCheckinConfigDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    monthlyCheckinConfigDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    monthlyCheckinConfigDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    monthlyCheckinConfigDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    monthlyCheckinConfigDataList.updateUserId = updateUserId;
  }
  final int? month = jsonConvert.convert<int>(json['month']);
  if (month != null) {
    monthlyCheckinConfigDataList.month = month;
  }
  final int? day = jsonConvert.convert<int>(json['day']);
  if (day != null) {
    monthlyCheckinConfigDataList.day = day;
  }
  final int? score = jsonConvert.convert<int>(json['score']);
  if (score != null) {
    monthlyCheckinConfigDataList.score = score;
  }
  final int? enabled = jsonConvert.convert<int>(json['enabled']);
  if (enabled != null) {
    monthlyCheckinConfigDataList.enabled = enabled;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    monthlyCheckinConfigDataList.remark = remark;
  }
  final int? isSigned = jsonConvert.convert<int>(json['isSigned']);
  if (isSigned != null) {
    monthlyCheckinConfigDataList.isSigned = isSigned;
  }
  return monthlyCheckinConfigDataList;
}

Map<String, dynamic> $MonthlyCheckinConfigDataListToJson(
  MonthlyCheckinConfigDataList entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['month'] = entity.month;
  data['day'] = entity.day;
  data['score'] = entity.score;
  data['enabled'] = entity.enabled;
  data['remark'] = entity.remark;
  data['isSigned'] = entity.isSigned;
  return data;
}

extension MonthlyCheckinConfigDataListExtension
    on MonthlyCheckinConfigDataList {
  MonthlyCheckinConfigDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    dynamic updateUserId,
    int? month,
    int? day,
    int? score,
    int? enabled,
    dynamic remark,
    int? isSigned,
  }) {
    return MonthlyCheckinConfigDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..month = month ?? this.month
      ..day = day ?? this.day
      ..score = score ?? this.score
      ..enabled = enabled ?? this.enabled
      ..remark = remark ?? this.remark
      ..isSigned = isSigned ?? this.isSigned;
  }
}
