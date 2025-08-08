import 'package:flutter_app/entity/week_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

WeekEntity $WeekEntityFromJson(Map<String, dynamic> json) {
  final WeekEntity weekEntity = WeekEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    weekEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    weekEntity.message = message;
  }
  final WeekData? data = jsonConvert.convert<WeekData>(json['data']);
  if (data != null) {
    weekEntity.data = data;
  }
  return weekEntity;
}

Map<String, dynamic> $WeekEntityToJson(WeekEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension WeekEntityExtension on WeekEntity {
  WeekEntity copyWith({int? code, String? message, WeekData? data}) {
    return WeekEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

WeekData $WeekDataFromJson(Map<String, dynamic> json) {
  final WeekData weekData = WeekData();
  final List<WeekDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map((e) => jsonConvert.convert<WeekDataList>(e) as WeekDataList)
          .toList();
  if (list != null) {
    weekData.list = list;
  }
  final WeekDataPagination? pagination = jsonConvert
      .convert<WeekDataPagination>(json['pagination']);
  if (pagination != null) {
    weekData.pagination = pagination;
  }
  return weekData;
}

Map<String, dynamic> $WeekDataToJson(WeekData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension WeekDataExtension on WeekData {
  WeekData copyWith({
    List<WeekDataList>? list,
    WeekDataPagination? pagination,
  }) {
    return WeekData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

WeekDataList $WeekDataListFromJson(Map<String, dynamic> json) {
  final WeekDataList weekDataList = WeekDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    weekDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    weekDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    weekDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    weekDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    weekDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    weekDataList.updateUserId = updateUserId;
  }
  final int? week = jsonConvert.convert<int>(json['week']);
  if (week != null) {
    weekDataList.week = week;
  }
  final int? videoId = jsonConvert.convert<int>(json['videoId']);
  if (videoId != null) {
    weekDataList.videoId = videoId;
  }
  final dynamic remarks = json['remarks'];
  if (remarks != null) {
    weekDataList.remarks = remarks;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    weekDataList.sort = sort;
  }
  final String? time = jsonConvert.convert<String>(json['time']);
  if (time != null) {
    weekDataList.time = time;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    weekDataList.title = title;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    weekDataList.categoryId = categoryId;
  }
  final int? categoryPid = jsonConvert.convert<int>(json['category_pid']);
  if (categoryPid != null) {
    weekDataList.categoryPid = categoryPid;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    weekDataList.surfacePlot = surfacePlot;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    weekDataList.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    weekDataList.cycleImg = cycleImg;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    weekDataList.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    weekDataList.actors = actors;
  }
  final String? imdbScore = jsonConvert.convert<String>(json['imdb_score']);
  if (imdbScore != null) {
    weekDataList.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
    json['imdb_score_id'],
  );
  if (imdbScoreId != null) {
    weekDataList.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    weekDataList.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
    json['douban_score_id'],
  );
  if (doubanScoreId != null) {
    weekDataList.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    weekDataList.introduce = introduce;
  }
  final String? popularity = jsonConvert.convert<String>(json['popularity']);
  if (popularity != null) {
    weekDataList.popularity = popularity;
  }
  final String? popularityDay = jsonConvert.convert<String>(
    json['popularity_day'],
  );
  if (popularityDay != null) {
    weekDataList.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
    json['popularity_week'],
  );
  if (popularityWeek != null) {
    weekDataList.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
    json['popularity_month'],
  );
  if (popularityMonth != null) {
    weekDataList.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
    json['popularity_sum'],
  );
  if (popularitySum != null) {
    weekDataList.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    weekDataList.note = note;
  }
  final int? year = jsonConvert.convert<int>(json['year']);
  if (year != null) {
    weekDataList.year = year;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    weekDataList.status = status;
  }
  final dynamic duration = json['duration'];
  if (duration != null) {
    weekDataList.duration = duration;
  }
  final int? region = jsonConvert.convert<int>(json['region']);
  if (region != null) {
    weekDataList.region = region;
  }
  final int? language = jsonConvert.convert<int>(json['language']);
  if (language != null) {
    weekDataList.language = language;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    weekDataList.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    weekDataList.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
    json['horizontal_poster'],
  );
  if (horizontalPoster != null) {
    weekDataList.horizontalPoster = horizontalPoster;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    weekDataList.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    weekDataList.publish = publish;
  }
  final String? pubdate = jsonConvert.convert<String>(json['pubdate']);
  if (pubdate != null) {
    weekDataList.pubdate = pubdate;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    weekDataList.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    weekDataList.screenshot = screenshot;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    weekDataList.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    weekDataList.unit = unit;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    weekDataList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    weekDataList.playUrlPutIn = playUrlPutIn;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    weekDataList.collectionId = collectionId;
  }
  final int? up = jsonConvert.convert<int>(json['up']);
  if (up != null) {
    weekDataList.up = up;
  }
  final int? down = jsonConvert.convert<int>(json['down']);
  if (down != null) {
    weekDataList.down = down;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    weekDataList.collectionName = collectionName;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    weekDataList.subTitle = subTitle;
  }
  final String? videoTag = jsonConvert.convert<String>(json['video_tag']);
  if (videoTag != null) {
    weekDataList.videoTag = videoTag;
  }
  final String? videoClass = jsonConvert.convert<String>(json['video_class']);
  if (videoClass != null) {
    weekDataList.videoClass = videoClass;
  }
  return weekDataList;
}

Map<String, dynamic> $WeekDataListToJson(WeekDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['week'] = entity.week;
  data['videoId'] = entity.videoId;
  data['remarks'] = entity.remarks;
  data['sort'] = entity.sort;
  data['time'] = entity.time;
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
  data['sub_title'] = entity.subTitle;
  data['video_tag'] = entity.videoTag;
  data['video_class'] = entity.videoClass;
  return data;
}

extension WeekDataListExtension on WeekDataList {
  WeekDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    dynamic updateUserId,
    int? week,
    int? videoId,
    dynamic remarks,
    int? sort,
    String? time,
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
    dynamic duration,
    int? region,
    int? language,
    String? number,
    String? total,
    String? horizontalPoster,
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
    String? subTitle,
    String? videoTag,
    String? videoClass,
  }) {
    return WeekDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..week = week ?? this.week
      ..videoId = videoId ?? this.videoId
      ..remarks = remarks ?? this.remarks
      ..sort = sort ?? this.sort
      ..time = time ?? this.time
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
      ..collectionName = collectionName ?? this.collectionName
      ..subTitle = subTitle ?? this.subTitle
      ..videoTag = videoTag ?? this.videoTag
      ..videoClass = videoClass ?? this.videoClass;
  }
}

WeekDataPagination $WeekDataPaginationFromJson(Map<String, dynamic> json) {
  final WeekDataPagination weekDataPagination = WeekDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    weekDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    weekDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    weekDataPagination.total = total;
  }
  return weekDataPagination;
}

Map<String, dynamic> $WeekDataPaginationToJson(WeekDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension WeekDataPaginationExtension on WeekDataPagination {
  WeekDataPagination copyWith({int? page, int? size, int? total}) {
    return WeekDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
