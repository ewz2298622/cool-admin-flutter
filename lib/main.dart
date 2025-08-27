import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/utils/ads.dart';
import 'package:flutter_app/utils/contacts.dart';
import 'package:flutter_app/utils/context_manager.dart';
import 'package:flutter_app/utils/device_info.dart';
import 'package:flutter_app/utils/store/app/appState.dart';
import 'package:flutter_app/utils/store/theme/theme.dart';
import 'package:flutter_app/utils/store/user/user.dart';
import 'package:flutter_app/views/environment_error/environment_error.dart';
import 'package:flutter_app/views/home/home.dart';
import 'package:flutter_app/views/my/my.dart';
import 'package:flutter_app/views/ranking/ranking.dart';
import 'package:flutter_app/views/service/service.dart';
import 'package:flutter_app/views/splash_page/splash_page.dart';
import 'package:flutter_app/views/video_filter/video_filter.dart';
import 'package:flutter_svg/svg.dart';
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
    initSDK();
    return Consumer<ThemeChangeEvent>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          darkTheme: ThemeData.dark(),
          themeMode: themeManager.themeMode,
          theme: ThemeData(
            primaryColor: const Color(0xFFFFFFFF),
            primaryColorDark: const Color(0xFFFFFFFF),
            primaryColorLight: const Color(0x33000000),
            scaffoldBackgroundColor: const Color(0xFFFFFFFF),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFFFFFF),
              foregroundColor: Color(0xFF000000),
              elevation: 0,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashPage(),
            '/main': (context) => MainPage(),
          },
          navigatorKey: ContextManager.navigatorKey,
        );
      },
    );
  }

  /// 初始化SDK
  Future<void> initSDK() async {
    try {
      await Ads.initRegister();
    } catch (e) {
      debugPrint('初始化失败: $e');
    }
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _futureBuilderFuture;
  Map<String, dynamic>? deviceInfo;
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
    return _buildContent();
  }

  Widget _buildContent() {
    return AppView();
  }

  Widget AppView() {
    bool status =
        deviceInfo?["checkIsTheDeveloperModeOn"] == true ||
        deviceInfo?["isphysicaldevice"] == false ||
        deviceInfo?["deviceUseVPN"] == true;
    if (false) {
      return EnvironmentError();
    } else {
      return Scaffold(
        body: IndexedStack(index: _selectedIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/images/sy_ic01h.svg',
                width: 25,
                height: 25,
              ),
              icon: SvgPicture.asset(
                'assets/images/sy_ic01.svg',
                width: 25,
                height: 25,
              ),
              label: '首页',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/images/sy_ic02h.svg',
                width: 25,
                height: 25,
              ),
              icon: SvgPicture.asset(
                'assets/images/sy_ic02.svg',
                width: 25,
                height: 25,
              ),
              label: '频道',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/images/sy_ic03h.svg',
                width: 25,
                height: 25,
              ),
              icon: SvgPicture.asset(
                'assets/images/sy_ic03.svg',
                width: 25,
                height: 25,
              ),
              label: '排行',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/images/sy_ic04h.svg',
                width: 25,
                height: 25,
              ),
              icon: SvgPicture.asset(
                'assets/images/sy_ic04.svg',
                width: 25,
                height: 25,
              ),
              label: '服务',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/images/sy_ic05h.svg',
                width: 25,
                height: 25,
              ),
              icon: SvgPicture.asset(
                'assets/images/sy_ic05.svg',
                width: 25,
                height: 25,
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
  }

  Future<String> init() async {
    try {
      // 使用Future.wait并发执行多个异步操作
      await Future.wait([
        Future.microtask(
          () => Contacts.requestPermissions(),
        ), // 放在microtask中执行，因为它是同步方法但需要返回Future
        DBManager.init(),
        initPlatformState(),
      ]);
      //跳转到SplashPage组件
      return "init success";
    } catch (e) {
      // 注意：Future.wait会在任意一个Future失败时立即抛出异常
      // 如果需要收集所有错误，需要更复杂的处理
      return "init fail: ${e.toString()}";
    }
  }

  Future<void> initPlatformState() async {
    deviceInfo = await DeviceInfoUtils().requestDeviceInfo();
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}
