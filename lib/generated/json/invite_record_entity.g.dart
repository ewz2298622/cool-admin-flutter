import 'package:flutter_app/entity/invite_record_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

InviteRecordEntity $InviteRecordEntityFromJson(Map<String, dynamic> json) {
  final InviteRecordEntity inviteRecordEntity = InviteRecordEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    inviteRecordEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    inviteRecordEntity.message = message;
  }
  final InviteRecordData? data = jsonConvert.convert<InviteRecordData>(
    json['data'],
  );
  if (data != null) {
    inviteRecordEntity.data = data;
  }
  return inviteRecordEntity;
}

Map<String, dynamic> $InviteRecordEntityToJson(InviteRecordEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension InviteRecordEntityExtension on InviteRecordEntity {
  InviteRecordEntity copyWith({
    int? code,
    String? message,
    InviteRecordData? data,
  }) {
    return InviteRecordEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

InviteRecordData $InviteRecordDataFromJson(Map<String, dynamic> json) {
  final InviteRecordData inviteRecordData = InviteRecordData();
  final List<InviteRecordDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<InviteRecordDataList>(e)
                    as InviteRecordDataList,
          )
          .toList();
  if (list != null) {
    inviteRecordData.list = list;
  }
  final InviteRecordDataPagination? pagination = jsonConvert
      .convert<InviteRecordDataPagination>(json['pagination']);
  if (pagination != null) {
    inviteRecordData.pagination = pagination;
  }
  return inviteRecordData;
}

Map<String, dynamic> $InviteRecordDataToJson(InviteRecordData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension InviteRecordDataExtension on InviteRecordData {
  InviteRecordData copyWith({
    List<InviteRecordDataList>? list,
    InviteRecordDataPagination? pagination,
  }) {
    return InviteRecordData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

InviteRecordDataList $InviteRecordDataListFromJson(Map<String, dynamic> json) {
  final InviteRecordDataList inviteRecordDataList = InviteRecordDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    inviteRecordDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    inviteRecordDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    inviteRecordDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    inviteRecordDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    inviteRecordDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    inviteRecordDataList.updateUserId = updateUserId;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    inviteRecordDataList.code = code;
  }
  final int? loginType = jsonConvert.convert<int>(json['loginType']);
  if (loginType != null) {
    inviteRecordDataList.loginType = loginType;
  }
  final String? ipAddress = jsonConvert.convert<String>(json['ipAddress']);
  if (ipAddress != null) {
    inviteRecordDataList.ipAddress = ipAddress;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    inviteRecordDataList.remark = remark;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    inviteRecordDataList.avatarUrl = avatarUrl;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    inviteRecordDataList.nickName = nickName;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    inviteRecordDataList.phone = phone;
  }
  final int? gender = jsonConvert.convert<int>(json['gender']);
  if (gender != null) {
    inviteRecordDataList.gender = gender;
  }
  return inviteRecordDataList;
}

Map<String, dynamic> $InviteRecordDataListToJson(InviteRecordDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['code'] = entity.code;
  data['loginType'] = entity.loginType;
  data['ipAddress'] = entity.ipAddress;
  data['remark'] = entity.remark;
  data['avatarUrl'] = entity.avatarUrl;
  data['nickName'] = entity.nickName;
  data['phone'] = entity.phone;
  data['gender'] = entity.gender;
  return data;
}

extension InviteRecordDataListExtension on InviteRecordDataList {
  InviteRecordDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    dynamic updateUserId,
    String? code,
    int? loginType,
    String? ipAddress,
    dynamic remark,
    String? avatarUrl,
    String? nickName,
    String? phone,
    int? gender,
  }) {
    return InviteRecordDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..code = code ?? this.code
      ..loginType = loginType ?? this.loginType
      ..ipAddress = ipAddress ?? this.ipAddress
      ..remark = remark ?? this.remark
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..nickName = nickName ?? this.nickName
      ..phone = phone ?? this.phone
      ..gender = gender ?? this.gender;
  }
}

InviteRecordDataPagination $InviteRecordDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final InviteRecordDataPagination inviteRecordDataPagination =
      InviteRecordDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    inviteRecordDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    inviteRecordDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    inviteRecordDataPagination.total = total;
  }
  return inviteRecordDataPagination;
}

Map<String, dynamic> $InviteRecordDataPaginationToJson(
  InviteRecordDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension InviteRecordDataPaginationExtension on InviteRecordDataPagination {
  InviteRecordDataPagination copyWith({int? page, int? size, int? total}) {
    return InviteRecordDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
