import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:media_kit/media_kit.dart';

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

  static String extractPlainText(String html) {
    final document = parse(html); // 解析 HTML
    return document.body?.text ?? ''; // 提取纯文本（自动忽略所有标签）
  }

  static String formatScore(int? number) {
    if (number == null) {
      return "0.0";
    }
    if (number == 0) return "0.0";

    int magnitude = 0;
    double temp = number.toDouble();

    // 计算数量级，使得 temp 在 1.0 到 10.0 之间
    while (temp >= 10.0) {
      temp /= 10.0;
      magnitude++;
    }

    while (temp < 1.0) {
      temp *= 10.0;
      magnitude--;
    }

    // 保留一位小数
    double compressed = double.parse(temp.toStringAsFixed(1));

    // 如果因为四舍五入导致个位数超过10，调整一下（例如 9.99 -> 10.0）
    if (compressed >= 10.0) {
      compressed /= 10.0;
      magnitude++;
    }
    //将compressed转化成字符串
    String compressedString = compressed.toString();
    //返回三位长度的字符串
    if (compressedString.length > 3) {
      compressedString = compressedString.substring(0, 3);
    }
    return compressedString;
  }

  //实现一个格式化日期的函数将 00:10:00 转化成 00:10的格式
  static String formatTime(String timeStr) {
    // 分割时间字符串
    List<String> parts = timeStr.split(':');

    // 确保时间格式正确
    if (parts.length < 2) return timeStr;

    // 如果只有两部分，直接返回
    if (parts.length == 2) return timeStr;

    // 取前两部分（小时和分钟）
    return '${parts[0]}:${parts[1]}';
  }

  static int formatTimeToSeconds(String timeStr) {
    // 移除毫秒部分（点号后面的部分）
    String timeWithoutMilliseconds = timeStr.split('.')[0];
  
    // 按冒号分割时间字符串
    List<String> timeParts = timeWithoutMilliseconds.split(':');
  
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
  
    // 根据时间格式处理（可能为 HH:mm:ss 或 mm:ss）
    if (timeParts.length == 3) {
      // 格式为 HH:mm:ss
      hours = int.parse(timeParts[0]);
      minutes = int.parse(timeParts[1]);
      seconds = int.parse(timeParts[2]);
    } else if (timeParts.length == 2) {
      // 格式为 mm:ss
      minutes = int.parse(timeParts[0]);
      seconds = int.parse(timeParts[1]);
    } else if (timeParts.length == 1) {
      // 格式为 ss
      seconds = int.parse(timeParts[0]);
    }
  
    // 计算总秒数
    return hours * 3600 + minutes * 60 + seconds;
  }

  static String formatDuration(double seconds) {
    final hours = (seconds / 3600).floor();
    final mins = ((seconds % 3600) / 60).floor();
    final secs = (seconds % 60).floor();
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  static PlayerConfiguration getConfig() {
    return const PlayerConfiguration(
      // ————————————————————————————
      // 【1】解决 90% 卡顿的核心参数
      // ————————————————————————————
      bufferSize: 128 * 1024 * 1024, // 放大缓冲 → 不卡
      async: true, // 异步加载 → 不卡UI
      vo: 'null', // 自动最佳渲染 → 不掉帧
      // ————————————————————————————
      // 【2】关闭所有耗性能功能
      // ————————————————————————————
      libass: false, // 关闭复杂字幕 → 大幅提升流畅度
      osc: false, // 关闭屏幕控制器 → 省性能
      pitch: false, // 关闭音调修正 → 省性能
      // ————————————————————————————
      // 【3】网络协议完整支持
      // ————————————————————————————
      protocolWhitelist: [
        'udp',
        'rtp',
        'tcp',
        'tls',
        'http',
        'https',
        'crypto',
        'file',
      ],

      // ————————————————————————————
      // 【4】基础设置
      // ————————————————————————————
      muted: false,
      title: 'VideoPlayer',
      logLevel: MPVLogLevel.error,
    );
  }
}
