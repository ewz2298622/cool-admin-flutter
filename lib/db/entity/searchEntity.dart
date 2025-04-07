import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class SearchHistoryEntity extends HiveObject {
  SearchHistoryEntity({required this.keyWord});

  @HiveField(0)
  String keyWord;
}
