import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/utils/contacts.dart';
import 'package:flutter_app/utils/context_manager.dart';
import 'package:flutter_app/utils/store/app/appState.dart';
import 'package:flutter_app/utils/store/theme/theme.dart';
import 'package:flutter_app/utils/store/user/user.dart';
import 'package:flutter_app/views/home/home.dart';
import 'package:flutter_app/views/my/my.dart';
import 'package:flutter_app/views/ranking/ranking.dart';
import 'package:flutter_app/views/service/service.dart';
import 'package:flutter_app/views/video_filter/video_filter.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'db/manager/DBManager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChangeEvent()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChangeEvent>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          darkTheme: ThemeData.dark(),
          themeMode: themeManager.themeMode,
          theme: ThemeData(
            primaryColor: const Color(0xFFFFFFFF),
            primaryColorDark: const Color(0xFFFFFFFF),
            primaryColorLight: const Color(0x33000000),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ),
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
    const VideoService(),
    const My(), // 确保每次切换时重新创建My页面
  ];
  int _selectedIndex = 0;

  void onTap(int index) {
    setState(() => _selectedIndex = index);
    TDToast.dismissLoading();
  }

  @override
  Widget build(BuildContext context) {
    ContextManager.setContext(context);
    return Scaffold(
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
          BottomNavigationBarItem(
            activeIcon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/8.png',
            ),
            icon: TDImage(
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              assetUrl: 'assets/images/7.png',
            ),
            label: '服务',
          ),
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
        unselectedFontSize: 14,
        selectedItemColor: ColorStyles.color_EA5034,
        selectedFontSize: 14,
      ),
    );
  }

  Future<void> init() async {
    Contacts.requestPermissions();
    await DBManager.init();
    debugPrint('main dart dbHelper init success');
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}
