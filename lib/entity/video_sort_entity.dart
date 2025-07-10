import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_sort_entity.g.dart';

export 'package:flutter_app/generated/json/video_sort_entity.g.dart';

@JsonSerializable()
class VideoSortEntity {
  int? code;
  String? message;
  VideoSortData? data;

  VideoSortEntity();

  factory VideoSortEntity.fromJson(Map<String, dynamic> json) =>
      $VideoSortEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoSortEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoSortData {
  List<VideoSortDataList>? list;
  VideoSortDataPagination? pagination;

  VideoSortData();

  factory VideoSortData.fromJson(Map<String, dynamic> json) =>
      $VideoSortDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoSortDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoSortDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  dynamic updateUserId;
  String? title;
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
  @JSONField(name: 'popularity_day')
  String? popularityDay;
  @JSONField(name: 'popularity_week')
  String? popularityWeek;
  @JSONField(name: 'popularity_month')
  String? popularityMonth;
  @JSONField(name: 'popularity_sum')
  String? popularitySum;
  dynamic note;
  String? status;
  dynamic duration;
  String? number;
  String? total;
  @JSONField(name: 'horizontal_poster')
  String? horizontalPoster;
  @JSONField(name: 'vertical_poster')
  dynamic verticalPoster;
  dynamic publish;
  @JSONField(name: 'serial_number')
  dynamic serialNumber;
  dynamic screenshot;
  int? end;
  dynamic unit;
  @JSONField(name: 'play_url')
  String? playUrl;
  @JSONField(name: 'play_url_put_in')
  int? playUrlPutIn;
  @JSONField(name: 'category_id')
  int? categoryId;
  int? region;
  int? language;
  @JSONField(name: 'collection_id')
  int? collectionId;
  @JSONField(name: 'collection_name')
  String? collectionName;
  String? remarks;
  int? year;
  @JSONField(name: 'category_pid')
  int? categoryPid;
  int? up;
  int? down;
  String? popularity;
  String? pubdate;
  @JSONField(name: 'sub_title')
  String? subTitle;
  @JSONField(name: 'video_tag')
  dynamic videoTag;
  @JSONField(name: 'video_class')
  dynamic videoClass;

  VideoSortDataList();

  factory VideoSortDataList.fromJson(Map<String, dynamic> json) =>
      $VideoSortDataListFromJson(json);

  Map<String, dynamic> toJson() => $VideoSortDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoSortDataPagination {
  int? page;
  int? size;
  int? total;

  VideoSortDataPagination();

  factory VideoSortDataPagination.fromJson(Map<String, dynamic> json) =>
      $VideoSortDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $VideoSortDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
