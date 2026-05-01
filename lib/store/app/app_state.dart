import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  // 定义你的应用状态

  void reset() {
    // 重置所有状态
    notifyListeners();
  }
}
