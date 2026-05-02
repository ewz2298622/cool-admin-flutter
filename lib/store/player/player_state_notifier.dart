import 'package:flutter/material.dart';

class PlayerStateNotifier extends ChangeNotifier {
  double _videoRate = 1.0;
  int _videoFit = 0;
  double _volume = 1.0;
  double _brightness = 1.0;
  double _skipOpening = 0.0;
  double _skipEnding = 0.0;
  double _longPressRate = 2.0;

  double get videoRate => _videoRate;
  int get videoFit => _videoFit;
  double get volume => _volume;
  double get brightness => _brightness;
  double get skipOpening => _skipOpening;
  double get skipEnding => _skipEnding;
  double get longPressRate => _longPressRate;

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

  void setLongPressRate(double rate) {
    _longPressRate = rate;
    notifyListeners();
  }

  void resetToDefaults() {
    _videoRate = 1.0;
    _videoFit = 0;
    _volume = 1.0;
    _brightness = 1.0;
    _skipOpening = 0.0;
    _skipEnding = 0.0;
    _longPressRate = 2.0;
    notifyListeners();
  }

  void applySettings({
    double? videoRate,
    int? videoFit,
    double? volume,
    double? brightness,
    double? skipOpening,
    double? skipEnding,
    double? longPressRate,
  }) {
    if (videoRate != null) _videoRate = videoRate;
    if (videoFit != null) _videoFit = videoFit;
    if (volume != null) _volume = volume;
    if (brightness != null) _brightness = brightness;
    if (skipOpening != null) _skipOpening = skipOpening;
    if (skipEnding != null) _skipEnding = skipEnding;
    if (longPressRate != null) _longPressRate = longPressRate;
    notifyListeners();
  }
}
