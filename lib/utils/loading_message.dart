//实现一个弹出层
import 'package:flutter/material.dart';

import '../components/loading.dart';

class LoadingMessage {
  static showLoading({required BuildContext context}) {
    showDialog<Null>(
      context: context,
      barrierColor: Colors.transparent,
      //背景色透明
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          //透明
          backgroundColor: Colors.transparent,
          //不要遮罩
          elevation: 0,
          content: PageLoading(),
        );
      },
    );
  }
}
