import 'package:flutter_app/entity/album_video_list_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

AlbumVideoListEntity $AlbumVideoListEntityFromJson(Map<String, dynamic> json) {
  final AlbumVideoListEntity albumVideoListEntity = AlbumVideoListEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    albumVideoListEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    albumVideoListEntity.message = message;
  }
  final AlbumVideoListData? data = jsonConvert.convert<AlbumVideoListData>(
    json['data'],
  );
  if (data != null) {
    albumVideoListEntity.data = data;
  }
  return albumVideoListEntity;
}

Map<String, dynamic> $AlbumVideoListEntityToJson(AlbumVideoListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension AlbumVideoListEntityExtension on AlbumVideoListEntity {
  AlbumVideoListEntity copyWith({
    int? code,
    String? message,
    AlbumVideoListData? data,
  }) {
    return AlbumVideoListEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

AlbumVideoListData $AlbumVideoListDataFromJson(Map<String, dynamic> json) {
  final AlbumVideoListData albumVideoListData = AlbumVideoListData();
  final List<AlbumVideoListDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<AlbumVideoListDataList>(e)
                    as AlbumVideoListDataList,
          )
          .toList();
  if (list != null) {
    albumVideoListData.list = list;
  }
  final AlbumVideoListDataPagination? pagination = jsonConvert
      .convert<AlbumVideoListDataPagination>(json['pagination']);
  if (pagination != null) {
    albumVideoListData.pagination = pagination;
  }
  return albumVideoListData;
}

Map<String, dynamic> $AlbumVideoListDataToJson(AlbumVideoListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension AlbumVideoListDataExtension on AlbumVideoListData {
  AlbumVideoListData copyWith({
    List<AlbumVideoListDataList>? list,
    AlbumVideoListDataPagination? pagination,
  }) {
    return AlbumVideoListData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

AlbumVideoListDataList $AlbumVideoListDataListFromJson(
  Map<String, dynamic> json,
) {
  final AlbumVideoListDataList albumVideoListDataList =
      AlbumVideoListDataList();
  final String? albumId = jsonConvert.convert<String>(json['album_id']);
  if (albumId != null) {
    albumVideoListDataList.albumId = albumId;
  }
  final String? videosId = jsonConvert.convert<String>(json['videos_id']);
  if (videosId != null) {
    albumVideoListDataList.videosId = videosId;
  }
  final dynamic createAt = json['create_at'];
  if (createAt != null) {
    albumVideoListDataList.createAt = createAt;
  }
  final dynamic updateAt = json['update_at'];
  if (updateAt != null) {
    albumVideoListDataList.updateAt = updateAt;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    albumVideoListDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    albumVideoListDataList.updateTime = updateTime;
  }
  final dynamic createUserId = json['createUserId'];
  if (createUserId != null) {
    albumVideoListDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    albumVideoListDataList.updateUserId = updateUserId;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    albumVideoListDataList.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    albumVideoListDataList.title = title;
  }
  final String? categoryPid = jsonConvert.convert<String>(json['category_pid']);
  if (categoryPid != null) {
    albumVideoListDataList.categoryPid = categoryPid;
  }
  final String? categoryChildId = jsonConvert.convert<String>(
    json['category_child_id'],
  );
  if (categoryChildId != null) {
    albumVideoListDataList.categoryChildId = categoryChildId;
  }
  final String? surfacePlot = jsonConvert.convert<String>(json['surface_plot']);
  if (surfacePlot != null) {
    albumVideoListDataList.surfacePlot = surfacePlot;
  }
  final String? recommend = jsonConvert.convert<String>(json['recommend']);
  if (recommend != null) {
    albumVideoListDataList.recommend = recommend;
  }
  final String? cycle = jsonConvert.convert<String>(json['cycle']);
  if (cycle != null) {
    albumVideoListDataList.cycle = cycle;
  }
  final String? cycleImg = jsonConvert.convert<String>(json['cycle_img']);
  if (cycleImg != null) {
    albumVideoListDataList.cycleImg = cycleImg;
  }
  final String? chargingMode = jsonConvert.convert<String>(
    json['charging_mode'],
  );
  if (chargingMode != null) {
    albumVideoListDataList.chargingMode = chargingMode;
  }
  final String? buyMode = jsonConvert.convert<String>(json['buy_mode']);
  if (buyMode != null) {
    albumVideoListDataList.buyMode = buyMode;
  }
  final String? gold = jsonConvert.convert<String>(json['gold']);
  if (gold != null) {
    albumVideoListDataList.gold = gold;
  }
  final String? directors = jsonConvert.convert<String>(json['directors']);
  if (directors != null) {
    albumVideoListDataList.directors = directors;
  }
  final String? actors = jsonConvert.convert<String>(json['actors']);
  if (actors != null) {
    albumVideoListDataList.actors = actors;
  }
  final String? imdbScore = jsonConvert.convert<String>(json['imdb_score']);
  if (imdbScore != null) {
    albumVideoListDataList.imdbScore = imdbScore;
  }
  final String? imdbScoreId = jsonConvert.convert<String>(
    json['imdb_score_id'],
  );
  if (imdbScoreId != null) {
    albumVideoListDataList.imdbScoreId = imdbScoreId;
  }
  final int? doubanScore = jsonConvert.convert<int>(json['douban_score']);
  if (doubanScore != null) {
    albumVideoListDataList.doubanScore = doubanScore;
  }
  final String? doubanScoreId = jsonConvert.convert<String>(
    json['douban_score_id'],
  );
  if (doubanScoreId != null) {
    albumVideoListDataList.doubanScoreId = doubanScoreId;
  }
  final String? introduce = jsonConvert.convert<String>(json['introduce']);
  if (introduce != null) {
    albumVideoListDataList.introduce = introduce;
  }
  final String? label = jsonConvert.convert<String>(json['label']);
  if (label != null) {
    albumVideoListDataList.label = label;
  }
  final String? language = jsonConvert.convert<String>(json['language']);
  if (language != null) {
    albumVideoListDataList.language = language;
  }
  final String? region = jsonConvert.convert<String>(json['region']);
  if (region != null) {
    albumVideoListDataList.region = region;
  }
  final String? note = jsonConvert.convert<String>(json['note']);
  if (note != null) {
    albumVideoListDataList.note = note;
  }
  final String? duration = jsonConvert.convert<String>(json['duration']);
  if (duration != null) {
    albumVideoListDataList.duration = duration;
  }
  final String? serialNumber = jsonConvert.convert<String>(
    json['serial_number'],
  );
  if (serialNumber != null) {
    albumVideoListDataList.serialNumber = serialNumber;
  }
  final String? year = jsonConvert.convert<String>(json['year']);
  if (year != null) {
    albumVideoListDataList.year = year;
  }
  final String? alias = jsonConvert.convert<String>(json['alias']);
  if (alias != null) {
    albumVideoListDataList.alias = alias;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    albumVideoListDataList.status = status;
  }
  final String? popularitySum = jsonConvert.convert<String>(
    json['popularity_sum'],
  );
  if (popularitySum != null) {
    albumVideoListDataList.popularitySum = popularitySum;
  }
  final String? popularityDay = jsonConvert.convert<String>(
    json['popularity_day'],
  );
  if (popularityDay != null) {
    albumVideoListDataList.popularityDay = popularityDay;
  }
  final String? popularityMonth = jsonConvert.convert<String>(
    json['popularity_month'],
  );
  if (popularityMonth != null) {
    albumVideoListDataList.popularityMonth = popularityMonth;
  }
  final String? popularityWeek = jsonConvert.convert<String>(
    json['popularity_week'],
  );
  if (popularityWeek != null) {
    albumVideoListDataList.popularityWeek = popularityWeek;
  }
  final String? releaseAt = jsonConvert.convert<String>(json['release_at']);
  if (releaseAt != null) {
    albumVideoListDataList.releaseAt = releaseAt;
  }
  final String? shelfAt = jsonConvert.convert<String>(json['shelf_at']);
  if (shelfAt != null) {
    albumVideoListDataList.shelfAt = shelfAt;
  }
  final String? screenshot = jsonConvert.convert<String>(json['screenshot']);
  if (screenshot != null) {
    albumVideoListDataList.screenshot = screenshot;
  }
  final String? playUrl = jsonConvert.convert<String>(json['play_url']);
  if (playUrl != null) {
    albumVideoListDataList.playUrl = playUrl;
  }
  final int? playUrlPutIn = jsonConvert.convert<int>(json['play_url_put_in']);
  if (playUrlPutIn != null) {
    albumVideoListDataList.playUrlPutIn = playUrlPutIn;
  }
  final int? trailerTime = jsonConvert.convert<int>(json['trailer_time']);
  if (trailerTime != null) {
    albumVideoListDataList.trailerTime = trailerTime;
  }
  final String? unit = jsonConvert.convert<String>(json['unit']);
  if (unit != null) {
    albumVideoListDataList.unit = unit;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    albumVideoListDataList.number = number;
  }
  final String? total = jsonConvert.convert<String>(json['total']);
  if (total != null) {
    albumVideoListDataList.total = total;
  }
  final String? horizontalPoster = jsonConvert.convert<String>(
    json['horizontal_poster'],
  );
  if (horizontalPoster != null) {
    albumVideoListDataList.horizontalPoster = horizontalPoster;
  }
  final String? verticalPoster = jsonConvert.convert<String>(
    json['vertical_poster'],
  );
  if (verticalPoster != null) {
    albumVideoListDataList.verticalPoster = verticalPoster;
  }
  final String? gif = jsonConvert.convert<String>(json['gif']);
  if (gif != null) {
    albumVideoListDataList.gif = gif;
  }
  return albumVideoListDataList;
}

Map<String, dynamic> $AlbumVideoListDataListToJson(
  AlbumVideoListDataList entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['album_id'] = entity.albumId;
  data['videos_id'] = entity.videosId;
  data['create_at'] = entity.createAt;
  data['update_at'] = entity.updateAt;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['id'] = entity.id;
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
  data['label'] = entity.label;
  data['language'] = entity.language;
  data['region'] = entity.region;
  data['note'] = entity.note;
  data['duration'] = entity.duration;
  data['serial_number'] = entity.serialNumber;
  data['year'] = entity.year;
  data['alias'] = entity.alias;
  data['status'] = entity.status;
  data['popularity_sum'] = entity.popularitySum;
  data['popularity_day'] = entity.popularityDay;
  data['popularity_month'] = entity.popularityMonth;
  data['popularity_week'] = entity.popularityWeek;
  data['release_at'] = entity.releaseAt;
  data['shelf_at'] = entity.shelfAt;
  data['screenshot'] = entity.screenshot;
  data['play_url'] = entity.playUrl;
  data['play_url_put_in'] = entity.playUrlPutIn;
  data['trailer_time'] = entity.trailerTime;
  data['unit'] = entity.unit;
  data['number'] = entity.number;
  data['total'] = entity.total;
  data['horizontal_poster'] = entity.horizontalPoster;
  data['vertical_poster'] = entity.verticalPoster;
  data['gif'] = entity.gif;
  return data;
}

extension AlbumVideoListDataListExtension on AlbumVideoListDataList {
  AlbumVideoListDataList copyWith({
    String? albumId,
    String? videosId,
    dynamic createAt,
    dynamic updateAt,
    String? createTime,
    String? updateTime,
    dynamic createUserId,
    dynamic updateUserId,
    int? id,
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
    String? label,
    String? language,
    String? region,
    String? note,
    String? duration,
    String? serialNumber,
    String? year,
    String? alias,
    String? status,
    String? popularitySum,
    String? popularityDay,
    String? popularityMonth,
    String? popularityWeek,
    String? releaseAt,
    String? shelfAt,
    String? screenshot,
    String? playUrl,
    int? playUrlPutIn,
    int? trailerTime,
    String? unit,
    String? number,
    String? total,
    String? horizontalPoster,
    String? verticalPoster,
    String? gif,
  }) {
    return AlbumVideoListDataList()
      ..albumId = albumId ?? this.albumId
      ..videosId = videosId ?? this.videosId
      ..createAt = createAt ?? this.createAt
      ..updateAt = updateAt ?? this.updateAt
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..id = id ?? this.id
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
      ..label = label ?? this.label
      ..language = language ?? this.language
      ..region = region ?? this.region
      ..note = note ?? this.note
      ..duration = duration ?? this.duration
      ..serialNumber = serialNumber ?? this.serialNumber
      ..year = year ?? this.year
      ..alias = alias ?? this.alias
      ..status = status ?? this.status
      ..popularitySum = popularitySum ?? this.popularitySum
      ..popularityDay = popularityDay ?? this.popularityDay
      ..popularityMonth = popularityMonth ?? this.popularityMonth
      ..popularityWeek = popularityWeek ?? this.popularityWeek
      ..releaseAt = releaseAt ?? this.releaseAt
      ..shelfAt = shelfAt ?? this.shelfAt
      ..screenshot = screenshot ?? this.screenshot
      ..playUrl = playUrl ?? this.playUrl
      ..playUrlPutIn = playUrlPutIn ?? this.playUrlPutIn
      ..trailerTime = trailerTime ?? this.trailerTime
      ..unit = unit ?? this.unit
      ..number = number ?? this.number
      ..total = total ?? this.total
      ..horizontalPoster = horizontalPoster ?? this.horizontalPoster
      ..verticalPoster = verticalPoster ?? this.verticalPoster
      ..gif = gif ?? this.gif;
  }
}

AlbumVideoListDataPagination $AlbumVideoListDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final AlbumVideoListDataPagination albumVideoListDataPagination =
      AlbumVideoListDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    albumVideoListDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    albumVideoListDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    albumVideoListDataPagination.total = total;
  }
  return albumVideoListDataPagination;
}

Map<String, dynamic> $AlbumVideoListDataPaginationToJson(
  AlbumVideoListDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension AlbumVideoListDataPaginationExtension
    on AlbumVideoListDataPagination {
  AlbumVideoListDataPagination copyWith({int? page, int? size, int? total}) {
    return AlbumVideoListDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
