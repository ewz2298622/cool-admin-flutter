class RequestConfig {
  // API 根地址
  static const String baseUrl = "http://169.254.186.87:8001";
  // 请求超时时间（毫秒）
  static const Duration connectTimeout = Duration(milliseconds: 500);
  // API 成功返回的状态码
  static const Duration successCode = Duration(milliseconds: 200);
  //设置请求头
  static Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
}
