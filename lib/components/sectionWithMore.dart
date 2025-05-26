import 'package:flutter/material.dart';

class SectionWithMore extends StatelessWidget {
  final String title; // 标题
  final VoidCallback? onMorePressed; // 更多点击事件（可选）

  const SectionWithMore({super.key, required this.title, this.onMorePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (onMorePressed != null) // 判断是否传入更多点击事件
              GestureDetector(
                onTap: onMorePressed,
                child: Row(
                  children: [
                    Text(
                      "更多",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(162, 162, 162, 1),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color.fromRGBO(203, 203, 203, 1),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
