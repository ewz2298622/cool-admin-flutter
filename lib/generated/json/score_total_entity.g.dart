import 'package:flutter_app/entity/score_total_entity.dart';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

ScoreTotalEntity $ScoreTotalEntityFromJson(Map<String, dynamic> json) {
  final ScoreTotalEntity scoreTotalEntity = ScoreTotalEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    scoreTotalEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    scoreTotalEntity.message = message;
  }
  final int? data = jsonConvert.convert<int>(json['data']);
  if (data != null) {
    scoreTotalEntity.data = data;
  }
  return scoreTotalEntity;
}

Map<String, dynamic> $ScoreTotalEntityToJson(ScoreTotalEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data;
  return data;
}

extension ScoreTotalEntityExtension on ScoreTotalEntity {
  ScoreTotalEntity copyWith({int? code, String? message, int? data}) {
    return ScoreTotalEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}
