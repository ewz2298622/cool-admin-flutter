import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/context_manager.dart';
import '../utils/user.dart';
import '../views/connection_error/connection_error.dart';

String TAG = "ErrorInterceptor";

class ErrorInterceptor extends InterceptorsWrapper {
  static DateTime? _lastToastTime;
  static String? _lastToastMessage;
  static const Duration _toastCooldown = Duration(seconds: 2);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data != null) {
      _handleError(err, handler);
    }
    if (err.type == DioExceptionType.connectionError) {
      Get.offAll(() => ConnectionError());
    } else if (err.type == DioExceptionType.connectionTimeout) {
      _showToast("网络连接超时");
    }
    return handler.next(err);
  }

  //根据状态码做不同的处理业务
  void _handleError(DioException err, ErrorInterceptorHandler handler) {
    _showToast(_extractMessage(err.response?.data));
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
    _showToast(_extractMessage(err.response?.data));
    User.deleteUser();
  }

  void _showToast(String? message) {
    final text = message?.trim();
    if (text == null || text.isEmpty) {
      return;
    }
    final now = DateTime.now();
    if (_lastToastMessage == text &&
        _lastToastTime != null &&
        now.difference(_lastToastTime!) < _toastCooldown) {
      return;
    }
    _lastToastMessage = text;
    _lastToastTime = now;
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String) {
        return message;
      }
    }
    if (data is String) {
      return data;
    }
    return null;
  }
}
