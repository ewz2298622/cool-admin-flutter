import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView JS 桥接服务类
/// 负责处理 WebView 与 Flutter 之间的 JavaScript 通信
class WebViewJsBridge {
  final BuildContext context;
  final Function(WebViewController controller)? onControllerReady;

  WebViewJsBridge({
    required this.context,
    this.onControllerReady,
  });

  /// 注册 JavaScript 通道到 WebViewController
  void registerJavaScriptChannel(WebViewController controller) {
    controller.addJavaScriptChannel(
      'flutterChannel',
      onMessageReceived: _handleJsMessage,
    );
  }

  /// 处理前端发送的消息
  void _handleJsMessage(JavaScriptMessage message) {
    try {
      // 解析 JSON 数据
      Map<String, dynamic> data = json.decode(message.message);
      String action = data['action'];

      // 根据事件类型处理不同逻辑
      switch (action) {
        case 'card_click':
          _handleCardClick(data['data']);
          break;
        case 'back_click':
          _handleBackClick();
          break;
        case 'play_toggle':
          _handlePlayToggle(data['isPlaying']);
          break;
        default:
          print('未知事件：$action');
      }
    } catch (e) {
      print('解析前端消息失败：$e');
    }
  }

  /// 处理影视卡片点击事件
  void _handleCardClick(dynamic cardData) {
    if (cardData is Map<String, dynamic>) {
      String movieName = cardData['name'] ?? '';
      String category = cardData['category'] ?? '';
      print('用户点击了：$category - $movieName');
      // TODO: 这里可以跳转详情页/上报埋点/播放视频等
      // 如果需要回调，可以通过构造函数传入回调函数
    }
  }

  /// 处理返回按钮点击
  void _handleBackClick() {
    Get.back();
  }

  /// 处理播放/暂停事件
  void _handlePlayToggle(bool isPlaying) {
    print('播放状态：${isPlaying ? '播放' : '暂停'}');
    // TODO: 可以根据需要添加更多逻辑
  }

  /// 注入主题样式到 WebView
  void injectThemeStyles(WebViewController controller, bool isDarkMode) {
    final cssContent = isDarkMode ? _getDarkModeCSS() : _getLightModeCSS();
    
    controller.runJavaScript("""
      (function() {
        var style = document.createElement('style');
        style.innerHTML = `$cssContent`;
        document.head.appendChild(style);
      })();
    """);
  }

  /// 获取黑夜模式 CSS 样式
  String _getDarkModeCSS() {
    return """
      <style>
        body, p, div, span, li, td, th {
          word-break: break-word;
          overflow-wrap: anywhere;
          white-space: normal;
        }
        p {
            background-color: #424242;
          color: #ffffff; /* 强制文字为白色 */
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        body {
          background-color: #424242;
          color: #ffffff; /* 强制文字为白色 */
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        h1, h2, h3, h4, h5, h6 {
          color: #e0e0e0;
        }
        a {
          color: #bb86fc;
        }
        code {
          background-color: #2d2d2d;
          color: #f8f8f2;
        }
        pre {
          background-color: #2d2d2d;
          color: #f8f8f2;
          padding: 10px;
          border-radius: 5px;
          overflow-x: auto;
        }
        blockquote {
          border-left: 4px solid #bb86fc;
          background-color: #1e1e1e;
          padding: 10px;
          margin: 10px 0;
        }
        table {
          border-collapse: collapse;
          width: 100%;
        }
        th, td {
          border: 1px solid #444;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #2d2d2d;
        }
        tr:nth-child(even) {
          background-color: #1e1e1e;
        }
      </style>
    """;
  }

  /// 获取白天模式 CSS 样式
  String _getLightModeCSS() {
    return """
      <style>
        body, p, div, span, li, td, th {
          word-break: break-word;
          overflow-wrap: anywhere;
          white-space: normal;
        }
        body {
          background-color: #ffffff;
          color: #000000;
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        h1, h2, h3, h4, h5, h6 {
          color: #333333;
        }
        a {
          color: #1976d2;
        }
        code {
          background-color: #f5f5f5;
          color: #333333;
        }
        pre {
          background-color: #f5f5f5;
          color: #333333;
          padding: 10px;
          border-radius: 5px;
          overflow-x: auto;
        }
        blockquote {
          border-left: 4px solid #1976d2;
          background-color: #f9f9f9;
          padding: 10px;
          margin: 10px 0;
        }
        table {
          border-collapse: collapse;
          width: 100%;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 8px;
          text-align: left;
        }
        th {
          background-color: #f2f2f2;
        }
        tr:nth-child(even) {
          background-color: #f9f9f9;
        }
      </style>
    """;
  }
}
