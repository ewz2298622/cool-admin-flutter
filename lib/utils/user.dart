import 'package:flutter/material.dart';
import 'package:flutter_app/utils/store/user/user.dart';
import 'package:provider/provider.dart';

import '../db/entity/UserEntity.dart';
import '../db/manager/TokenDatabaseHelper.dart';
import '../db/manager/UserDatabaseHelper.dart';
import '../views/login/login.dart';
import 'context_manager.dart';

class User {
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  static final TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
  static UserEntity? userInfoData;
  
  static bool isLogin() {
    try {
      Iterable<UserEntity> user = userDatabaseHelper.list();
      if (user.isEmpty) {
        return false;
      } else {
        userInfoData = user.first as UserEntity?;
        BuildContext? context = ContextManager.getContext() as BuildContext?;
        if (context != null) {
          try {
            context.read<UserState>().updateUserInfoData(userInfoData as UserEntity);
          } catch (e) {
            debugPrint('Failed to update user info in provider: $e');
          }
        }
        return true;
      }
    } catch (error) {
      debugPrint('isLogin error: $error');
      return false;
    }
  }

  static void _modalBottomSheetMenu(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  static bool isUserLoginView(BuildContext context) {
    if (!isLogin()) {
      _modalBottomSheetMenu(context);
      return false;
    } else {
      return true;
    }
  }

  //删除用户信息
  static void deleteUser() {
    try {
      userDatabaseHelper.deleteAll();
      tokenDatabaseHelper.deleteAll();
    } catch (e) {
      debugPrint('deleteUser error: $e');
    }
  }

  //实现一个对手机号脱敏的函数
  static String getPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "";
    }
    if (phoneNumber.length < 7) {
      return phoneNumber;
    }
    return phoneNumber.replaceRange(3, phoneNumber.length - 4, "****");
  }
}