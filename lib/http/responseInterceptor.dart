import 'package:dio/dio.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data["code"] == 1000) {
      return handler.next(response);
    } else {
      //抛出错误
      handler.next(response);

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
