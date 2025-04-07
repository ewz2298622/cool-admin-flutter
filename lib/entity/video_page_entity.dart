import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/video_page_entity.g.dart';

export 'package:flutter_app/generated/json/video_page_entity.g.dart';

@JsonSerializable()
class VideoPageEntity {
  int? code;
  String? message;
  VideoPageData? data;

  VideoPageEntity();

  factory VideoPageEntity.fromJson(Map<String, dynamic> json) =>
      $VideoPageEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoPageEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoPageData {
  List<VideoPageDataList>? list;
  VideoPageDataPagination? pagination;

  VideoPageData();

  factory VideoPageData.fromJson(Map<String, dynamic> json) =>
      $VideoPageDataFromJson(json);

  Map<String, dynamic> toJson() => $VideoPageDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoPageDataList {
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
  String? introduce;
  @JSONField(name: 'popularity_day')
  String? popularityDay;
  @JSONField(name: 'popularity_week')
  String? popularityWeek;
  @JSONField(name: 'popularity_month')
  String? popularityMonth;
  @JSONField(name: 'popularity_sum')
  String? popularitySum;
  String? note;
  String? year;
  String? status;
  @JSONField(name: 'create_at')
  String? createAt;
  @JSONField(name: 'update_at')
  String? updateAt;
  String? duration;
  String? region;
  String? language;
  String? label;
  String? number;
  String? total;
  @JSONField(name: 'horizontal_poster')
  String? horizontalPoster;
  @JSONField(name: 'vertical_poster')
  String? verticalPoster;
  String? publish;
  @JSONField(name: 'serial_number')
  String? serialNumber;
  String? screenshot;
  String? gif;
  String? alias;
  @JSONField(name: 'release_at')
  String? releaseAt;
  @JSONField(name: 'shelf_at')
  String? shelfAt;
  int? end;
  String? unit;
  String? watch;
  @JSONField(name: 'collection_id')
  String? collectionId;
  @JSONField(name: 'use_local_image')
  dynamic useLocalImage;
  @JSONField(name: 'titles_time')
  int? titlesTime;
  @JSONField(name: 'trailer_time')
  int? trailerTime;
  @JSONField(name: 'site_id')
  int? siteId;
  @JSONField(name: 'category_pid_status')
  int? categoryPidStatus;
  @JSONField(name: 'category_child_id_status')
  int? categoryChildIdStatus;
  @JSONField(name: 'play_url')
  String? playUrl;
  @JSONField(name: 'play_url_put_in')
  int? playUrlPutIn;
  String? createTime;
  String? updateTime;
  dynamic createUserId;
  dynamic updateUserId;
  int? id;
  @JSONField(name: 'douban_score_id')
  String? doubanScoreId;
  @JSONField(name: 'album_id')
  int? albumId;
  @JSONField(name: 'douban_score')
  int? doubanScore;

  VideoPageDataList();

  factory VideoPageDataList.fromJson(Map<String, dynamic> json) =>
      $VideoPageDataListFromJson(json);

  Map<String, dynamic> toJson() => $VideoPageDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoPageDataPagination {
  int? page;
  int? size;
  int? total;

  VideoPageDataPagination();

  factory VideoPageDataPagination.fromJson(Map<String, dynamic> json) =>
      $VideoPageDataPaginationFromJson(json);

  Map<String, dynamic> toJson() => $VideoPageDataPaginationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
