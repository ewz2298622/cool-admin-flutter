import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../db/manager/helper.dart';
import '../../main.dart';
import '../../utils/user.dart';

// 定义一个名为 Setting 的有状态组件，用于展示一个包含 WebView 的页面
class Setting extends StatefulWidget {
  // 构造函数，Key? key 是可选参数，用于在组件树中唯一标识该组件
  const Setting({Key? key}) : super(key: key);

  // 创建该组件对应的状态类实例
  @override
  State<Setting> createState() => _SettingState();
}

// 定义 Setting 组件对应的状态类
class _SettingState extends State<Setting> {
  // 提取常量
  static const _gradientColors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];
  static const _gradientStops = [0.2, 0.8];

  // 组件状态初始化方法，在组件创建时调用
  @override
  void initState() {
    // 调用父类的 initState 方法，确保父类的初始化逻辑正常执行
    super.initState();
  }

  Widget _buildTDCellGroup(BuildContext context) {
    return TDCellGroup(
      cells: [
        // 可单独修改样式
        TDCell(
          arrow: true,
          title: '清空缓存',
          style: TDCellStyle.cellStyle(context),
          onClick: (cell) {
            deleteAll();
          },
        ),
        TDCell(
          arrow: true,
          title: '退出登录',
          onClick: (cell) {
            logout();
          },
        ),
      ],
    );
  }

  //退出登录
  Future<void> logout() async {
    User.deleteUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp(key: UniqueKey())),
    );
  }

  Future<void> deleteAll() async {
    Helper.deleteAll();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp(key: UniqueKey())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置", style: TextStyle(fontSize: 16)),
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
        backgroundColor: const Color.fromRGBO(255, 218, 112, 1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: _gradientStops,
            colors: _gradientColors,
          ),
        ),
        child: _buildTDCellGroup(context),
      ),
    );
  }
}
