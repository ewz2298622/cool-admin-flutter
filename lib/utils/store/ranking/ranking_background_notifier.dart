import 'package:flutter/foundation.dart';

class RankingBackgroundNotifier extends ChangeNotifier {
  int _backgroundIndex = 0;

  int get backgroundIndex => _backgroundIndex;

  void updateBackgroundIndex(int newIndex) {
    if (_backgroundIndex != newIndex) {
      _backgroundIndex = newIndex;
      notifyListeners();
    }
  }

  void reset() {
    _backgroundIndex = 0;
    notifyListeners();
  }
}