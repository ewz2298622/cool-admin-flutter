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
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
                color: Colors.black,
              ),
            ),
            if (onMorePressed != null) // 判断是否传入更多点击事件
              GestureDetector(
                onTap: onMorePressed,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "更多",
                      style: TextStyle(
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: Color(0xFF666666),
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
