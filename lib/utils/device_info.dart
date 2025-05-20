import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtils {
  // 添加单例实例
  static final DeviceInfoUtils _instance = DeviceInfoUtils._internal();
  // 添加数据缓存字段
  Map<String, dynamic> deviceInfo = {};

  // 私有构造函数
  DeviceInfoUtils._internal();

  // 单例访问点
  factory DeviceInfoUtils() => _instance;

  Map<String, dynamic>? getDeviceInfo() {
    return deviceInfo;
  }

  Future<Map<String, dynamic>> requestDeviceInfo() async {
    //判断平台
    if (Platform.isAndroid) {
      // 获取Android设备信息
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      // 添加deviceInfo
      deviceInfo = {
        "deviceName": androidInfo.model,
        "deviceBrand": androidInfo.brand,
        "deviceType": Platform.operatingSystem,
        "deviceVersion": androidInfo.version.release,
      };
    } else if (Platform.isIOS) {
      // 获取iOS设备信息
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      deviceInfo = {
        "deviceName": iosInfo.name,
        "deviceBrand": iosInfo.utsname.machine,
        "deviceType": Platform.operatingSystem,
        "deviceVersion": iosInfo.systemVersion,
      };
    }

    return deviceInfo;
  }
}
