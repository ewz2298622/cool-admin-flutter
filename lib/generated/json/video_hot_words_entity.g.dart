import 'package:flutter_app/entity/video_hot_words_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

VideoHotWordsEntity $VideoHotWordsEntityFromJson(Map<String, dynamic> json) {
  final VideoHotWordsEntity videoHotWordsEntity = VideoHotWordsEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoHotWordsEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    videoHotWordsEntity.message = message;
  }
  final VideoHotWordsData? data = jsonConvert.convert<VideoHotWordsData>(
    json['data'],
  );
  if (data != null) {
    videoHotWordsEntity.data = data;
  }
  return videoHotWordsEntity;
}

Map<String, dynamic> $VideoHotWordsEntityToJson(VideoHotWordsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension VideoHotWordsEntityExtension on VideoHotWordsEntity {
  VideoHotWordsEntity copyWith({
    int? code,
    String? message,
    VideoHotWordsData? data,
  }) {
    return VideoHotWordsEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

VideoHotWordsData $VideoHotWordsDataFromJson(Map<String, dynamic> json) {
  final VideoHotWordsData videoHotWordsData = VideoHotWordsData();
  final List<VideoHotWordsDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoHotWordsDataList>(e)
                    as VideoHotWordsDataList,
          )
          .toList();
  if (list != null) {
    videoHotWordsData.list = list;
  }
  return videoHotWordsData;
}

Map<String, dynamic> $VideoHotWordsDataToJson(VideoHotWordsData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension VideoHotWordsDataExtension on VideoHotWordsData {
  VideoHotWordsData copyWith({List<VideoHotWordsDataList>? list}) {
    return VideoHotWordsData()..list = list ?? this.list;
  }
}

VideoHotWordsDataList $VideoHotWordsDataListFromJson(
  Map<String, dynamic> json,
) {
  final VideoHotWordsDataList videoHotWordsDataList = VideoHotWordsDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoHotWordsDataList.id = id;
  }
  final int? typeId = jsonConvert.convert<int>(json['typeId']);
  if (typeId != null) {
    videoHotWordsDataList.typeId = typeId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    videoHotWordsDataList.name = name;
  }
  final dynamic value = json['value'];
  if (value != null) {
    videoHotWordsDataList.value = value;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    videoHotWordsDataList.orderNum = orderNum;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    videoHotWordsDataList.status = status;
  }
  final dynamic color = json['color'];
  if (color != null) {
    videoHotWordsDataList.color = color;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    videoHotWordsDataList.remark = remark;
  }
  final dynamic parentId = json['parentId'];
  if (parentId != null) {
    videoHotWordsDataList.parentId = parentId;
  }
  final List<VideoHotWordsDataListList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<VideoHotWordsDataListList>(e)
                    as VideoHotWordsDataListList,
          )
          .toList();
  if (list != null) {
    videoHotWordsDataList.list = list;
  }
  return videoHotWordsDataList;
}

Map<String, dynamic> $VideoHotWordsDataListToJson(
  VideoHotWordsDataList entity,
) {
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

extension VideoHotWordsDataListExtension on VideoHotWordsDataList {
  VideoHotWordsDataList copyWith({
    int? id,
    int? typeId,
    String? name,
    dynamic value,
    int? orderNum,
    int? status,
    dynamic color,
    String? remark,
    dynamic parentId,
    List<VideoHotWordsDataListList>? list,
  }) {
    return VideoHotWordsDataList()
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

VideoHotWordsDataListList $VideoHotWordsDataListListFromJson(
  Map<String, dynamic> json,
) {
  final VideoHotWordsDataListList videoHotWordsDataListList =
      VideoHotWordsDataListList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    videoHotWordsDataListList.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    videoHotWordsDataListList.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    videoHotWordsDataListList.updateTime = updateTime;
  }
  final dynamic tenantId = json['tenantId'];
  if (tenantId != null) {
    videoHotWordsDataListList.tenantId = tenantId;
  }
  final int? createUserId = jsonConvert.convert<int>(json['createUserId']);
  if (createUserId != null) {
    videoHotWordsDataListList.createUserId = createUserId;
  }
  final dynamic updateUserId = json['updateUserId'];
  if (updateUserId != null) {
    videoHotWordsDataListList.updateUserId = updateUserId;
  }
  final String? keyWord = jsonConvert.convert<String>(json['keyWord']);
  if (keyWord != null) {
    videoHotWordsDataListList.keyWord = keyWord;
  }
  final int? categoryId = jsonConvert.convert<int>(json['category_id']);
  if (categoryId != null) {
    videoHotWordsDataListList.categoryId = categoryId;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    videoHotWordsDataListList.tag = tag;
  }
  final String? bgColor = jsonConvert.convert<String>(json['bgColor']);
  if (bgColor != null) {
    videoHotWordsDataListList.bgColor = bgColor;
  }
  final String? fontColor = jsonConvert.convert<String>(json['fontColor']);
  if (fontColor != null) {
    videoHotWordsDataListList.fontColor = fontColor;
  }
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    videoHotWordsDataListList.sort = sort;
  }
  return videoHotWordsDataListList;
}

Map<String, dynamic> $VideoHotWordsDataListListToJson(
  VideoHotWordsDataListList entity,
) {
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
  data['sort'] = entity.sort;
  return data;
}

extension VideoHotWordsDataListListExtension on VideoHotWordsDataListList {
  VideoHotWordsDataListList copyWith({
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
    int? sort,
  }) {
    return VideoHotWordsDataListList()
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
      ..fontColor = fontColor ?? this.fontColor
      ..sort = sort ?? this.sort;
  }
}
