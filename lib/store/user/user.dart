import 'package:flutter/material.dart';

import '../../db/entity/UserEntity.dart';
import '../../utils/bus/bus.dart';
import '../../utils/bus/constant.dart';

class UserState extends ChangeNotifier {
  UserEntity? _userInfoData;

  UserEntity? get userInfoData => _userInfoData;

  updateUserInfoData(UserEntity userInfoData) {
    _userInfoData = userInfoData;
    notifyListeners();
    eventBus.fire(RefreshViewEvent());
  }

  //刪除
  deleteUserInfoData() {
    _userInfoData = null;
    notifyListeners();
  }
}
