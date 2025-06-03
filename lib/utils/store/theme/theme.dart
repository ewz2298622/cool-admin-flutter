import 'package:flutter/material.dart';

class ThemeChangeEvent extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // 控制亮色/暗色模式

  ThemeMode get themeMode => _themeMode;

  changeTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    //刷新UI
    debugPrint('changeTheme $themeMode');
    notifyListeners();
  }
}
