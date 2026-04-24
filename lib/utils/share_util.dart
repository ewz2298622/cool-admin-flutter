import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtil {
  static String? _cachedImagePath;

  // 预先将分享图片复制到应用沙箱中
  static Future<void> prepareShareImage() async {
    try {
      final directory = await getTemporaryDirectory();
      final targetDir = Directory('${directory.path}/images');
      
      // 创建父目录（如果不存在）
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
      
      final fileName = 'share_banner.png';
      final targetPath = '${directory.path}/images/$fileName';
      final byteData = await rootBundle.load('assets/images/share_banner.png');
      final file = File(targetPath)
        ..writeAsBytesSync(byteData.buffer.asUint8List());
      
      _cachedImagePath = targetPath;
    } catch (e) {
      print('Prepare share image failed: $e');
      _cachedImagePath = null;
    }
  }

  // 执行分享逻辑
  static Future<void> shareImage() async {
    if (_cachedImagePath == null) {
      // 如果没有预先准备，尝试重新准备
      await prepareShareImage();
    }
    
    if (_cachedImagePath != null && await File(_cachedImagePath!).exists()) {
      final files = [
        XFile(_cachedImagePath!),
      ];
      
      SharePlus.instance.share(
        ShareParams(
          files: files,
          text: '附带描述文本',
          subject: '分享标题',
          title: '分享',
        ),
      );
    } else {
      throw Exception('分享图片不存在');
    }
  }
}