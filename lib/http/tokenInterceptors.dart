import 'package:dio/dio.dart';
import 'package:flutter_app/http/requestConfig.dart';

import '../db/manager/TokenDatabaseHelper.dart';

TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();

/// Token拦截器
class TokenInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //如果需要token的接口，则添加token
    if (tokenRequiredUrls.contains(options.path)) {
      String authorization = tokenDatabaseHelper.getLatest()?.token ?? "";
      options.headers["Authorization"] = authorization;
    }
    handler.next(options);
  }
}
