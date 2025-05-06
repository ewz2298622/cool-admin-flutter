import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/video_page_entity.dart';

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
  VideoPageEntity copyWith({
    int? code,
    String? message,
    VideoPageData? data,
  }) {
    return VideoPageEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoPageData $VideoPageDataFromJson(Map<String, dynamic> json) {
  final VideoPageData videoPageData = VideoPageData();
  final List<VideoPageDataList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<VideoPageDataList>(e) as VideoPageDataList)
      .toList();
  if (list != null) {
    videoPageData.list = list;
  }
  final VideoPageDataPagination? pagination = jsonConvert.convert<
      VideoPageDataPagination>(json['pagination']);
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
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    videoPageDataList.title = title;
  }
  final String? categoryPid = jsonConvert.convert<String>(json['category_pid']);
  if (categoryPid != null) {
    videoPageDataList.categoryPid = categoryPid;
  }
  final String? categoryChildId = jsonConvert.convert<String>(
      json['category_child_id']);
  if (categoryChildId != null) {
    videoPageDataList.categoryChildId = categoryChildId;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoPageDataList.surfacePlot = surfacePlot;
  }
  final String? recommend = jsonConvert.convert<String>(json['recommend']);
  if (recommend != null) {
    videoPageDataList.recommend = recommend;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoPageDataList.cycle = cycle;
  }
  final String? cycleImg = jsonConvert.convert<String>(json['cycle_img']);
  if (cycleImg != null) {
    videoPageDataList.cycleImg = cycleImg;
  }
  final String? chargingMode = jsonConvert.convert<String>(
      json['charging_mode']);
  if (chargingMode != null) {
    videoPageDataList.chargingMode = chargingMode;
  }
  final String? buyMode = jsonConvert.convert<String>(json['buy_mode']);
  if (buyMode != null) {
    videoPageDataList.buyMode = buyMode;
  }
  final String? gold = jsonConvert.convert<String>(json['gold']);
  if (gold != null) {
    videoPageDataList.gold = gold;
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
      json['imdb_score_id']);
  if (imdbScoreId != null) {
    videoPageDataList.imdbScoreId = imdbScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    videoPageDataList.introduce = introduce;
  }
  final String? popularityDay = jsonConvert.convert<String>(
      json['popularity_day']);
  if (popularityDay != null) {
    videoPageDataList.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
      json['popularity_week']);
  if (popularityWeek != null) {
    videoPageDataList.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
      json['popularity_month']);
  if (popularityMonth != null) {
    videoPageDataList.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
      json['popularity_sum']);
  if (popularitySum != null) {
    videoPageDataList.popularitySum = popularitySum;
  }
  final String? note = jsonConvert.convert<String>(json['note']);
  if (note != null) {
    videoPageDataList.note = note;
  }
  final String? year = jsonConvert.convert<String>(json['year']);
  if (year != null) {
    videoPageDataList.year = year;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoPageDataList.status = status;
  }
  final String? createAt = jsonConvert.convert<String>(json['create_at']);
  if (createAt != null) {
    videoPageDataList.createAt = createAt;
  }
  final String? updateAt = jsonConvert.convert<String>(json['update_at']);
  if (updateAt != null) {
    videoPageDataList.updateAt = updateAt;
  }
  final String? duration = jsonConvert.convert<String>(json['duration']);
  if (duration != null) {
    videoPageDataList.duration = duration;
  }
  final String? region = jsonConvert.convert<String>(json['region']);
  if (region != null) {
    videoPageDataList.region = region;
  }
  final String? language = jsonConvert.convert<String>(json['language']);
  if (language != null) {
    videoPageDataList.language = language;
  }
  final String? label = jsonConvert.convert<String>(json['label']);
  if (label != null) {
    videoPageDataList.label = label;
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
      json['horizontal_poster']);
  if (horizontalPoster != null) {
    videoPageDataList.horizontalPoster = horizontalPoster;
  }
  final String? verticalPoster = jsonConvert.convert<String>(
      json['vertical_poster']);
  if (verticalPoster != null) {
    videoPageDataList.verticalPoster = verticalPoster;
  }
  final String? publish = jsonConvert.convert<String>(json['publish']);
  if (publish != null) {
    videoPageDataList.publish = publish;
  }
  final String? serialNumber = jsonConvert.convert<String>(
      json['serial_number']);
  if (serialNumber != null) {
    videoPageDataList.serialNumber = serialNumber;
  }
  final String? screenshot = jsonConvert.convert<String>(json['screenshot']);
  if (screenshot != null) {
    videoPageDataList.screenshot = screenshot;
  }
  final String? gif = jsonConvert.convert<String>(json['gif']);
  if (gif != null) {
    videoPageDataList.gif = gif;
  }
  final String? alias = jsonConvert.convert<String>(json['alias']);
  if (alias != null) {
    videoPageDataList.alias = alias;
  }
  final String? releaseAt = jsonConvert.convert<String>(json['release_at']);
  if (releaseAt != null) {
    videoPageDataList.releaseAt = releaseAt;
  }
  final String? shelfAt = jsonConvert.convert<String>(json['shelf_at']);
  if (shelfAt != null) {
    videoPageDataList.shelfAt = shelfAt;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    videoPageDataList.end = end;
  }
  final String? unit = jsonConvert.convert<String>(json['unit']);
  if (unit != null) {
    videoPageDataList.unit = unit;
  }
  final String? watch = jsonConvert.convert<String>(json['watch']);
  if (watch != null) {
    videoPageDataList.watch = watch;
  }
  final String? collectionId = jsonConvert.convert<String>(
      json['collection_id']);
  if (collectionId != null) {
    videoPageDataList.collectionId = collectionId;
  }
  final dynamic useLocalImage = json['use_local_image'];
  if (useLocalImage != null) {
    videoPageDataList.useLocalImage = useLocalImage;
  }
  final int? titlesTime = jsonConvert.convert<int>(json['titles_time']);
  if (titlesTime != null) {
    videoPageDataList.titlesTime = titlesTime;
  }
  final int? trailerTime = jsonConvert.convert<int>(json['trailer_time']);
  if (trailerTime != null) {
    videoPageDataList.trailerTime = trailerTime;
  }
  final int? siteId = jsonConvert.convert<int>(json['site_id']);
  if (siteId != null) {
    videoPageDataList.siteId = siteId;
  }
  final int? categoryPidStatus = jsonConvert.convert<int>(
      json['category_pid_status']);
  if (categoryPidStatus != null) {
    videoPageDataList.categoryPidStatus = categoryPidStatus;
  }
  final int? categoryChildIdStatus = jsonConvert.convert<int>(
      json['category_child_id_status']);
  if (categoryChildIdStatus != null) {
    videoPageDataList.categoryChildIdStatus = categoryChildIdStatus;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    videoPageDataList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    videoPageDataList.playUrlPutIn = playUrlPutIn;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoPageDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoPageDataList.updateTime = updateTime;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoPageDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoPageDataList.updateUserId = updateUserId;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoPageDataList.id = id;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
      json['douban_score_id']);
  if (doubanScoreId != null) {
    videoPageDataList.doubanScoreId = doubanScoreId;
  }
  final int? albumId = jsonConvert.convert<int>(json['album_id']);
  if (albumId != null) {
    videoPageDataList.albumId = albumId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    videoPageDataList.doubanScore = doubanScore;
  }
  return videoPageDataList;
}

Map<String, dynamic> $VideoPageDataListToJson(VideoPageDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
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
  data['introduce'] = entity.introduce;
  data['popularity_day'] = entity.popularityDay;
  data['popularity_week'] = entity.popularityWeek;
  data['popularity_month'] = entity.popularityMonth;
  data['popularity_sum'] = entity.popularitySum;
  data['note'] = entity.note;
  data['year'] = entity.year;
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
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['id'] = entity.id;
  data['douban_score_id'] = entity.doubanScoreId;
  data['album_id'] = entity.albumId;
  data['douban_score'] = entity.doubanScore;
  return data;
}

extension VideoPageDataListExtension on VideoPageDataList {
  VideoPageDataList copyWith({
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
    String? introduce,
    String? popularityDay,
    String? popularityWeek,
    String? popularityMonth,
    String? popularitySum,
    String? note,
    String? year,
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
    String? createTime,
    String? updateTime,
    dynamic createUserId,
    dynamic updateUserId,
    int? id,
    String? doubanScoreId,
    int? albumId,
    int? doubanScore,
  }) {
    return VideoPageDataList()
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
      ..introduce = introduce ?? this.introduce
      ..popularityDay = popularityDay ?? this.popularityDay
      ..popularityWeek = popularityWeek ?? this.popularityWeek
      ..popularityMonth = popularityMonth ?? this.popularityMonth
      ..popularitySum = popularitySum ?? this.popularitySum
      ..note = note ?? this.note
      ..year = year ?? this.year
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
      ..categoryChildIdStatus = categoryChildIdStatus ??
          this.categoryChildIdStatus
      ..playUrl = playUrl ?? this.playUrl
      ..playUrlPutIn = playUrlPutIn ?? this.playUrlPutIn
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..id = id ?? this.id
      ..doubanScoreId = doubanScoreId ?? this.doubanScoreId
      ..albumId = albumId ?? this.albumId
      ..doubanScore = doubanScore ?? this.doubanScore;
  }
}

VideoPageDataPagination $VideoPageDataPaginationFromJson(
    Map<String, dynamic> json) {
  final VideoPageDataPagination videoPageDataPagination = VideoPageDataPagination();
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
    VideoPageDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension VideoPageDataPaginationExtension on VideoPageDataPagination {
  VideoPageDataPagination copyWith({
    int? page,
    int? size,
    int? total,
  }) {
    return VideoPageDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}