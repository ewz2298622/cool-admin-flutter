import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// 剧情简介组件
/// 展示视频的剧情介绍内容
class PlotSection extends StatelessWidget {
  final String? introduce;

  const PlotSection({
    super.key,
    this.introduce,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '剧情',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
            height: 1.4,
          ),
        ),
        SizedBox(height: 12),
        Html(
          data: introduce ?? "",
          style: {
            "body": Style(
              color: Color(0xFF4B5563),
              backgroundColor: Colors.transparent,
              fontSize: FontSize(15),
              lineHeight: LineHeight(1.6),
            ),
            "p": Style(
              color: Color(0xFF4B5563),
              backgroundColor: Colors.transparent,
              fontSize: FontSize(15),
              lineHeight: LineHeight(1.6),
              margin: Margins.only(bottom: 8),
            ),
            "span": Style(
              color: Color(0xFF4B5563),
              backgroundColor: Colors.transparent,
              fontSize: FontSize(15),
              lineHeight: LineHeight(1.6),
            ),
          },
        ),
      ],
    );
  }
}
