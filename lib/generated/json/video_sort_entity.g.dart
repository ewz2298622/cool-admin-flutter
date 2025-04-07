import 'package:flutter_app/entity/video_sort_entity.dart';

import 'base/json_convert_content.dart';

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
  final String? categoryPid = jsonConvert.convert<String>(json['category_pid']);
  if (categoryPid != null) {
    videoSortDataList.categoryPid = categoryPid;
  }
  final String? categoryChildId = jsonConvert.convert<String>(
    json['category_child_id'],
  );
  if (categoryChildId != null) {
    videoSortDataList.categoryChildId = categoryChildId;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoSortDataList.surfacePlot = surfacePlot;
  }
  final String? recommend = jsonConvert.convert<String>(json['recommend']);
  if (recommend != null) {
    videoSortDataList.recommend = recommend;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoSortDataList.cycle = cycle;
  }
  final String? cycleImg = jsonConvert.convert<String>(json['cycle_img']);
  if (cycleImg != null) {
    videoSortDataList.cycleImg = cycleImg;
  }
  final String? chargingMode = jsonConvert.convert<String>(
    json['charging_mode'],
  );
  if (chargingMode != null) {
    videoSortDataList.chargingMode = chargingMode;
  }
  final String? buyMode = jsonConvert.convert<String>(json['buy_mode']);
  if (buyMode != null) {
    videoSortDataList.buyMode = buyMode;
  }
  final String? gold = jsonConvert.convert<String>(json['gold']);
  if (gold != null) {
    videoSortDataList.gold = gold;
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
  final String? note = jsonConvert.convert<String>(json['note']);
  if (note != null) {
    videoSortDataList.note = note;
  }
  final String? year = jsonConvert.convert<String>(json['year']);
  if (year != null) {
    videoSortDataList.year = year;
  }
  final int? albumId = jsonConvert.convert<int>(json['album_id']);
  if (albumId != null) {
    videoSortDataList.albumId = albumId;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoSortDataList.status = status;
  }
  final String? createAt = jsonConvert.convert<String>(json['create_at']);
  if (createAt != null) {
    videoSortDataList.createAt = createAt;
  }
  final String? updateAt = jsonConvert.convert<String>(json['update_at']);
  if (updateAt != null) {
    videoSortDataList.updateAt = updateAt;
  }
  final String? duration = jsonConvert.convert<String>(json['duration']);
  if (duration != null) {
    videoSortDataList.duration = duration;
  }
  final String? region = jsonConvert.convert<String>(json['region']);
  if (region != null) {
    videoSortDataList.region = region;
  }
  final String? language = jsonConvert.convert<String>(json['language']);
  if (language != null) {
    videoSortDataList.language = language;
  }
  final String? label = jsonConvert.convert<String>(json['label']);
  if (label != null) {
    videoSortDataList.label = label;
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
  final String? verticalPoster = jsonConvert.convert<String>(
    json['vertical_poster'],
  );
  if (verticalPoster != null) {
    videoSortDataList.verticalPoster = verticalPoster;
  }
  final String? publish = jsonConvert.convert<String>(json['publish']);
  if (publish != null) {
    videoSortDataList.publish = publish;
  }
  final String? serialNumber = jsonConvert.convert<String>(
    json['serial_number'],
  );
  if (serialNumber != null) {
    videoSortDataList.serialNumber = serialNumber;
  }
  final String? screenshot = jsonConvert.convert<String>(json['screenshot']);
  if (screenshot != null) {
    videoSortDataList.screenshot = screenshot;
  }
  final String? gif = jsonConvert.convert<String>(json['gif']);
  if (gif != null) {
    videoSortDataList.gif = gif;
  }
  final String? alias = jsonConvert.convert<String>(json['alias']);
  if (alias != null) {
    videoSortDataList.alias = alias;
  }
  final String? releaseAt = jsonConvert.convert<String>(json['release_at']);
  if (releaseAt != null) {
    videoSortDataList.releaseAt = releaseAt;
  }
  final String? shelfAt = jsonConvert.convert<String>(json['shelf_at']);
  if (shelfAt != null) {
    videoSortDataList.shelfAt = shelfAt;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    videoSortDataList.end = end;
  }
  final String? unit = jsonConvert.convert<String>(json['unit']);
  if (unit != null) {
    videoSortDataList.unit = unit;
  }
  final String? watch = jsonConvert.convert<String>(json['watch']);
  if (watch != null) {
    videoSortDataList.watch = watch;
  }
  final String? collectionId = jsonConvert.convert<String>(
    json['collection_id'],
  );
  if (collectionId != null) {
    videoSortDataList.collectionId = collectionId;
  }
  final dynamic useLocalImage = json['use_local_image'];
  if (useLocalImage != null) {
    videoSortDataList.useLocalImage = useLocalImage;
  }
  final int? titlesTime = jsonConvert.convert<int>(json['titles_time']);
  if (titlesTime != null) {
    videoSortDataList.titlesTime = titlesTime;
  }
  final int? trailerTime = jsonConvert.convert<int>(json['trailer_time']);
  if (trailerTime != null) {
    videoSortDataList.trailerTime = trailerTime;
  }
  final int? siteId = jsonConvert.convert<int>(json['site_id']);
  if (siteId != null) {
    videoSortDataList.siteId = siteId;
  }
  final int? categoryPidStatus = jsonConvert.convert<int>(
    json['category_pid_status'],
  );
  if (categoryPidStatus != null) {
    videoSortDataList.categoryPidStatus = categoryPidStatus;
  }
  final int? categoryChildIdStatus = jsonConvert.convert<int>(
    json['category_child_id_status'],
  );
  if (categoryChildIdStatus != null) {
    videoSortDataList.categoryChildIdStatus = categoryChildIdStatus;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    videoSortDataList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    videoSortDataList.playUrlPutIn = playUrlPutIn;
  }
  return videoSortDataList;
}

Map<String, dynamic> $VideoSortDataListToJson(VideoSortDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
  data['category_pid'] = entity.categoryPid;
  data['category_child_id'] = entity.categoryChildId;
  data['surface_plot'] = entity.surfacePlot;
  data['recommend'] = entity.recommend;
  data['cycle'] = entity.cycle;
  data['cycle_img'] = entity.cycleImg;
  data['charging_mode'] = entity.chargingMode;
  data['buy_mode'] = entity.buyMode;
  data['gold'] = entity.gold;
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
  data['year'] = entity.year;
  data['album_id'] = entity.albumId;
  data['status'] = entity.status;
  data['create_at'] = entity.createAt;
  data['update_at'] = entity.updateAt;
  data['duration'] = entity.duration;
  data['region'] = entity.region;
  data['language'] = entity.language;
  data['label'] = entity.label;
  data['number'] = entity.number;
  data['total'] = entity.total;
  data['horizontal_poster'] = entity.horizontalPoster;
  data['vertical_poster'] = entity.verticalPoster;
  data['publish'] = entity.publish;
  data['serial_number'] = entity.serialNumber;
  data['screenshot'] = entity.screenshot;
  data['gif'] = entity.gif;
  data['alias'] = entity.alias;
  data['release_at'] = entity.releaseAt;
  data['shelf_at'] = entity.shelfAt;
  data['end'] = entity.end;
  data['unit'] = entity.unit;
  data['watch'] = entity.watch;
  data['collection_id'] = entity.collectionId;
  data['use_local_image'] = entity.useLocalImage;
  data['titles_time'] = entity.titlesTime;
  data['trailer_time'] = entity.trailerTime;
  data['site_id'] = entity.siteId;
  data['category_pid_status'] = entity.categoryPidStatus;
  data['category_child_id_status'] = entity.categoryChildIdStatus;
  data['play_url'] = entity.playUrl;
  data['play_url_put_in'] = entity.playUrlPutIn;
  return data;
}

extension VideoSortDataListExtension on VideoSortDataList {
  VideoSortDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic createUserId,
    dynamic updateUserId,
    String? title,
    String? categoryPid,
    String? categoryChildId,
    String? surfacePlot,
    String? recommend,
    String? cycle,
    String? cycleImg,
    String? chargingMode,
    String? buyMode,
    String? gold,
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
    String? note,
    String? year,
    int? albumId,
    String? status,
    String? createAt,
    String? updateAt,
    String? duration,
    String? region,
    String? language,
    String? label,
    String? number,
    String? total,
    String? horizontalPoster,
    String? verticalPoster,
    String? publish,
    String? serialNumber,
    String? screenshot,
    String? gif,
    String? alias,
    String? releaseAt,
    String? shelfAt,
    int? end,
    String? unit,
    String? watch,
    String? collectionId,
    dynamic useLocalImage,
    int? titlesTime,
    int? trailerTime,
    int? siteId,
    int? categoryPidStatus,
    int? categoryChildIdStatus,
    String? playUrl,
    int? playUrlPutIn,
  }) {
    return VideoSortDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..categoryPid = categoryPid ?? this.categoryPid
      ..categoryChildId = categoryChildId ?? this.categoryChildId
      ..surfacePlot = surfacePlot ?? this.surfacePlot
      ..recommend = recommend ?? this.recommend
      ..cycle = cycle ?? this.cycle
      ..cycleImg = cycleImg ?? this.cycleImg
      ..chargingMode = chargingMode ?? this.chargingMode
      ..buyMode = buyMode ?? this.buyMode
      ..gold = gold ?? this.gold
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
      ..year = year ?? this.year
      ..albumId = albumId ?? this.albumId
      ..status = status ?? this.status
      ..createAt = createAt ?? this.createAt
      ..updateAt = updateAt ?? this.updateAt
      ..duration = duration ?? this.duration
      ..region = region ?? this.region
      ..language = language ?? this.language
      ..label = label ?? this.label
      ..number = number ?? this.number
      ..total = total ?? this.total
      ..horizontalPoster = horizontalPoster ?? this.horizontalPoster
      ..verticalPoster = verticalPoster ?? this.verticalPoster
      ..publish = publish ?? this.publish
      ..serialNumber = serialNumber ?? this.serialNumber
      ..screenshot = screenshot ?? this.screenshot
      ..gif = gif ?? this.gif
      ..alias = alias ?? this.alias
      ..releaseAt = releaseAt ?? this.releaseAt
      ..shelfAt = shelfAt ?? this.shelfAt
      ..end = end ?? this.end
      ..unit = unit ?? this.unit
      ..watch = watch ?? this.watch
      ..collectionId = collectionId ?? this.collectionId
      ..useLocalImage = useLocalImage ?? this.useLocalImage
      ..titlesTime = titlesTime ?? this.titlesTime
      ..trailerTime = trailerTime ?? this.trailerTime
      ..siteId = siteId ?? this.siteId
      ..categoryPidStatus = categoryPidStatus ?? this.categoryPidStatus
      ..categoryChildIdStatus =
          categoryChildIdStatus ?? this.categoryChildIdStatus
      ..playUrl = playUrl ?? this.playUrl
      ..playUrlPutIn = playUrlPutIn ?? this.playUrlPutIn;
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
