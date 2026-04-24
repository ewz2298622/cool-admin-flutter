import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data["code"] == 1000) {
      return handler.next(response);
    } else {
      //打印错误数据
      debugPrint("请求失败: ${response.data.toString()}");
      // 使用handler.reject来正确处理错误，确保错误能被拦截器捕获
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "请求失败",
        ),
        true,
      );
    }
  }
}
