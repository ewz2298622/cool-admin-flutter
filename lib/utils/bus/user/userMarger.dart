import 'package:flutter/material.dart';
import 'package:flutter_app/utils/bus/%20theme/theme.dart';

import '../bus.dart';

class UserManager with ChangeNotifier {
  UserManager() {
    eventEmitter.on().listen((event) {
      debugPrint('ThemeMode: ${event.themeMode}');
      notifyListeners(); // 通知UI更新
    });
  }
  static void changeUser(ThemeMode themeMode) {
    eventEmitter.fire(ThemeChangeEvent(themeMode));
  }
}
