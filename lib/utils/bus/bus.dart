import 'package:events_emitter/events_emitter.dart';

import 'constant.dart';

class EventBus extends Constant {
  final EventEmitter _events = EventEmitter();

  // 注册事件监听器
  void on(String event, Function listener) {
    _events.on(event, listener());
  }

  // 触发事件
  void emit(String event, dynamic data) {
    _events.emit(event, data);
  }

  void off(String event, Function listener) {
    final List<String> busIds = getBusIds();
    for (var busId in busIds) {
      _events.off<String>(type: busId);
    }
  }
}
