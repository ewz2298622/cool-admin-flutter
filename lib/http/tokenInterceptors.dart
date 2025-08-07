import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../db/manager/AldultDatabaseHelper.dart';
import '../db/manager/TokenDatabaseHelper.dart';
import '../utils/device_info.dart';

String TAG = "TokenDatabaseHelper";
TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
AldultDatabaseHelper aldultDatabaseHelper = AldultDatabaseHelper();

/// Token拦截器
class TokenInterceptors extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      late String? authorization = tokenDatabaseHelper.getLatest()?.token;
      late int? aldult = aldultDatabaseHelper.getLatest()?.status;
      if (authorization != null) {
        // 修改: 直接赋值而不是addAll，避免重复添加header导致handler被多次调用
        options.headers["authorization"] = authorization;
      }
      if (aldult != null) {
        // 忽略已调用的错误，避免程序崩溃
        options.headers["aldult"] = aldult;
      }

      Map<String, dynamic>? deviceInfo =
          await DeviceInfoUtils().requestDeviceInfo();
      deviceInfo.forEach((key, value) {
        options.headers[key] = value;
        debugPrint("$TAG: $key: $value");
      });

      // if (options.headers["checkIsTheDeveloperModeOn"] == true ||
      //     options.headers["isphysicaldevice"] == false) {
      //   handler.reject(
      //     DioException(
      //       requestOptions: options,
      //       type: DioExceptionType.cancel,
      //       error: "checkIsTheDeveloperModeOn is true, not request",
      //     ),
      //   );
      // }

      handler.next(options);
    } catch (e) {
      //打印错误
      handler.next(options);
      // 忽略已调用的错误，避免程序崩溃
    }
  }
}
