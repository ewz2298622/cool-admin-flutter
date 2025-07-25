class AldultEntity {
  int? id; // 主键
  int status; // 搜索内容
  DateTime timestamp; // 搜索时间

  AldultEntity({this.id, required this.status, required this.timestamp});

  // 将实体类转换为Map，便于插入数据库
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // 从数据库查询结果中创建实体类
  factory AldultEntity.fromMap(Map<String, dynamic> map) {
    return AldultEntity(
      id: map['id'],
      status: map['status'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
