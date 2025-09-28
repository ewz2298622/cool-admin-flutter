import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/member_exchange_config_entity.g.dart';
import 'dart:convert';
export 'package:flutter_app/generated/json/member_exchange_config_entity.g.dart';

@JsonSerializable()
class MemberExchangeConfigEntity {
	int? code;
	String? message;
	MemberExchangeConfigData? data;

	MemberExchangeConfigEntity();

	factory MemberExchangeConfigEntity.fromJson(Map<String, dynamic> json) => $MemberExchangeConfigEntityFromJson(json);

	Map<String, dynamic> toJson() => $MemberExchangeConfigEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberExchangeConfigData {
	List<MemberExchangeConfigDataList>? list;
	MemberExchangeConfigDataPagination? pagination;

	MemberExchangeConfigData();

	factory MemberExchangeConfigData.fromJson(Map<String, dynamic> json) => $MemberExchangeConfigDataFromJson(json);

	Map<String, dynamic> toJson() => $MemberExchangeConfigDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberExchangeConfigDataList {
	int? id;
	String? createTime;
	String? updateTime;
	dynamic tenantId;
	String? exchangeName;
	int? requiredScore;
	int? days;
	int? sort;
	dynamic remark;
	int? enabled;

	MemberExchangeConfigDataList();

	factory MemberExchangeConfigDataList.fromJson(Map<String, dynamic> json) => $MemberExchangeConfigDataListFromJson(json);

	Map<String, dynamic> toJson() => $MemberExchangeConfigDataListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MemberExchangeConfigDataPagination {
	int? page;
	int? size;
	int? total;

	MemberExchangeConfigDataPagination();

	factory MemberExchangeConfigDataPagination.fromJson(Map<String, dynamic> json) => $MemberExchangeConfigDataPaginationFromJson(json);

	Map<String, dynamic> toJson() => $MemberExchangeConfigDataPaginationToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}