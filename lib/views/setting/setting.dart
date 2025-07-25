import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../db/entity/AldultEntity.dart';
import '../../db/manager/AldultDatabaseHelper.dart';
import '../../db/manager/helper.dart';
import '../../utils/store/app/appState.dart';
import '../../utils/store/theme/theme.dart';
import '../../utils/store/user/user.dart';
import '../../utils/user.dart';

// 定义一个名为 Setting 的有状态组件，用于展示一个包含 WebView 的页面
class Setting extends StatefulWidget {
  // 构造函数，Key? key 是可选参数，用于在组件树中唯一标识该组件
  const Setting({super.key});

  // 创建该组件对应的状态类实例
  @override
  State<Setting> createState() => _SettingState();
}

// 定义 Setting 组件对应的状态类
class _SettingState extends State<Setting> {
  //判断当前主题如何是黑夜模式就是true 否则就是false
  static final AldultDatabaseHelper aldultDatabaseHelper =
      AldultDatabaseHelper();
  // 组件状态初始化方法，在组件创建时调用
  @override
  void initState() {
    // 调用父类的 initState 方法，确保父类的初始化逻辑正常执行
    super.initState();
  }

  Widget _buildTDCellGroup(BuildContext context) {
    bool flag =
        Provider.of<ThemeChangeEvent>(context).themeMode == ThemeMode.dark;
    int teenagerModel = aldultDatabaseHelper.getLatest()?.status ?? 0;
    return Card(
      child: TDCellGroup(
        theme: TDCellGroupTheme.cardTheme,
        cells: [
          TDCell(
            style: TDCellStyle(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              titleStyle: TextStyle(
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
            arrow: false,
            title: '深色模式',
            rightIconWidget: TDSwitch(
              isOn: flag,
              trackOnColor: Colors.green,
              openText: "夜",
              type: TDSwitchType.text,
              closeText: "日",
              onChanged: (bool value) {
                setState(() {
                  flag = value;
                });
                context.read<ThemeChangeEvent>().changeTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
                return flag;
              },
            ),
          ),
          TDCell(
            style: TDCellStyle(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              titleStyle: TextStyle(
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
            arrow: false,
            title: '青少年模式',
            rightIconWidget: TDSwitch(
              isOn: teenagerModel == 0,
              trackOnColor: Colors.green,
              openText: "开",
              type: TDSwitchType.text,
              closeText: "关",
              onChanged: (bool value) {
                setState(() {
                  teenagerModel = value == true ? 0 : 1;
                });
                aldultDatabaseHelper.insertAldult(
                  AldultEntity(
                    status: teenagerModel,
                    timestamp: DateTime.now(),
                  ),
                );
                //重启app
                Navigator.of(context).pushReplacementNamed('/');
                return value;
              },
            ),
          ),
          // 可单独修改样式
          TDCell(
            style: TDCellStyle(
              padding: EdgeInsets.only(top: 10, bottom: 25),
              titleStyle: TextStyle(
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
              // backgroundColor: Theme.of(context).cardColor,
            ),
            arrow: true,
            title: '清空缓存',
            onClick: (cell) {
              deleteAll(context);
            },
          ),
          TDCell(
            style: TDCellStyle(
              padding: EdgeInsets.only(top: 10, bottom: 25),
              titleStyle: TextStyle(
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
              // backgroundColor: Theme.of(context).cardColor,
            ),
            arrow: true,
            title: '退出登录',
            onClick: (cell) {
              logout(context);
            },
          ),
        ],
      ),
    );
  }

  //退出登录
  Future<void> logout(BuildContext context) async {
    User.deleteUser();
    context.read<UserState>().deleteUserInfoData();
    Navigator.of(context, rootNavigator: true).pop(context);
  }

  Future<void> deleteAll(BuildContext context) async {
    Helper.deleteAll();
    Navigator.of(context, rootNavigator: true).pop(context);
    context.read<UserState>().deleteUserInfoData();
    final appState = Provider.of<AppState>(context, listen: false);
    appState.reset();
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
      ),
      body: Container(child: _buildTDCellGroup(context)),
    );
  }
}
