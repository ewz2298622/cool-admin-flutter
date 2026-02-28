import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/requestMultiplePermissions.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api.dart';
import 'context_manager.dart';

/// 应用更新工具类
class AppUpdater {
  /// 检查应用更新
  ///
  /// [showNoUpdateDialog] 可选参数，默认为 false
  /// - false: 没有新版本时不执行任何操作（不显示对话框）
  /// - true: 没有新版本时显示"当前已是最新版本"对话框
  static Future<void> checkUpdate({bool showNoUpdateDialog = false}) async {
    try {
      // 获取当前应用信息
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      final response = await Api.noticeInfo({
        "page": 1,
        "size": 1,
        "type": 636,
        "status": 1,
      });

      final noticeInfoData = response.data?.list ?? [];

      // 检查是否有更新数据
      if (noticeInfoData.isEmpty) {
        debugPrint('没有获取到更新信息');
        return;
      }

      // 假设服务器返回JSON格式: {"title": "版本更新通知", "content": "本次更新优化了性能并修复了已知问题...", "type": 1, "summary": "v2.0.0 版本更新公告", "status": 1, "appVersion": "2.0.0", "appUrl": "https://example.com/app/download"}
      String latestVersion = noticeInfoData[0].appVersion ?? '';
      String description = noticeInfoData[0].summary ?? '';
      String downloadUrl = noticeInfoData[0].appUrl ?? '';

      // 比较版本
      debugPrint('AppUpdater currentVersion: $currentVersion');
      debugPrint('AppUpdater latestVersion: $latestVersion');

      if (latestVersion.isEmpty) {
        debugPrint('没有新版本信息');
        return;
      }

      // 获取 context，如果为 null 则使用 navigatorKey
      BuildContext? context = ContextManager.getContext();
      if (context == null) {
        final navigatorKey = ContextManager.getNavigatorKey();
        context = navigatorKey?.currentContext;
      }

      if (context == null) {
        debugPrint('无法获取 context，无法显示更新对话框');
        return;
      }

      // 比较版本号（支持 "1.0.0" 格式）
      if (_compareVersions(currentVersion, latestVersion) < 0) {
        debugPrint('有新版本');
        // 有新版本
        _showUpdateDialog(
          context: context,
          version: latestVersion,
          description: description,
          forceUpdate: false, // 固定为false
          onConfirm: () {
            _downloadAndInstallApk(downloadUrl);
          },
        );
      } else {
        debugPrint('没有新版本');
        // 只有当 showNoUpdateDialog 为 true 时才显示"没有新版本"对话框
        if (showNoUpdateDialog) {
          _showNoUpdateDialog(context);
        }
      }
    } catch (e) {
      debugPrint('请求新版本失败: $e');
      // 获取 context 用于显示错误对话框
      BuildContext? context = ContextManager.getContext();
      if (context == null) {
        final navigatorKey = ContextManager.getNavigatorKey();
        context = navigatorKey?.currentContext;
      }
      if (context != null) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  /// 比较版本号
  /// 返回: -1 表示 version1 < version2, 0 表示相等, 1 表示 version1 > version2
  static int _compareVersions(String version1, String version2) {
    try {
      // 移除可能的 "v" 前缀
      version1 = version1.replaceAll(RegExp(r'^v'), '');
      version2 = version2.replaceAll(RegExp(r'^v'), '');

      // 尝试直接解析为数字（如 "1.0"）
      try {
        double v1 = double.parse(version1);
        double v2 = double.parse(version2);
        if (v1 < v2) return -1;
        if (v1 > v2) return 1;
        return 0;
      } catch (e) {
        // 如果不是纯数字，则按点分割比较
        List<int> v1Parts =
            version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
        List<int> v2Parts =
            version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

        int maxLength =
            v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;

        // 补齐长度
        while (v1Parts.length < maxLength) v1Parts.add(0);
        while (v2Parts.length < maxLength) v2Parts.add(0);

        for (int i = 0; i < maxLength; i++) {
          if (v1Parts[i] < v2Parts[i]) return -1;
          if (v1Parts[i] > v2Parts[i]) return 1;
        }
        return 0;
      }
    } catch (e) {
      debugPrint('版本号比较失败: $e');
      return 0;
    }
  }

  /// 下载并安装APK
  static Future<void> _downloadAndInstallApk(String apkUrl) async {
    try {
      //如果apkUrl 不是以.apk结尾的 就直接跳转到系统浏览器打开url 使用url_launcher
      if (!apkUrl.endsWith('.apk')) {
        await launchUrl(Uri.parse(apkUrl));
        return;
      }
      // 请求存储权限
      if (!await RequestMultiplePermissions.checkPermissionGranted(
        Permission.storage,
      )) {
        throw Exception('存储权限被拒绝');
      }

      // 获取下载目录
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      String savePath = '${directory!.path}/app_update.apk';

      // 下载文件
      final dio = Dio();
      await dio.download(
        apkUrl,
        savePath,
        onReceiveProgress: (count, total) {
          debugPrint('下载进度: ${(count / total * 100).toStringAsFixed(2)}%');
        },
      );

      // 安装APK
      await _installApk(savePath);
    } catch (e) {
      _showErrorDialog(navigatorKey.currentContext!, e.toString());
    }
  }

  /// 安装APK
  static Future<void> _installApk(String apkPath) async {
    if (Platform.isAndroid) {
      try {
        final result = await OpenFile.open(
          apkPath,
          type: 'application/vnd.android.package-archive',
        );
        print('安装成功 path $apkPath: ${result.message}');
      } catch (e) {
        print('安装失败 path $apkPath: $e');
      }
    }
  }

  /// 显示更新对话框
  static void _showUpdateDialog({
    required BuildContext context,
    required String version,
    required String description,
    required bool forceUpdate,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '发现新版本 $version',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description.isNotEmpty ? description : '优化体验，修复了一些问题',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '请点击确认开始下载更新',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                if (!forceUpdate)
                  TDButton(
                    text: '稍后再说',
                    isBlock: true,
                    size: TDButtonSize.large,
                    theme: TDButtonTheme.defaultTheme,
                    type: TDButtonType.outline,
                    onTap: () => Navigator.of(dialogContext).pop(),
                    style: TDButtonStyle(
                      textColor: theme.primaryColor,
                      radius: BorderRadius.circular(20),
                    ),
                  ),
                if (!forceUpdate) const SizedBox(height: 12),
                TDButton(
                  text: '立即更新',
                  isBlock: true,
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    onConfirm();
                  },
                  style: TDButtonStyle(
                    backgroundColor: const Color.fromRGBO(255, 95, 1, 1),
                    textColor: Colors.white,
                    radius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示无更新对话框
  static void _showNoUpdateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '检查更新',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Text(
                  '当前已是最新版本',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 24),
                TDButton(
                  text: '确定',
                  isBlock: true,
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: () => Navigator.of(dialogContext).pop(),
                  style: TDButtonStyle(
                    backgroundColor: const Color.fromRGBO(255, 95, 1, 1),
                    textColor: Colors.white,
                    radius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示错误对话框
  static void _showErrorDialog(BuildContext context, String error) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '出错啦',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  '更新过程中发生错误',
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 24),
                TDButton(
                  text: '确定',
                  isBlock: true,
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: () => Navigator.of(dialogContext).pop(),
                  style: TDButtonStyle(
                    backgroundColor: const Color.fromRGBO(255, 95, 1, 1),
                    textColor: Colors.white,
                    radius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 全局导航键
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App更新示例',
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App更新示例')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('点击下方按钮检查更新'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AppUpdater.checkUpdate();
              },
              child: const Text('检查更新'),
            ),
          ],
        ),
      ),
    );
  }
}
