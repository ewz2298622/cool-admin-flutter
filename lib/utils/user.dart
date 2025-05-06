import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../db/entity/UserEntity.dart';
import '../db/manager/UserDatabaseHelper.dart';
import '../views/login/login.dart';

class User {
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  static isLogin() {
    Iterable<UserEntity> user = userDatabaseHelper.list();
    if (user.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static void isUserLoginView(BuildContext context) {
    if (!isLogin()) {
      showGeneralDialog(
        context: context,
        pageBuilder: (
          BuildContext buildContext,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return TDConfirmDialog(
            content: "用户暂未登录",
            action:
                () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  ),
                },
          );
        },
      );
    }
  }
}
