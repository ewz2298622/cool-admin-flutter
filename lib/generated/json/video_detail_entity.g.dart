import 'package:flutter_app/entity/video_detail_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

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
    json['data'],
  );
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
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    videoDetailData.categoryId = categoryId;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoDetailData.surfacePlot = surfacePlot;
  }
  final dynamic recommend = json['recommend'];
  if (recommend != null) {
    videoDetailData.recommend = recommend;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoDetailData.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    videoDetailData.cycleImg = cycleImg;
  }
  final String? chargingMode = jsonConvert.convert<String>(
    json['charging_mode'],
  );
  if (chargingMode != null) {
    videoDetailData.chargingMode = chargingMode;
  }
  final dynamic buyMode = json['buy_mode'];
  if (buyMode != null) {
    videoDetailData.buyMode = buyMode;
  }
  final dynamic gold = json['gold'];
  if (gold != null) {
    videoDetailData.gold = gold;
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
    json['imdb_score_id'],
  );
  if (imdbScoreId != null) {
    videoDetailData.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    videoDetailData.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
    json['douban_score_id'],
  );
  if (doubanScoreId != null) {
    videoDetailData.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    videoDetailData.introduce = introduce;
  }
  final String? popularityDay = jsonConvert.convert<String>(
    json['popularity_day'],
  );
  if (popularityDay != null) {
    videoDetailData.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
    json['popularity_week'],
  );
  if (popularityWeek != null) {
    videoDetailData.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
    json['popularity_month'],
  );
  if (popularityMonth != null) {
    videoDetailData.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
    json['popularity_sum'],
  );
  if (popularitySum != null) {
    videoDetailData.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    videoDetailData.note = note;
  }
  final String? year = jsonConvert.convert<String>(json['year']);
  if (year != null) {
    videoDetailData.year = year;
  }
  final dynamic albumId = json['album_id'];
  if (albumId != null) {
    videoDetailData.albumId = albumId;
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
  final dynamic label = json['label'];
  if (label != null) {
    videoDetailData.label = label;
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
    json['horizontal_poster'],
  );
  if (horizontalPoster != null) {
    videoDetailData.horizontalPoster = horizontalPoster;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    videoDetailData.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    videoDetailData.publish = publish;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    videoDetailData.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    videoDetailData.screenshot = screenshot;
  }
  final dynamic gif = json['gif'];
  if (gif != null) {
    videoDetailData.gif = gif;
  }
  final dynamic alias = json['alias'];
  if (alias != null) {
    videoDetailData.alias = alias;
  }
  final dynamic releaseAt = json['release_at'];
  if (releaseAt != null) {
    videoDetailData.releaseAt = releaseAt;
  }
  final dynamic shelfAt = json['shelf_at'];
  if (shelfAt != null) {
    videoDetailData.shelfAt = shelfAt;
  }
  final dynamic end = json['end'];
  if (end != null) {
    videoDetailData.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    videoDetailData.unit = unit;
  }
  final dynamic watch = json['watch'];
  if (watch != null) {
    videoDetailData.watch = watch;
  }
  final dynamic useLocalImage = json['use_local_image'];
  if (useLocalImage != null) {
    videoDetailData.useLocalImage = useLocalImage;
  }
  final int? titlesTime = jsonConvert.convert<int>(json['titles_time']);
  if (titlesTime != null) {
    videoDetailData.titlesTime = titlesTime;
  }
  final int? trailerTime = jsonConvert.convert<int>(json['trailer_time']);
  if (trailerTime != null) {
    videoDetailData.trailerTime = trailerTime;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    videoDetailData.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    videoDetailData.playUrlPutIn = playUrlPutIn;
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
  data['category_id'] = entity.categoryId;
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
  data['use_local_image'] = entity.useLocalImage;
  data['titles_time'] = entity.titlesTime;
  data['trailer_time'] = entity.trailerTime;
  data['play_url'] = entity.playUrl;
  data['play_url_put_in'] = entity.playUrlPutIn;
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
    int? categoryId,
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
    int? region,
    int? language,
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
  }) {
    return VideoDetailData()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..categoryId = categoryId ?? this.categoryId
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
      ..useLocalImage = useLocalImage ?? this.useLocalImage
      ..titlesTime = titlesTime ?? this.titlesTime
      ..trailerTime = trailerTime ?? this.trailerTime
      ..playUrl = playUrl ?? this.playUrl
      ..playUrlPutIn = playUrlPutIn ?? this.playUrlPutIn;
  }
}
