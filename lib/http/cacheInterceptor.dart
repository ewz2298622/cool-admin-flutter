import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheInterceptor extends Interceptor {
  final Duration cacheDuration;
  final bool forceRefresh;
  final List<String> whitelistPaths;

  CacheInterceptor({
    this.cacheDuration = const Duration(minutes: 10),
    this.forceRefresh = false,
    this.whitelistPaths = const [],
  });

  // 生成更健壮的缓存键
  String _generateCacheKey(RequestOptions options) {
    try {
      return 'cache_${options.method.toLowerCase()}_${options.uri.toString()}_'
          '${json.encode(options.queryParameters)}_${json.encode(options.data)}';
    } catch (e) {
      // 如果序列化失败，使用简单键
      return 'cache_${options.method.toLowerCase()}_${options.uri.toString()}';
    }
  }

  int _getCurrentTimestamp() => DateTime.now().millisecondsSinceEpoch;

  // 检查请求是否在白名单中
  bool _isWhitelisted(RequestOptions options) {
    if (whitelistPaths.isEmpty) return false;

    final uri = options.uri;
    return whitelistPaths.any(
      (path) => uri.path.contains(path) || uri.toString().contains(path),
    );
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (forceRefresh) {
      handler.next(options);
      return;
    }

    // 只处理GET和POST请求
    final method = options.method.toLowerCase();
    if (method != 'get' && method != 'post') {
      handler.next(options);
      return;
    }

    // 检查是否禁用缓存
    if (options.extra['noCache'] == true) {
      handler.next(options);
      return;
    }

    // 检查是否在白名单中，如果在白名单中则不使用缓存
    if (_isWhitelisted(options)) {
      handler.next(options);
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _generateCacheKey(options);
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        try {
          final cacheMap = json.decode(cachedData);
          final cacheTimestamp = cacheMap['timestamp'];
          final isExpired =
              _getCurrentTimestamp() - cacheTimestamp >
              cacheDuration.inMilliseconds;

          if (!isExpired) {
            // 返回缓存数据
            final cachedResponse = Response<dynamic>(
              data: cacheMap['data'],
              requestOptions: options,
              statusCode: 200,
            );
            handler.resolve(cachedResponse);
            return;
          }
        } catch (e) {
          // 缓存数据解析失败，忽略并继续请求
          print('Cache parse error: $e');
        }
      }

      // 没有缓存或缓存已过期，继续请求
      handler.next(options);
    } catch (e) {
      // 缓存读取失败，继续请求
      print('Cache read error: $e');
      handler.next(options);
    }
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // 只缓存成功的响应
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.requestOptions.extra['noCache'] != true &&
        !_isWhitelisted(response.requestOptions)) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final cacheKey = _generateCacheKey(response.requestOptions);
        final cacheData = {
          'data': response.data,
          'timestamp': _getCurrentTimestamp(),
        };

        await prefs.setString(cacheKey, json.encode(cacheData));
      } catch (e) {
        // 缓存失败不影响正常流程
        print('Cache save failed: $e');
      }
    }

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    handler.next(err);
  }

  //删除所有数据
  static Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return;
  }
}
