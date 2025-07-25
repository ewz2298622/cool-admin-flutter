import 'package:sqlite3/sqlite3.dart';

import '../entity/AldultEntity.dart';
import 'DBManager.dart';

class AldultDatabaseHelper {
  late Database _database;

  // 初始化数据库
  AldultDatabaseHelper() {
    _database = DBManager.getDataBase();
    _createTable();
  }

  // 创建搜索历史表
  void _createTable() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS aldult (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        status INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      );
    ''');
  }

  // 插入搜索记录
  void insertAldult(AldultEntity aldult) {
    final query = '''
      INSERT INTO aldult (status, timestamp)
      VALUES (?, ?);
    ''';
    _database.execute(query, [
      aldult.status,
      aldult.timestamp.toIso8601String(),
    ]);
  }

  // 查询所有搜索记录
  List<AldultEntity> getAllAldult() {
    final query = 'SELECT * FROM aldult ORDER BY timestamp DESC;';
    final result = _database.select(query);

    return result.map((row) {
      return AldultEntity(
        id: row.columnAt(0),
        status: row.columnAt(1),
        timestamp: DateTime.parse(row.columnAt(2)),
      );
    }).toList();
  }

  //分页查询
  Iterable<AldultEntity> getAldultByPage(int page, int pageSize) {
    final query =
        'SELECT * FROM aldult ORDER BY timestamp DESC LIMIT ? OFFSET ?;';
    final result = _database.select(query, [pageSize, (page - 1) * pageSize]);

    return result.map((row) {
      return AldultEntity(
        id: row.columnAt(0),
        status: row.columnAt(1),
        timestamp: DateTime.parse(row.columnAt(2)),
      );
    });
  }

  // 根据ID删除搜索记录
  void deleteAldultById(int id) {
    final query = 'DELETE FROM aldult WHERE id = ?;';
    _database.execute(query, [id]);
  }

  // 关闭数据库
  void close() {
    _database.dispose();
  }

  //删除所有记录
  void deleteAll() {
    final query = 'DELETE FROM aldult;';
    _database.execute(query);
  }

  //查询最新的一条记录
  AldultEntity? getLatest() {
    final query = 'SELECT * FROM aldult ORDER BY timestamp DESC LIMIT 1;';
    final result = _database.select(query);
    if (result.isEmpty) {
      return null;
    }
    return AldultEntity(
      id: result.first.columnAt(0),
      status: result.first.columnAt(1),
      timestamp: DateTime.parse(result.first.columnAt(2)),
    );
  }
}
