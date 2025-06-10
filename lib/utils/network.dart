import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

// 定义回调函数类型
// 网络状态变化时的回调函数，参数为当前的网络状态列表
typedef NetworkStatusCallback = void Function(List<ConnectivityResult> result);

// 网络连接时的回调函数，无参数
typedef NetworkConnectedCallback = void Function();

// 网络断开时的回调函数，无参数
typedef NetworkDisconnectedCallback = void Function();

class NetworkStatusManager {
  // 使用 Connectivity 插件实例来监听网络状态变化
  final Connectivity _connectivity = Connectivity();

  // StreamSubscription 用于订阅网络状态变化事件
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // 定义回调函数
  // 网络状态变化时的回调函数
  late NetworkStatusCallback _onNetworkChanged;

  // 网络连接时的回调函数
  late NetworkConnectedCallback _onNetworkConnected;

  // 网络断开时的回调函数
  late NetworkDisconnectedCallback _onNetworkDisconnected;

  // 初始化网络状态管理器
  // 参数：
  // - onNetworkChanged：网络状态变化时的回调函数
  // - onNetworkConnected：网络连接时的回调函数
  // - onNetworkDisconnected：网络断开时的回调函数
  void initNetworkStatusManager({
    required NetworkStatusCallback onNetworkChanged,
    required NetworkConnectedCallback onNetworkConnected,
    required NetworkDisconnectedCallback onNetworkDisconnected,
  }) {
    // 保存回调函数
    _onNetworkChanged = onNetworkChanged;
    _onNetworkConnected = onNetworkConnected;
    _onNetworkDisconnected = onNetworkDisconnected;

    // 监听网络状态变化
    // 使用 _connectivity.onConnectivityChanged 获取网络状态变化的流
    // 并订阅该流，当网络状态变化时调用 _handleConnectivityChange 方法
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
  }

  // 处理网络状态变化
  // 参数：
  // - result：当前的网络状态列表
  void _handleConnectivityChange(List<ConnectivityResult> result) {
    // 调用网络状态变化的回调函数
    _onNetworkChanged.call(result);

    // 检查网络状态
    // 如果 result 中包含 ConnectivityResult.none，则认为网络断开
    if (result.any((status) => status == ConnectivityResult.none)) {
      // 调用网络断开的回调函数
      _onNetworkDisconnected.call();
    } else {
      // 否则认为网络连接
      // 调用网络连接的回调函数
      _onNetworkConnected.call();
    }
  }

  // 取消监听
  // 释放资源，取消对网络状态变化事件的订阅
  void dispose() {
    _connectivitySubscription.cancel();
  }
}
