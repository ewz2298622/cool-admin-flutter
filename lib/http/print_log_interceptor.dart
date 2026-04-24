// H:/video/flutter/flutter_app/lib/http/print_log_interceptor.dart

//print_log_interceptor.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';

import '../ads/config.dart';

String TAG = "RequestLog";

class PrintLogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 在生产环境中不打印日志
    if (IS_PRODUCTION) {
      return handler.next(options);
    }

    TAG = options.path;
    LogUtil.e("请求路径:${options.path}", tag: TAG);
    LogUtil.e("请求方法:${options.method}", tag: TAG);
    LogUtil.e("请求时间:${options.receiveTimeout}", tag: TAG);
    LogUtil.e("请求内容:${options.contentType}", tag: TAG);
    LogUtil.e("请求编码:${options.sendTimeout}", tag: TAG);
    LogUtil.e("请求类型:${options.responseType}", tag: TAG);
    LogUtil.e("请求参数:${options.queryParameters}", tag: TAG);
    LogUtil.e("请求数据:${options.data}", tag: TAG);
    LogUtil.e("请求头:${options.headers}", tag: TAG);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 在生产环境中不打印日志
    if (IS_PRODUCTION) {
      return handler.next(response);
    }

    TAG = response.requestOptions.path;

    // --- 温柔的修改开始 ---
    // 为了避免打印超大数据导致卡顿，我们在这里对它进行处理
    String responseDataString;
    try {
      // 尝试将响应数据转为格式化的JSON字符串
      var jsonObject = json.decode(response.data.toString());
      responseDataString = JsonEncoder.withIndent('  ').convert(jsonObject);
    } catch (e) {
      // 如果转换失败（比如它不是一个合法的JSON），就直接用toString()
      responseDataString = response.data.toString();
    }

    // 如果字符串太长，就截取一部分，避免刷屏和卡顿
    if (responseDataString.length > 500) {
      responseDataString =
          '${responseDataString.substring(0, 500)}... (内容过长，已截断)';
    }

    LogUtil.e("响应数据:\n$responseDataString", tag: TAG);
    // --- 温柔的修改结束 ---

    LogUtil.e("响应头:${response.headers}", tag: TAG);
    LogUtil.e("响应状态码:${response.statusCode}", tag: TAG);
    LogUtil.e("响应时间:${response.requestOptions.receiveTimeout}", tag: TAG);
    LogUtil.e("响应内容:${response.requestOptions.contentType}", tag: TAG);
    LogUtil.e("响应类型:${response.requestOptions.responseType}", tag: TAG);
    LogUtil.e("响应编码:${response.requestOptions.sendTimeout}", tag: TAG);
    LogUtil.e("响应路径:${response.requestOptions.path}", tag: TAG);
    LogUtil.e("响应方法:${response.requestOptions.method}", tag: TAG);
    LogUtil.e("响应参数:${response.requestOptions.queryParameters}", tag: TAG);
    LogUtil.e("响应状态码${response.statusCode}", tag: TAG);
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 在生产环境中不打印日志
    if (IS_PRODUCTION) {
      return super.onError(err, handler);
    }

    TAG = err.requestOptions.path; // 确保TAG在错误时也能被正确设置

    LogUtil.e("错误信息:${err.error}", tag: TAG);
    LogUtil.e("错误数据:${err.response?.data}", tag: TAG);
    LogUtil.e("错误状态码:${err.response?.statusCode}", tag: TAG);
    LogUtil.e("错误头:${err.response?.headers}", tag: TAG);
    LogUtil.e("错误内容:${err.response?.requestOptions.contentType}", tag: TAG);
    LogUtil.e("错误类型:${err.response?.requestOptions.responseType}", tag: TAG);
    LogUtil.e("错误路径:${err.response?.requestOptions.path}", tag: TAG);
    LogUtil.e("错误方法:${err.response?.requestOptions.method}", tag: TAG);
    LogUtil.e("错误编码:${err.response?.requestOptions.sendTimeout}", tag: TAG);
    LogUtil.e("错误时间:${err.response?.requestOptions.receiveTimeout}", tag: TAG);
    LogUtil.e("错误请求:${err.requestOptions}", tag: TAG);
    LogUtil.e("错误响应:${err.response}", tag: TAG);
    return super.onError(err, handler);
  }
}
