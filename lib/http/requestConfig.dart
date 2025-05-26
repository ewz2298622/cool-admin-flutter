class RequestConfig {
  //动态获取本机的ipv4地址
  // API 根地址
  static const String baseUrl = "http://192.168.2.248:8001";
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

//需要token的接口数组
List<String> tokenRequiredUrls = [
  "/app/user/info/person",
  "/app/user/views/page",
  "/app/user/views/add",
];
