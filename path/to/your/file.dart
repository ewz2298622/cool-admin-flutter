import 'package:flutter/material.dart';
import '../../utils/bus/bus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // 注册事件监听器
    EventBusUtil.registerListener<String>((message) {
      print('Received message: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Bus Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 发布事件
            EventBusUtil.publish('Hello, Event Bus!');
          },
          child: Text('Send Message'),
        ),
      ),
    );
  }
}