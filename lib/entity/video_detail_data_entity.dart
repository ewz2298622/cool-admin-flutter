import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_detail_data_entity.g.dart';
import 'dart:convert';
export 'package:flutter_app/generated/json/video_detail_data_entity.g.dart';

@JsonSerializable()
class VideoDetailDataEntity {
	int? code;
	String? message;
	VideoDetailDataData? data;

	VideoDetailDataEntity();

	factory VideoDetailDataEntity.fromJson(Map<String, dynamic> json) => $VideoDetailDataEntityFromJson(json);

	Map<String, dynamic> toJson() => $VideoDetailDataEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VideoDetailDataData {
	VideoDetailDataDataVideo? video;
	List<VideoDetailDataDataLines>? lines;

	VideoDetailDataData();

	factory VideoDetailDataData.fromJson(Map<String, dynamic> json) => $VideoDetailDataDataFromJson(json);

	Map<String, dynamic> toJson() => $VideoDetailDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VideoDetailDataDataVideo {
	int? id;
	String? createTime;
	String? updateTime;
	dynamic tenantId;
	dynamic createUserId;
	dynamic updateUserId;
	String? title;
	@JSONField(name: 'sub_title')
	String? subTitle;
	int? vip;
	@JSONField(name: 'video_tag')
	String? videoTag;
	@JSONField(name: 'video_class')
	String? videoClass;
	@JSONField(name: 'category_id')
	int? categoryId;
	@JSONField(name: 'category_pid')
	int? categoryPid;
	@JSONField(name: 'surface_plot')
	String? surfacePlot;
	String? cycle;
	@JSONField(name: 'cycle_img')
	dynamic cycleImg;
	String? directors;
	String? actors;
	@JSONField(name: 'imdb_score')
	int? imdbScore;
	@JSONField(name: 'imdb_score_id')
	String? imdbScoreId;
	@JSONField(name: 'douban_score')
	int? doubanScore;
	@JSONField(name: 'douban_score_id')
	String? doubanScoreId;
	String? introduce;
	String? popularity;
	@JSONField(name: 'popularity_day')
	String? popularityDay;
	@JSONField(name: 'popularity_week')
	String? popularityWeek;
	@JSONField(name: 'popularity_month')
	String? popularityMonth;
	@JSONField(name: 'popularity_sum')
	String? popularitySum;
	dynamic note;
	int? year;
	String? status;
	dynamic duration;
	int? region;
	int? language;
	String? number;
	String? total;
	@JSONField(name: 'horizontal_poster')
	String? horizontalPoster;
	String? remarks;
	@JSONField(name: 'vertical_poster')
	dynamic verticalPoster;
	dynamic publish;
	String? pubdate;
	@JSONField(name: 'serial_number')
	dynamic serialNumber;
	dynamic screenshot;
	int? end;
	dynamic unit;
	@JSONField(name: 'play_url')
	String? playUrl;
	@JSONField(name: 'play_url_put_in')
	int? playUrlPutIn;
	@JSONField(name: 'collection_id')
	int? collectionId;
	int? up;
	int? down;
	int? vipNumber;
	@JSONField(name: 'collection_name')
	String? collectionName;
	dynamic searchRecommendType;
	int? sort;

	VideoDetailDataDataVideo();

	factory VideoDetailDataDataVideo.fromJson(Map<String, dynamic> json) => $VideoDetailDataDataVideoFromJson(json);

	Map<String, dynamic> toJson() => $VideoDetailDataDataVideoToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VideoDetailDataDataLines {
	int? id;
	String? createTime;
	String? updateTime;
	dynamic tenantId;
	dynamic createUserId;
	dynamic updateUserId;
	@JSONField(name: 'video_id')
	String? videoId;
	@JSONField(name: 'video_name')
	String? videoName;
	@JSONField(name: 'collection_name')
	String? collectionName;
	@JSONField(name: 'collection_id')
	int? collectionId;
	@JSONField(name: 'player_id')
	int? playerId;
	int? sort;
	String? tag;
	List<VideoDetailDataDataLinesPlayLines>? playLines;

	VideoDetailDataDataLines();

	factory VideoDetailDataDataLines.fromJson(Map<String, dynamic> json) => $VideoDetailDataDataLinesFromJson(json);

	Map<String, dynamic> toJson() => $VideoDetailDataDataLinesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class VideoDetailDataDataLinesPlayLines {
	int? id;
	String? createTime;
	String? updateTime;
	dynamic tenantId;
	dynamic createUserId;
	dynamic updateUserId;
	@JSONField(name: 'video_id')
	String? videoId;
	@JSONField(name: 'video_name')
	String? videoName;
	@JSONField(name: 'video_line_id')
	String? videoLineId;
	String? name;
	@JSONField(name: 'collection_id')
	int? collectionId;
	@JSONField(name: 'collection_name')
	String? collectionName;
	String? file;
	@JSONField(name: 'sub_title')
	String? subTitle;
	int? status;
	int? sort;
	String? tag;
	int? vip;

	VideoDetailDataDataLinesPlayLines();

	factory VideoDetailDataDataLinesPlayLines.fromJson(Map<String, dynamic> json) => $VideoDetailDataDataLinesPlayLinesFromJson(json);

	Map<String, dynamic> toJson() => $VideoDetailDataDataLinesPlayLinesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}