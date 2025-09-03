import 'package:sqlite3/sqlite3.dart';

import '../entity/UserEntity.dart';
import 'DBManager.dart';

class UserDatabaseHelper {
  late Database _database;

  // 初始化数据库
  UserDatabaseHelper() {
    _database = DBManager.getDataBase();
    _createTable();
  }

  // 创建搜索历史表
  void _createTable() {
    _database.execute('''
    CREATE TABLE IF NOT EXISTS user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      createTime TEXT,          -- 允许为空
      updateTime TEXT,          -- 允许为空
      unionid TEXT NOT NULL,             -- 允许为空
      avatarUrl TEXT,           -- 仍不允许为空（示例）
      nickName TEXT NOT NULL,   -- 仍不允许为空（示例）
      phone TEXT NOT NULL,      -- 仍不允许为空（示例）
      gender INTEGER,           -- 允许为空
      status INTEGER,           -- 允许为空
      loginType INTEGER,        -- 允许为空
      password TEXT,            -- 允许为空
      userId INTEGER            -- 允许为空
    );
  ''');
  }

  // 插入记录
  void insert(UserEntity data) {
    final query = '''
    INSERT INTO user 
    (createTime, updateTime, unionid, avatarUrl, nickName, phone, gender, status, loginType, password, userId)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?);
  ''';

    final now = DateTime.now().toIso8601String();

    try {
      _database.execute(query, [
        now,
        now,
        data.unionid,
        data.avatarUrl,
        data.nickName,
        data.phone,
        data.gender,
        data.status,
        data.loginType,
        data.password,
        data.userId,
      ]);
    } catch (e) {
      // 处理异常，例如记录日志或抛出自定义异常
      print('Error inserting user data: $e');
      throw Exception('Failed to insert user data');
    }
  }

  //查询记录
  Iterable<UserEntity> list() {
    final query = 'SELECT * FROM user;';
    final result = _database.select(query);

    return result.map((row) {
      return UserEntity(
        id: row.columnAt(0),
        createTime: row.columnAt(1),
        updateTime: row.columnAt(2),
        unionid: row.columnAt(3),
        avatarUrl: row.columnAt(4),
        nickName: row.columnAt(5),
        phone: row.columnAt(6),
        gender: row.columnAt(7),
        status: row.columnAt(8),
        loginType: row.columnAt(9),
        password: row.columnAt(10),
        userId: row.columnAt(11),
      );
    });
  }

  //根据createTime字段 查询最新的一条数据
  UserEntity? findByNewUserInfo() {
    final createTime = DateTime.now().toIso8601String();
    final query = 'SELECT * FROM user WHERE createTime = ?;';
    final result = _database.select(query, [createTime]);

    if (result.isEmpty) {
      return null;
    }

    return UserEntity(
      id: result.first.columnAt(0),
      createTime: result.first.columnAt(1),
      updateTime: result.first.columnAt(2),
      unionid: result.first.columnAt(3),
      avatarUrl: result.first.columnAt(4),
      nickName: result.first.columnAt(5),
      phone: result.first.columnAt(6),
      gender: result.first.columnAt(7),
      status: result.first.columnAt(8),
      loginType: result.first.columnAt(9),
      password: result.first.columnAt(10),
      userId: result.first.columnAt(11),
    );
  }

  //删除表里面所有数据
  void deleteAll() {
    final query = 'DELETE FROM user;';
    _database.execute(query);
  }
}
