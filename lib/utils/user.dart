import 'package:flutter/material.dart';

import '../db/entity/UserEntity.dart';
import '../db/manager/UserDatabaseHelper.dart';
import '../views/login/login.dart';

class User {
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  static isLogin() {
    try {
      Iterable<UserEntity> user = userDatabaseHelper.list();
      if (user.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  static void _modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      //设置标题
      isScrollControlled: true,
      //设置高度
      builder: (builder) {
        return Login(parentContext: context);
      },
    );
  }

  static bool isUserLoginView(BuildContext context) {
    if (!isLogin()) {
      _modalBottomSheetMenu(context);
      return false;
    } else {
      return true;
    }
  }
}
