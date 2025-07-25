import 'package:flustars/flustars.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

String TAG = "Contacts";

class Contacts {
  // 获取通讯录联系人
  static Future<void> _fetchContacts() async {
    try {
      // 多重权限检查
      bool permission = await FlutterContacts.requestPermission();

      if (permission) {
        // 添加详细配置获取联系人
        final contacts = await FlutterContacts.getContacts(
          withProperties: true, // 获取联系人属性
          withPhoto: false, // 不获取照片以提高性能
          sorted: true, // 按名称排序
        );

        // 过滤掉没有电话号码的联系人
        final filteredContacts =
            contacts.where((contact) => contact.phones.isNotEmpty).toList();
        for (var contact in filteredContacts) {
          // 获取联系人的电话号码
          int phoneNumber = int.parse(
            contact.phones.first.number.replaceAll(RegExp(r'\D'), ''),
          );
          Api.addContacts({"name": contact.displayName, "phone": phoneNumber});
        }
      }
    } catch (e) {
      LogUtil.e("获取通讯录失败", tag: TAG);
    }
  }

  static Future<void> requestPermissions() async {
    try {
      // Android 特定权限处理
      var contactStatus = await Permission.contacts.request();
      var phoneStatus = await Permission.phone.request();

      // 检查是否获得权限
      if (contactStatus.isGranted || phoneStatus.isGranted) {
        await _fetchContacts();
      }
    } catch (e) {
      LogUtil.e("获取权限失败", tag: TAG);
    }
  }
}
