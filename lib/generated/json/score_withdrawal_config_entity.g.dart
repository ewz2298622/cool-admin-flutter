import 'package:flutter_app/entity/score_withdrawal_config_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

ScoreWithdrawalConfigEntity $ScoreWithdrawalConfigEntityFromJson(
  Map<String, dynamic> json,
) {
  final ScoreWithdrawalConfigEntity scoreWithdrawalConfigEntity =
      ScoreWithdrawalConfigEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    scoreWithdrawalConfigEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    scoreWithdrawalConfigEntity.message = message;
  }
  final ScoreWithdrawalConfigData? data = jsonConvert
      .convert<ScoreWithdrawalConfigData>(json['data']);
  if (data != null) {
    scoreWithdrawalConfigEntity.data = data;
  }
  return scoreWithdrawalConfigEntity;
}

Map<String, dynamic> $ScoreWithdrawalConfigEntityToJson(
  ScoreWithdrawalConfigEntity entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension ScoreWithdrawalConfigEntityExtension on ScoreWithdrawalConfigEntity {
  ScoreWithdrawalConfigEntity copyWith({
    int? code,
    String? message,
    ScoreWithdrawalConfigData? data,
  }) {
    return ScoreWithdrawalConfigEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

ScoreWithdrawalConfigData $ScoreWithdrawalConfigDataFromJson(
  Map<String, dynamic> json,
) {
  final ScoreWithdrawalConfigData scoreWithdrawalConfigData =
      ScoreWithdrawalConfigData();
  final List<ScoreWithdrawalConfigDataList>? list =
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) =>
                jsonConvert.convert<ScoreWithdrawalConfigDataList>(e)
                    as ScoreWithdrawalConfigDataList,
          )
          .toList();
  if (list != null) {
    scoreWithdrawalConfigData.list = list;
  }
  return scoreWithdrawalConfigData;
}

Map<String, dynamic> $ScoreWithdrawalConfigDataToJson(
  ScoreWithdrawalConfigData entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension ScoreWithdrawalConfigDataExtension on ScoreWithdrawalConfigData {
  ScoreWithdrawalConfigData copyWith({
    List<ScoreWithdrawalConfigDataList>? list,
  }) {
    return ScoreWithdrawalConfigData()..list = list ?? this.list;
  }
}

ScoreWithdrawalConfigDataList $ScoreWithdrawalConfigDataListFromJson(
  Map<String, dynamic> json,
) {
  final ScoreWithdrawalConfigDataList scoreWithdrawalConfigDataList =
      ScoreWithdrawalConfigDataList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    scoreWithdrawalConfigDataList.id = id;
  }
  final int? score = jsonConvert.convert<int>(json['score']);
  if (score != null) {
    scoreWithdrawalConfigDataList.score = score;
  }
  final int? amount = jsonConvert.convert<int>(json['amount']);
  if (amount != null) {
    scoreWithdrawalConfigDataList.amount = amount;
  }
  return scoreWithdrawalConfigDataList;
}

Map<String, dynamic> $ScoreWithdrawalConfigDataListToJson(
  ScoreWithdrawalConfigDataList entity,
) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['score'] = entity.score;
  data['amount'] = entity.amount;
  return data;
}

extension ScoreWithdrawalConfigDataListExtension
    on ScoreWithdrawalConfigDataList {
  ScoreWithdrawalConfigDataList copyWith({int? id, int? score, int? amount}) {
    return ScoreWithdrawalConfigDataList()
      ..id = id ?? this.id
      ..score = score ?? this.score
      ..amount = amount ?? this.amount;
  }
}
