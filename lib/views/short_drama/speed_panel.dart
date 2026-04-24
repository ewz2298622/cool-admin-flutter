import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../style/color_styles.dart';

class SpeedPanel extends StatelessWidget {
  final double currentSpeed;
  final Function(double) onSpeedSelected;

  const SpeedPanel({
    super.key,
    required this.currentSpeed,
    required this.onSpeedSelected,
  });

  static const List<double> speeds = [3.0, 2.0, 1.5, 1.25, 1.0, 0.75];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: const Text(
              '倍速',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...speeds.map((speed) => _buildSpeedItem(context, speed)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedItem(BuildContext context, double speed) {
    final isSelected = speed == currentSpeed;
    final isDefault = speed == 1.0;

    return InkWell(
      onTap: () {
        onSpeedSelected(speed);
        Fluttertoast.showToast(
          msg: '倍数切换为${speed}x',
          toastLength: Toast.LENGTH_SHORT,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    '${speed}x',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color:
                          isSelected
                              ? ColorStyles.colorPrimary
                              : Colors.black87,
                    ),
                  ),
                  if (isDefault)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '(默认)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: ColorStyles.colorPrimary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
