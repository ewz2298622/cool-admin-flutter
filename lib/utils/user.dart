import 'package:flutter/material.dart';
import 'package:flutter_app/utils/store/user/user.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../db/entity/TokenEntity.dart';
import '../db/entity/UserEntity.dart';
import '../db/manager/token_database_helper.dart';
import '../db/manager/user_database_helper.dart';
import '../entity/login_entity.dart';
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
            context.read<UserState>().updateUserInfoData(
              userInfoData as UserEntity,
            );
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
    Get.toNamed("/login");
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

  //刷新refreshToken
  static refreshToken() async {
    TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
    TokenEntity? token = tokenDatabaseHelper.getLatest();
    LoginData? response =
        (await Api.refreshToken({
          "refreshToken": token?.refreshToken ?? '',
        })).data;
    tokenDatabaseHelper.deleteAll();
    if (response != null) {
      tokenDatabaseHelper.insert(
        TokenEntity(
          expire: response.expire,
          token: response.token,
          refreshExpire: response.refreshExpire,
          refreshToken: response.refreshToken,
        ),
      );
    } else {
      deleteUser();
    }
  }
}
