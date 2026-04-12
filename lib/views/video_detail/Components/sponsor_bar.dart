import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 赞助提示栏组件
/// 显示视频免责声明和提示信息
class SponsorBar extends StatelessWidget {
  const SponsorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              TDIcons.sound,
              size: 18,
              color: Color(0xFFD97706),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '本片仅供学习参考，请勿用于商业用途。切勿传播违法信息。视频中的广告不参与本片制作，仅供学习参考。谨防上当受骗',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF92400E),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
