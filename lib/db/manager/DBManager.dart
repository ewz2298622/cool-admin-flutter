import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class DBManager {
  static late Database _database;
  //实现一个init方法 video数据库不存在就创建video数据库
  static Future<Database> init() async {
    // 获取应用程序的文档目录路径
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/video.db';
    // 打开数据库（如果数据库不存在，它将被创建）
    _database = sqlite3.open(path);
    return _database;
  }

  static Database getDataBase() {
    return _database;
  }

  // 关闭数据库
  void close() {
    _database.dispose();
  }
}
