import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/video_detail_entity.dart';

VideoDetailEntity $VideoDetailEntityFromJson(Map<String, dynamic> json) {
  final VideoDetailEntity videoDetailEntity = VideoDetailEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoDetailEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoDetailEntity.message = message;
  }
  final VideoDetailData? data = jsonConvert.convert<VideoDetailData>(
      json['data']);
  if (data != null) {
    videoDetailEntity.data = data;
  }
  return videoDetailEntity;
}

Map<String, dynamic> $VideoDetailEntityToJson(VideoDetailEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoDetailEntityExtension on VideoDetailEntity {
  VideoDetailEntity copyWith({
    int? code,
    String? message,
    VideoDetailData? data,
  }) {
    return VideoDetailEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoDetailData $VideoDetailDataFromJson(Map<String, dynamic> json) {
  final VideoDetailData videoDetailData = VideoDetailData();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoDetailData.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoDetailData.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoDetailData.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoDetailData.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoDetailData.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoDetailData.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    videoDetailData.title = title;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    videoDetailData.subTitle = subTitle;
  }
  final dynamic videoTag = json['video_tag'];
  if (videoTag != null) {
    videoDetailData.videoTag = videoTag;
  }
  final dynamic videoClass = json['video_class'];
  if (videoClass != null) {
    videoDetailData.videoClass = videoClass;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    videoDetailData.categoryId = categoryId;
  }
  final int? categoryPid = jsonConvert.convert<int>(json['category_pid']);
  if (categoryPid != null) {
    videoDetailData.categoryPid = categoryPid;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoDetailData.surfacePlot = surfacePlot;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoDetailData.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    videoDetailData.cycleImg = cycleImg;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    videoDetailData.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    videoDetailData.actors = actors;
  }
  final String? imdbScore = jsonConvert.convert<String>(json['imdb_score']);
  if (imdbScore != null) {
    videoDetailData.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
      json['imdb_score_id']);
  if (imdbScoreId != null) {
    videoDetailData.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    videoDetailData.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
      json['douban_score_id']);
  if (doubanScoreId != null) {
    videoDetailData.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    videoDetailData.introduce = introduce;
  }
  final String? popularity = jsonConvert.convert<String>(json['popularity']);
  if (popularity != null) {
    videoDetailData.popularity = popularity;
  }
  final String? popularityDay = jsonConvert.convert<String>(
      json['popularity_day']);
  if (popularityDay != null) {
    videoDetailData.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
      json['popularity_week']);
  if (popularityWeek != null) {
    videoDetailData.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
      json['popularity_month']);
  if (popularityMonth != null) {
    videoDetailData.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
      json['popularity_sum']);
  if (popularitySum != null) {
    videoDetailData.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    videoDetailData.note = note;
  }
  final int? year = jsonConvert.convert<int>(json['year']);
  if (year != null) {
    videoDetailData.year = year;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoDetailData.status = status;
  }
  final dynamic duration = json['duration'];
  if (duration != null) {
    videoDetailData.duration = duration;
  }
  final int? region = jsonConvert.convert<int>(json['region']);
  if (region != null) {
    videoDetailData.region = region;
  }
  final int? language = jsonConvert.convert<int>(json['language']);
  if (language != null) {
    videoDetailData.language = language;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    videoDetailData.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    videoDetailData.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
      json['horizontal_poster']);
  if (horizontalPoster != null) {
    videoDetailData.horizontalPoster = horizontalPoster;
  }
  final String? remarks = jsonConvert.convert<String>(json['remarks']);
  if (remarks != null) {
    videoDetailData.remarks = remarks;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    videoDetailData.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    videoDetailData.publish = publish;
  }
  final String? pubdate = jsonConvert.convert<String>(json['pubdate']);
  if (pubdate != null) {
    videoDetailData.pubdate = pubdate;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    videoDetailData.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    videoDetailData.screenshot = screenshot;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    videoDetailData.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    videoDetailData.unit = unit;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    videoDetailData.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    videoDetailData.playUrlPutIn = playUrlPutIn;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    videoDetailData.collectionId = collectionId;
  }
  final int? up = jsonConvert.convert<int>(json['up']);
  if (up != null) {
    videoDetailData.up = up;
  }
  final int? down = jsonConvert.convert<int>(json['down']);
  if (down != null) {
    videoDetailData.down = down;
  }
  final String? collectionName = jsonConvert.convert<String>(
      json['collection_name']);
  if (collectionName != null) {
    videoDetailData.collectionName = collectionName;
  }
  return videoDetailData;
}

Map<String, dynamic> $VideoDetailDataToJson(VideoDetailData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
  data['sub_title'] = entity.subTitle;
  data['video_tag'] = entity.videoTag;
  data['video_class'] = entity.videoClass;
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

extension VideoDetailDataExtension on VideoDetailData {
  VideoDetailData copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? title,
    String? subTitle,
    dynamic videoTag,
    dynamic videoClass,
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
    dynamic duration,
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
    return VideoDetailData()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..subTitle = subTitle ?? this.subTitle
      ..videoTag = videoTag ?? this.videoTag
      ..videoClass = videoClass ?? this.videoClass
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