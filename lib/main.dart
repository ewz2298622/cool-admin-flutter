import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/utils/context_manager.dart';
import 'package:flutter_app/utils/device_info.dart';
import 'package:flutter_app/utils/store/theme/theme.dart';
import 'package:flutter_app/views/home/home.dart';
import 'package:flutter_app/views/my/my.dart';
import 'package:flutter_app/views/ranking/ranking.dart';
import 'package:flutter_app/views/video_filter/video_filter.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'db/manager/DBManager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeChangeEvent())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChangeEvent>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          darkTheme: ThemeData.dark(),
          themeMode: themeManager.themeMode,
          home: MainPage(),
          navigatorKey: ContextManager.navigatorKey,
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> pages = [
    const Home(),
    const VideoFilter(),
    const VideoRanking(),
    // const VideoService(),
    My(key: UniqueKey()),
  ];
  int _selectedIndex = 0;

  void onTap(int index) {
    // if (index == (pages.length - 1)) {
    //   // 如果是非缓存页面，每次切换时重新创建
    //   pages[pages.length - 1] = My(key: UniqueKey());
    // }
    setState(() => _selectedIndex = index);
    TDToast.dismissLoading();
  }

  @override
  Widget build(BuildContext context) {
    ContextManager.setContext(context);
    return Scaffold(
      // body: pages[_selectedIndex],
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            activeIcon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/1.png',
            ),
            icon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/2.png',
            ),
            label: '首页',
          ),
          BottomNavigationBarItem(
            activeIcon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/3.png',
            ),
            icon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/4.png',
            ),
            label: '频道',
          ),
          BottomNavigationBarItem(
            activeIcon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/6.png',
            ),
            icon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/5.png',
            ),
            label: '排行',
          ),
          // BottomNavigationBarItem(
          //   activeIcon: TDImage(
          //     width: 25,
          //     height: 25,
          //     fit: BoxFit.cover,
          //     assetUrl: 'assets/images/8.png',
          //   ),
          //   icon: TDImage(
          //     width: 25,
          //     height: 25,
          //     fit: BoxFit.cover,
          //     assetUrl: 'assets/images/7.png',
          //   ),
          //   label: '服务',
          // ),
          BottomNavigationBarItem(
            activeIcon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/9.png',
            ),
            icon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/10.png',
            ),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        unselectedItemColor: ColorStyles.color_1E88E5,
        // 未选中状态下的颜色
        unselectedFontSize: 14,
        // 未选中状态下的字体大小
        selectedItemColor: ColorStyles.color_EA5034,
        // 选中状态下的颜色
        selectedFontSize: 14, // 选中状态下的字体大小
      ),
    );
  }

  Future<void> init() async {
    await DBManager.init();
    await DeviceInfoUtils().requestDeviceInfo();
    debugPrint('main dart dbHelper init success');
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}
