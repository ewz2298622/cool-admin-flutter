import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/member_exchange_config_entity.dart';
import '../../entity/monthly_checkinConfig_entity.dart';
import '../../utils/ads.dart';
import '../../utils/request_multiple_permissions.dart';
import '../../router/routes.dart';
import '../../main.dart' show routeObserver;

/// 任务中心页面
class TaskCenterPage extends StatefulWidget {
  const TaskCenterPage({super.key});

  @override
  TaskCenterPageState createState() => TaskCenterPageState();
}

class TaskCenterPageState extends State<TaskCenterPage> with RouteAware {
  late Future<String> _futureBuilderFuture;
  bool _isDailyTaskExpanded = true;
  bool _isSignTaskExpanded = true;
  int score = 0;
  List<MemberExchangeConfigDataList> memberExchangeConfigDataList = [];
  List<MonthlyCheckinConfigDataList> signData = [];
  bool _isLoading = false; // 防止重复请求

  // 常量定义
  static const double _toolbarHeight = 40.0;
  static const double _iconSize = 20.0;
  static const double _titleFontSize = 16.0;
  static const double _coinCardHeight = 80.0;
  static const double _signCardWidth = 70.0;
  static const double _signCardIconSize = 20.0;
  static const double _borderRadius = 8.0;
  static const double _vipCardBorderRadius = 16.0;
  static const double _buttonBorderRadius = 20.0;
  static const int _coinColor = 0xFFFF7D00;
  static const int _signActiveColor = 0xFFFF3B30;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPush() {
  }

  @override
  void didPopNext() {
    if (mounted) {
      setState(() {
        _futureBuilderFuture = init();
      });
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// 获取会员配置
  Future<void> getMemberConfig() async {
    try {
      if (!mounted) return;
      memberExchangeConfigDataList =
          (await Api.getMemberConfig({})).data?.list ??
          <MemberExchangeConfigDataList>[];
    } catch (e) {
      debugPrint('getMemberConfig failed: $e');
      memberExchangeConfigDataList = <MemberExchangeConfigDataList>[];
    }
  }

  /// 获取积分
  Future<void> getScore() async {
    try {
      score = (await Api.getUserScore({})).data ?? 0;
      setState(() {});
    } catch (e) {
      debugPrint('getScore failed: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// 获取当月签到数据
  Future<void> getSignData() async {
    try {
      if (!mounted) return;
      signData =
          (await Api.getSignInData({})).data?.list ??
          <MonthlyCheckinConfigDataList>[];
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('getSignData failed: $e');
      signData = <MonthlyCheckinConfigDataList>[];
    }
  }

  /// 初始化数据（并发执行）
  Future<String> init() async {
    try {
      if (!mounted) return "init failed";

      await Future.wait([getScore(), getMemberConfig(), getSignData()]);

      debugPrint("TaskCenterPage init success");
      return "init success";
    } catch (e) {
      debugPrint("TaskCenterPage init failed: $e");
      return "init failed";
    }
  }

  /// 刷新积分和签到数据
  Future<void> _refreshData() async {
    if (!mounted) return;
    await Future.wait([getScore(), getSignData()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 26.06 / 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: _iconSize,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        toolbarHeight: _toolbarHeight,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const PageLoading();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text('加载失败：${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureBuilderFuture = init();
                        });
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              );
            }
            return Stack(
              children: [
                // 背景渐变层
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  // 高度设置为整个屏幕高度
                  height: 300,
                  child: Stack(
                    children: [
                      // 底层：整个区域填充最后一种渐变颜色
                      // Container(color: const Color.fromRGBO(245, 245, 245, 1)),
                      // 上层：300高度的渐变区域
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        //页面的高度
                        height: 300,
                        child: ShaderMask(
                          shaderCallback:
                              (bounds) => LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white, // 顶部不透明
                                  Colors.white.withOpacity(0.0), // 底部透明
                                ],
                              ).createShader(bounds),
                          blendMode: BlendMode.dstIn,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/ces.jpg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 内容层
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Stack(
                    children: [
                      // Positioned(
                      //   left: 0,
                      //   top: 100,
                      //   child: Container(
                      //     width: 88,
                      //     height: 32,
                      //     decoration: BoxDecoration(
                      //       color: const Color.fromARGB(255, 25, 138, 255),
                      //       borderRadius: const BorderRadius.only(
                      //         topRight: Radius.circular(16),
                      //         bottomRight: Radius.circular(16),
                      //       ),
                      //     ),
                      //     alignment: Alignment.center,
                      //     child: GestureDetector(
                      //       onTap: () => Get.toNamed("/score_order"),
                      //       child: const Text(
                      //         "金币详情",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          right: 10,
                          left: 10,
                        ),
                        child: Column(
                          children: [
                            RepaintBoundary(
                              child: _buildCoinVipArea(screenWidth),
                            ),
                            RepaintBoundary(
                              child: _buildVipExchangeArea(screenWidth),
                            ),
                            RepaintBoundary(
                              child: _buildSignTaskArea(screenWidth),
                            ),
                            RepaintBoundary(
                              child: _buildDailyTaskArea(screenWidth),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          default:
            return const PageLoading();
        }
      },
    );
  }

  /// 金币与会员兑换区
  Widget _buildCoinVipArea(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.only(top: 22, bottom: 22, left: 15),
      child: Column(
        children: [
          SizedBox(height: _toolbarHeight), // 留出 AppBar 高度
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 100,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.scoreOrder);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Text(
                      "金币收益",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                        height: 1.45,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 5,
                      children: [
                        Text(
                          score.toString(),
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "金币",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(AppRoutes.cashPage);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Text(
                      "现金收益",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                        height: 1.45,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 5,
                      children: [
                        Text(
                          (score / 1000).toString(),
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "现金",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // 底部间距
        ],
      ),
    );
  }

  /// 签到任务区
  Widget _buildSignTaskArea(double screenWidth) {
    if (signData.isEmpty) {
      return const SizedBox.shrink();
    }

    // 修复逻辑漏洞：简化查找逻辑，避免重复的 where 和 firstWhere
    final today = DateTime.now().day;
    final todaySignData = signData.firstWhere(
      (element) => element.day == today,
      orElse: () => MonthlyCheckinConfigDataList(),
    );
    final coin = todaySignData.score ?? 0;

    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "今日签到领 $coin 金币",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _isSignTaskExpanded = !_isSignTaskExpanded;
                    });
                  }
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  _isSignTaskExpanded ? "收起" : "展开",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          if (_isSignTaskExpanded) ...[
            Container(
              margin: const EdgeInsets.only(top: 12),
              height: _coinCardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                cacheExtent: 200,
                itemCount: signData.length,
                itemBuilder: (context, index) {
                  return RepaintBoundary(child: _buildSignCardItem(index));
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建签到卡片项
  Widget _buildSignCardItem(int index) {
    // 容错处理：检查索引有效性
    if (index >= signData.length) {
      return const SizedBox.shrink();
    }

    final item = signData[index];
    final isSigned = item.isSigned ?? 0;
    final isActive = isSigned == 3;
    final statusText =
        isSigned == 1
            ? "已签到"
            : isSigned == 3
            ? "签到"
            : "未签到";
    final scoreText = "${item.score ?? 0}";

    return GestureDetector(
      onTap: () => _handleSignTap(item, index),
      child: _buildSignCard(statusText, scoreText, isActive),
    );
  }

  /// 处理签到点击
  Future<void> _handleSignTap(
    MonthlyCheckinConfigDataList item,
    int index,
  ) async {
    // 容错处理：检查签到状态和ID
    if (item.isSigned != 3) {
      Fluttertoast.showToast(msg: "当前无法签到", toastLength: Toast.LENGTH_SHORT);
      return;
    }

    if (item.id == null) {
      Fluttertoast.showToast(msg: "签到数据异常", toastLength: Toast.LENGTH_SHORT);
      return;
    }

    try {
      await Api.addScore({"businessType": 1, "businessId": item.id});

      if (mounted) {
        Fluttertoast.showToast(msg: "签到成功", toastLength: Toast.LENGTH_SHORT);
        await _refreshData();
      }
    } catch (e) {
      debugPrint('签到失败: $e');
      if (mounted) {
        Fluttertoast.showToast(
          msg: "签到失败: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    }
  }

  /// 签到卡片组件
  Widget _buildSignCard(String day, String coin, bool isActive) {
    return Container(
      width: _signCardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(_signActiveColor) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? const Color(_signActiveColor) : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/gole.svg',
            width: _signCardIconSize,
            height: _signCardIconSize,
          ),
          Text(
            coin,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day,
            style: TextStyle(
              color: isActive ? Colors.white70 : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// 日常任务区
  Widget _buildDailyTaskArea(double screenWidth) {
    return Container(
      width: screenWidth,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (mounted) {
                setState(() {
                  _isDailyTaskExpanded = !_isDailyTaskExpanded;
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "日常任务",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(
                  _isDailyTaskExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          if (_isDailyTaskExpanded) ...[
            _buildTaskItem(
              "允许安装应用",
              "可在应用内直接更新",
              "",
              Icons.download,
              "去完成",
              Colors.red[100]!,
              Colors.red,
              () => _handleInstallPermission(),
            ),
            _buildTaskItem(
              "允许存储权限",
              "可在应用内直接更新",
              "",
              Icons.video_collection,
              "去完成",
              Colors.blue[100]!,
              Colors.blue,
              () => _handleStoragePermission(),
            ),
            _buildTaskItem(
              "看广告赚金币",
              "最高得2880金币",
              "",
              Icons.ad_units,
              "去完成",
              Colors.green[100]!,
              Colors.green,
              () => _handleWatchAd(),
            ),
          ],
        ],
      ),
    );
  }

  /// 处理安装权限
  Future<void> _handleInstallPermission() async {
    try {
      if (await RequestMultiplePermissions.checkPermissionGranted(
        Permission.requestInstallPackages,
      )) {
        if (mounted) {
          TDToast.showText('已授权，请勿重复授权', context: context);
        }
        return;
      }
      await RequestMultiplePermissions.requestPermissions(
        Permission.requestInstallPackages,
      );
      await getScore();
    } catch (e) {
      debugPrint('处理安装权限失败: $e');
      if (mounted) {
        TDToast.showText('授权失败', context: context);
      }
    }
  }

  /// 处理存储权限
  Future<void> _handleStoragePermission() async {
    try {
      if (await RequestMultiplePermissions.checkPermissionGranted(
        Permission.storage,
      )) {
        if (mounted) {
          TDToast.showText('已授权，请勿重复授权', context: context);
        }
        return;
      }
      await RequestMultiplePermissions.requestPermissions(Permission.storage);
      await getScore();
    } catch (e) {
      debugPrint('处理存储权限失败: $e');
      if (mounted) {
        TDToast.showText('授权失败', context: context);
      }
    }
  }

  /// 处理观看广告
  Future<void> _handleWatchAd() async {
    try {
      await Ads.loadRewardVideoAd();
      Ads.showRewardVideoAd();
      await getScore();
    } catch (e) {
      debugPrint('观看广告失败: $e');
      if (mounted) {
        TDToast.showText('加载广告失败', context: context);
      }
    }
  }

  /// 普通任务项组件
  Widget _buildTaskItem(
    String title,
    String subTitle,
    String desc,
    IconData icon,
    String buttonText,
    Color iconBgColor,
    Color iconColor,
    VoidCallback onButtonPressed,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        // border: Border.all(color: Colors.grey[100]!),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey[100]!,
        //     blurRadius: 2,
        //     offset: const Offset(0, 1),
        //   ),
        // ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 100),
            child: SizedBox(
              width: 68,
              height: 34,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_buttonBorderRadius),
                  ),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: onButtonPressed,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromARGB(255, 255, 161, 50),
                        const Color.fromARGB(255, 255, 198, 54),
                        const Color.fromARGB(255, 255, 192, 33),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(_buttonBorderRadius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 会员分类兑换区
  Widget _buildVipExchangeArea(double screenWidth) {
    if (memberExchangeConfigDataList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 0, bottom: 8),
                child: Text(
                  "领取视频卡可免费观影",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
              ...memberExchangeConfigDataList.map(
                (item) => RepaintBoundary(child: _buildVipCard(item)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 会员卡片
  Widget _buildVipCard(MemberExchangeConfigDataList item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE0E0FF).withValues(alpha: 0.9),
            const Color(0xFFE0E0FF),
          ],
        ),
        borderRadius: BorderRadius.circular(_vipCardBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/vip.svg', width: 50, height: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.days}天会员',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '剩余: ${item.requiredScore}积分',
                  style: TextStyle(fontSize: 16, color: Colors.orange[300]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 100),
                child: SizedBox(
                  width: 68,
                  height: 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          _buttonBorderRadius,
                        ),
                      ),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () => _handleVipExchange(item),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color.fromARGB(255, 255, 161, 50),
                            const Color.fromARGB(255, 255, 198, 54),
                            const Color.fromARGB(255, 255, 192, 33),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          _buttonBorderRadius,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "立即兑换",
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 处理会员兑换
  Future<void> _handleVipExchange(MemberExchangeConfigDataList item) async {
    // 容错处理：检查ID是否有效
    if (item.id == null) {
      if (mounted) {
        Fluttertoast.showToast(msg: "兑换数据异常", toastLength: Toast.LENGTH_SHORT);
      }
      return;
    }

    try {
      await Api.memberExchange({"userMmemberExchangeId": item.id});
      await getScore();

      if (mounted) {
        Fluttertoast.showToast(msg: "兑换成功", toastLength: Toast.LENGTH_SHORT);
      }
      debugPrint('会员兑换成功: ${item.id}');
    } catch (e) {
      debugPrint('会员兑换失败: $e');
      if (mounted) {
        Fluttertoast.showToast(
          msg: "兑换失败: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    }
  }
}
