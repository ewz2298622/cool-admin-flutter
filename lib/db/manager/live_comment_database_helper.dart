import 'package:sqlite3/sqlite3.dart';

import '../entity/LiveCommentEntity.dart';
import 'DBManager.dart';

class LiveCommentDatabaseHelper {
  late Database _database;

  LiveCommentDatabaseHelper() {
    _database = DBManager.getDataBase();
    _createTable();
  }

  void _createTable() {
    _database.execute('''
    CREATE TABLE IF NOT EXISTS live_comment (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      liveId INTEGER NOT NULL,
      userId INTEGER NOT NULL,
      nickName TEXT,
      avatarUrl TEXT,
      content TEXT NOT NULL,
      createTime TEXT
    );
  ''');
    _database.execute('''
      CREATE INDEX IF NOT EXISTS idx_live_comment_createTime 
      ON live_comment(createTime DESC);
    ''');
    _database.execute('''
      CREATE INDEX IF NOT EXISTS idx_live_comment_liveId 
      ON live_comment(liveId);
    ''');
  }

  void insert(LiveCommentEntity data) {
    final query = '''
    INSERT INTO live_comment 
    (liveId, userId, nickName, avatarUrl, content, createTime)
    VALUES (?, ?, ?, ?, ?, ?);
  ''';

    final now = DateTime.now().toIso8601String();

    try {
      _database.execute(query, [
        data.liveId,
        data.userId,
        data.nickName,
        data.avatarUrl,
        data.content,
        now,
      ]);
    } catch (e) {
      print('Error inserting live comment data: $e');
      throw Exception('Failed to insert live comment data');
    }
  }

  Iterable<LiveCommentEntity> list() {
    final query = 'SELECT * FROM live_comment ORDER BY createTime DESC;';
    final result = _database.select(query);

    return result.map((row) {
      return LiveCommentEntity(
        id: row.columnAt(0),
        liveId: row.columnAt(1),
        userId: row.columnAt(2),
        nickName: row.columnAt(3),
        avatarUrl: row.columnAt(4),
        content: row.columnAt(5),
        createTime: row.columnAt(6),
      );
    });
  }

  Iterable<LiveCommentEntity> findByLiveId(int liveId) {
    final query = 'SELECT * FROM live_comment WHERE liveId = ? ORDER BY createTime DESC;';
    final result = _database.select(query, [liveId]);

    return result.map((row) {
      return LiveCommentEntity(
        id: row.columnAt(0),
        liveId: row.columnAt(1),
        userId: row.columnAt(2),
        nickName: row.columnAt(3),
        avatarUrl: row.columnAt(4),
        content: row.columnAt(5),
        createTime: row.columnAt(6),
      );
    });
  }

  void deleteAll() {
    final query = 'DELETE FROM live_comment;';
    _database.execute(query);
  }

  void deleteByLiveId(int liveId) {
    final query = 'DELETE FROM live_comment WHERE liveId = ?;';
    _database.execute(query, [liveId]);
  }
}
