import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:media_kit/media_kit.dart';

import '../../../entity/video_detail_data_entity.dart';
import '../../../store/player/player_state_notifier.dart';
import '../../../utils/video.dart';

class VideoSettingsSheet extends StatefulWidget {
  final Player player;
  final double currentRate;
  final VideoDetailDataData videoInfoData;
  final int currentLine;
  final int currentPlay;
  final int currentVideoFit;
  final Function(int) onVideoFitChanged;
  final List<String> fitModes;
  final List<double> rateList;
  final Function(double) onVideoRateChanged;
  final Function(double) onBrightnessChanged;
  final Function(double) onSkipOpeningChanged;
  final Function(double) onSkipEndingChanged;
  final double currentBrightness;
  final double currentSkipOpening;
  final double currentSkipEnding;
  final double currentVolume;
  final double currentLongPressRate;
  final Function(double) onVolumeChanged;
  final Function(double) onLongPressRateChanged;
  final Listenable playerStateNotifier;

  const VideoSettingsSheet({
    super.key,
    required this.player,
    required this.currentRate,
    required this.videoInfoData,
    required this.currentLine,
    required this.currentPlay,
    required this.currentVideoFit,
    required this.onVideoFitChanged,
    required this.fitModes,
    required this.rateList,
    required this.onVideoRateChanged,
    required this.onBrightnessChanged,
    required this.onSkipOpeningChanged,
    required this.onSkipEndingChanged,
    this.currentBrightness = 1.0,
    this.currentSkipOpening = 0.0,
    this.currentSkipEnding = 0.0,
    this.currentVolume = 1.0,
    this.currentLongPressRate = 2.0,
    required this.onVolumeChanged,
    required this.onLongPressRateChanged,
    required this.playerStateNotifier,
  });

  @override
  State<VideoSettingsSheet> createState() => _VideoSettingsSheetState();
}

class _VideoSettingsSheetState extends State<VideoSettingsSheet> {
  late double _selectedRate;
  double _selectedVolume = 1.0;
  double _selectedBrightness = 1.0;
  int _videoFit = 0;
  double _skipOpening = 0.0;
  double _skipEnding = 0.0;
  double _longPressRate = 2.0;
  bool _isUserInteracting = false;

  final List<double> _longPressRates = [1.25, 1.5, 2.0, 2.5, 3.0];

  @override
  void initState() {
    super.initState();
    _selectedRate = widget.currentRate;
    _selectedVolume = widget.currentVolume;
    _videoFit = widget.currentVideoFit;
    _selectedBrightness = widget.currentBrightness;
    _skipOpening = widget.currentSkipOpening;
    _skipEnding = widget.currentSkipEnding;
    _longPressRate = widget.currentLongPressRate;
  }

  void _setBrightness(double value) {
    setState(() {
      _isUserInteracting = true;
      _selectedBrightness = value;
    });
    widget.onBrightnessChanged(value);
  }

  void _resetToDefaults() {
    setState(() {
      _selectedRate = 1.0;
      _selectedVolume = 1.0;
      _selectedBrightness = 1.0;
      _videoFit = 0;
      _skipOpening = 0.0;
      _skipEnding = 0.0;
      _longPressRate = 2.0;
    });
    widget.player.setRate(1.0);
    widget.player.setVolume(100);
    widget.onVideoRateChanged(1.0);
    widget.onVolumeChanged(1.0);
    widget.onSkipOpeningChanged(0.0);
    widget.onSkipEndingChanged(0.0);
    widget.onLongPressRateChanged(2.0);
    widget.onVideoFitChanged(0);
    _setBrightness(1.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxHeight = screenSize.height * 0.7;

    return ListenableBuilder(
      listenable: widget.playerStateNotifier,
      builder: (context, child) {
        final notifier = widget.playerStateNotifier as PlayerStateNotifier;

        if (!_isUserInteracting) {
          if (_selectedRate != notifier.videoRate) {
            _selectedRate = notifier.videoRate;
          }
          if (_selectedVolume != notifier.volume) {
            _selectedVolume = notifier.volume;
          }
          if (_selectedBrightness != notifier.brightness) {
            _selectedBrightness = notifier.brightness;
          }
          if (_videoFit != notifier.videoFit) {
            _videoFit = notifier.videoFit;
          }
          if (_skipOpening != notifier.skipOpening) {
            _skipOpening = notifier.skipOpening;
          }
          if (_skipEnding != notifier.skipEnding) {
            _skipEnding = notifier.skipEnding;
          }
          if (_longPressRate != notifier.longPressRate) {
            _longPressRate = notifier.longPressRate;
          }
        }

        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 16, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
                  child: Row(
                    children: [
                      const Text(
                        '播放设置',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _resetToDefaults,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            '恢复默认',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                    child: Column(
                      children: [
                        _buildVolumeAndBrightnessRow(),
                        const SizedBox(height: 24),
                        _buildSkipRow(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('倍速播放'),
                        _buildRateSelector(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('画面尺寸'),
                        _buildFitSelector(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('长按加速'),
                        _buildLongPressSelector(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('线路选择'),
                        _buildLineSelector(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVolumeAndBrightnessRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildSliderLabel('音量调节', '${(_selectedVolume * 100).toInt()}%'),
              const SizedBox(height: 12),
              _buildGradientSlider(
                value: _selectedVolume,
                onChanged: (value) {
                  setState(() {
                    _isUserInteracting = true;
                    _selectedVolume = value;
                  });
                  widget.player.setVolume(value * 100);
                  widget.onVolumeChanged(value);
                },
                onChangeEnd: (_) {
                  setState(() => _isUserInteracting = false);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _buildSliderLabel('屏幕亮度', '${(_selectedBrightness * 100).toInt()}%'),
              const SizedBox(height: 12),
              _buildGradientSlider(
                value: _selectedBrightness,
                onChanged: _setBrightness,
                onChangeEnd: (_) {
                  setState(() => _isUserInteracting = false);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkipRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildSliderLabel('跳过片头', VideoUtil.formatDuration(_skipOpening)),
              const SizedBox(height: 12),
              _buildGradientSlider(
                value: _skipOpening,
                min: 0,
                max: 300,
                divisions: 30,
                onChanged: (value) {
                  setState(() {
                    _isUserInteracting = true;
                    _skipOpening = value;
                  });
                  widget.onSkipOpeningChanged(value);
                },
                onChangeEnd: (_) {
                  setState(() => _isUserInteracting = false);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _buildSliderLabel('跳过片尾', VideoUtil.formatDuration(_skipEnding)),
              const SizedBox(height: 12),
              _buildGradientSlider(
                value: _skipEnding,
                min: 0,
                max: 300,
                divisions: 30,
                onChanged: (value) {
                  setState(() {
                    _isUserInteracting = true;
                    _skipEnding = value;
                  });
                  widget.onSkipEndingChanged(value);
                },
                onChangeEnd: (_) {
                  setState(() => _isUserInteracting = false);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRateSelector() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: widget.rateList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final rate = widget.rateList[index];
          final isSelected = (_selectedRate - rate).abs() < 0.01;
          return GestureDetector(
            onTap: () {
              setState(() {
                _isUserInteracting = true;
                _selectedRate = rate;
              });
              widget.player.setRate(rate);
              widget.onVideoRateChanged(rate);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  rate == 1.0 ? '1.0x' : '${rate}x',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFitSelector() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: widget.fitModes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final mode = widget.fitModes[index];
          final isSelected = _videoFit == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _isUserInteracting = true;
                _videoFit = index;
              });
              widget.onVideoFitChanged(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  mode,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLongPressSelector() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: _longPressRates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final rate = _longPressRates[index];
          final isSelected = (_longPressRate - rate).abs() < 0.01;
          return GestureDetector(
            onTap: () {
              setState(() {
                _isUserInteracting = true;
                _longPressRate = rate;
              });
              widget.onLongPressRateChanged(rate);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  '${rate}x',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLineSelector() {
    return GestureDetector(
      onTap: () {
        Fluttertoast.showToast(
          msg: '正在检测线路...',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.network_check, color: Colors.white70, size: 20),
            SizedBox(width: 12),
            Text('卡顿？检测切换线路', style: TextStyle(color: Colors.white70, fontSize: 14)),
            Spacer(),
            Icon(Icons.chevron_right, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildSliderLabel(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildGradientSlider({
    required double value,
    required ValueChanged<double> onChanged,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    double min = 0.0,
    double max = 1.0,
    int? divisions,
  }) {
    return SizedBox(
      height: 24,
      child: SliderTheme(
        data: SliderThemeData(
          activeTrackColor: const Color(0xFFE53935),
          inactiveTrackColor: const Color(0xFF4A4A4A),
          thumbColor: Colors.white,
          overlayColor: Colors.transparent,
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          onChangeStart: onChangeStart,
          onChangeEnd: onChangeEnd,
        ),
      ),
    );
  }
}
