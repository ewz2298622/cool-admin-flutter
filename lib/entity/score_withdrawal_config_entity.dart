import 'dart:convert';

import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/score_withdrawal_config_entity.g.dart';

export 'package:flutter_app/generated/json/score_withdrawal_config_entity.g.dart';

@JsonSerializable()
class ScoreWithdrawalConfigEntity {
  int? code;
  String? message;
  ScoreWithdrawalConfigData? data;

  ScoreWithdrawalConfigEntity();

  factory ScoreWithdrawalConfigEntity.fromJson(Map<String, dynamic> json) =>
      $ScoreWithdrawalConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $ScoreWithdrawalConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ScoreWithdrawalConfigData {
  List<ScoreWithdrawalConfigDataList>? list;

  ScoreWithdrawalConfigData();

  factory ScoreWithdrawalConfigData.fromJson(Map<String, dynamic> json) =>
      $ScoreWithdrawalConfigDataFromJson(json);

  Map<String, dynamic> toJson() => $ScoreWithdrawalConfigDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ScoreWithdrawalConfigDataList {
  int? id;
  int? score;
  int? amount;

  ScoreWithdrawalConfigDataList();

  factory ScoreWithdrawalConfigDataList.fromJson(Map<String, dynamic> json) =>
      $ScoreWithdrawalConfigDataListFromJson(json);

  Map<String, dynamic> toJson() => $ScoreWithdrawalConfigDataListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
