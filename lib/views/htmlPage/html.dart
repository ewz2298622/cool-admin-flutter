import 'package:flutter/material.dart';
// 导入 webview_flutter 包，用于在 Flutter 应用中嵌入 WebView 来显示网页内容
import 'package:webview_flutter/webview_flutter.dart';

// 定义一个名为 HtmlPage 的有状态组件，用于展示一个包含 WebView 的页面
class HtmlPage extends StatefulWidget {
  // 构造函数，Key? key 是可选参数，用于在组件树中唯一标识该组件
  final String content; // 内容
  final String title;
  const HtmlPage({Key? key, required this.content, required this.title});

  // 创建该组件对应的状态类实例
  @override
  State<HtmlPage> createState() => _HtmlPageState();
}

// 定义 HtmlPage 组件对应的状态类
class _HtmlPageState extends State<HtmlPage> {
  // 定义一个 WebViewController 类型的变量 controller，用于控制 WebView 的行为
  // late 关键字表示该变量会在使用前被初始化
  late WebViewController controller;

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
    // 创建一个 WebViewController 实例，并对其进行一系列配置
    controller =
        WebViewController()
          // 设置 JavaScript 模式为 unrestricted，表示允许在 WebView 中无限制地执行 JavaScript 代码
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          // 设置 WebView 的背景颜色为透明
          ..setBackgroundColor(const Color(0x00000000))
          // 设置导航委托，用于监听 WebView 的各种导航事件
          ..setNavigationDelegate(
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
                // 页面加载完成后才能执行 js，当前代码中注释掉了具体执行逻辑
                // _handleBackForbid();
              },
              // 当 Web 资源加载出错时调用该回调函数，参数 error 包含错误信息
              onWebResourceError: (WebResourceError error) {},
              // 当有导航请求时调用该回调函数，参数 request 包含导航请求的信息
              // 根据具体情况返回 NavigationDecision.navigate 或 NavigationDecision.prevent 来决定是否允许导航
              onNavigationRequest: (NavigationRequest request) {
                // 允许所有导航请求
                return NavigationDecision.navigate;
              },
            ),
          )
          // 加载指定 URL 的网页
          // ..loadRequest(Uri.parse('https://www.geekailab.com'));
          ..loadHtmlString(widget.content);
  }

  // 构建组件的 UI 界面
  @override
  Widget build(BuildContext context) {
    // 返回一个 Scaffold 组件，它是 Flutter 中常用的页面布局组件
    return Scaffold(
      // 设置页面的顶部导航栏，显示标题为 'Flutter Simple Example'
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 16)),
        //返回
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false, //设置为false
      ),
      // 设置页面的主体内容，使用 WebViewWidget 组件来显示 WebView
      // 将之前初始化好的 controller 传递给 WebViewWidget，用于控制 WebView 的行为
      body: WebViewWidget(controller: controller),
    );
  }
}
