import 'dart:async';

import 'package:dlna_dart/dlna.dart';
import 'package:dlna_dart/xmlParser.dart';
import 'package:flutter/material.dart';

/// 投屏管理类
class CastScreenManager {
  /// 设备列表
  List<dynamic> deviceList = [];

  /// DLNA管理器
  DLNAManager? _dlnaManager;

  /// 流订阅
  StreamSubscription? _deviceSubscription;

  /// 状态更新回调
  Function(List<dynamic>)? onDeviceListUpdate;

  /// 开始搜索设备
  Future<void> startSearchDevices() async {
    // 清空设备列表
    deviceList.clear();

    // 通知UI更新
    onDeviceListUpdate?.call(deviceList);

    // 如果已有活动的管理器，先停止它
    await stopSearchDevices();

    try {
      // 创建DLNA管理器
      _dlnaManager = DLNAManager();
      final manager = await _dlnaManager?.start();
      
      if (manager != null) {
        // 监听设备列表变化
        _deviceSubscription?.cancel();
        _deviceSubscription = manager.devices.stream.listen((dataList) {
          for (var entry in dataList.entries) {
            final key = entry.key;
            final value = entry.value;

            //打印key value
            debugPrint('startSearchDevices  key: $key, value: $value');

            // 检查设备是否已存在
            bool isAlreadyAdded = false;
            for (var element in deviceList) {
              if (element['key'] == key) {
                isAlreadyAdded = true;
                break;
              }
            }

            // 添加新设备
            if (!isAlreadyAdded) {
              Map<String, dynamic> data = {'key': key, 'value': value};
              deviceList.add(data);
            }
          }

          // 通知UI更新设备列表
          try {
            onDeviceListUpdate?.call(deviceList);
          } catch (e) {
            debugPrint('Error calling onDeviceListUpdate: $e');
          }
        }, onError: (error) {
          debugPrint('Device stream error: $error');
        });
      }
    } catch (e) {
      debugPrint('搜索投屏设备失败: $e');
    }
  }

  /// 停止搜索设备
  Future<void> stopSearchDevices() async {
    _deviceSubscription?.cancel();
    _dlnaManager?.stop();
    deviceList.clear();
  }

  /// 向指定设备投屏
  Future<void> castToDevice(dynamic device, String url, String title) async {
    try {
      if (device != null && device['value'] != null) {
        await device['value'].setUrl(url, title: title, type: PlayType.Video);
      }
    } catch (e) {
      debugPrint('投屏失败: $e');
    }
  }

  /// 释放资源
  void dispose() {
    _deviceSubscription?.cancel();
    _dlnaManager?.stop();
    deviceList.clear();
  }
}