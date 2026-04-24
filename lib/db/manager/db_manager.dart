import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class DBManager {
  static Database? _database;
  static bool _isInitialized = false;

  //实现一个init方法 video数据库不存在就创建video数据库
  static Future<Database> init() async {
    // 防止重复初始化
    if (_isInitialized && _database != null) {
      return _database!;
    }

    try {
      // 获取应用程序的文档目录路径
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = '${documentsDirectory.path}/video.db';
      // 打开数据库（如果数据库不存在，它将被创建）
      _database = sqlite3.open(path);
      _isInitialized = true;
      return _database!;
    } catch (e) {
      rethrow;
    }
  }

  static Database getDataBase() {
    if (_database == null) {
      throw Exception("Database not initialized. Call DBManager.init() first.");
    }
    return _database!;
  }

  // 关闭数据库
  static void close() {
    _database?.dispose();
    _database = null;
    _isInitialized = false;
  }
}
