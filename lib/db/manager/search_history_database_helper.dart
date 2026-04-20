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

  // 创建搜索历史表 - 优化：添加索引提升查询性能
  void _createTable() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        timestamp TEXT NOT NULL
      );
    ''');
    // 为 query 字段添加索引，提升查询性能
    _database.execute('''
      CREATE INDEX IF NOT EXISTS idx_search_history_query 
      ON search_history(query);
    ''');
    // 为 timestamp 字段添加索引，提升排序性能
    _database.execute('''
      CREATE INDEX IF NOT EXISTS idx_search_history_timestamp 
      ON search_history(timestamp DESC);
    ''');
  }

  // 插入搜索记录 - 优化：使用 LIMIT 1 提升查询性能
  void insertSearchHistory(SearchHistoryEntity searchHistory) {
    // 清除搜索空格
    searchHistory.query = searchHistory.query.trim();
    
    // 检查是否已存在（使用 LIMIT 1 提升性能）
    final existing = _database.select(
      'SELECT id FROM search_history WHERE query = ? LIMIT 1;',
      [searchHistory.query],
    );
    if (existing.isNotEmpty) {
      return;
    }

    // 插入新记录
    _database.execute(
      'INSERT INTO search_history (query, timestamp) VALUES (?, ?);',
      [
        searchHistory.query,
        searchHistory.timestamp.toIso8601String(),
      ],
    );
  }

  // 根据搜索内容查询搜索记录 - 优化：修复变量名冲突
  SearchHistoryEntity? getSearchHistoryByQuery(String searchQuery) {
    final sql = 'SELECT * FROM search_history WHERE query = ? LIMIT 1;';
    final result = _database.select(sql, [searchQuery]);

    if (result.isEmpty) {
      return null;
    }

    return SearchHistoryEntity(
      id: result.first.columnAt(0),
      query: result.first.columnAt(1),
      timestamp: DateTime.parse(result.first.columnAt(2)),
    );
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

  //删除所有记录
  void deleteAll() {
    final query = 'DELETE FROM search_history;';
    _database.execute(query);
  }
}
