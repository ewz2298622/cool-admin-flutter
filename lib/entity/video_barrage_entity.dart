import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_barrage_entity.g.dart';
import 'dart:convert';
export 'package:flutter_app/generated/json/video_barrage_entity.g.dart';

@JsonSerializable()
class VideoBarrageEntity {
	int? code;
	String? message;
	VideoBarrageData? data;

	VideoBarrageEntity();

	factory VideoBarrageEntity.fromJson(Map<String, dynamic> json) => $VideoBarrageEntityFromJson(json);

	Map<String, dynamic> toJson() => $VideoBarrageEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VideoBarrageData {
	List<VideoBarrageDataList>? list;
	VideoBarrageDataPagination? pagination;

	VideoBarrageData();

	factory VideoBarrageData.fromJson(Map<String, dynamic> json) => $VideoBarrageDataFromJson(json);

	Map<String, dynamic> toJson() => $VideoBarrageDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VideoBarrageDataList {
	int? id;
	String? createTime;
	String? updateTime;
	int? tenantId;
	int? createUserId;
	int? updateUserId;
	@JSONField(name: 'video_id')
	String? videoId;
	String? text;
	int? fontSize;
	int? type;
	String? color;
	int? status;
	int? time;

	VideoBarrageDataList();

	factory VideoBarrageDataList.fromJson(Map<String, dynamic> json) => $VideoBarrageDataListFromJson(json);

	Map<String, dynamic> toJson() => $VideoBarrageDataListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VideoBarrageDataPagination {
	int? page;
	int? size;
	int? total;

	VideoBarrageDataPagination();

	factory VideoBarrageDataPagination.fromJson(Map<String, dynamic> json) => $VideoBarrageDataPaginationFromJson(json);

	Map<String, dynamic> toJson() => $VideoBarrageDataPaginationToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}