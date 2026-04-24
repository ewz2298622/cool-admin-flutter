import 'package:sqlite3/sqlite3.dart';

import '../entity/TokenEntity.dart';
import 'db_manager.dart';

class TokenDatabaseHelper {
  late Database _database;

  // 初始化数据库
  TokenDatabaseHelper() {
    _database = DBManager.getDataBase();
    _createTable();
  }

  // 创建搜索历史表
  void _createTable() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS user_token (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        createTime TEXT NOT NULL,
        updateTime TEXT NOT NULL,
        expire INTEGER NOT NULL,
        token TEXT NOT NULL,
        refreshExpire INTEGER NOT NULL,
        refreshToken TEXT NOT NULL
      );
    ''');
  }

  // 插入记录
  void insert(TokenEntity data) {
    final query = '''
      INSERT INTO user_token 
      (createTime, updateTime, expire, token, refreshExpire, refreshToken)
      VALUES (?, ?, ?, ?, ?, ?);
    ''';
    _database.execute(query, [
      DateTime.now().toIso8601String(),
      DateTime.now().toIso8601String(),
      data.expire,
      data.token,
      data.refreshExpire,
      data.refreshToken,
    ]);
  }

  //查询记录
  Iterable<TokenEntity> list() {
    final query = 'SELECT * FROM user_token;';
    final result = _database.select(query);

    return result.map((row) {
      return TokenEntity(
        id: row.columnAt(0),
        createTime: row.columnAt(1),
        updateTime: row.columnAt(2),
        expire: row.columnAt(3),
        token: row.columnAt(4),
        refreshExpire: row.columnAt(5),
        refreshToken: row.columnAt(6),
      );
    });
  }

  //查询最新的一条记录 按照createTime字段查询
  TokenEntity? getLatest() {
    final query = 'SELECT * FROM user_token ORDER BY createTime DESC LIMIT 1;';
    final result = _database.select(query);
    if (result.isEmpty) {
      return null;
    }
    return TokenEntity(
      id: result.first.columnAt(0),
      createTime: result.first.columnAt(1),
      updateTime: result.first.columnAt(2),
      expire: result.first.columnAt(3),
      token: result.first.columnAt(4),
      refreshExpire: result.first.columnAt(5),
      refreshToken: result.first.columnAt(6),
    );
  }

  //删除所有记录
  void deleteAll() {
    final query = 'DELETE FROM user_token;';
    _database.execute(query);
  }
}
