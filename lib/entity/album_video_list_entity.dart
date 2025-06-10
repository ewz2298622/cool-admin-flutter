import 'dart:convert';

import 'package:flutter_app/generated/json/album_video_list_entity.g.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

export 'package:flutter_app/generated/json/album_video_list_entity.g.dart';

@JsonSerializable()
class AlbumVideoListEntity {
  int? code;
  String? message;
  AlbumVideoListData? data;

  AlbumVideoListEntity();

  factory AlbumVideoListEntity.fromJson(Map<String, dynamic> json) =>
      $AlbumVideoListEntityFromJson(json);

  Map<String, dynamic> toJson() => $AlbumVideoListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AlbumVideoListData {
  List<AlbumVideoListDataList>? list;
  AlbumVideoListDataPagination? pagination;

  AlbumVideoListData();

  factory AlbumVideoListData.fromJson(Map<String, dynamic> json) =>
      $AlbumVideoListDataFromJson(json);

  Map<String, dynamic> toJson() => $AlbumVideoListDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AlbumVideoListDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  dynamic updateUserId;
  @JSONField(name: 'album_id')
  String? albumId;
  @JSONField(name: 'videos_id')
  String? videosId;
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
  @JSONField(name: 'collection_name')
  String? collectionName;

  AlbumVideoListDataList();

  factory AlbumVideoListDataList.fromJson(Map<String, dynamic> json) =>
      $AlbumVideoListDataListFromJson(json);

  Map<String, dynamic> toJson() => $AlbumVideoListDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AlbumVideoListDataPagination {
  int? page;
  int? size;
  int? total;

  AlbumVideoListDataPagination();

  factory AlbumVideoListDataPagination.fromJson(Map<String, dynamic> json) =>
      $AlbumVideoListDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $AlbumVideoListDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
