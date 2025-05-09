import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/user.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data != null) {
      _handleError(err, handler);
    }
    return super.onError(err, handler);
  }

  //根据状态码做不同的处理业务
  void _handleError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.response?.statusCode) {
      case 401:
        _handle401(err, handler);
        break;
      case 403:
        Fluttertoast.showToast(
          msg: err.response?.data['message'],
          toastLength: Toast.LENGTH_SHORT,
        );
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
