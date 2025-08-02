import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// 定义一个名为 ConnectionError 的有状态组件，用于展示一个包含 WebView 的页面
class ConnectionError extends StatefulWidget {
  // 构造函数，Key? key 是可选参数，用于在组件树中唯一标识该组件
  const ConnectionError({super.key});

  // 创建该组件对应的状态类实例
  @override
  State<ConnectionError> createState() => _ConnectionErrorState();
}

// 定义 ConnectionError 组件对应的状态类
class _ConnectionErrorState extends State<ConnectionError> {
  // bool flag = ThemeManager.themeMode == ThemeMode.dark;
  //判断当前主题如何是黑夜模式就是true 否则就是false

  // 组件状态初始化方法，在组件创建时调用
  @override
  void initState() {
    // 调用父类的 initState 方法，确保父类的初始化逻辑正常执行
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("服务错误", style: TextStyle(fontSize: 16)),
        //返回
        leading: Container(),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false, //设置为false
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            TDImage(
              width: 300,
              height: 300,
              assetUrl: 'assets/images/server_error.png',
            ),
            TDButton(
              text: '重启应用',
              size: TDButtonSize.large,
              type: TDButtonType.outline,
              isBlock: true,
              shape: TDButtonShape.rectangle,
              onTap: () {
                // 跳转到首页
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
