import 'package:sqlite3/sqlite3.dart';

import '../entity/VideoPlayerSettingsEntity.dart';
import 'db_manager.dart';

class VideoPlayerSettingsDatabaseHelper {
  late Database _database;

  VideoPlayerSettingsDatabaseHelper() {
    _database = DBManager.getDataBase();
    _createTable();
  }

  void _createTable() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS video_player_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        video_id TEXT NOT NULL UNIQUE,
        video_title TEXT NOT NULL,
        skip_opening REAL NOT NULL DEFAULT 0.0,
        skip_ending REAL NOT NULL DEFAULT 0.0,
        volume REAL NOT NULL DEFAULT 1.0,
        brightness REAL NOT NULL DEFAULT 1.0,
        video_fit INTEGER NOT NULL DEFAULT 0,
        playback_rate REAL NOT NULL DEFAULT 1.0,
        long_press_rate REAL NOT NULL DEFAULT 2.0,
        updated_at TEXT NOT NULL
      );
    ''');
    _database.execute('''
      CREATE INDEX IF NOT EXISTS idx_video_player_settings_video_id
      ON video_player_settings(video_id);
    ''');
    _addColumnIfExists();
  }

  void _addColumnIfExists() {
    try {
      final result = _database.select(
        "PRAGMA table_info(video_player_settings);",
      );
      final hasColumn = result.any((row) => row.columnAt(1) == 'long_press_rate');
      if (!hasColumn) {
        _database.execute(
          'ALTER TABLE video_player_settings ADD COLUMN long_press_rate REAL NOT NULL DEFAULT 2.0;',
        );
      }
    } catch (e) {
      print('[VideoSettings] Migration check error: $e');
    }
  }

  void insertOrUpdate(VideoPlayerSettingsEntity entity) {
    print('[VideoSettings] DB insertOrUpdate videoId=${entity.videoId}, skipOpening=${entity.skipOpening}, skipEnding=${entity.skipEnding}');
    final existing = _database.select(
      'SELECT id FROM video_player_settings WHERE video_id = ? LIMIT 1;',
      [entity.videoId],
    );

    if (existing.isNotEmpty) {
      print('[VideoSettings] DB UPDATE existing record');
      _database.execute('''
        UPDATE video_player_settings
        SET video_title = ?, skip_opening = ?, skip_ending = ?,
            volume = ?, brightness = ?, video_fit = ?, playback_rate = ?, long_press_rate = ?, updated_at = ?
        WHERE video_id = ?;
      ''', [
        entity.videoTitle,
        entity.skipOpening,
        entity.skipEnding,
        entity.volume,
        entity.brightness,
        entity.videoFit,
        entity.playbackRate,
        entity.longPressRate,
        entity.updatedAt.toIso8601String(),
        entity.videoId,
      ]);
    } else {
      print('[VideoSettings] DB INSERT new record');
      _database.execute('''
        INSERT INTO video_player_settings (video_id, video_title, skip_opening, skip_ending,
            volume, brightness, video_fit, playback_rate, long_press_rate, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''', [
        entity.videoId,
        entity.videoTitle,
        entity.skipOpening,
        entity.skipEnding,
        entity.volume,
        entity.brightness,
        entity.videoFit,
        entity.playbackRate,
        entity.longPressRate,
        entity.updatedAt.toIso8601String(),
      ]);
    }
    print('[VideoSettings] DB operation completed');
  }

  VideoPlayerSettingsEntity? getByVideoId(String videoId) {
    print('[VideoSettings] DB getByVideoId videoId=$videoId');
    final result = _database.select(
      'SELECT * FROM video_player_settings WHERE video_id = ? LIMIT 1;',
      [videoId],
    );
    print('[VideoSettings] DB result count=${result.length}');

    if (result.isEmpty) {
      print('[VideoSettings] DB no data found');
      return null;
    }

    final entity = VideoPlayerSettingsEntity.fromMap({
      'id': result.first.columnAt(0),
      'video_id': result.first.columnAt(1),
      'video_title': result.first.columnAt(2),
      'skip_opening': result.first.columnAt(3),
      'skip_ending': result.first.columnAt(4),
      'volume': result.first.columnAt(5),
      'brightness': result.first.columnAt(6),
      'video_fit': result.first.columnAt(7),
      'playback_rate': result.first.columnAt(8),
      'long_press_rate': result.first.columnAt(9),
      'updated_at': result.first.columnAt(10),
    });
    print('[VideoSettings] DB entity skipOpening=${entity.skipOpening}, skipEnding=${entity.skipEnding}');
    return entity;
  }

  List<VideoPlayerSettingsEntity> getAll() {
    final result = _database.select(
      'SELECT * FROM video_player_settings ORDER BY updated_at DESC;',
    );

    return result.map((row) {
      return VideoPlayerSettingsEntity.fromMap({
        'id': row.columnAt(0),
        'video_id': row.columnAt(1),
        'video_title': row.columnAt(2),
        'skip_opening': row.columnAt(3),
        'skip_ending': row.columnAt(4),
        'volume': row.columnAt(5),
        'brightness': row.columnAt(6),
        'video_fit': row.columnAt(7),
        'playback_rate': row.columnAt(8),
        'long_press_rate': row.columnAt(9),
        'updated_at': row.columnAt(10),
      });
    }).toList();
  }

  void deleteByVideoId(String videoId) {
    _database.execute(
      'DELETE FROM video_player_settings WHERE video_id = ?;',
      [videoId],
    );
  }

  void deleteAll() {
    _database.execute('DELETE FROM video_player_settings;');
  }

  void close() {
    _database.dispose();
  }
}
