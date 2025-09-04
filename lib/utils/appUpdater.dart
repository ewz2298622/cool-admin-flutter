import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/requestMultiplePermissions.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/api.dart';
import '../entity/notice_Info_entity.dart';
import 'context_manager.dart';

/// 应用更新工具类
class AppUpdater {
  /// 检查应用更新
  static Future<void> checkUpdate() async {
    try {
      // 获取当前应用信息
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      List<NoticeInfoDataList> noticeInfoData =
          (await Api.noticeInfo({"page": 1, "size": 1, "type": 636})).data?.list
              as List<NoticeInfoDataList>;

      // 假设服务器返回JSON格式: {"title": "版本更新通知", "content": "本次更新优化了性能并修复了已知问题...", "type": 1, "summary": "v2.0.0 版本更新公告", "status": 1, "appVersion": "2.0.0", "appUrl": "https://example.com/app/download"}
      String latestVersion = noticeInfoData[0].appVersion ?? '';
      String description = noticeInfoData[0].summary ?? '';
      String downloadUrl = noticeInfoData[0].appUrl ?? '';

      // 比较版本 _compareVersions(currentVersion, latestVersion) < 0
      if (currentVersion != latestVersion) {
        debugPrint('有新版本');
        // 有新版本
        _showUpdateDialog(
          context: ContextManager.getContext() as BuildContext,
          version: latestVersion,
          description: description,
          forceUpdate: false, // 固定为false
          onConfirm: () {
            _downloadAndInstallApk(downloadUrl);
          },
        );
      } else {
        debugPrint('没有新版本');
        _showNoUpdateDialog(ContextManager.getContext() as BuildContext);
      }
    } catch (e) {
      _showErrorDialog(
        ContextManager.getContext() as BuildContext,
        e.toString(),
      );
    }
  }

  /// 下载并安装APK
  static Future<void> _downloadAndInstallApk(String apkUrl) async {
    try {
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
