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
  @JSONField(name: 'album_id')
  String? albumId;
  @JSONField(name: 'videos_id')
  String? videosId;
  @JSONField(name: 'create_at')
  dynamic createAt;
  @JSONField(name: 'update_at')
  dynamic updateAt;
  String? createTime;
  String? updateTime;
  dynamic createUserId;
  dynamic updateUserId;
  int? id;
  String? title;
  @JSONField(name: 'category_pid')
  String? categoryPid;
  @JSONField(name: 'category_child_id')
  String? categoryChildId;
  @JSONField(name: 'surface_plot')
  String? surfacePlot;
  String? recommend;
  String? cycle;
  @JSONField(name: 'cycle_img')
  String? cycleImg;
  @JSONField(name: 'charging_mode')
  String? chargingMode;
  @JSONField(name: 'buy_mode')
  String? buyMode;
  String? gold;
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
  String? label;
  String? language;
  String? region;
  String? note;
  String? duration;
  @JSONField(name: 'serial_number')
  String? serialNumber;
  String? year;
  String? alias;
  String? status;
  @JSONField(name: 'popularity_sum')
  String? popularitySum;
  @JSONField(name: 'popularity_day')
  String? popularityDay;
  @JSONField(name: 'popularity_month')
  String? popularityMonth;
  @JSONField(name: 'popularity_week')
  String? popularityWeek;
  @JSONField(name: 'release_at')
  String? releaseAt;
  @JSONField(name: 'shelf_at')
  String? shelfAt;
  String? screenshot;
  @JSONField(name: 'play_url')
  String? playUrl;
  @JSONField(name: 'play_url_put_in')
  int? playUrlPutIn;
  @JSONField(name: 'trailer_time')
  int? trailerTime;
  String? unit;
  String? number;
  String? total;
  @JSONField(name: 'horizontal_poster')
  String? horizontalPoster;
  @JSONField(name: 'vertical_poster')
  String? verticalPoster;
  String? gif;

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
