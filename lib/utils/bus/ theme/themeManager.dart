import 'package:flutter/material.dart';
import 'package:flutter_app/utils/bus/%20theme/theme.dart';

import '../bus.dart';

class ThemeManager with ChangeNotifier {
  static ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    eventEmitter.on<ThemeChangeEvent>().listen((event) {
      _themeMode = event.themeMode;
      debugPrint('ThemeMode: ${event.themeMode}');
      notifyListeners(); // 通知UI更新
    });
  }
  static void changeTheme(ThemeMode themeMode) {
    eventEmitter.fire(ThemeChangeEvent(themeMode));
  }
}
