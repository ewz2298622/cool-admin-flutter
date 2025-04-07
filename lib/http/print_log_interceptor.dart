//print_log_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'dioResponse.dart';

class PrintLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint("请求url:${options.uri}");
    debugPrint("请求参数:${options.queryParameters}");
    debugPrint("请求头:${options.headers}");
    debugPrint("请求数据:${options.data}");
    //打印这些数据
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.data =
        DioResponse(code: 200, message: "请求成功啦", data: response.data);
    return super.onResponse(response.data, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint("错误信息:${err.error}");
    return super.onError(err, handler);
  }
}
