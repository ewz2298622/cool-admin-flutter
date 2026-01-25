import 'package:flutter/material.dart';

class ColorNotifier extends ChangeNotifier {
  Color _primaryColor = const Color.fromRGBO(252, 187, 162, 1.0);

  Color get primaryColor => _primaryColor;

  void updatePrimaryColor(Color newColor) {
    _primaryColor = newColor;
    notifyListeners();
  }

  void resetToDefault() {
    _primaryColor = const Color.fromRGBO(252, 187, 162, 1.0);
    notifyListeners();
  }
}
