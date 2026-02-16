import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/utils/ads.dart';
import 'package:flutter_app/utils/context_manager.dart';
import 'package:flutter_app/utils/device_info.dart';
import 'package:flutter_app/utils/share_util.dart';
import 'package:flutter_app/utils/store/app/appState.dart';
import 'package:flutter_app/utils/store/home/color_notifier.dart';
import 'package:flutter_app/utils/store/theme/theme.dart';
import 'package:flutter_app/utils/store/user/user.dart';
import 'package:flutter_app/utils/user.dart';
import 'package:flutter_app/views/album/album.dart';
import 'package:flutter_app/views/connection_error/connectionError.dart';
import 'package:flutter_app/views/environment_error/environment_error.dart';
import 'package:flutter_app/views/feedback/feedback.dart';
import 'package:flutter_app/views/home/home.dart';
import 'package:flutter_app/views/htmlPage/html.dart';
import 'package:flutter_app/views/live_detail/live_detail.dart';
import 'package:flutter_app/views/login/login.dart';
import 'package:flutter_app/views/my/my.dart';
import 'package:flutter_app/views/notice/notice.dart';
import 'package:flutter_app/views/ranking/ranking.dart';
import 'package:flutter_app/views/score/score.dart';
import 'package:flutter_app/views/score_order/score_order.dart';
import 'package:flutter_app/views/search/result/search_result.dart';
import 'package:flutter_app/views/search/search.dart';
import 'package:flutter_app/views/service/service.dart';
import 'package:flutter_app/views/short_drama/short_drama.dart';
import 'package:flutter_app/views/splash_page/splash_page.dart';
import 'package:flutter_app/views/video_detail/detail.dart';
import 'package:flutter_app/views/video_filter/video_filter.dart';
import 'package:flutter_app/views/week/week.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'api/api.dart';
import 'components/loading.dart';
import 'db/manager/DBManager.dart';
import 'entity/app_ads_entity.dart';
import 'services/home_prefetch_service.dart';
import 'services/video_filter_prefetch_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  // 修复：先启动 App，再执行预加载，避免阻塞首帧
  runApp(const AppBootstrap());

  // 使用 addPostFrameCallback 确保在第一帧绘制完成后再开始繁重的预加载任务
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // 延迟一点点，让 UI 动画先跑起来
    Future.delayed(const Duration(milliseconds: 500), () {
      // 并行预加载多个服务的数据
      HomePrefetchService.instance.preload().catchError((e) {
        debugPrint('Home prefetch failed: $e');
      });

      VideoFilterPrefetchService.instance.preload().catchError((e) {
        debugPrint('VideoFilter prefetch failed: $e');
      });
    });
  });
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChangeEvent()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ColorNotifier()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static bool _sdkInitialized = false;

  @override
  void initState() {
    super.initState();
    if (!_sdkInitialized) {
      _sdkInitialized = true;
      // 修复：增加延迟时间，避免与 App 启动时的 UI 构建争抢资源
      // 延迟 1.5 秒初始化广告 SDK，确保 Splash 页面已经展示
      Future.delayed(const Duration(milliseconds: 1500), _initSDK);
    }
  }

  Future<void> _initSDK() async {
    try {
      await Ads.initRegister();
    } catch (e) {
      debugPrint('初始化失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            popGesture: true, // 启用手势控制
            transitionDuration: const Duration(milliseconds: 210),
            defaultTransition: Transition.rightToLeft, // 使用iOS风格转场

            locale: const Locale('zh', 'CN'),
            // 设置默认语言为中文
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('zh', 'CN')],
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
              GetPage(name: '/main', page: () => MainPage()),
              GetPage(name: '/video_detail', page: () => Video_Detail()),
              GetPage(name: '/short_drama', page: () => ShortDrama()),
              GetPage(name: '/notice', page: () => Notice()),
              GetPage(name: '/html', page: () => HtmlPage()),
              GetPage(name: '/week', page: () => WeekPage()),
              GetPage(name: '/search', page: () => VideoSearch()),
              GetPage(name: '/search_result', page: () => SearchResult()),
              GetPage(name: '/login', page: () => Login()),
              GetPage(name: '/feedback', page: () => FeedbackPage()),
              GetPage(name: '/score', page: () => TaskCenterPage()),
              GetPage(name: '/score_order', page: () => ScoreOrder()),
              GetPage(name: '/connection_error', page: () => ConnectionError()),
              GetPage(name: '/video_album', page: () => VideoAlbum()),
              GetPage(name: '/live_detail', page: () => Live_Detail()),

              GetPage(
                name: '/environment_error',
                page: () => EnvironmentError(),
              ),
            ],
            navigatorKey: ContextManager.navigatorKey,
            navigatorObservers: [routeObserver], // 添加路由观察者
          ),
        );
      },
    );
  }
}

// 创建全局的 RouteObserver
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, dynamic>? deviceInfo;
  late final List<Widget> _pages;
  int _selectedIndex = 0;
  final GlobalKey<MyState> _myPageKey =
      GlobalKey<MyState>(); // 添加GlobalKey来访问My页面的状态

  void onTap(int index) {
    setState(() => _selectedIndex = index);
    TDToast.dismissLoading();

    // 当切换到"我的"页面时，调用页面的刷新方法
    if (index == 4) {
      // "我的"页面索引为4
      _myPageKey.currentState?.init();
    }
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
        body: IndexedStack(index: _selectedIndex, children: _pages),
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
              label: '分类',
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
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: onTap,
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
      // 修复：给 UI 一点时间来渲染，避免数据库初始化卡住主线程
      await Future.delayed(const Duration(milliseconds: 200));

      // 只等待关键操作：数据库初始化（必需，其他操作依赖它）
      await DBManager.init();

      // 其他非关键操作改为后台异步执行，不阻塞应用启动
      // 保持原有业务逻辑不变，只是改变执行时机
      // 设备信息获取（延迟执行，不阻塞启动）
      Future.delayed(const Duration(milliseconds: 500), () {
        initPlatformState().catchError((e) {
          debugPrint('initPlatformState failed: $e');
        });
      });

      // 分享图片准备（延迟执行，在真正需要时再准备）
      Future.delayed(const Duration(milliseconds: 1000), () {
        ShareUtil.prepareShareImage().catchError((e) {
          debugPrint('prepareShareImage failed: $e');
        });
      });

      // 登录状态检查（延迟执行）
      Future.delayed(const Duration(milliseconds: 800), () {
        User.isLogin();
      });

      // 广告加载改为后台异步执行，不阻塞应用启动
      // 延迟加载广告，优先展示内容
      Future.delayed(const Duration(milliseconds: 1000), () {
        getAd().catchError((e) {
          debugPrint('getAd failed: $e');
        });
      });

      //跳转到SplashPage组件
      return "init success";
    } catch (e) {
      // 数据库初始化失败时记录错误，但不阻塞启动
      debugPrint('DBManager.init failed: $e');
      return "init success"; // 即使失败也返回成功，让应用继续启动
    }
  }

  // //获取广告（不再缓存，直接请求，后台异步执行，不阻塞启动）
  Future<void> getAd() async {
    try {
      List<AppAdsDataList> list =
          (await Api.getAdsList({
            'status': 1,
            'adsPage': 896,
            'type': 682,
          })).data?.list ??
          [] as List<AppAdsDataList>;
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
    // 初始化页面
    _pages = <Widget>[
      const Home(),
      const VideoFilter(),
      const VideoRanking(),
      const VideoService(),
      My(key: _myPageKey),
    ];
    init();
  }
}
