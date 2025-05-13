import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/views_entity.g.dart';
import 'dart:convert';
export 'package:flutter_app/generated/json/views_entity.g.dart';

@JsonSerializable()
class ViewsEntity {
	int? code;
	String? message;
	ViewsData? data;

	ViewsEntity();

	factory ViewsEntity.fromJson(Map<String, dynamic> json) => $ViewsEntityFromJson(json);

	Map<String, dynamic> toJson() => $ViewsEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ViewsData {
	List<ViewsDataList>? list;
	ViewsDataPagination? pagination;

	ViewsData();

	factory ViewsData.fromJson(Map<String, dynamic> json) => $ViewsDataFromJson(json);

	Map<String, dynamic> toJson() => $ViewsDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ViewsDataList {
	int? id;
	String? createTime;
	String? updateTime;
	dynamic tenantId;
	int? createUserId;
	dynamic updateUserId;
	String? title;
	int? type;
	int? associationId;
	String? cover;
	int? duration;
	int? viewingDuration;

	ViewsDataList();

	factory ViewsDataList.fromJson(Map<String, dynamic> json) => $ViewsDataListFromJson(json);

	Map<String, dynamic> toJson() => $ViewsDataListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ViewsDataPagination {
	int? page;
	int? size;
	int? total;

	ViewsDataPagination();

	factory ViewsDataPagination.fromJson(Map<String, dynamic> json) => $ViewsDataPaginationFromJson(json);

	Map<String, dynamic> toJson() => $ViewsDataPaginationToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}