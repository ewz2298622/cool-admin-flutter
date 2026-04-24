import 'package:flutter_app/entity/video_detail_data_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

VideoDetailDataEntity $VideoDetailDataEntityFromJson(
  Map<String, dynamic> json,
) {
  final VideoDetailDataEntity videoDetailDataEntity = VideoDetailDataEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoDetailDataEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoDetailDataEntity.message = message;
  }
  final VideoDetailDataData? data = jsonConvert.convert<VideoDetailDataData>(
    json['data'],
  );
  if (data != null) {
    videoDetailDataEntity.data = data;
  }
  return videoDetailDataEntity;
}

Map<String, dynamic> $VideoDetailDataEntityToJson(
  VideoDetailDataEntity entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoDetailDataEntityExtension on VideoDetailDataEntity {
  VideoDetailDataEntity copyWith({
    int? code,
    String? message,
    VideoDetailDataData? data,
  }) {
    return VideoDetailDataEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoDetailDataData $VideoDetailDataDataFromJson(Map<String, dynamic> json) {
  final VideoDetailDataData videoDetailDataData = VideoDetailDataData();
  final VideoDetailDataDataVideo? video = jsonConvert
      .convert<VideoDetailDataDataVideo>(json['video']);
  if (video != null) {
    videoDetailDataData.video = video;
  }
  final List<VideoDetailDataDataLines>? lines =
      (json['lines'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoDetailDataDataLines>(e)
                    as VideoDetailDataDataLines,
          )
          .toList();
  if (lines != null) {
    videoDetailDataData.lines = lines;
  }
  return videoDetailDataData;
}

Map<String, dynamic> $VideoDetailDataDataToJson(VideoDetailDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['video'] = entity.video?.toJson();
  data['lines'] = entity.lines?.map((v) => v.toJson()).toList();
  return data;
}

extension VideoDetailDataDataExtension on VideoDetailDataData {
  VideoDetailDataData copyWith({
    VideoDetailDataDataVideo? video,
    List<VideoDetailDataDataLines>? lines,
  }) {
    return VideoDetailDataData()
      ..video = video ?? this.video
      ..lines = lines ?? this.lines;
  }
}

VideoDetailDataDataVideo $VideoDetailDataDataVideoFromJson(
  Map<String, dynamic> json,
) {
  final VideoDetailDataDataVideo videoDetailDataDataVideo =
      VideoDetailDataDataVideo();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoDetailDataDataVideo.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoDetailDataDataVideo.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoDetailDataDataVideo.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoDetailDataDataVideo.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoDetailDataDataVideo.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoDetailDataDataVideo.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    videoDetailDataDataVideo.title = title;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    videoDetailDataDataVideo.subTitle = subTitle;
  }
  final int? vip = jsonConvert.convert<int>(json['vip']);
  if (vip != null) {
    videoDetailDataDataVideo.vip = vip;
  }
  final String? videoTag = jsonConvert.convert<String>(json['video_tag']);
  if (videoTag != null) {
    videoDetailDataDataVideo.videoTag = videoTag;
  }
  final String? videoClass = jsonConvert.convert<String>(json['video_class']);
  if (videoClass != null) {
    videoDetailDataDataVideo.videoClass = videoClass;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    videoDetailDataDataVideo.categoryId = categoryId;
  }
  final int? categoryPid = jsonConvert.convert<int>(json['category_pid']);
  if (categoryPid != null) {
    videoDetailDataDataVideo.categoryPid = categoryPid;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoDetailDataDataVideo.surfacePlot = surfacePlot;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoDetailDataDataVideo.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    videoDetailDataDataVideo.cycleImg = cycleImg;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    videoDetailDataDataVideo.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    videoDetailDataDataVideo.actors = actors;
  }
  final int? imdbScore = jsonConvert.convert<int>(json['imdb_score']);
  if (imdbScore != null) {
    videoDetailDataDataVideo.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
    json['imdb_score_id'],
  );
  if (imdbScoreId != null) {
    videoDetailDataDataVideo.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    videoDetailDataDataVideo.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
    json['douban_score_id'],
  );
  if (doubanScoreId != null) {
    videoDetailDataDataVideo.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    videoDetailDataDataVideo.introduce = introduce;
  }
  final String? popularity = jsonConvert.convert<String>(json['popularity']);
  if (popularity != null) {
    videoDetailDataDataVideo.popularity = popularity;
  }
  final String? popularityDay = jsonConvert.convert<String>(
    json['popularity_day'],
  );
  if (popularityDay != null) {
    videoDetailDataDataVideo.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
    json['popularity_week'],
  );
  if (popularityWeek != null) {
    videoDetailDataDataVideo.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
    json['popularity_month'],
  );
  if (popularityMonth != null) {
    videoDetailDataDataVideo.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
    json['popularity_sum'],
  );
  if (popularitySum != null) {
    videoDetailDataDataVideo.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    videoDetailDataDataVideo.note = note;
  }
  final int? year = jsonConvert.convert<int>(json['year']);
  if (year != null) {
    videoDetailDataDataVideo.year = year;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoDetailDataDataVideo.status = status;
  }
  final dynamic duration = json['duration'];
  if (duration != null) {
    videoDetailDataDataVideo.duration = duration;
  }
  final int? region = jsonConvert.convert<int>(json['region']);
  if (region != null) {
    videoDetailDataDataVideo.region = region;
  }
  final int? language = jsonConvert.convert<int>(json['language']);
  if (language != null) {
    videoDetailDataDataVideo.language = language;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    videoDetailDataDataVideo.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    videoDetailDataDataVideo.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
    json['horizontal_poster'],
  );
  if (horizontalPoster != null) {
    videoDetailDataDataVideo.horizontalPoster = horizontalPoster;
  }
  final String? remarks = jsonConvert.convert<String>(json['remarks']);
  if (remarks != null) {
    videoDetailDataDataVideo.remarks = remarks;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    videoDetailDataDataVideo.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    videoDetailDataDataVideo.publish = publish;
  }
  final String? pubdate = jsonConvert.convert<String>(json['pubdate']);
  if (pubdate != null) {
    videoDetailDataDataVideo.pubdate = pubdate;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    videoDetailDataDataVideo.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    videoDetailDataDataVideo.screenshot = screenshot;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    videoDetailDataDataVideo.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    videoDetailDataDataVideo.unit = unit;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    videoDetailDataDataVideo.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    videoDetailDataDataVideo.playUrlPutIn = playUrlPutIn;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    videoDetailDataDataVideo.collectionId = collectionId;
  }
  final int? up = jsonConvert.convert<int>(json['up']);
  if (up != null) {
    videoDetailDataDataVideo.up = up;
  }
  final int? down = jsonConvert.convert<int>(json['down']);
  if (down != null) {
    videoDetailDataDataVideo.down = down;
  }
  final int? vipNumber = jsonConvert.convert<int>(json['vipNumber']);
  if (vipNumber != null) {
    videoDetailDataDataVideo.vipNumber = vipNumber;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    videoDetailDataDataVideo.collectionName = collectionName;
  }
  final dynamic searchRecommendType = json['searchRecommendType'];
  if (searchRecommendType != null) {
    videoDetailDataDataVideo.searchRecommendType = searchRecommendType;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    videoDetailDataDataVideo.sort = sort;
  }
  return videoDetailDataDataVideo;
}

Map<String, dynamic> $VideoDetailDataDataVideoToJson(
  VideoDetailDataDataVideo entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
  data['sub_title'] = entity.subTitle;
  data['vip'] = entity.vip;
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
  data['vipNumber'] = entity.vipNumber;
  data['collection_name'] = entity.collectionName;
  data['searchRecommendType'] = entity.searchRecommendType;
  data['sort'] = entity.sort;
  return data;
}

extension VideoDetailDataDataVideoExtension on VideoDetailDataDataVideo {
  VideoDetailDataDataVideo copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? title,
    String? subTitle,
    int? vip,
    String? videoTag,
    String? videoClass,
    int? categoryId,
    int? categoryPid,
    String? surfacePlot,
    String? cycle,
    dynamic cycleImg,
    String? directors,
    String? actors,
    int? imdbScore,
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
    int? vipNumber,
    String? collectionName,
    dynamic searchRecommendType,
    int? sort,
  }) {
    return VideoDetailDataDataVideo()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..subTitle = subTitle ?? this.subTitle
      ..vip = vip ?? this.vip
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
      ..vipNumber = vipNumber ?? this.vipNumber
      ..collectionName = collectionName ?? this.collectionName
      ..searchRecommendType = searchRecommendType ?? this.searchRecommendType
      ..sort = sort ?? this.sort;
  }
}

VideoDetailDataDataLines $VideoDetailDataDataLinesFromJson(
  Map<String, dynamic> json,
) {
  final VideoDetailDataDataLines videoDetailDataDataLines =
      VideoDetailDataDataLines();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoDetailDataDataLines.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoDetailDataDataLines.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoDetailDataDataLines.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoDetailDataDataLines.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoDetailDataDataLines.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoDetailDataDataLines.updateUserId = updateUserId;
  }
  final String? videoId = jsonConvert.convert<String>(json['video_id']);
  if (videoId != null) {
    videoDetailDataDataLines.videoId = videoId;
  }
  final String? videoName = jsonConvert.convert<String>(json['video_name']);
  if (videoName != null) {
    videoDetailDataDataLines.videoName = videoName;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    videoDetailDataDataLines.collectionName = collectionName;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    videoDetailDataDataLines.collectionId = collectionId;
  }
  final int? playerId = jsonConvert.convert<int>(json['player_id']);
  if (playerId != null) {
    videoDetailDataDataLines.playerId = playerId;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    videoDetailDataDataLines.sort = sort;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    videoDetailDataDataLines.tag = tag;
  }
  final List<VideoDetailDataDataLinesPlayLines>? playLines =
      (json['playLines'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoDetailDataDataLinesPlayLines>(e)
                    as VideoDetailDataDataLinesPlayLines,
          )
          .toList();
  if (playLines != null) {
    videoDetailDataDataLines.playLines = playLines;
  }
  return videoDetailDataDataLines;
}

Map<String, dynamic> $VideoDetailDataDataLinesToJson(
  VideoDetailDataDataLines entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['video_id'] = entity.videoId;
  data['video_name'] = entity.videoName;
  data['collection_name'] = entity.collectionName;
  data['collection_id'] = entity.collectionId;
  data['player_id'] = entity.playerId;
  data['sort'] = entity.sort;
  data['tag'] = entity.tag;
  data['playLines'] = entity.playLines?.map((v) => v.toJson()).toList();
  return data;
}

extension VideoDetailDataDataLinesExtension on VideoDetailDataDataLines {
  VideoDetailDataDataLines copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? videoId,
    String? videoName,
    String? collectionName,
    int? collectionId,
    int? playerId,
    int? sort,
    String? tag,
    List<VideoDetailDataDataLinesPlayLines>? playLines,
  }) {
    return VideoDetailDataDataLines()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..videoId = videoId ?? this.videoId
      ..videoName = videoName ?? this.videoName
      ..collectionName = collectionName ?? this.collectionName
      ..collectionId = collectionId ?? this.collectionId
      ..playerId = playerId ?? this.playerId
      ..sort = sort ?? this.sort
      ..tag = tag ?? this.tag
      ..playLines = playLines ?? this.playLines;
  }
}

VideoDetailDataDataLinesPlayLines $VideoDetailDataDataLinesPlayLinesFromJson(
  Map<String, dynamic> json,
) {
  final VideoDetailDataDataLinesPlayLines videoDetailDataDataLinesPlayLines =
      VideoDetailDataDataLinesPlayLines();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoDetailDataDataLinesPlayLines.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoDetailDataDataLinesPlayLines.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoDetailDataDataLinesPlayLines.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoDetailDataDataLinesPlayLines.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoDetailDataDataLinesPlayLines.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoDetailDataDataLinesPlayLines.updateUserId = updateUserId;
  }
  final String? videoId = jsonConvert.convert<String>(json['video_id']);
  if (videoId != null) {
    videoDetailDataDataLinesPlayLines.videoId = videoId;
  }
  final String? videoName = jsonConvert.convert<String>(json['video_name']);
  if (videoName != null) {
    videoDetailDataDataLinesPlayLines.videoName = videoName;
  }
  final String? videoLineId = jsonConvert.convert<String>(
    json['video_line_id'],
  );
  if (videoLineId != null) {
    videoDetailDataDataLinesPlayLines.videoLineId = videoLineId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    videoDetailDataDataLinesPlayLines.name = name;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    videoDetailDataDataLinesPlayLines.collectionId = collectionId;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    videoDetailDataDataLinesPlayLines.collectionName = collectionName;
  }
  final String? file = jsonConvert.convert<String>(json['file']);
  if (file != null) {
    videoDetailDataDataLinesPlayLines.file = file;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    videoDetailDataDataLinesPlayLines.subTitle = subTitle;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    videoDetailDataDataLinesPlayLines.status = status;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    videoDetailDataDataLinesPlayLines.sort = sort;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    videoDetailDataDataLinesPlayLines.tag = tag;
  }
  final int? vip = jsonConvert.convert<int>(json['vip']);
  if (vip != null) {
    videoDetailDataDataLinesPlayLines.vip = vip;
  }
  return videoDetailDataDataLinesPlayLines;
}

Map<String, dynamic> $VideoDetailDataDataLinesPlayLinesToJson(
  VideoDetailDataDataLinesPlayLines entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['video_id'] = entity.videoId;
  data['video_name'] = entity.videoName;
  data['video_line_id'] = entity.videoLineId;
  data['name'] = entity.name;
  data['collection_id'] = entity.collectionId;
  data['collection_name'] = entity.collectionName;
  data['file'] = entity.file;
  data['sub_title'] = entity.subTitle;
  data['status'] = entity.status;
  data['sort'] = entity.sort;
  data['tag'] = entity.tag;
  data['vip'] = entity.vip;
  return data;
}

extension VideoDetailDataDataLinesPlayLinesExtension
    on VideoDetailDataDataLinesPlayLines {
  VideoDetailDataDataLinesPlayLines copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? videoId,
    String? videoName,
    String? videoLineId,
    String? name,
    int? collectionId,
    String? collectionName,
    String? file,
    String? subTitle,
    int? status,
    int? sort,
    String? tag,
    int? vip,
  }) {
    return VideoDetailDataDataLinesPlayLines()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..videoId = videoId ?? this.videoId
      ..videoName = videoName ?? this.videoName
      ..videoLineId = videoLineId ?? this.videoLineId
      ..name = name ?? this.name
      ..collectionId = collectionId ?? this.collectionId
      ..collectionName = collectionName ?? this.collectionName
      ..file = file ?? this.file
      ..subTitle = subTitle ?? this.subTitle
      ..status = status ?? this.status
      ..sort = sort ?? this.sort
      ..tag = tag ?? this.tag
      ..vip = vip ?? this.vip;
  }
}
