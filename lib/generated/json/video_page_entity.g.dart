import 'package:flutter_app/entity/video_page_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

VideoPageEntity $VideoPageEntityFromJson(Map<String, dynamic> json) {
  final VideoPageEntity videoPageEntity = VideoPageEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoPageEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoPageEntity.message = message;
  }
  final VideoPageData? data = jsonConvert.convert<VideoPageData>(json['data']);
  if (data != null) {
    videoPageEntity.data = data;
  }
  return videoPageEntity;
}

Map<String, dynamic> $VideoPageEntityToJson(VideoPageEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoPageEntityExtension on VideoPageEntity {
  VideoPageEntity copyWith({int? code, String? message, VideoPageData? data}) {
    return VideoPageEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoPageData $VideoPageDataFromJson(Map<String, dynamic> json) {
  final VideoPageData videoPageData = VideoPageData();
  final List<VideoPageDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoPageDataList>(e) as VideoPageDataList,
          )
          .toList();
  if (list != null) {
    videoPageData.list = list;
  }
  final VideoPageDataPagination? pagination = jsonConvert
      .convert<VideoPageDataPagination>(json['pagination']);
  if (pagination != null) {
    videoPageData.pagination = pagination;
  }
  return videoPageData;
}

Map<String, dynamic> $VideoPageDataToJson(VideoPageData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension VideoPageDataExtension on VideoPageData {
  VideoPageData copyWith({
    List<VideoPageDataList>? list,
    VideoPageDataPagination? pagination,
  }) {
    return VideoPageData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

VideoPageDataList $VideoPageDataListFromJson(Map<String, dynamic> json) {
  final VideoPageDataList videoPageDataList = VideoPageDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoPageDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoPageDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoPageDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoPageDataList.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoPageDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoPageDataList.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    videoPageDataList.title = title;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoPageDataList.surfacePlot = surfacePlot;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoPageDataList.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    videoPageDataList.cycleImg = cycleImg;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    videoPageDataList.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    videoPageDataList.actors = actors;
  }
  final String? imdbScore = jsonConvert.convert<String>(json['imdb_score']);
  if (imdbScore != null) {
    videoPageDataList.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
    json['imdb_score_id'],
  );
  if (imdbScoreId != null) {
    videoPageDataList.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    videoPageDataList.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
    json['douban_score_id'],
  );
  if (doubanScoreId != null) {
    videoPageDataList.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    videoPageDataList.introduce = introduce;
  }
  final String? popularityDay = jsonConvert.convert<String>(
    json['popularity_day'],
  );
  if (popularityDay != null) {
    videoPageDataList.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
    json['popularity_week'],
  );
  if (popularityWeek != null) {
    videoPageDataList.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
    json['popularity_month'],
  );
  if (popularityMonth != null) {
    videoPageDataList.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
    json['popularity_sum'],
  );
  if (popularitySum != null) {
    videoPageDataList.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    videoPageDataList.note = note;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoPageDataList.status = status;
  }
  final dynamic duration = json['duration'];
  if (duration != null) {
    videoPageDataList.duration = duration;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    videoPageDataList.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    videoPageDataList.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
    json['horizontal_poster'],
  );
  if (horizontalPoster != null) {
    videoPageDataList.horizontalPoster = horizontalPoster;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    videoPageDataList.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    videoPageDataList.publish = publish;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    videoPageDataList.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    videoPageDataList.screenshot = screenshot;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    videoPageDataList.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    videoPageDataList.unit = unit;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    videoPageDataList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    videoPageDataList.playUrlPutIn = playUrlPutIn;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    videoPageDataList.categoryId = categoryId;
  }
  final int? region = jsonConvert.convert<int>(json['region']);
  if (region != null) {
    videoPageDataList.region = region;
  }
  final int? language = jsonConvert.convert<int>(json['language']);
  if (language != null) {
    videoPageDataList.language = language;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    videoPageDataList.collectionId = collectionId;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    videoPageDataList.collectionName = collectionName;
  }
  final String? remarks = jsonConvert.convert<String>(json['remarks']);
  if (remarks != null) {
    videoPageDataList.remarks = remarks;
  }
  final int? year = jsonConvert.convert<int>(json['year']);
  if (year != null) {
    videoPageDataList.year = year;
  }
  final int? categoryPid = jsonConvert.convert<int>(json['category_pid']);
  if (categoryPid != null) {
    videoPageDataList.categoryPid = categoryPid;
  }
  final int? up = jsonConvert.convert<int>(json['up']);
  if (up != null) {
    videoPageDataList.up = up;
  }
  final int? down = jsonConvert.convert<int>(json['down']);
  if (down != null) {
    videoPageDataList.down = down;
  }
  final String? popularity = jsonConvert.convert<String>(json['popularity']);
  if (popularity != null) {
    videoPageDataList.popularity = popularity;
  }
  final String? pubdate = jsonConvert.convert<String>(json['pubdate']);
  if (pubdate != null) {
    videoPageDataList.pubdate = pubdate;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    videoPageDataList.subTitle = subTitle;
  }
  final dynamic videoTag = json['video_tag'];
  if (videoTag != null) {
    videoPageDataList.videoTag = videoTag;
  }
  final dynamic videoClass = json['video_class'];
  if (videoClass != null) {
    videoPageDataList.videoClass = videoClass;
  }
  return videoPageDataList;
}

Map<String, dynamic> $VideoPageDataListToJson(VideoPageDataList entity) {
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

extension VideoPageDataListExtension on VideoPageDataList {
  VideoPageDataList copyWith({
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
    return VideoPageDataList()
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

VideoPageDataPagination $VideoPageDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final VideoPageDataPagination videoPageDataPagination =
      VideoPageDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    videoPageDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    videoPageDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    videoPageDataPagination.total = total;
  }
  return videoPageDataPagination;
}

Map<String, dynamic> $VideoPageDataPaginationToJson(
  VideoPageDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension VideoPageDataPaginationExtension on VideoPageDataPagination {
  VideoPageDataPagination copyWith({int? page, int? size, int? total}) {
    return VideoPageDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
