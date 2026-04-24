import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/week_entity.g.dart';

export 'package:flutter_app/generated/json/week_entity.g.dart';

@JsonSerializable()
class WeekEntity {
  int? code;
  String? message;
  WeekData? data;

  WeekEntity();

  factory WeekEntity.fromJson(Map<String, dynamic> json) =>
      $WeekEntityFromJson(json);

  Map<String, dynamic> toJson() => $WeekEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class WeekData {
  List<WeekDataList>? list;
  WeekDataPagination? pagination;

  WeekData();

  factory WeekData.fromJson(Map<String, dynamic> json) =>
      $WeekDataFromJson(json);

  Map<String, dynamic> toJson() => $WeekDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class WeekDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  int? createUserId;
  dynamic updateUserId;
  int? week;
  int? videoId;
  dynamic remarks;
  int? sort;
  String? time;
  String? title;
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
  String? imdbScore;
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
  @JSONField(name: 'collection_name')
  String? collectionName;
  @JSONField(name: 'sub_title')
  String? subTitle;
  @JSONField(name: 'video_tag')
  String? videoTag;
  @JSONField(name: 'video_class')
  String? videoClass;

  WeekDataList();

  factory WeekDataList.fromJson(Map<String, dynamic> json) =>
      $WeekDataListFromJson(json);

  Map<String, dynamic> toJson() => $WeekDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class WeekDataPagination {
  int? page;
  int? size;
  int? total;

  WeekDataPagination();

  factory WeekDataPagination.fromJson(Map<String, dynamic> json) =>
      $WeekDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $WeekDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
