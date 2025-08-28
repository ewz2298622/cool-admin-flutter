import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/http/print_log_interceptor.dart';
import 'package:flutter_app/http/requestConfig.dart';
import 'package:flutter_app/http/responseInterceptor.dart';
import 'package:flutter_app/http/tokenInterceptors.dart';

import 'cacheInterceptor.dart';
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
    _dio.interceptors.add(
      CacheInterceptor(
        cacheDuration: const Duration(minutes: 5), // 设置5分钟缓存
        // forceRefresh: true, // 强制刷新时取消注释
        whitelistPaths: ["/app/user/login/captcha"],
      ),
    );
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
    try {
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
      );
    } on DioException catch (e) {
      // 处理 Dio 异常
      throw _handleDioError(e);
    } catch (e) {
      // 处理其他异常
      throw '未知错误: $e';
    }
  }

  // post请求
  Future post<Response>(
    String url, {
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
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
      );
    } on DioException catch (e) {
      // 处理 Dio 异常
      throw _handleDioError(e);
    } catch (e) {
      // 处理其他异常
      throw '未知错误: $e';
    }
  }

  // 统一处理 Dio 错误信息
  String _handleDioError(DioException e) {
    final requestOptions = e.requestOptions;
    final uri = '${requestOptions.method} ${requestOptions.uri}';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时: $uri';
      case DioExceptionType.sendTimeout:
        return '发送超时: $uri';
      case DioExceptionType.receiveTimeout:
        return '接收超时: $uri';
      case DioExceptionType.badResponse:
        return '服务器错误(${e.response?.statusCode}): ${e.message}';
      case DioExceptionType.cancel:
        return '请求被取消: $uri';
      case DioExceptionType.unknown:
        return '网络异常: $uri';
      default:
        return '请求失败: $uri';
    }
  }
}
