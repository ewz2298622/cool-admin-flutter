import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:protect_app/protect_app.dart';

/// 设备信息工具类
/// 提供设备信息获取、安全检测等功能
class DeviceInfoUtils {
  /// 单例实例
  static final DeviceInfoUtils _instance = DeviceInfoUtils._internal();

  /// 设备信息插件实例
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  /// 保护应用插件实例（单例复用）
  static final ProtectApp _protectApp = ProtectApp();

  /// 设备数据缓存
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  /// 设备信息缓存
  Map<String, dynamic>? deviceInfo;

  /// 未知设备信息常量
  static const String _unknownDevice = 'Unknown';

  /// 私有构造函数
  DeviceInfoUtils._internal();

  /// 单例访问点
  factory DeviceInfoUtils() => _instance;

  /// 获取缓存的设备信息
  Map<String, dynamic>? getDeviceInfo() {
    return deviceInfo;
  }

  /// 请求设备信息
  /// 如果已缓存则直接返回，否则获取并缓存设备信息
  Future<Map<String, dynamic>> requestDeviceInfo() async {
    // 如果已经获取过设备信息，则直接返回
    if (deviceInfo != null) {
      return deviceInfo!;
    }

    try {
      // 开启禁止屏幕截图功能
      await _protectApp.turnOffScreenshots();

      // 并行获取安全检测信息
      final securityInfo = await _getSecurityInfo();

      // 根据平台获取设备信息
      if (Platform.isAndroid) {
        deviceInfo = await _getAndroidDeviceInfo(securityInfo);
      } else if (Platform.isIOS) {
        deviceInfo = await _getIOSDeviceInfo(securityInfo);
      } else {
        deviceInfo = _getUnknownDeviceInfo(securityInfo);
      }

      debugPrint('deviceInfo: $deviceInfo');
      return deviceInfo!;
    } catch (e, stackTrace) {
      debugPrint('获取设备信息失败: $e\n$stackTrace');
      // 返回默认设备信息
      deviceInfo = _getUnknownDeviceInfo({
        'deviceUseVPN': false,
        'isDeviceIsReal': false,
        'isUseJailBrokenOrRoot': false,
        'isRunOnTestFlight': false,
        'checkIsTheDeveloperModeOn': false,
      });
      return deviceInfo!;
    }
  }

  /// 获取安全检测信息
  Future<Map<String, bool>> _getSecurityInfo() async {
    return {
      'deviceUseVPN': await _protectApp.isDeviceUseVPN() ?? false,
      'isDeviceIsReal': await _protectApp.isItRealDevice() ?? false,
      'isUseJailBrokenOrRoot':
          await _protectApp.isUseJailBrokenOrRoot() ?? false,
      'isRunOnTestFlight':
          await _protectApp.isRunningInTestFlight() ?? false,
      'checkIsTheDeveloperModeOn':
          await _protectApp.checkIsTheDeveloperModeOn() ?? false,
    };
  }

  /// 获取Android设备信息
  Future<Map<String, dynamic>> _getAndroidDeviceInfo(
    Map<String, bool> securityInfo,
  ) async {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return {
      'deviceId': androidInfo.id,
      'deviceName': androidInfo.model,
      'deviceBrand': androidInfo.brand,
      'deviceType': Platform.operatingSystem,
      'deviceVersion': androidInfo.version.release,
      'isPhysicalDevice': androidInfo.isPhysicalDevice,
      ...securityInfo,
    };
  }

  /// 获取iOS设备信息
  Future<Map<String, dynamic>> _getIOSDeviceInfo(
    Map<String, bool> securityInfo,
  ) async {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    return {
      'deviceName': iosInfo.name,
      'deviceBrand': iosInfo.utsname.machine,
      'deviceType': Platform.operatingSystem,
      'deviceVersion': iosInfo.systemVersion,
      'isPhysicalDevice': iosInfo.isPhysicalDevice,
      ...securityInfo,
    };
  }

  /// 获取未知平台设备信息
  Map<String, dynamic> _getUnknownDeviceInfo(Map<String, bool> securityInfo) {
    return {
      'deviceName': _unknownDevice,
      'deviceBrand': _unknownDevice,
      'deviceType': Platform.operatingSystem,
      'deviceVersion': _unknownDevice,
      ...securityInfo,
    };
  }

  /// 初始化平台状态
  /// 获取平台相关的详细设备信息
  Future<void> initPlatformState() async {
    try {
      if (kIsWeb) {
        _deviceData = _readWebBrowserInfo(
          await deviceInfoPlugin.webBrowserInfo,
        );
      } else {
        _deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android => _readAndroidBuildData(
            await deviceInfoPlugin.androidInfo,
          ),
          TargetPlatform.iOS => _readIosDeviceInfo(
            await deviceInfoPlugin.iosInfo,
          ),
          TargetPlatform.linux => _readLinuxDeviceInfo(
            await deviceInfoPlugin.linuxInfo,
          ),
          TargetPlatform.windows => _readWindowsDeviceInfo(
            await deviceInfoPlugin.windowsInfo,
          ),
          TargetPlatform.macOS => _readMacOsDeviceInfo(
            await deviceInfoPlugin.macOsInfo,
          ),
          TargetPlatform.fuchsia => <String, dynamic>{
            'Error': 'Fuchsia platform is not supported',
          },
        };
      }
    } on PlatformException catch (e, stackTrace) {
      debugPrint('获取平台信息失败: $e\n$stackTrace');
      _deviceData = <String, dynamic>{
        'Error': 'Failed to get platform version',
      };
    }
  }

  /// 读取Android构建数据
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'name': build.name,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
      'physicalRamSize': build.physicalRamSize,
      'availableRamSize': build.availableRamSize,
    };
  }

  /// 读取iOS设备信息
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'modelName': data.modelName,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'isiOSAppOnMac': data.isiOSAppOnMac,
      'physicalRamSize': data.physicalRamSize,
      'availableRamSize': data.availableRamSize,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  /// 读取Linux设备信息
  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  /// 读取Web浏览器信息
  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  /// 读取macOS设备信息
  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'modelName': data.modelName,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  /// 读取Windows设备信息
  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }
}
