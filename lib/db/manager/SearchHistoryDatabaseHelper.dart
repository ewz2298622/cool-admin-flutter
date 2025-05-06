import 'package:sqlite3/sqlite3.dart';

import '../entity/SearchHistoryEntity.dart';
import 'DBManager.dart';

class SearchHistoryDatabaseHelper {
  late Database _database;

  // 初始化数据库
  SearchHistoryDatabaseHelper() {
    _database = DBManager.getDataBase();
    _createTable();
  }

  // 创建搜索历史表
  void _createTable() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        timestamp TEXT NOT NULL
      );
    ''');
  }

  // 插入搜索记录
  void insertSearchHistory(SearchHistoryEntity searchHistory) {
    final query = '''
      INSERT INTO search_history (query, timestamp)
      VALUES (?, ?);
    ''';
    _database.execute(query, [
      searchHistory.query,
      searchHistory.timestamp.toIso8601String(),
    ]);
  }

  // 查询所有搜索记录
  List<SearchHistoryEntity> getAllSearchHistory() {
    final query = 'SELECT * FROM search_history ORDER BY timestamp DESC;';
    final result = _database.select(query);

    return result.map((row) {
      return SearchHistoryEntity(
        id: row.columnAt(0),
        query: row.columnAt(1),
        timestamp: DateTime.parse(row.columnAt(2)),
      );
    }).toList();
  }

  //分页查询
  Iterable<SearchHistoryEntity> getSearchHistoryByPage(int page, int pageSize) {
    final query =
        'SELECT * FROM search_history ORDER BY timestamp DESC LIMIT ? OFFSET ?;';
    final result = _database.select(query, [pageSize, (page - 1) * pageSize]);

    return result.map((row) {
      return SearchHistoryEntity(
        id: row.columnAt(0),
        query: row.columnAt(1),
        timestamp: DateTime.parse(row.columnAt(2)),
      );
    });
  }

  // 根据ID删除搜索记录
  void deleteSearchHistoryById(int id) {
    final query = 'DELETE FROM search_history WHERE id = ?;';
    _database.execute(query, [id]);
  }

  // 关闭数据库
  void close() {
    _database.dispose();
  }
}
