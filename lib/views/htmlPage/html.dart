import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../services/webview_js_bridge.dart';

// 定义一个名为 HtmlPage 的有状态组件，用于展示一个包含 WebView 的页面
class HtmlPage extends StatefulWidget {
  const HtmlPage({super.key});

  // 创建该组件对应的状态类实例
  @override
  State<HtmlPage> createState() => _HtmlPageState();
}

// 定义 HtmlPage 组件对应的状态类
class _HtmlPageState extends State<HtmlPage> {
  // 定义一个 WebViewController 类型的变量 controller，用于控制 WebView 的行为
  // late 关键字表示该变量会在使用前被初始化
  late WebViewController controller;
  
  // JS 桥接服务实例
  late WebViewJsBridge jsBridge;

  String title = Get.arguments["title"];
  String content = Get.arguments["content"];

  // 缓存主题样式避免重复计算
  String? _cachedDarkModeCSS;
  String? _cachedLightModeCSS;

  // 组件状态初始化方法，在组件创建时调用
  @override
  void initState() {
    // 调用父类的 initState 方法，确保父类的初始化逻辑正常执行
    super.initState();
    // 调用自定义的初始化 WebView 控制器的方法
    _initWebViewController();
  }

  // 自定义方法，用于初始化 WebView 控制器
  void _initWebViewController() {
    // 创建 JS 桥接服务实例
    jsBridge = WebViewJsBridge(
      context: context,
    );
    
    // 创建一个 WebViewController 实例，并对其进行一系列配置
    controller =
        WebViewController()
          // 设置 JavaScript 模式为 unrestricted，表示允许在 WebView 中无限制地执行 JavaScript 代码
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          // 设置 WebView 的背景颜色为透明
          ..setBackgroundColor(Colors.transparent)
          ..setJavaScriptMode(JavaScriptMode.unrestricted);
    
    // 注册 JS 通道（名称需和前端的 flutterChannel 一致）
    jsBridge.registerJavaScriptChannel(controller);
    
    // 设置导航委托，用于监听 WebView 的各种导航事件
    controller.setNavigationDelegate(
      NavigationDelegate(
        // 当页面加载进度发生变化时调用该回调函数，参数 progress 表示加载进度百分比
        onProgress: (int progress) {
          // 这里可以更新加载进度条，但当前代码中未实现具体逻辑
          // Update loading bar.
        },
        // 当页面开始加载时调用该回调函数，参数 url 表示要加载的页面的 URL
        onPageStarted: (String url) {},
        // 当页面加载完成时调用该回调函数，参数 url 表示已加载完成的页面的 URL
        onPageFinished: (String url) {
          // 页面加载完成后应用主题样式
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          jsBridge.injectThemeStyles(controller, isDarkMode);
        },
        // 当 Web 资源加载出错时调用该回调函数，参数 error 包含错误信息
        onWebResourceError: (WebResourceError error) {},
        // 当有导航请求时调用该回调函数，参数 request 包含导航请求的信息
        // 根据具体情况返回 NavigationDecision.navigate 或 NavigationDecision.prevent 来决定是否允许导航
        onNavigationRequest: (NavigationRequest request) {
          // 如果不是本地内容且不是以特定域名开头的链接，则在系统浏览器中打开
          if (!request.url.startsWith('data:text/html') &&
              !request.url.startsWith('https://www.geekailab.com')) {
            _launchURL(request.url);
            return NavigationDecision.prevent;
          }
          // 允许所有导航请求
          return NavigationDecision.navigate;
        },
      ),
    );
    
    // 加载指定 HTML 内容
    controller.loadHtmlString(content);
  }

  // 在系统浏览器中打开链接
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 构建组件的 UI 界面
  @override
  Widget build(BuildContext context) {
    // 修改: 使用 Theme.of(context).brightness 替代 MediaQuery.platformBrightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 设置页面的顶部导航栏，显示标题
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        //返回按钮
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        // AppBar背景色跟随主题
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      // 设置页面的主体内容，使用 WebViewWidget 组件来显示 WebView
      body: ColoredBox(
        color: isDarkMode ? Colors.black : Colors.white,
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
