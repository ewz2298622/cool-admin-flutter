import 'package:flutter/cupertino.dart';

class VideoUtil {
  //tag格式化
  static String formatTag(String tag) {
    //如果传进来的格式满足 2018-04-07(韩国) 将日期提取出来
    String date = tag;
    String text = '高清';
    try {
      if (tag.contains("-")) {
        if (tag.contains("(")) {
          date = tag.substring(0, tag.indexOf("("));
        }
        //判断date 举例当前时间差多少天
        if (date.isNotEmpty) {
          DateTime now = DateTime.now();
          DateTime dateTime = DateTime.parse(date);
          int days = now.difference(dateTime).inDays;
          if (days < 30) {
            text = '最新';
          }
        }
      }
    } catch (e) {
      return text;
    }
    return text;
  }

  static int calculateHorizontalCrossAxisCount({
    required BuildContext context,
    required int verticalCrossAxisCount,
    required double crossAxisSpacing,
    required double mainAxisSpacing,
    required double childAspectRatio,
    double? mainAxisExtent,
  }) {
    // 获取竖屏下的屏幕尺寸
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.width < screenSize.height;

    // 确保当前是竖屏状态（否则参数无意义）
    if (!isPortrait) {
      return verticalCrossAxisCount; // 如果已经是横屏，直接返回原值
    }

    // 竖屏下的屏幕宽度
    final portraitWidth = screenSize.width;

    // 计算竖屏下子项的宽度
    final itemWidth =
        (portraitWidth - crossAxisSpacing * (verticalCrossAxisCount - 1)) /
        verticalCrossAxisCount;

    // 横屏下的屏幕宽度
    final landscapeWidth = screenSize.height; // 竖屏的高就是横屏的宽

    // 计算横屏下的 crossAxisCount
    // 公式：newCrossAxisCount = (landscapeWidth + crossAxisSpacing) / (itemWidth + crossAxisSpacing)
    final newCrossAxisCount =
        (landscapeWidth + crossAxisSpacing) / (itemWidth + crossAxisSpacing);

    // 向上取整，确保能容纳所有子项
    return newCrossAxisCount.ceil();
  }
}
