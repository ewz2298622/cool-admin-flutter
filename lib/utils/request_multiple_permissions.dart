import 'package:permission_handler/permission_handler.dart';

import '../api/api.dart';

class RequestMultiplePermissions {
  /// 请求多个权限
  static Future<void> requestPermissions(Permission permission) async {
    Map<Permission, PermissionStatus> statuses = await [permission].request();

    statuses.forEach((permission, status) async {
      if (status.isGranted) {
        await Api.addScore({"businessType": 3, "businessId": 0});
      } else {
        print('$permission 权限被拒绝');
      }
    });
  }

  /// 检查多个权限的状态
  static Future<Map<Permission, PermissionStatus>> checkPermissionsStatus(
    Permission permission,
  ) async {
    List<Permission> permissions = [permission];

    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in permissions) {
      statuses[permission] = await permission.status;
    }

    return statuses;
  }

  //检查某个权限是否被授予
  static Future<bool> checkPermissionGranted(Permission permission) async {
    return (await permission.status).isGranted;
  }
}
