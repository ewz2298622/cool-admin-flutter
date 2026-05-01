import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/utils/ads.dart';
import 'package:flutter_app/utils/context_manager.dart';
import 'package:flutter_app/utils/device_info.dart';
import 'package:flutter_app/utils/share_util.dart';
import 'package:flutter_app/store/app/app_state.dart';
import 'package:flutter_app/store/home/color_notifier.dart';
import 'package:flutter_app/store/theme/theme.dart';
import 'package:flutter_app/store/user/user.dart';
import 'package:flutter_app/utils/user.dart';
import 'package:flutter_app/views/album/album.dart';
import 'package:flutter_app/views/cash/cash.dart';
import 'package:flutter_app/views/cash_order/cash_order.dart';
import 'package:flutter_app/views/connection_error/connection_error.dart';
import 'package:flutter_app/views/environment_error/environment_error.dart';
import 'package:flutter_app/views/feedback/feedback.dart';
import 'package:flutter_app/views/home/home.dart';
import 'package:flutter_app/views/htmlPage/html.dart';
import 'package:flutter_app/views/invite/invite.dart';
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
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'api/api.dart';
import 'components/loading.dart';
import 'db/manager/db_manager.dart';
import 'entity/app_ads_entity.dart';
import 'services/home_prefetch_service.dart';
import 'utils/routes.dart';
import 'services/video_filter_prefetch_service.dart';

/**
 * 应用程序入口点
 * 负责初始化应用环境、设置系统 UI 样式、启动应用并执行预加载任务
 */
Future<void> main() async {
  MediaKit.ensureInitialized();
  
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

  runApp(const AppBootstrap());

  // 使用 addPostFrameCallback 确保在第一帧绘制完成后再开始繁重的预加载任务
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // 延迟一点点，让 UI 动画先跑起来
    Future.delayed(const Duration(milliseconds: 500), () {
      // 并行预加载多个服务的数据
      Future.wait([
        HomePrefetchService.instance.preload().catchError((e, stackTrace) {
          debugPrint('Home prefetch failed: $e');
          debugPrint('Stack trace: $stackTrace');
        }),
        VideoFilterPrefetchService.instance.preload().catchError((e, stackTrace) {
          debugPrint('VideoFilter prefetch failed: $e');
          debugPrint('Stack trace: $stackTrace');
        }),
      ]).catchError((e, stackTrace) {
        debugPrint('Prefetch services failed: $e');
        debugPrint('Stack trace: $stackTrace');
      });
    });
  });
}

/**
 * 应用引导类
 * 负责提供应用所需的状态管理提供者
 */
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

/**
 * 应用主类
 * 负责初始化广告 SDK 和构建应用的根 Widget
 */
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/**
 * 应用主类状态管理
 * 负责初始化广告 SDK 和构建应用的根 Widget
 */
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 立即初始化广告 SDK，Splash 页面会等待初始化完成
    _initSDK();
  }

  /**
   * 初始化广告 SDK
   */
  Future<void> _initSDK() async {
    try {
      await Ads.initRegister();
      debugPrint('Ads SDK initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Ads SDK initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
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
            initialRoute: AppRoutes.splash,
            getPages: [
              GetPage(name: AppRoutes.splash, page: () => SplashPage()),
              GetPage(name: AppRoutes.main, page: () => MainPage()),
              GetPage(name: AppRoutes.videoDetail, page: () => Video_Detail()),
              GetPage(name: AppRoutes.shortDrama, page: () => ShortDrama()),
              GetPage(name: AppRoutes.notice, page: () => Notice()),
              GetPage(name: AppRoutes.html, page: () => HtmlPage()),
              GetPage(name: AppRoutes.week, page: () => WeekPage()),
              GetPage(name: AppRoutes.search, page: () => VideoSearch()),
              GetPage(name: AppRoutes.searchResult, page: () => SearchResult()),
              GetPage(name: AppRoutes.login, page: () => Login()),
              GetPage(name: AppRoutes.feedback, page: () => FeedbackPage()),
              GetPage(name: AppRoutes.score, page: () => TaskCenterPage()),
              GetPage(name: AppRoutes.scoreOrder, page: () => ScoreOrder()),
              GetPage(name: AppRoutes.connectionError, page: () => ConnectionError()),
              GetPage(name: AppRoutes.videoAlbum, page: () => VideoAlbum()),
              GetPage(name: AppRoutes.liveDetail, page: () => Live_Detail()),
              GetPage(name: AppRoutes.inviteRecord, page: () => InviteCenterPage()),
              GetPage(name: AppRoutes.cashPage, page: () => CashPage()),
              GetPage(name: AppRoutes.cashOrder, page: () => CashOrder()),
              GetPage(
                name: AppRoutes.environmentError,
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

/**
 * 主页面
 * 包含底部导航栏和多个子页面
 */
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

/**
 * 主页面状态管理
 * 负责初始化页面、处理底部导航栏切换和应用初始化
 */
class _MainPageState extends State<MainPage> {
  // 设备信息
  Map<String, dynamic>? deviceInfo;
  // 页面列表
  late final List<Widget> _pages;
  // 当前选中的页面索引
  int _selectedIndex = 0;
  // 使用 GlobalKey 来访问 My 页面的状态，注意在 dispose 时处理
  final GlobalKey<MyState> _myPageKey = GlobalKey<MyState>();

  /**
   * 底部导航栏点击事件处理
   * @param index 选中的页面索引
   */
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

  /**
   * 构建内容
   */
  Widget _buildContent() {
    return AppView();
  }

  /**
   * 构建应用视图
   */
  Widget AppView() {
    bool status = deviceInfo?["checkIsTheDeveloperModeOn"] == true ||
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
          backgroundColor: Colors.white,
          unselectedItemColor: ColorStyles.color_1E88E5,
          unselectedFontSize: 14,
          selectedItemColor: ColorStyles.color_EA5034,
          selectedFontSize: 14,
        ),
      );
    }
  }

  /**
   * 初始化应用
   * 负责初始化数据库、设备信息、分享图片、登录状态和广告
   */
  Future<String> init() async {
    try {
      // 修复：给 UI 一点时间来渲染，避免数据库初始化卡住主线程
      await Future.delayed(const Duration(milliseconds: 200));

      // 只等待关键操作：数据库初始化（必需，其他操作依赖它）
      await DBManager.init();
      debugPrint('Database initialized successfully');

      // 其他非关键操作改为后台异步执行，不阻塞应用启动
      // 保持原有业务逻辑不变，只是改变执行时机
      // 设备信息获取（延迟执行，不阻塞启动）
      Future.delayed(const Duration(milliseconds: 500), () {
        initPlatformState().catchError((e, stackTrace) {
          debugPrint('initPlatformState failed: $e');
          debugPrint('Stack trace: $stackTrace');
        });
      });

      // 分享图片准备（延迟执行，在真正需要时再准备）
      Future.delayed(const Duration(milliseconds: 1000), () {
        ShareUtil.prepareShareImage().catchError((e, stackTrace) {
          debugPrint('prepareShareImage failed: $e');
          debugPrint('Stack trace: $stackTrace');
        });
      });

      // 登录状态检查（延迟执行）
      Future.delayed(const Duration(milliseconds: 800), () {
        try {
          User.isLogin();
        } catch (e, stackTrace) {
          debugPrint('User.isLogin failed: $e');
          debugPrint('Stack trace: $stackTrace');
        }
      });

      // 广告加载改为后台异步执行，不阻塞应用启动
      // 延迟加载广告，优先展示内容
      Future.delayed(const Duration(milliseconds: 1000), () {
        getAd().catchError((e, stackTrace) {
          debugPrint('getAd failed: $e');
          debugPrint('Stack trace: $stackTrace');
        });
      });

      //跳转到SplashPage组件
      return "init success";
    } catch (e, stackTrace) {
      // 数据库初始化失败时记录错误，但不阻塞启动
      debugPrint('DBManager.init failed: $e');
      debugPrint('Stack trace: $stackTrace');
      return "init success"; // 即使失败也返回成功，让应用继续启动
    }
  }

  // 获取广告（不再缓存，直接请求，后台异步执行，不阻塞启动）
  Future<void> getAd() async {
    try {
      final response = await Api.getAdsList({
        'status': 1,
        'adsPage': 896,
        'type': 682,
      });
      final List<AppAdsDataList> list = response.data?.list ?? [];
      debugPrint('获取广告成功: ${list.length} 条');
    } catch (e, stackTrace) {
      debugPrint('获取广告失败: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> initPlatformState() async {
    try {
      deviceInfo = await DeviceInfoUtils().requestDeviceInfo();
      debugPrint('Device info initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize device info: $e');
      debugPrint('Stack trace: $stackTrace');
    }
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
