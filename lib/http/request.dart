import 'package:dio/dio.dart';
import 'package:flutter_app/http/print_log_interceptor.dart';
import 'package:flutter_app/http/requestConfig.dart';

import 'http_method.dart';

class DioInstance {
  static DioInstance? _instance;

  DioInstance._();

  static DioInstance instance() {
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: RequestConfig.baseUrl, // 请求的基础路径
      connectTimeout: RequestConfig.connectTimeout, // 超时时间
      receiveTimeout: RequestConfig.connectTimeout, // 接收超时时间
      headers: RequestConfig.headers,
    ),
  );
  final _defaultTime = const Duration(seconds: 30);

  void initDio({
    required String baseUrl,
    String? httpMethod = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType,
    String? contentType,
  }) {
    _dio.options = BaseOptions(
      method: httpMethod,
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? _defaultTime,
      receiveTimeout: receiveTimeout ?? _defaultTime,
      sendTimeout: sendTimeout ?? _defaultTime,
      responseType: responseType ?? ResponseType.json,
      contentType: contentType,
    );
    _dio.interceptors.add(PrintLogInterceptor());
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
