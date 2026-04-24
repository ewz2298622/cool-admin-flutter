import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/entity/album_entity.dart';

AlbumEntity $AlbumEntityFromJson(Map<String, dynamic> json) {
  final AlbumEntity albumEntity = AlbumEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    albumEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    albumEntity.message = message;
  }
  final AlbumData? data = jsonConvert.convert<AlbumData>(json['data']);
  if (data != null) {
    albumEntity.data = data;
  }
  return albumEntity;
}

Map<String, dynamic> $AlbumEntityToJson(AlbumEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension AlbumEntityExtension on AlbumEntity {
  AlbumEntity copyWith({
    int? code,
    String? message,
    AlbumData? data,
  }) {
    return AlbumEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

AlbumData $AlbumDataFromJson(Map<String, dynamic> json) {
  final AlbumData albumData = AlbumData();
  final List<AlbumDataList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<AlbumDataList>(e) as AlbumDataList)
      .toList();
  if (list != null) {
    albumData.list = list;
  }
  final AlbumDataPagination? pagination = jsonConvert.convert<
      AlbumDataPagination>(json['pagination']);
  if (pagination != null) {
    albumData.pagination = pagination;
  }
  return albumData;
}

Map<String, dynamic> $AlbumDataToJson(AlbumData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension AlbumDataExtension on AlbumData {
  AlbumData copyWith({
    List<AlbumDataList>? list,
    AlbumDataPagination? pagination,
  }) {
    return AlbumData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

AlbumDataList $AlbumDataListFromJson(Map<String, dynamic> json) {
  final AlbumDataList albumDataList = AlbumDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    albumDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    albumDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    albumDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    albumDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    albumDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    albumDataList.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    albumDataList.title = title;
  }
  final dynamic name = json['name'];
  if (name != null) {
    albumDataList.name = name;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    albumDataList.surfacePlot = surfacePlot;
  }
  final String? recommend = jsonConvert.convert<String>(json['recommend']);
  if (recommend != null) {
    albumDataList.recommend = recommend;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    albumDataList.status = status;
  }
  final dynamic introduce = json['introduce'];
  if (introduce != null) {
    albumDataList.introduce = introduce;
  }
  final String? popularityDay = jsonConvert.convert<String>(
      json['popularity_day']);
  if (popularityDay != null) {
    albumDataList.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
      json['popularity_week']);
  if (popularityWeek != null) {
    albumDataList.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
      json['popularity_month']);
  if (popularityMonth != null) {
    albumDataList.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
      json['popularity_sum']);
  if (popularitySum != null) {
    albumDataList.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    albumDataList.note = note;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    albumDataList.sort = sort;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    albumDataList.categoryId = categoryId;
  }
  final List<AlbumDataListList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<AlbumDataListList>(e) as AlbumDataListList)
      .toList();
  if (list != null) {
    albumDataList.list = list;
  }
  return albumDataList;
}

Map<String, dynamic> $AlbumDataListToJson(AlbumDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['title'] = entity.title;
  data['name'] = entity.name;
  data['surface_plot'] = entity.surfacePlot;
  data['recommend'] = entity.recommend;
  data['status'] = entity.status;
  data['introduce'] = entity.introduce;
  data['popularity_day'] = entity.popularityDay;
  data['popularity_week'] = entity.popularityWeek;
  data['popularity_month'] = entity.popularityMonth;
  data['popularity_sum'] = entity.popularitySum;
  data['note'] = entity.note;
  data['sort'] = entity.sort;
  data['category_id'] = entity.categoryId;
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension AlbumDataListExtension on AlbumDataList {
  AlbumDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    dynamic updateUserId,
    String? title,
    dynamic name,
    String? surfacePlot,
    String? recommend,
    String? status,
    dynamic introduce,
    String? popularityDay,
    String? popularityWeek,
    String? popularityMonth,
    String? popularitySum,
    dynamic note,
    int? sort,
    int? categoryId,
    List<AlbumDataListList>? list,
  }) {
    return AlbumDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..title = title ?? this.title
      ..name = name ?? this.name
      ..surfacePlot = surfacePlot ?? this.surfacePlot
      ..recommend = recommend ?? this.recommend
      ..status = status ?? this.status
      ..introduce = introduce ?? this.introduce
      ..popularityDay = popularityDay ?? this.popularityDay
      ..popularityWeek = popularityWeek ?? this.popularityWeek
      ..popularityMonth = popularityMonth ?? this.popularityMonth
      ..popularitySum = popularitySum ?? this.popularitySum
      ..note = note ?? this.note
      ..sort = sort ?? this.sort
      ..categoryId = categoryId ?? this.categoryId
      ..list = list ?? this.list;
  }
}

AlbumDataListList $AlbumDataListListFromJson(Map<String, dynamic> json) {
  final AlbumDataListList albumDataListList = AlbumDataListList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    albumDataListList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    albumDataListList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    albumDataListList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    albumDataListList.tenantId = tenantId;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    albumDataListList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    albumDataListList.updateUserId = updateUserId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    albumDataListList.title = title;
  }
  final String? subTitle = jsonConvert.convert<String>(json['sub_title']);
  if (subTitle != null) {
    albumDataListList.subTitle = subTitle;
  }
  final String? videoTag = jsonConvert.convert<String>(json['video_tag']);
  if (videoTag != null) {
    albumDataListList.videoTag = videoTag;
  }
  final String? videoClass = jsonConvert.convert<String>(json['video_class']);
  if (videoClass != null) {
    albumDataListList.videoClass = videoClass;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    albumDataListList.categoryId = categoryId;
  }
  final int? categoryPid = jsonConvert.convert<int>(json['category_pid']);
  if (categoryPid != null) {
    albumDataListList.categoryPid = categoryPid;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    albumDataListList.surfacePlot = surfacePlot;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    albumDataListList.cycle = cycle;
  }
  final dynamic cycleImg = json['cycle_img'];
  if (cycleImg != null) {
    albumDataListList.cycleImg = cycleImg;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    albumDataListList.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    albumDataListList.actors = actors;
  }
  final String? imdbScore = jsonConvert.convert<String>(json['imdb_score']);
  if (imdbScore != null) {
    albumDataListList.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
      json['imdb_score_id']);
  if (imdbScoreId != null) {
    albumDataListList.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    albumDataListList.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
      json['douban_score_id']);
  if (doubanScoreId != null) {
    albumDataListList.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    albumDataListList.introduce = introduce;
  }
  final String? popularity = jsonConvert.convert<String>(json['popularity']);
  if (popularity != null) {
    albumDataListList.popularity = popularity;
  }
  final String? popularityDay = jsonConvert.convert<String>(
      json['popularity_day']);
  if (popularityDay != null) {
    albumDataListList.popularityDay = popularityDay;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
      json['popularity_week']);
  if (popularityWeek != null) {
    albumDataListList.popularityWeek = popularityWeek;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
      json['popularity_month']);
  if (popularityMonth != null) {
    albumDataListList.popularityMonth = popularityMonth;
  }
  final String? popularitySum = jsonConvert.convert<String>(
      json['popularity_sum']);
  if (popularitySum != null) {
    albumDataListList.popularitySum = popularitySum;
  }
  final dynamic note = json['note'];
  if (note != null) {
    albumDataListList.note = note;
  }
  final int? year = jsonConvert.convert<int>(json['year']);
  if (year != null) {
    albumDataListList.year = year;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    albumDataListList.status = status;
  }
  final dynamic duration = json['duration'];
  if (duration != null) {
    albumDataListList.duration = duration;
  }
  final int? region = jsonConvert.convert<int>(json['region']);
  if (region != null) {
    albumDataListList.region = region;
  }
  final int? language = jsonConvert.convert<int>(json['language']);
  if (language != null) {
    albumDataListList.language = language;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    albumDataListList.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    albumDataListList.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
      json['horizontal_poster']);
  if (horizontalPoster != null) {
    albumDataListList.horizontalPoster = horizontalPoster;
  }
  final String? remarks = jsonConvert.convert<String>(json['remarks']);
  if (remarks != null) {
    albumDataListList.remarks = remarks;
  }
  final dynamic verticalPoster = json['vertical_poster'];
  if (verticalPoster != null) {
    albumDataListList.verticalPoster = verticalPoster;
  }
  final dynamic publish = json['publish'];
  if (publish != null) {
    albumDataListList.publish = publish;
  }
  final String? pubdate = jsonConvert.convert<String>(json['pubdate']);
  if (pubdate != null) {
    albumDataListList.pubdate = pubdate;
  }
  final dynamic serialNumber = json['serial_number'];
  if (serialNumber != null) {
    albumDataListList.serialNumber = serialNumber;
  }
  final dynamic screenshot = json['screenshot'];
  if (screenshot != null) {
    albumDataListList.screenshot = screenshot;
  }
  final int? end = jsonConvert.convert<int>(json['end']);
  if (end != null) {
    albumDataListList.end = end;
  }
  final dynamic unit = json['unit'];
  if (unit != null) {
    albumDataListList.unit = unit;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    albumDataListList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    albumDataListList.playUrlPutIn = playUrlPutIn;
  }
  final int? collectionId = jsonConvert.convert<int>(json['collection_id']);
  if (collectionId != null) {
    albumDataListList.collectionId = collectionId;
  }
  final int? up = jsonConvert.convert<int>(json['up']);
  if (up != null) {
    albumDataListList.up = up;
  }
  final int? down = jsonConvert.convert<int>(json['down']);
  if (down != null) {
    albumDataListList.down = down;
  }
  final String? collectionName = jsonConvert.convert<String>(
      json['collection_name']);
  if (collectionName != null) {
    albumDataListList.collectionName = collectionName;
  }
  return albumDataListList;
}

Map<String, dynamic> $AlbumDataListListToJson(AlbumDataListList entity) {
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

extension AlbumDataListListExtension on AlbumDataListList {
  AlbumDataListList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    dynamic createUserId,
    dynamic updateUserId,
    String? title,
    String? subTitle,
    String? videoTag,
    String? videoClass,
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
    return AlbumDataListList()
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

AlbumDataPagination $AlbumDataPaginationFromJson(Map<String, dynamic> json) {
  final AlbumDataPagination albumDataPagination = AlbumDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    albumDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    albumDataPagination.size = size;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    albumDataPagination.categoryId = categoryId;
  }
  final int? videoSize = jsonConvert.convert<int>(json['videoSize']);
  if (videoSize != null) {
    albumDataPagination.videoSize = videoSize;
  }
  final int? videoPage = jsonConvert.convert<int>(json['videoPage']);
  if (videoPage != null) {
    albumDataPagination.videoPage = videoPage;
  }
  return albumDataPagination;
}

Map<String, dynamic> $AlbumDataPaginationToJson(AlbumDataPagination entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['category_id'] = entity.categoryId;
  data['videoSize'] = entity.videoSize;
  data['videoPage'] = entity.videoPage;
  return data;
}

extension AlbumDataPaginationExtension on AlbumDataPagination {
  AlbumDataPagination copyWith({
    int? page,
    int? size,
    int? categoryId,
    int? videoSize,
    int? videoPage,
  }) {
    return AlbumDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..categoryId = categoryId ?? this.categoryId
      ..videoSize = videoSize ?? this.videoSize
      ..videoPage = videoPage ?? this.videoPage;
  }
}