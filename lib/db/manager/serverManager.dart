import 'package:flutter/cupertino.dart';

import '../dao/searchDao.dart';

class ServerManager {
  // 私有静态实例变量
  static final ServerManager _instance = ServerManager._internal();

  // 私有构造函数
  ServerManager._internal();

  // 公共静态方法，用于获取单例实例
  static ServerManager getInstance() {
    return _instance;
  }

  // 示例方法
  SearchDao searchService() {
    debugPrint('ServerManager searchService');
    return SearchDao();
  }

  Future<void> init() async {
    // 使用示例方法
    debugPrint('ServerManager init');
    try {
      await searchService().open();
    } catch (e) {
      debugPrint('Failed to initialize ServerManager: $e');
      throw Exception('Failed to initialize ServerManager: $e');
    }
  }
}