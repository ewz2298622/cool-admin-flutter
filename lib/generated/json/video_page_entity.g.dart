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
  final dynamic recommend = json['recommend'];
  if (recommend != null) {
    videoPageDataList.recommend = recommend;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoPageDataList.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    videoPageDataList.cycleImg = cycleImg;
  }
  final String? chargingMode = jsonConvert.convert<String>(
    json['charging_mode'],
  );
  if (chargingMode != null) {
    videoPageDataList.chargingMode = chargingMode;
  }
  final dynamic buyMode = json['buy_mode'];
  if (buyMode != null) {
    videoPageDataList.buyMode = buyMode;
  }
  final dynamic gold = json['gold'];
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
  final String? year = jsonConvert.convert<String>(json['year']);
  if (year != null) {
    videoPageDataList.year = year;
  }
  final dynamic albumId = json['album_id'];
  if (albumId != null) {
    videoPageDataList.albumId = albumId;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoPageDataList.status = status;
  }
  final dynamic duration = json['duration'];
  if (duration != null) {
    videoPageDataList.duration = duration;
  }
  final dynamic label = json['label'];
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
  final dynamic gif = json['gif'];
  if (gif != null) {
    videoPageDataList.gif = gif;
  }
  final dynamic alias = json['alias'];
  if (alias != null) {
    videoPageDataList.alias = alias;
  }
  final dynamic releaseAt = json['release_at'];
  if (releaseAt != null) {
    videoPageDataList.releaseAt = releaseAt;
  }
  final dynamic shelfAt = json['shelf_at'];
  if (shelfAt != null) {
    videoPageDataList.shelfAt = shelfAt;
  }
  final dynamic end = json['end'];
  if (end != null) {
    videoPageDataList.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    videoPageDataList.unit = unit;
  }
  final dynamic watch = json['watch'];
  if (watch != null) {
    videoPageDataList.watch = watch;
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
  data['duration'] = entity.duration;
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
  data['use_local_image'] = entity.useLocalImage;
  data['titles_time'] = entity.titlesTime;
  data['trailer_time'] = entity.trailerTime;
  data['play_url'] = entity.playUrl;
  data['play_url_put_in'] = entity.playUrlPutIn;
  data['category_id'] = entity.categoryId;
  data['region'] = entity.region;
  data['language'] = entity.language;
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
    dynamic recommend,
    String? cycle,
    dynamic cycleImg,
    String? chargingMode,
    dynamic buyMode,
    dynamic gold,
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
    String? year,
    dynamic albumId,
    String? status,
    dynamic duration,
    dynamic label,
    String? number,
    String? total,
    String? horizontalPoster,
    dynamic verticalPoster,
    dynamic publish,
    dynamic serialNumber,
    dynamic screenshot,
    dynamic gif,
    dynamic alias,
    dynamic releaseAt,
    dynamic shelfAt,
    dynamic end,
    dynamic unit,
    dynamic watch,
    dynamic useLocalImage,
    int? titlesTime,
    int? trailerTime,
    String? playUrl,
    int? playUrlPutIn,
    int? categoryId,
    int? region,
    int? language,
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
      ..duration = duration ?? this.duration
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
      ..useLocalImage = useLocalImage ?? this.useLocalImage
      ..titlesTime = titlesTime ?? this.titlesTime
      ..trailerTime = trailerTime ?? this.trailerTime
      ..playUrl = playUrl ?? this.playUrl
      ..playUrlPutIn = playUrlPutIn ?? this.playUrlPutIn
      ..categoryId = categoryId ?? this.categoryId
      ..region = region ?? this.region
      ..language = language ?? this.language;
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
