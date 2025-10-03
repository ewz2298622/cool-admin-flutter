import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/generated/json/score_total_entity.g.dart';
import 'dart:convert';
export 'package:flutter_app/generated/json/score_total_entity.g.dart';

@JsonSerializable()
class ScoreTotalEntity {
	int? code;
	String? message;
	int? data;

	ScoreTotalEntity();

	factory ScoreTotalEntity.fromJson(Map<String, dynamic> json) => $ScoreTotalEntityFromJson(json);

	Map<String, dynamic> toJson() => $ScoreTotalEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}