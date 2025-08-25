import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 应用更新工具类
class AppUpdater {
  /// 检查应用更新
  /// [serverVersionUrl] 服务器版本信息API地址
  /// [apkDownloadUrl] APK下载地址
  /// [showUpdateDialog] 是否显示更新对话框
  static Future<void> checkUpdate({
    required String serverVersionUrl,
    required String apkDownloadUrl,
    bool showUpdateDialog = true,
  }) async {
    try {
      // 获取当前应用信息
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // 获取服务器版本信息
      final dio = Dio();
      final response = await dio.get(serverVersionUrl);
      final serverData = response.data;

      // 假设服务器返回JSON格式: {"version": "1.0.1", "description": "更新内容", "forceUpdate": false}
      String latestVersion = serverData['version'];
      String description = serverData['description'] ?? '';
      bool forceUpdate = serverData['forceUpdate'] ?? false;

      // 比较版本 _compareVersions(currentVersion, latestVersion) < 0
      if (_compareVersions(currentVersion, latestVersion) < 0) {
        // 有新版本
        if (showUpdateDialog) {
          _showUpdateDialog(
            context: navigatorKey.currentContext!,
            version: latestVersion,
            description: description,
            forceUpdate: forceUpdate,
            onConfirm: () {
              _downloadAndInstallApk(apkDownloadUrl);
            },
          );
        } else {
          _downloadAndInstallApk(apkDownloadUrl);
        }
      } else {
        if (showUpdateDialog) {
          _showNoUpdateDialog(navigatorKey.currentContext!);
        }
      }
    } catch (e) {
      if (showUpdateDialog) {
        _showErrorDialog(navigatorKey.currentContext!, e.toString());
      }
    }
  }

  /// 比较版本号
  static int _compareVersions(String version1, String version2) {
    List<String> v1 = version1.split('.');
    List<String> v2 = version2.split('.');

    for (int i = 0; i < v1.length; i++) {
      if (v2.length <= i) return 1; // v1 > v2

      int num1 = int.tryParse(v1[i]) ?? 0;
      int num2 = int.tryParse(v2[i]) ?? 0;

      if (num1 > num2) return 1;
      if (num1 < num2) return -1;
    }

    if (v2.length > v1.length) return -1; // v2 > v1

    return 0; // 相等
  }

  /// 下载并安装APK
  static Future<void> _downloadAndInstallApk(String apkUrl) async {
    try {
      // 请求存储权限
      if (!await _requestStoragePermission()) {
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
          // 可以在这里添加下载进度回调
          if (total != -1) {
            double progress = count / total;
            print('下载进度: ${(progress * 100).toStringAsFixed(2)}%');
          }
        },
      );

      // 安装APK
      await _installApk(savePath);
    } catch (e) {
      _showErrorDialog(navigatorKey.currentContext!, e.toString());
    }
  }

  /// 请求存储权限
  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true;
  }

  /// 安装APK
  static Future<void> _installApk(String apkPath) async {
    if (Platform.isAndroid) {
      const methodChannel = MethodChannel('app_updater');
      try {
        await methodChannel.invokeMethod('installApk', {'apkPath': apkPath});
      } on PlatformException catch (e) {
        throw Exception('安装APK失败: ${e.message}');
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
    showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('发现新版本 $version'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(description.isNotEmpty ? description : '优化体验，修复了一些问题'),
                const SizedBox(height: 16),
                const Text('请点击确认开始下载更新'),
              ],
            ),
          ),
          actions:
              forceUpdate
                  ? [
                    TextButton(onPressed: onConfirm, child: const Text('确认更新')),
                  ]
                  : [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      child: const Text('确认更新'),
                    ),
                  ],
        );
      },
    );
  }

  /// 显示无更新对话框
  static void _showNoUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('检查更新'),
          content: const Text('当前已是最新版本'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  /// 显示错误对话框
  static void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('出错啦'),
          content: Text('更新过程中发生错误: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
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
                AppUpdater.checkUpdate(
                  serverVersionUrl: 'https://your-server.com/version.json',
                  apkDownloadUrl: 'https://your-server.com/app-release.apk',
                );
              },
              child: const Text('检查更新'),
            ),
          ],
        ),
      ),
    );
  }
}
