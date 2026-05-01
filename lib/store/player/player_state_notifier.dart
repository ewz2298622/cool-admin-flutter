import 'package:flutter/material.dart';

class PlayerStateNotifier extends ChangeNotifier {
  double _videoRate = 1.0;
  int _videoFit = 0;
  double _volume = 1.0;
  double _brightness = 1.0;
  double _skipOpening = 0.0;
  double _skipEnding = 0.0;

  double get videoRate => _videoRate;
  int get videoFit => _videoFit;
  double get volume => _volume;
  double get brightness => _brightness;
  double get skipOpening => _skipOpening;
  double get skipEnding => _skipEnding;

  void setVideoRate(double rate) {
    _videoRate = rate;
    notifyListeners();
  }

  void setVideoFit(int fit) {
    _videoFit = fit;
    notifyListeners();
  }

  void setVolume(double volume) {
    _volume = volume;
    notifyListeners();
  }

  void setBrightness(double brightness) {
    _brightness = brightness;
    notifyListeners();
  }

  void setSkipOpening(double seconds) {
    _skipOpening = seconds;
    notifyListeners();
  }

  void setSkipEnding(double seconds) {
    _skipEnding = seconds;
    notifyListeners();
  }

  void resetToDefaults() {
    _videoRate = 1.0;
    _videoFit = 0;
    _volume = 1.0;
    _brightness = 1.0;
    _skipOpening = 0.0;
    _skipEnding = 0.0;
    notifyListeners();
  }
}
