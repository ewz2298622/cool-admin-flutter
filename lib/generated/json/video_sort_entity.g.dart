import 'package:flutter_app/entity/video_sort_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

VideoSortEntity $VideoSortEntityFromJson(Map<String, dynamic> json) {
  final VideoSortEntity videoSortEntity = VideoSortEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoSortEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoSortEntity.message = message;
  }
  final VideoSortData? data = jsonConvert.convert<VideoSortData>(json['data']);
  if (data != null) {
    videoSortEntity.data = data;
  }
  return videoSortEntity;
}

Map<String, dynamic> $VideoSortEntityToJson(VideoSortEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoSortEntityExtension on VideoSortEntity {
  VideoSortEntity copyWith({int? code, String? message, VideoSortData? data}) {
    return VideoSortEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoSortData $VideoSortDataFromJson(Map<String, dynamic> json) {
  final VideoSortData videoSortData = VideoSortData();
  final List<VideoSortDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoSortDataList>(e) as VideoSortDataList,
          )
          .toList();
  if (list != null) {
    videoSortData.list = list;
  }
  final VideoSortDataPagination? pagination = jsonConvert
      .convert<VideoSortDataPagination>(json['pagination']);
  if (pagination != null) {
    videoSortData.pagination = pagination;
  }
  return videoSortData;
}

Map<String, dynamic> $VideoSortDataToJson(VideoSortData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension VideoSortDataExtension on VideoSortData {
  VideoSortData copyWith({
    List<VideoSortDataList>? list,
    VideoSortDataPagination? pagination,
  }) {
    return VideoSortData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

VideoSortDataList $VideoSortDataListFromJson(Map<String, dynamic> json) {
  final VideoSortDataList videoSortDataList = VideoSortDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoSortDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoSortDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoSortDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoSortDataList.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoSortDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoSortDataList.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    videoSortDataList.title = title;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoSortDataList.surfacePlot = surfacePlot;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoSortDataList.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    videoSortDataList.cycleImg = cycleImg;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    videoSortDataList.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    videoSortDataList.actors = actors;
  }
  final String? imdbScore = jsonConvert.convert<String>(json['imdb_score']);
  if (imdbScore != null) {
    videoSortDataList.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
    json['imdb_score_id'],
  );
  if (imdbScoreId != null) {
    videoSortDataList.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    videoSortDataList.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
    json['douban_score_id'],
  );
  if (doubanScoreId != null) {
    videoSortDataList.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    videoSortDataList.introduce = introduce;
  }
  final String? popularityDay = jsonConvert.convert<String>(
    json['popularity_day'],
  );
  if (popularityDay != null) {
    videoSortDataList.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
    json['popularity_week'],
  );
  if (popularityWeek != null) {
    videoSortDataList.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
    json['popularity_month'],
  );
  if (popularityMonth != null) {
    videoSortDataList.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
    json['popularity_sum'],
  );
  if (popularitySum != null) {
    videoSortDataList.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    videoSortDataList.note = note;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoSortDataList.status = status;
  }
  final dynamic duration = json['duration'];
  if (duration != null) {
    videoSortDataList.duration = duration;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    videoSortDataList.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    videoSortDataList.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
    json['horizontal_poster'],
  );
  if (horizontalPoster != null) {
    videoSortDataList.horizontalPoster = horizontalPoster;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    videoSortDataList.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    videoSortDataList.publish = publish;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    videoSortDataList.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    videoSortDataList.screenshot = screenshot;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    videoSortDataList.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    videoSortDataList.unit = unit;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    videoSortDataList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    videoSortDataList.playUrlPutIn = playUrlPutIn;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    videoSortDataList.categoryId = categoryId;
  }
  final int? region = jsonConvert.convert<int>(json['region']);
  if (region != null) {
    videoSortDataList.region = region;
  }
  final int? language = jsonConvert.convert<int>(json['language']);
  if (language != null) {
    videoSortDataList.language = language;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    videoSortDataList.collectionId = collectionId;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    videoSortDataList.collectionName = collectionName;
  }
  final String? remarks = jsonConvert.convert<String>(json['remarks']);
  if (remarks != null) {
    videoSortDataList.remarks = remarks;
  }
  final int? year = jsonConvert.convert<int>(json['year']);
  if (year != null) {
    videoSortDataList.year = year;
  }
  final int? categoryPid = jsonConvert.convert<int>(json['category_pid']);
  if (categoryPid != null) {
    videoSortDataList.categoryPid = categoryPid;
  }
  final int? up = jsonConvert.convert<int>(json['up']);
  if (up != null) {
    videoSortDataList.up = up;
  }
  final int? down = jsonConvert.convert<int>(json['down']);
  if (down != null) {
    videoSortDataList.down = down;
  }
  final String? popularity = jsonConvert.convert<String>(json['popularity']);
  if (popularity != null) {
    videoSortDataList.popularity = popularity;
  }
  final String? pubdate = jsonConvert.convert<String>(json['pubdate']);
  if (pubdate != null) {
    videoSortDataList.pubdate = pubdate;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    videoSortDataList.subTitle = subTitle;
  }
  final dynamic videoTag = json['video_tag'];
  if (videoTag != null) {
    videoSortDataList.videoTag = videoTag;
  }
  final dynamic videoClass = json['video_class'];
  if (videoClass != null) {
    videoSortDataList.videoClass = videoClass;
  }
  return videoSortDataList;
}

Map<String, dynamic> $VideoSortDataListToJson(VideoSortDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
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
  data['popularity_day'] = entity.popularityDay;
  data['popularity_week'] = entity.popularityWeek;
  data['popularity_month'] = entity.popularityMonth;
  data['popularity_sum'] = entity.popularitySum;
  data['note'] = entity.note;
  data['status'] = entity.status;
  data['duration'] = entity.duration;
  data['number'] = entity.number;
  data['total'] = entity.total;
  data['horizontal_poster'] = entity.horizontalPoster;
  data['vertical_poster'] = entity.verticalPoster;
  data['publish'] = entity.publish;
  data['serial_number'] = entity.serialNumber;
  data['screenshot'] = entity.screenshot;
  data['end'] = entity.end;
  data['unit'] = entity.unit;
  data['play_url'] = entity.playUrl;
  data['play_url_put_in'] = entity.playUrlPutIn;
  data['category_id'] = entity.categoryId;
  data['region'] = entity.region;
  data['language'] = entity.language;
  data['collection_id'] = entity.collectionId;
  data['collection_name'] = entity.collectionName;
  data['remarks'] = entity.remarks;
  data['year'] = entity.year;
  data['category_pid'] = entity.categoryPid;
  data['up'] = entity.up;
  data['down'] = entity.down;
  data['popularity'] = entity.popularity;
  data['pubdate'] = entity.pubdate;
  data['sub_title'] = entity.subTitle;
  data['video_tag'] = entity.videoTag;
  data['video_class'] = entity.videoClass;
  return data;
}

extension VideoSortDataListExtension on VideoSortDataList {
  VideoSortDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? title,
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
    String? popularityDay,
    String? popularityWeek,
    String? popularityMonth,
    String? popularitySum,
    dynamic note,
    String? status,
    dynamic duration,
    String? number,
    String? total,
    String? horizontalPoster,
    dynamic verticalPoster,
    dynamic publish,
    dynamic serialNumber,
    dynamic screenshot,
    int? end,
    dynamic unit,
    String? playUrl,
    int? playUrlPutIn,
    int? categoryId,
    int? region,
    int? language,
    int? collectionId,
    String? collectionName,
    String? remarks,
    int? year,
    int? categoryPid,
    int? up,
    int? down,
    String? popularity,
    String? pubdate,
    String? subTitle,
    dynamic videoTag,
    dynamic videoClass,
  }) {
    return VideoSortDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
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
      ..popularityDay = popularityDay ?? this.popularityDay
      ..popularityWeek = popularityWeek ?? this.popularityWeek
      ..popularityMonth = popularityMonth ?? this.popularityMonth
      ..popularitySum = popularitySum ?? this.popularitySum
      ..note = note ?? this.note
      ..status = status ?? this.status
      ..duration = duration ?? this.duration
      ..number = number ?? this.number
      ..total = total ?? this.total
      ..horizontalPoster = horizontalPoster ?? this.horizontalPoster
      ..verticalPoster = verticalPoster ?? this.verticalPoster
      ..publish = publish ?? this.publish
      ..serialNumber = serialNumber ?? this.serialNumber
      ..screenshot = screenshot ?? this.screenshot
      ..end = end ?? this.end
      ..unit = unit ?? this.unit
      ..playUrl = playUrl ?? this.playUrl
      ..playUrlPutIn = playUrlPutIn ?? this.playUrlPutIn
      ..categoryId = categoryId ?? this.categoryId
      ..region = region ?? this.region
      ..language = language ?? this.language
      ..collectionId = collectionId ?? this.collectionId
      ..collectionName = collectionName ?? this.collectionName
      ..remarks = remarks ?? this.remarks
      ..year = year ?? this.year
      ..categoryPid = categoryPid ?? this.categoryPid
      ..up = up ?? this.up
      ..down = down ?? this.down
      ..popularity = popularity ?? this.popularity
      ..pubdate = pubdate ?? this.pubdate
      ..subTitle = subTitle ?? this.subTitle
      ..videoTag = videoTag ?? this.videoTag
      ..videoClass = videoClass ?? this.videoClass;
  }
}

VideoSortDataPagination $VideoSortDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final VideoSortDataPagination videoSortDataPagination =
      VideoSortDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    videoSortDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    videoSortDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    videoSortDataPagination.total = total;
  }
  return videoSortDataPagination;
}

Map<String, dynamic> $VideoSortDataPaginationToJson(
  VideoSortDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension VideoSortDataPaginationExtension on VideoSortDataPagination {
  VideoSortDataPagination copyWith({int? page, int? size, int? total}) {
    return VideoSortDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
