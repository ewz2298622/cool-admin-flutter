import 'package:flutter_app/entity/cash_order_entity.dart';

import 'base/json_convert_content.dart';

CashOrderEntity $CashOrderEntityFromJson(Map<String, dynamic> json) {
  final CashOrderEntity cashOrderEntity = CashOrderEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    cashOrderEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    cashOrderEntity.message = message;
  }
  final CashOrderData? data = jsonConvert.convert<CashOrderData>(json['data']);
  if (data != null) {
    cashOrderEntity.data = data;
  }
  return cashOrderEntity;
}

Map<String, dynamic> $CashOrderEntityToJson(CashOrderEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension CashOrderEntityExtension on CashOrderEntity {
  CashOrderEntity copyWith({int? code, String? message, CashOrderData? data}) {
    return CashOrderEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

CashOrderData $CashOrderDataFromJson(Map<String, dynamic> json) {
  final CashOrderData cashOrderData = CashOrderData();
  final List<CashOrderDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<CashOrderDataList>(e) as CashOrderDataList,
          )
          .toList();
  if (list != null) {
    cashOrderData.list = list;
  }
  final CashOrderDataPagination? pagination = jsonConvert
      .convert<CashOrderDataPagination>(json['pagination']);
  if (pagination != null) {
    cashOrderData.pagination = pagination;
  }
  return cashOrderData;
}

Map<String, dynamic> $CashOrderDataToJson(CashOrderData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension CashOrderDataExtension on CashOrderData {
  CashOrderData copyWith({
    List<CashOrderDataList>? list,
    CashOrderDataPagination? pagination,
  }) {
    return CashOrderData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

CashOrderDataList $CashOrderDataListFromJson(Map<String, dynamic> json) {
  final CashOrderDataList cashOrderDataList = CashOrderDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    cashOrderDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    cashOrderDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    cashOrderDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    cashOrderDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    cashOrderDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    cashOrderDataList.updateUserId = updateUserId;
  }
  final int? score = jsonConvert.convert<int>(json['score']);
  if (score != null) {
    cashOrderDataList.score = score;
  }
  final String? amount = jsonConvert.convert<String>(json['amount']);
  if (amount != null) {
    cashOrderDataList.amount = amount;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    cashOrderDataList.status = status;
  }
  final dynamic auditRemark = json['auditRemark'];
  if (auditRemark != null) {
    cashOrderDataList.auditRemark = auditRemark;
  }
  final int? paymentType = jsonConvert.convert<int>(json['paymentType']);
  if (paymentType != null) {
    cashOrderDataList.paymentType = paymentType;
  }
  final String? paymentAccount = jsonConvert.convert<String>(
    json['paymentAccount'],
  );
  if (paymentAccount != null) {
    cashOrderDataList.paymentAccount = paymentAccount;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    cashOrderDataList.remark = remark;
  }
  final String? ipAddress = jsonConvert.convert<String>(json['ipAddress']);
  if (ipAddress != null) {
    cashOrderDataList.ipAddress = ipAddress;
  }
  return cashOrderDataList;
}

Map<String, dynamic> $CashOrderDataListToJson(CashOrderDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['score'] = entity.score;
  data['amount'] = entity.amount;
  data['status'] = entity.status;
  data['auditRemark'] = entity.auditRemark;
  data['paymentType'] = entity.paymentType;
  data['paymentAccount'] = entity.paymentAccount;
  data['remark'] = entity.remark;
  data['ipAddress'] = entity.ipAddress;
  return data;
}

extension CashOrderDataListExtension on CashOrderDataList {
  CashOrderDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    dynamic updateUserId,
    int? score,
    String? amount,
    int? status,
    dynamic auditRemark,
    int? paymentType,
    String? paymentAccount,
    dynamic remark,
    String? ipAddress,
  }) {
    return CashOrderDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..score = score ?? this.score
      ..amount = amount ?? this.amount
      ..status = status ?? this.status
      ..auditRemark = auditRemark ?? this.auditRemark
      ..paymentType = paymentType ?? this.paymentType
      ..paymentAccount = paymentAccount ?? this.paymentAccount
      ..remark = remark ?? this.remark
      ..ipAddress = ipAddress ?? this.ipAddress;
  }
}

CashOrderDataPagination $CashOrderDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final CashOrderDataPagination cashOrderDataPagination =
      CashOrderDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    cashOrderDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    cashOrderDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    cashOrderDataPagination.total = total;
  }
  return cashOrderDataPagination;
}

Map<String, dynamic> $CashOrderDataPaginationToJson(
  CashOrderDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension CashOrderDataPaginationExtension on CashOrderDataPagination {
  CashOrderDataPagination copyWith({int? page, int? size, int? total}) {
    return CashOrderDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
