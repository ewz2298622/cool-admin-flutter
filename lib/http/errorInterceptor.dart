import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/context_manager.dart';
import '../utils/user.dart';
import '../views/connection_error/connectionError.dart';

String TAG = "ErrorInterceptor";

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data != null) {
      _handleError(err, handler);
    }
    if (err.type == DioExceptionType.connectionError) {
      Navigator.pushReplacement(
        ContextManager.getNavigatorKey()?.currentState!.context as BuildContext,
        MaterialPageRoute(builder: (context) => ConnectionError()),
      );
    } else if (err.type == DioExceptionType.connectionTimeout) {
      Fluttertoast.showToast(msg: "网络连接超时", toastLength: Toast.LENGTH_SHORT);
    }
    handler.next(err);
    return super.onError(err, handler);
  }

  //根据状态码做不同的处理业务
  void _handleError(DioException err, ErrorInterceptorHandler handler) {
    Fluttertoast.showToast(
      msg: err.response?.data['message'],
      toastLength: Toast.LENGTH_SHORT,
    );
    switch (err.response?.statusCode) {
      case 401:
        _handle401(err, handler);
        break;
      case 403:
      //处理逻辑
    }
  }

  //401处理逻辑
  void _handle401(DioException err, ErrorInterceptorHandler handler) {
    Fluttertoast.showToast(
      msg: err.response?.data['message'],
      toastLength: Toast.LENGTH_SHORT,
    );
    User.deleteUser();
  }
}
