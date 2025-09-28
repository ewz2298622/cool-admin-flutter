import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/utils/ads.dart';
import 'package:flutter_app/utils/ads_cache_util.dart';
import 'package:flutter_app/utils/context_manager.dart';
import 'package:flutter_app/utils/device_info.dart';
import 'package:flutter_app/utils/requestMultiplePermissions.dart';
import 'package:flutter_app/utils/share_util.dart';
import 'package:flutter_app/utils/store/app/appState.dart';
import 'package:flutter_app/utils/store/theme/theme.dart';
import 'package:flutter_app/utils/store/user/user.dart';
import 'package:flutter_app/views/environment_error/environment_error.dart';
import 'package:flutter_app/views/feedback/feedback.dart';
import 'package:flutter_app/views/home/home.dart';
import 'package:flutter_app/views/htmlPage/html.dart';
import 'package:flutter_app/views/login/login.dart';
import 'package:flutter_app/views/my/my.dart';
import 'package:flutter_app/views/notice/notice.dart';
import 'package:flutter_app/views/ranking/ranking.dart';
import 'package:flutter_app/views/score/score.dart';
import 'package:flutter_app/views/search/result/search_result.dart';
import 'package:flutter_app/views/search/search.dart';
import 'package:flutter_app/views/service/service.dart';
import 'package:flutter_app/views/short_drama/short_drama.dart';
import 'package:flutter_app/views/splash_page/splash_page.dart';
import 'package:flutter_app/views/video_detail/detail.dart';
import 'package:flutter_app/views/video_filter/video_filter.dart';
import 'package:flutter_app/views/week/week.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'api/api.dart';
import 'components/loading.dart';
import 'db/manager/DBManager.dart';
import 'entity/app_ads_entity.dart';

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
        return RefreshConfiguration(
          springDescription: SpringDescription(
            stiffness: 170,
            damping: 16,
            mass: 0.1,
          ),
          headerBuilder:
              () => WaterDropHeader(
                refresh: PageLoading(),
                complete: Text(''),
                failed: Text(''),
              ),
          footerBuilder:
              () => ClassicFooter(
                loadingText: '',
                loadingIcon: PageLoading(),
                idleText: '',
                noDataText: '',
                failedText: '',
                canLoadingText: '',
              ),
          child: GetMaterialApp(
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
            getPages: [
              GetPage(name: '/', page: () => SplashPage()),
              GetPage(name: '/main', page: () => const MainPage()),
              GetPage(name: '/video_detail', page: () => Video_Detail()),
              GetPage(name: '/short_drama', page: () => ShortDrama()),
              GetPage(name: '/notice', page: () => Notice()),
              GetPage(name: '/html', page: () => HtmlPage()),
              GetPage(name: '/week', page: () => WeekPage()),
              GetPage(name: '/search', page: () => VideoSearch()),
              GetPage(name: '/search_result', page: () => SearchResult()),
              GetPage(name: '/login', page: () => Login()),
              GetPage(name: '/feedback', page: () => FeedbackPage()),
              GetPage(name: '/score', page: () => ScoreCenterPage()),
            ],
            navigatorKey: ContextManager.navigatorKey,
          ),
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
        RequestMultiplePermissions.requestPermissions(),
        DBManager.init(),
        initPlatformState(),
        ShareUtil.prepareShareImage(),
        getAd(),
      ]);

      //跳转到SplashPage组件
      return "init success";
    } catch (e) {
      // 注意：Future.wait会在任意一个Future失败时立即抛出异常
      // 如果需要收集所有错误，需要更复杂的处理
      return "init fail: ${e.toString()}";
    }
  }

  //获取广告
  Future<void> getAd() async {
    try {
      List<AppAdsDataList> list =
          (await Api.getAdsList({})).data?.list ?? [] as List<AppAdsDataList>;
      AdsCacheUtil.saveAdsData(list);
      debugPrint('获取广告成功: $list');
    } catch (e) {
      debugPrint('获取广告失败: $e');
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
