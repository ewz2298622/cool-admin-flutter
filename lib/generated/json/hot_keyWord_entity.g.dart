import 'package:flutter_app/entity/hot_keyWord_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

HotKeyWordEntity $HotKeyWordEntityFromJson(Map<String, dynamic> json) {
  final HotKeyWordEntity hotKeyWordEntity = HotKeyWordEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    hotKeyWordEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    hotKeyWordEntity.message = message;
  }
  final HotKeyWordData? data = jsonConvert.convert<HotKeyWordData>(
    json['data'],
  );
  if (data != null) {
    hotKeyWordEntity.data = data;
  }
  return hotKeyWordEntity;
}

Map<String, dynamic> $HotKeyWordEntityToJson(HotKeyWordEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension HotKeyWordEntityExtension on HotKeyWordEntity {
  HotKeyWordEntity copyWith({
    int? code,
    String? message,
    HotKeyWordData? data,
  }) {
    return HotKeyWordEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

HotKeyWordData $HotKeyWordDataFromJson(Map<String, dynamic> json) {
  final HotKeyWordData hotKeyWordData = HotKeyWordData();
  final List<HotKeyWordDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<HotKeyWordDataList>(e)
                    as HotKeyWordDataList,
          )
          .toList();
  if (list != null) {
    hotKeyWordData.list = list;
  }
  final HotKeyWordDataPagination? pagination = jsonConvert
      .convert<HotKeyWordDataPagination>(json['pagination']);
  if (pagination != null) {
    hotKeyWordData.pagination = pagination;
  }
  return hotKeyWordData;
}

Map<String, dynamic> $HotKeyWordDataToJson(HotKeyWordData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['pagination'] = entity.pagination?.toJson();
  return data;
}

extension HotKeyWordDataExtension on HotKeyWordData {
  HotKeyWordData copyWith({
    List<HotKeyWordDataList>? list,
    HotKeyWordDataPagination? pagination,
  }) {
    return HotKeyWordData()
      ..list = list ?? this.list
      ..pagination = pagination ?? this.pagination;
  }
}

HotKeyWordDataList $HotKeyWordDataListFromJson(Map<String, dynamic> json) {
  final HotKeyWordDataList hotKeyWordDataList = HotKeyWordDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    hotKeyWordDataList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    hotKeyWordDataList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    hotKeyWordDataList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    hotKeyWordDataList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    hotKeyWordDataList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    hotKeyWordDataList.updateUserId = updateUserId;
  }
  final String? keyWord = jsonConvert.convert<String>(json['keyWord']);
  if (keyWord != null) {
    hotKeyWordDataList.keyWord = keyWord;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    hotKeyWordDataList.categoryId = categoryId;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    hotKeyWordDataList.tag = tag;
  }
  final String? bgColor = jsonConvert.convert<String>(json['bgColor']);
  if (bgColor != null) {
    hotKeyWordDataList.bgColor = bgColor;
  }
  final String? fontColor = jsonConvert.convert<String>(json['fontColor']);
  if (fontColor != null) {
    hotKeyWordDataList.fontColor = fontColor;
  }
  return hotKeyWordDataList;
}

Map<String, dynamic> $HotKeyWordDataListToJson(HotKeyWordDataList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['tenantId'] = entity.tenantId;
  data['createUserId'] = entity.createUserId;
  data['updateUserId'] = entity.updateUserId;
  data['keyWord'] = entity.keyWord;
  data['category_id'] = entity.categoryId;
  data['tag'] = entity.tag;
  data['bgColor'] = entity.bgColor;
  data['fontColor'] = entity.fontColor;
  return data;
}

extension HotKeyWordDataListExtension on HotKeyWordDataList {
  HotKeyWordDataList copyWith({
    int? id,
    String? createTime,
    String? updateTime,
    dynamic tenantId,
    int? createUserId,
    dynamic updateUserId,
    String? keyWord,
    int? categoryId,
    String? tag,
    String? bgColor,
    String? fontColor,
  }) {
    return HotKeyWordDataList()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..tenantId = tenantId ?? this.tenantId
      ..createUserId = createUserId ?? this.createUserId
      ..updateUserId = updateUserId ?? this.updateUserId
      ..keyWord = keyWord ?? this.keyWord
      ..categoryId = categoryId ?? this.categoryId
      ..tag = tag ?? this.tag
      ..bgColor = bgColor ?? this.bgColor
      ..fontColor = fontColor ?? this.fontColor;
  }
}

HotKeyWordDataPagination $HotKeyWordDataPaginationFromJson(
  Map<String, dynamic> json,
) {
  final HotKeyWordDataPagination hotKeyWordDataPagination =
      HotKeyWordDataPagination();
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    hotKeyWordDataPagination.page = page;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    hotKeyWordDataPagination.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    hotKeyWordDataPagination.total = total;
  }
  return hotKeyWordDataPagination;
}

Map<String, dynamic> $HotKeyWordDataPaginationToJson(
  HotKeyWordDataPagination entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension HotKeyWordDataPaginationExtension on HotKeyWordDataPagination {
  HotKeyWordDataPagination copyWith({int? page, int? size, int? total}) {
    return HotKeyWordDataPagination()
      ..page = page ?? this.page
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}
