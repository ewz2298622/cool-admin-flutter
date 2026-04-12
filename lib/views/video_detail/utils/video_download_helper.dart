import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../entity/video_detail_data_entity.dart';

/// 视频下载助手类
/// 负责处理视频下载相关的业务逻辑
class VideoDownloadHelper {
  /// 下载视频
  /// 
  /// [videoInfoData] 视频详情数据
  /// [currentLine] 当前线路索引
  /// [currentPlay] 当前播放集数索引
  static Future<void> downloadVideo({
    required VideoDetailDataData videoInfoData,
    required int currentLine,
    required int currentPlay,
  }) async {
    try {
      final selectedLine = videoInfoData.lines?[currentLine];
      if (selectedLine?.playLines != null &&
          currentPlay < (selectedLine?.playLines?.length ?? 0)) {
        final selectedPlayLine = selectedLine?.playLines?[currentPlay];
        
        // 将视频链接复制到剪贴板
        await Clipboard.setData(
          ClipboardData(text: selectedPlayLine?.file ?? ""),
        );
        
        // 显示提示信息
        await Fluttertoast.showToast(
          msg: "请打开迅雷 app",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      debugPrint('videoDownload 下载失败：$e');
    }
  }
}
