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
  int? type;
  @JSONField(name: 'create_at')
  dynamic createAt;
  @JSONField(name: 'update_at')
  dynamic updateAt;
  @JSONField(name: 'site_id')
  dynamic siteId;
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
  dynamic createUserId;
  dynamic updateUserId;
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
  @JSONField(name: 'album_id')
  int? albumId;
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
  int? useLocalImage;
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

  AlbumDataListList();

  factory AlbumDataListList.fromJson(Map<String, dynamic> json) =>
      $AlbumDataListListFromJson(json);

  Map<String, dynamic> toJson() => $AlbumDataListListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
