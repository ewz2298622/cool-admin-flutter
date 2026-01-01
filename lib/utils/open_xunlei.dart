import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// 打开迅雷应用的工具类
/// 用于通过包名打开迅雷应用并创建下载任务
class OpenXunlei {
  /// 迅雷应用的包名
  static const String androidPackageName = 'com.xunlei.downloadprovider';

  /// 通过包名打开迅雷应用
  ///
  /// [packageName] 应用的包名（Android），默认使用迅雷包名
  ///
  /// 返回是否成功打开应用
  ///
  /// 示例：
  /// ```dart
  /// await OpenXunlei.openAppByPackage();
  /// // 或使用自定义包名
  /// await OpenXunlei.openAppByPackage(packageName: 'com.xunlei.downloadprovider');
  /// ```
  static Future<bool> openAppByPackage({String? packageName}) async {
    if (!Platform.isAndroid) {
      debugPrint('通过包名打开应用仅支持Android平台');
      return false;
    }

    try {
      final pkgName = packageName ?? androidPackageName;
      debugPrint('尝试通过包名打开应用: $pkgName');

      // 使用Android Intent URL Scheme通过包名打开应用
      // 格式: intent://#Intent;package=包名;end
      final intentUrl = 'intent://#Intent;package=$pkgName;end';
      final uri = Uri.parse(intentUrl);

      try {
        if (await canLaunchUrl(uri)) {
          final launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) {
            debugPrint('成功通过包名打开应用: $pkgName');
            return true;
          }
        } else {
          debugPrint('无法通过canLaunchUrl检测Intent URL，尝试直接打开');
          // 即使canLaunchUrl返回false，也尝试直接打开
          final launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) {
            debugPrint('成功通过包名打开应用（直接打开方式）: $pkgName');
            return true;
          }
        }
      } catch (e) {
        debugPrint('通过包名打开应用失败: $e');
      }

      debugPrint('通过包名打开应用失败：应用可能未安装');
      return false;
    } catch (e) {
      debugPrint('通过包名打开应用异常: $e');
      return false;
    }
  }

  /// 通过包名打开迅雷应用并创建下载任务
  ///
  /// [uri] 要下载的URI地址（支持String或Uri类型）
  /// [packageName] 应用的包名，默认使用迅雷包名
  ///
  /// 返回是否成功打开应用
  ///
  /// 示例：
  /// ```dart
  /// await OpenXunlei.openDownloadByPackage('https://example.com/video.m3u8');
  /// await OpenXunlei.openDownloadByPackage(Uri.parse('https://example.com/video.m3u8'));
  /// ```
  static Future<bool> openDownloadByPackage(
    dynamic uri, {
    String? packageName,
  }) async {
    if (!Platform.isAndroid) {
      debugPrint('iOS平台不支持包名方式');
      return false;
    }

    try {
      // 将URI转换为字符串
      final urlString = uri is Uri ? uri.toString() : uri.toString();
      debugPrint('尝试通过包名打开迅雷并创建下载任务');
      debugPrint('原始URI: $urlString');

      // 将URI转码成迅雷链接格式
      final thunderUrl = _buildThunderUrl(urlString);
      debugPrint('迅雷链接格式: $thunderUrl');

      final thunderUri = Uri.parse(thunderUrl);

      try {
        if (await canLaunchUrl(thunderUri)) {
          final launched = await launchUrl(
            thunderUri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) {
            debugPrint('成功通过迅雷链接打开迅雷并创建下载任务');
            return true;
          }
        } else {
          debugPrint('无法通过canLaunchUrl检测迅雷链接，尝试直接打开');
          final launched = await launchUrl(
            thunderUri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) {
            debugPrint('成功通过迅雷链接打开迅雷（直接打开方式）');
            return true;
          }
        }
      } catch (e) {
        debugPrint('通过迅雷链接打开迅雷失败: $e');
      }

      debugPrint('通过迅雷链接打开迅雷失败：应用可能未安装');
      return false;
    } catch (e) {
      debugPrint('通过迅雷链接打开迅雷异常: $e');
      return false;
    }
  }

  /// 将URI转码成迅雷链接格式
  ///
  /// [url] 原始URL地址
  ///
  /// 返回格式化后的迅雷URL（thunder://协议）
  ///
  /// 注意：迅雷协议需要去掉原始URL的http://或https://前缀
  static String _buildThunderUrl(String url) {
    String urlForThunder = 'AA${url}ZZ';
    //将urlForThunder进行base64编码
    String base64Url = base64Encode(utf8.encode(urlForThunder));

    return 'thunder://$base64Url';
  }

  /// 检查应用是否已安装（通过包名）
  ///
  /// [packageName] 应用的包名，默认使用迅雷包名
  ///
  /// 返回应用是否已安装
  ///
  /// 注意：此方法在Android上通过尝试打开应用来判断，不保证100%准确
  static Future<bool> isAppInstalled({String? packageName}) async {
    if (!Platform.isAndroid) {
      debugPrint('检查应用安装状态仅支持Android平台');
      return false;
    }

    try {
      final pkgName = packageName ?? androidPackageName;
      final intentUrl = 'intent://#Intent;package=$pkgName;end';
      final uri = Uri.parse(intentUrl);
      return await canLaunchUrl(uri);
    } catch (e) {
      debugPrint('检查应用安装状态失败: $e');
      return false;
    }
  }
}
