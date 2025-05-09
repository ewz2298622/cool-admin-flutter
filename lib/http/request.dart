import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/http/print_log_interceptor.dart';
import 'package:flutter_app/http/requestConfig.dart';
import 'package:flutter_app/http/responseInterceptor.dart';
import 'package:flutter_app/http/tokenInterceptors.dart';

import 'errorInterceptor.dart';
import 'http_method.dart';

class DioHttp {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: RequestConfig.baseUrl, // 请求的基础路径
      connectTimeout: RequestConfig.connectTimeout, // 超时时间
      receiveTimeout: RequestConfig.connectTimeout, // 接收超时时间
      headers: RequestConfig.headers,
    ),
  );
  final _defaultTime = const Duration(seconds: 30);

  DioHttp() {
    // 添加新的拦截器
    debugPrint('DioInstance init');
    _dio.interceptors.add(TokenInterceptors()); //token
    _dio.interceptors.add(ResponseInterceptor()); //response
    _dio.interceptors.add(ErrorInterceptor()); //error
    _dio.interceptors.add(PrintLogInterceptor()); //日志
  }

  Future get<Response>(
    String url, {
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get<Response>(
      url,
      queryParameters: param ?? {},
      options:
          options ??
          Options(
            method: HttpMethod.GET,
            receiveTimeout: _defaultTime,
            sendTimeout: _defaultTime,
          ),
      cancelToken: cancelToken,
    );
  }

  // post请求
  Future post<Response>(
    String url, {
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post<Response>(
      url,
      data: data,
      options:
          options ??
          Options(
            method: HttpMethod.POST,
            receiveTimeout: _defaultTime,
            sendTimeout: _defaultTime,
          ),
      cancelToken: cancelToken ?? CancelToken(),
    );
  }
}
