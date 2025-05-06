class SearchHistoryEntity {
  int? id; // 主键
  String query; // 搜索内容
  DateTime timestamp; // 搜索时间

  SearchHistoryEntity({this.id, required this.query, required this.timestamp});

  // 将实体类转换为Map，便于插入数据库
  Map<String, dynamic> toMap() {
    return {'id': id, 'query': query, 'timestamp': timestamp.toIso8601String()};
  }

  // 从数据库查询结果中创建实体类
  factory SearchHistoryEntity.fromMap(Map<String, dynamic> map) {
    return SearchHistoryEntity(
      id: map['id'],
      query: map['query'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
