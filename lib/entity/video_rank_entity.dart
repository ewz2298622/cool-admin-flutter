import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_rank_entity.g.dart';

export 'package:flutter_app/generated/json/video_rank_entity.g.dart';

@JsonSerializable()
class VideoRankEntity {
  int? code;
  String? message;
  VideoRankData? data;

  VideoRankEntity();

  factory VideoRankEntity.fromJson(Map<String, dynamic> json) =>
      $VideoRankEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoRankEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoRankData {
  List<VideoRankDataList>? list;

  VideoRankData();

  factory VideoRankData.fromJson(Map<String, dynamic> json) =>
      $VideoRankDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoRankDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoRankDataList {
  int? id;
  int? typeId;
  String? name;
  dynamic value;
  int? orderNum;
  int? status;
  String? color;
  dynamic remark;
  dynamic parentId;
  List<VideoRankDataListList>? list;

  VideoRankDataList();

  factory VideoRankDataList.fromJson(Map<String, dynamic> json) =>
      $VideoRankDataListFromJson(json);

  Map<String, dynamic> toJson() => $VideoRankDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoRankDataListList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  int? updateUserId;
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
  String? duration;
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
  int? searchRecommendType;
  int? sort;

  VideoRankDataListList();

  factory VideoRankDataListList.fromJson(Map<String, dynamic> json) =>
      $VideoRankDataListListFromJson(json);

  Map<String, dynamic> toJson() => $VideoRankDataListListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
