import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/views/home/home.dart';
import 'package:flutter_app/views/ranking/ranking.dart';
import 'package:flutter_app/views/video_filter/video_filter.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'db/manager/serverManager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: MainPage()));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> pages = [
    const Home(),
    const VideoFilter(),
    const VideoRanking(),
  ];
  int _selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    TDToast.dismissLoading();
  }

  @override
  Widget build(BuildContext context) {
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
          // BottomNavigationBarItem(
          //     activeIcon: TDImage(
          //         width: 25,
          //         height: 25,
          //         fit: BoxFit.cover,
          //         assetUrl: 'assets/images/8.png'),
          //     icon: TDImage(
          //         width: 25,
          //         height: 25,
          //         fit: BoxFit.cover,
          //         assetUrl: 'assets/images/7.png'),
          //     label: '服务'),
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
          //     activeIcon: TDImage(
          //         width: 25,
          //         height: 25,
          //         fit: BoxFit.cover,
          //         assetUrl: 'assets/images/9.png'),
          //     icon: TDImage(
          //         width: 25,
          //         height: 25,
          //         fit: BoxFit.cover,
          //         assetUrl: 'assets/images/10.png'),
          //     label: '我的'),
        ],
        currentIndex: _selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorStyles.color_FFFFFF,
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

  init() {
    debugPrint('main dart init');
    ServerManager.getInstance().init();
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}
