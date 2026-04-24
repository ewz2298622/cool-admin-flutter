import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/album_video_list_entity.dart';

AlbumVideoListEntity $AlbumVideoListEntityFromJson(Map<String, dynamic> json) {
  final AlbumVideoListEntity albumVideoListEntity = AlbumVideoListEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    albumVideoListEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    albumVideoListEntity.message = message;
  }
  final AlbumVideoListData? data = jsonConvert.convert<AlbumVideoListData>(
      json['data']);
  if (data != null) {
    albumVideoListEntity.data = data;
  }
  return albumVideoListEntity;
}

Map<String, dynamic> $AlbumVideoListEntityToJson(AlbumVideoListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension AlbumVideoListEntityExtension on AlbumVideoListEntity {
  AlbumVideoListEntity copyWith({
    int? code,
    String? message,
    AlbumVideoListData? data,
  }) {
    return AlbumVideoListEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

AlbumVideoListData $AlbumVideoListDataFromJson(Map<String, dynamic> json) {
  final AlbumVideoListData albumVideoListData = AlbumVideoListData();
  final List<AlbumVideoListDataList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<AlbumVideoListDataList>(e) as AlbumVideoListDataList)
      .toList();
  if (list != null) {
    albumVideoListData.list = list;
  }
  final AlbumVideoListDataPagination? pagination = jsonConvert.convert<
      AlbumVideoListDataPagination>(json['pagination']);
  if (pagination != null) {
    albumVideoListData.pagination = pagination;
  }
  return albumVideoListData;
}

Map<String, dynamic> $AlbumVideoListDataToJson(AlbumVideoListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension AlbumVideoListDataExtension on AlbumVideoListData {
  AlbumVideoListData copyWith({
    List<AlbumVideoListDataList>? list,
    AlbumVideoListDataPagination? pagination,
  }) {
    return AlbumVideoListData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

AlbumVideoListDataList $AlbumVideoListDataListFromJson(
    Map<String, dynamic> json) {
  final AlbumVideoListDataList albumVideoListDataList = AlbumVideoListDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    albumVideoListDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    albumVideoListDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    albumVideoListDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    albumVideoListDataList.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    albumVideoListDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    albumVideoListDataList.updateUserId = updateUserId;
  }
  final String? albumId = jsonConvert.convert<String>(json['album_id']);
  if (albumId != null) {
    albumVideoListDataList.albumId = albumId;
  }
  final String? videosId = jsonConvert.convert<String>(json['videos_id']);
  if (videosId != null) {
    albumVideoListDataList.videosId = videosId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    albumVideoListDataList.title = title;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    albumVideoListDataList.categoryId = categoryId;
  }
  final int? categoryPid = jsonConvert.convert<int>(json['category_pid']);
  if (categoryPid != null) {
    albumVideoListDataList.categoryPid = categoryPid;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    albumVideoListDataList.surfacePlot = surfacePlot;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    albumVideoListDataList.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    albumVideoListDataList.cycleImg = cycleImg;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    albumVideoListDataList.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    albumVideoListDataList.actors = actors;
  }
  final String? imdbScore = jsonConvert.convert<String>(json['imdb_score']);
  if (imdbScore != null) {
    albumVideoListDataList.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
      json['imdb_score_id']);
  if (imdbScoreId != null) {
    albumVideoListDataList.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    albumVideoListDataList.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
      json['douban_score_id']);
  if (doubanScoreId != null) {
    albumVideoListDataList.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    albumVideoListDataList.introduce = introduce;
  }
  final String? popularity = jsonConvert.convert<String>(json['popularity']);
  if (popularity != null) {
    albumVideoListDataList.popularity = popularity;
  }
  final String? popularityDay = jsonConvert.convert<String>(
      json['popularity_day']);
  if (popularityDay != null) {
    albumVideoListDataList.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
      json['popularity_week']);
  if (popularityWeek != null) {
    albumVideoListDataList.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
      json['popularity_month']);
  if (popularityMonth != null) {
    albumVideoListDataList.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
      json['popularity_sum']);
  if (popularitySum != null) {
    albumVideoListDataList.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    albumVideoListDataList.note = note;
  }
  final int? year = jsonConvert.convert<int>(json['year']);
  if (year != null) {
    albumVideoListDataList.year = year;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    albumVideoListDataList.status = status;
  }
  final String? duration = jsonConvert.convert<String>(json['duration']);
  if (duration != null) {
    albumVideoListDataList.duration = duration;
  }
  final int? region = jsonConvert.convert<int>(json['region']);
  if (region != null) {
    albumVideoListDataList.region = region;
  }
  final int? language = jsonConvert.convert<int>(json['language']);
  if (language != null) {
    albumVideoListDataList.language = language;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    albumVideoListDataList.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    albumVideoListDataList.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
      json['horizontal_poster']);
  if (horizontalPoster != null) {
    albumVideoListDataList.horizontalPoster = horizontalPoster;
  }
  final String? remarks = jsonConvert.convert<String>(json['remarks']);
  if (remarks != null) {
    albumVideoListDataList.remarks = remarks;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    albumVideoListDataList.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    albumVideoListDataList.publish = publish;
  }
  final String? pubdate = jsonConvert.convert<String>(json['pubdate']);
  if (pubdate != null) {
    albumVideoListDataList.pubdate = pubdate;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    albumVideoListDataList.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    albumVideoListDataList.screenshot = screenshot;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    albumVideoListDataList.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    albumVideoListDataList.unit = unit;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    albumVideoListDataList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    albumVideoListDataList.playUrlPutIn = playUrlPutIn;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    albumVideoListDataList.collectionId = collectionId;
  }
  final int? up = jsonConvert.convert<int>(json['up']);
  if (up != null) {
    albumVideoListDataList.up = up;
  }
  final int? down = jsonConvert.convert<int>(json['down']);
  if (down != null) {
    albumVideoListDataList.down = down;
  }
  final String? collectionName = jsonConvert.convert<String>(
      json['collection_name']);
  if (collectionName != null) {
    albumVideoListDataList.collectionName = collectionName;
  }
  return albumVideoListDataList;
}

Map<String, dynamic> $AlbumVideoListDataListToJson(
    AlbumVideoListDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['album_id'] = entity.albumId;
  data['videos_id'] = entity.videosId;
  data['title'] = entity.title;
  data['category_id'] = entity.categoryId;
  data['category_pid'] = entity.categoryPid;
  data['surface_plot'] = entity.surfacePlot;
  data['cycle'] = entity.cycle;
  data['cycle_img'] = entity.cycleImg;
  data['directors'] = entity.directors;
  data['actors'] = entity.actors;
  data['imdb_score'] = entity.imdbScore;
  data['imdb_score_id'] = entity.imdbScoreId;
  data['douban_score'] = entity.doubanScore;
  data['douban_score_id'] = entity.doubanScoreId;
  data['introduce'] = entity.introduce;
  data['popularity'] = entity.popularity;
  data['popularity_day'] = entity.popularityDay;
  data['popularity_week'] = entity.popularityWeek;
  data['popularity_month'] = entity.popularityMonth;
  data['popularity_sum'] = entity.popularitySum;
  data['note'] = entity.note;
  data['year'] = entity.year;
  data['status'] = entity.status;
  data['duration'] = entity.duration;
  data['region'] = entity.region;
  data['language'] = entity.language;
  data['number'] = entity.number;
  data['total'] = entity.total;
  data['horizontal_poster'] = entity.horizontalPoster;
  data['remarks'] = entity.remarks;
  data['vertical_poster'] = entity.verticalPoster;
  data['publish'] = entity.publish;
  data['pubdate'] = entity.pubdate;
  data['serial_number'] = entity.serialNumber;
  data['screenshot'] = entity.screenshot;
  data['end'] = entity.end;
  data['unit'] = entity.unit;
  data['play_url'] = entity.playUrl;
  data['play_url_put_in'] = entity.playUrlPutIn;
  data['collection_id'] = entity.collectionId;
  data['up'] = entity.up;
  data['down'] = entity.down;
  data['collection_name'] = entity.collectionName;
  return data;
}

extension AlbumVideoListDataListExtension on AlbumVideoListDataList {
  AlbumVideoListDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? albumId,
    String? videosId,
    String? title,
    int? categoryId,
    int? categoryPid,
    String? surfacePlot,
    String? cycle,
    dynamic cycleImg,
    String? directors,
    String? actors,
    String? imdbScore,
    String? imdbScoreId,
    int? doubanScore,
    String? doubanScoreId,
    String? introduce,
    String? popularity,
    String? popularityDay,
    String? popularityWeek,
    String? popularityMonth,
    String? popularitySum,
    dynamic note,
    int? year,
    String? status,
    String? duration,
    int? region,
    int? language,
    String? number,
    String? total,
    String? horizontalPoster,
    String? remarks,
    dynamic verticalPoster,
    dynamic publish,
    String? pubdate,
    dynamic serialNumber,
    dynamic screenshot,
    int? end,
    dynamic unit,
    String? playUrl,
    int? playUrlPutIn,
    int? collectionId,
    int? up,
    int? down,
    String? collectionName,
  }) {
    return AlbumVideoListDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..albumId = albumId ?? this.albumId
      ..videosId = videosId ?? this.videosId
      ..title = title ?? this.title
      ..categoryId = categoryId ?? this.categoryId
      ..categoryPid = categoryPid ?? this.categoryPid
      ..surfacePlot = surfacePlot ?? this.surfacePlot
      ..cycle = cycle ?? this.cycle
      ..cycleImg = cycleImg ?? this.cycleImg
      ..directors = directors ?? this.directors
      ..actors = actors ?? this.actors
      ..imdbScore = imdbScore ?? this.imdbScore
      ..imdbScoreId = imdbScoreId ?? this.imdbScoreId
      ..doubanScore = doubanScore ?? this.doubanScore
      ..doubanScoreId = doubanScoreId ?? this.doubanScoreId
      ..introduce = introduce ?? this.introduce
      ..popularity = popularity ?? this.popularity
      ..popularityDay = popularityDay ?? this.popularityDay
      ..popularityWeek = popularityWeek ?? this.popularityWeek
      ..popularityMonth = popularityMonth ?? this.popularityMonth
      ..popularitySum = popularitySum ?? this.popularitySum
      ..note = note ?? this.note
      ..year = year ?? this.year
      ..status = status ?? this.status
      ..duration = duration ?? this.duration
      ..region = region ?? this.region
      ..language = language ?? this.language
      ..number = number ?? this.number
      ..total = total ?? this.total
      ..horizontalPoster = horizontalPoster ?? this.horizontalPoster
      ..remarks = remarks ?? this.remarks
      ..verticalPoster = verticalPoster ?? this.verticalPoster
      ..publish = publish ?? this.publish
      ..pubdate = pubdate ?? this.pubdate
      ..serialNumber = serialNumber ?? this.serialNumber
      ..screenshot = screenshot ?? this.screenshot
      ..end = end ?? this.end
      ..unit = unit ?? this.unit
      ..playUrl = playUrl ?? this.playUrl
      ..playUrlPutIn = playUrlPutIn ?? this.playUrlPutIn
      ..collectionId = collectionId ?? this.collectionId
      ..up = up ?? this.up
      ..down = down ?? this.down
      ..collectionName = collectionName ?? this.collectionName;
  }
}

AlbumVideoListDataPagination $AlbumVideoListDataPaginationFromJson(
    Map<String, dynamic> json) {
  final AlbumVideoListDataPagination albumVideoListDataPagination = AlbumVideoListDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    albumVideoListDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    albumVideoListDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    albumVideoListDataPagination.total = total;
  }
  return albumVideoListDataPagination;
}

Map<String, dynamic> $AlbumVideoListDataPaginationToJson(
    AlbumVideoListDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension AlbumVideoListDataPaginationExtension on AlbumVideoListDataPagination {
  AlbumVideoListDataPagination copyWith({
    int? page,
    int? size,
    int? total,
  }) {
    return AlbumVideoListDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}