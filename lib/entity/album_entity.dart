import 'dart:convert';

import 'package:flutter_app/generated/json/album_entity.g.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

export 'package:flutter_app/generated/json/album_entity.g.dart';

@JsonSerializable()
class AlbumEntity {
  int? code;
  String? message;
  AlbumData? data;

  AlbumEntity();

  factory AlbumEntity.fromJson(Map<String, dynamic> json) =>
      $AlbumEntityFromJson(json);

  Map<String, dynamic> toJson() => $AlbumEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AlbumData {
  List<AlbumDataList>? list;

  AlbumData();

  factory AlbumData.fromJson(Map<String, dynamic> json) =>
      $AlbumDataFromJson(json);

  Map<String, dynamic> toJson() => $AlbumDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AlbumDataList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  dynamic updateUserId;
  String? title;
  dynamic name;
  @JSONField(name: 'surface_plot')
  String? surfacePlot;
  String? recommend;
  String? status;
  dynamic introduce;
  @JSONField(name: 'popularity_day')
  String? popularityDay;
  @JSONField(name: 'popularity_week')
  String? popularityWeek;
  @JSONField(name: 'popularity_month')
  String? popularityMonth;
  @JSONField(name: 'popularity_sum')
  String? popularitySum;
  dynamic note;
  int? sort;
  @JSONField(name: 'category_id')
  int? categoryId;
  List<AlbumDataListList>? list;

  AlbumDataList();

  factory AlbumDataList.fromJson(Map<String, dynamic> json) =>
      $AlbumDataListFromJson(json);

  Map<String, dynamic> toJson() => $AlbumDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AlbumDataListList {
  int? id;
  String? createTime;
  String? updateTime;
  dynamic tenantId;
  dynamic createUserId;
  dynamic updateUserId;
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

  AlbumDataListList();

  factory AlbumDataListList.fromJson(Map<String, dynamic> json) =>
      $AlbumDataListListFromJson(json);

  Map<String, dynamic> toJson() => $AlbumDataListListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
