import 'package:permission_handler/permission_handler.dart';

class RequestMultiplePermissions {
  /// 请求多个权限
  static Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.camera,
          Permission.microphone,
          Permission.storage,
          //联系人权限
          Permission.contacts,
          Permission.phone,
          Permission.systemAlertWindow,
          Permission.location,
          Permission.locationAlways,
          Permission.requestInstallPackages,
          // Permission.systemAlertWindow,
        ].request();

    statuses.forEach((permission, status) {
      if (status.isGranted) {
        print('$permission 权限已授予');
      } else {
        print('$permission 权限被拒绝');
      }
    });
  }

  /// 检查多个权限的状态
  static Future<Map<Permission, PermissionStatus>>
  checkPermissionsStatus() async {
    List<Permission> permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.contacts,
      Permission.phone,
      Permission.systemAlertWindow,
      Permission.location,
      Permission.locationAlways,
      Permission.requestInstallPackages,
    ];

    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in permissions) {
      statuses[permission] = await permission.status;
    }

    return statuses;
  }

  /// 检查是否所有权限都被授予
  static Future<bool> checkAllPermissionsGranted() async {
    Map<Permission, PermissionStatus> statuses = await checkPermissionsStatus();
    return statuses.values.every((status) => status.isGranted);
  }

  /// 检查是否有任何权限被拒绝
  static Future<bool> checkAnyPermissionDenied() async {
    Map<Permission, PermissionStatus> statuses = await checkPermissionsStatus();
    return statuses.values.any((status) => status.isDenied);
  }

  //检查某个权限是否被授予
  static Future<bool> checkPermissionGranted(Permission permission) async {
    return (await permission.status).isGranted;
  }
}
