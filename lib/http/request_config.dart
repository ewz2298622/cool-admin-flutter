class RequestConfig {
  //动态获取本机的ipv4地址
  // API 根地址
  static const String baseUrl = "http://10.132.233.100:8001";
  // 请求超时时间（毫秒）
  static const Duration connectTimeout = Duration(milliseconds: 9000);
  // API 成功返回的状态码
  static const Duration successCode = Duration(milliseconds: 500);
  //设置请求头
  static Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
}
