import 'package:flutter_app/entity/video_rank_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

VideoRankEntity $VideoRankEntityFromJson(Map<String, dynamic> json) {
  final VideoRankEntity videoRankEntity = VideoRankEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoRankEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoRankEntity.message = message;
  }
  final VideoRankData? data = jsonConvert.convert<VideoRankData>(json['data']);
  if (data != null) {
    videoRankEntity.data = data;
  }
  return videoRankEntity;
}

Map<String, dynamic> $VideoRankEntityToJson(VideoRankEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoRankEntityExtension on VideoRankEntity {
  VideoRankEntity copyWith({int? code, String? message, VideoRankData? data}) {
    return VideoRankEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoRankData $VideoRankDataFromJson(Map<String, dynamic> json) {
  final VideoRankData videoRankData = VideoRankData();
  final List<VideoRankDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoRankDataList>(e) as VideoRankDataList,
          )
          .toList();
  if (list != null) {
    videoRankData.list = list;
  }
  return videoRankData;
}

Map<String, dynamic> $VideoRankDataToJson(VideoRankData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension VideoRankDataExtension on VideoRankData {
  VideoRankData copyWith({List<VideoRankDataList>? list}) {
    return VideoRankData()..list = list ?? this.list;
  }
}

VideoRankDataList $VideoRankDataListFromJson(Map<String, dynamic> json) {
  final VideoRankDataList videoRankDataList = VideoRankDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoRankDataList.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    videoRankDataList.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    videoRankDataList.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    videoRankDataList.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    videoRankDataList.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    videoRankDataList.status = status;
  }
  final String? color = jsonConvert.convert<String>(json['color']);
  if (color != null) {
    videoRankDataList.color = color;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    videoRankDataList.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    videoRankDataList.parentId = parentId;
  }
  final List<VideoRankDataListList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoRankDataListList>(e)
                    as VideoRankDataListList,
          )
          .toList();
  if (list != null) {
    videoRankDataList.list = list;
  }
  return videoRankDataList;
}

Map<String, dynamic> $VideoRankDataListToJson(VideoRankDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['typeId'] = entity.typeId;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['orderNum'] = entity.orderNum;
  data['status'] = entity.status;
  data['color'] = entity.color;
  data['remark'] = entity.remark;
  data['parentId'] = entity.parentId;
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension VideoRankDataListExtension on VideoRankDataList {
  VideoRankDataList copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    String? color,
    dynamic remark,
    dynamic parentId,
    List<VideoRankDataListList>? list,
  }) {
    return VideoRankDataList()
      ..id = id ?? this.id
      ..typeId = typeId ?? this.typeId
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..orderNum = orderNum ?? this.orderNum
      ..status = status ?? this.status
      ..color = color ?? this.color
      ..remark = remark ?? this.remark
      ..parentId = parentId ?? this.parentId
      ..list = list ?? this.list;
  }
}

VideoRankDataListList $VideoRankDataListListFromJson(
  Map<String, dynamic> json,
) {
  final VideoRankDataListList videoRankDataListList = VideoRankDataListList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoRankDataListList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoRankDataListList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoRankDataListList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoRankDataListList.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    videoRankDataListList.createUserId = createUserId;
  }
  final int? updateUserId = jsonConvert.convert<int>(json['updateUserId']);
  if (updateUserId != null) {
    videoRankDataListList.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    videoRankDataListList.title = title;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    videoRankDataListList.subTitle = subTitle;
  }
  final int? vip = jsonConvert.convert<int>(json['vip']);
  if (vip != null) {
    videoRankDataListList.vip = vip;
  }
  final String? videoTag = jsonConvert.convert<String>(json['video_tag']);
  if (videoTag != null) {
    videoRankDataListList.videoTag = videoTag;
  }
  final String? videoClass = jsonConvert.convert<String>(json['video_class']);
  if (videoClass != null) {
    videoRankDataListList.videoClass = videoClass;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    videoRankDataListList.categoryId = categoryId;
  }
  final int? categoryPid = jsonConvert.convert<int>(json['category_pid']);
  if (categoryPid != null) {
    videoRankDataListList.categoryPid = categoryPid;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    videoRankDataListList.surfacePlot = surfacePlot;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    videoRankDataListList.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    videoRankDataListList.cycleImg = cycleImg;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    videoRankDataListList.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    videoRankDataListList.actors = actors;
  }
  final int? imdbScore = jsonConvert.convert<int>(json['imdb_score']);
  if (imdbScore != null) {
    videoRankDataListList.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
    json['imdb_score_id'],
  );
  if (imdbScoreId != null) {
    videoRankDataListList.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    videoRankDataListList.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
    json['douban_score_id'],
  );
  if (doubanScoreId != null) {
    videoRankDataListList.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    videoRankDataListList.introduce = introduce;
  }
  final String? popularity = jsonConvert.convert<String>(json['popularity']);
  if (popularity != null) {
    videoRankDataListList.popularity = popularity;
  }
  final String? popularityDay = jsonConvert.convert<String>(
    json['popularity_day'],
  );
  if (popularityDay != null) {
    videoRankDataListList.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
    json['popularity_week'],
  );
  if (popularityWeek != null) {
    videoRankDataListList.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
    json['popularity_month'],
  );
  if (popularityMonth != null) {
    videoRankDataListList.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
    json['popularity_sum'],
  );
  if (popularitySum != null) {
    videoRankDataListList.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    videoRankDataListList.note = note;
  }
  final int? year = jsonConvert.convert<int>(json['year']);
  if (year != null) {
    videoRankDataListList.year = year;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    videoRankDataListList.status = status;
  }
  final String? duration = jsonConvert.convert<String>(json['duration']);
  if (duration != null) {
    videoRankDataListList.duration = duration;
  }
  final int? region = jsonConvert.convert<int>(json['region']);
  if (region != null) {
    videoRankDataListList.region = region;
  }
  final int? language = jsonConvert.convert<int>(json['language']);
  if (language != null) {
    videoRankDataListList.language = language;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    videoRankDataListList.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    videoRankDataListList.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
    json['horizontal_poster'],
  );
  if (horizontalPoster != null) {
    videoRankDataListList.horizontalPoster = horizontalPoster;
  }
  final String? remarks = jsonConvert.convert<String>(json['remarks']);
  if (remarks != null) {
    videoRankDataListList.remarks = remarks;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    videoRankDataListList.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    videoRankDataListList.publish = publish;
  }
  final String? pubdate = jsonConvert.convert<String>(json['pubdate']);
  if (pubdate != null) {
    videoRankDataListList.pubdate = pubdate;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    videoRankDataListList.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    videoRankDataListList.screenshot = screenshot;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    videoRankDataListList.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    videoRankDataListList.unit = unit;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    videoRankDataListList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    videoRankDataListList.playUrlPutIn = playUrlPutIn;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    videoRankDataListList.collectionId = collectionId;
  }
  final int? up = jsonConvert.convert<int>(json['up']);
  if (up != null) {
    videoRankDataListList.up = up;
  }
  final int? down = jsonConvert.convert<int>(json['down']);
  if (down != null) {
    videoRankDataListList.down = down;
  }
  final int? vipNumber = jsonConvert.convert<int>(json['vipNumber']);
  if (vipNumber != null) {
    videoRankDataListList.vipNumber = vipNumber;
  }
  final String? collectionName = jsonConvert.convert<String>(
    json['collection_name'],
  );
  if (collectionName != null) {
    videoRankDataListList.collectionName = collectionName;
  }
  final int? searchRecommendType = jsonConvert.convert<int>(
    json['searchRecommendType'],
  );
  if (searchRecommendType != null) {
    videoRankDataListList.searchRecommendType = searchRecommendType;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    videoRankDataListList.sort = sort;
  }
  return videoRankDataListList;
}

Map<String, dynamic> $VideoRankDataListListToJson(
  VideoRankDataListList entity,
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

extension VideoRankDataListListExtension on VideoRankDataListList {
  VideoRankDataListList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    int? updateUserId,
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
    int? vipNumber,
    String? collectionName,
    int? searchRecommendType,
    int? sort,
  }) {
    return VideoRankDataListList()
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
