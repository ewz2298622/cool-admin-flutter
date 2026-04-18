import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/score_withdrawal_config_entity.dart';

/// 现金页面
class CashPage extends StatefulWidget {
  const CashPage({super.key});

  @override
  CashPageState createState() => CashPageState();
}

class CashPageState extends State<CashPage> {
  late Future<String> _futureBuilderFuture;
  double balance = 0.00;
  double todayScore = 80;
  bool _isLoading = false;
  int score = 0;

  List<ScoreWithdrawalConfigDataList> scoreWithdrawalConfigList = [];

  // 常量定义
  static const double _toolbarHeight = 40.0;
  static const double _iconSize = 20.0;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 页面显示时刷新积分数据
    getScore();
    getCashData();
  }

  /// 获取积分
  Future<void> getScore() async {
    try {
      score = (await Api.getUserScore({})).data ?? 0;
      balance = score / 1000;
      setState(() {});
    } catch (e) {
      debugPrint('getScore failed: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// 获取现金数据
  Future<void> getCashData() async {
    try {
      scoreWithdrawalConfigList =
          (await Api.scoreWithdrawalConfig({})).data?.list
              as List<ScoreWithdrawalConfigDataList>;
      // final response = await Api.getCashData({});
      // balance = response.data?.balance ?? 0.0;
      // todayScore = response.data?.todayScore ?? 0;

      setState(() {});
    } catch (e) {
      debugPrint('getCashData failed: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// 初始化数据
  Future<String> init() async {
    try {
      if (!mounted) return "init failed";

      await getCashData();
      await getScore();
      debugPrint("CashPage init success");
      return "init success";
    } catch (e) {
      debugPrint("CashPage init failed: $e");
      return "init failed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: _iconSize,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed("/cash_order");
            },
            child: const Text(
              '收益明细',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     // TODO: 跳转到规则页面
          //   },
          //   child: const Text(
          //     '规则',
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.black87,
          //     ),
          //   ),
          // ),
        ],
        toolbarHeight: _toolbarHeight,
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
            return Container(
              color: const Color(0xFFF5F5F5),
              child: Stack(
                children: [
                  // 背景渐变层
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 300,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 300,
                          child: ShaderMask(
                            shaderCallback:
                                (bounds) => LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.0),
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
                    child: Column(
                      children: [
                        _buildBalanceArea(screenWidth),
                        _buildWithdrawArea(screenWidth),
                        // _buildLimitedActivityArea(screenWidth),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          default:
            return const PageLoading();
        }
      },
    );
  }

  /// 余额区域
  Widget _buildBalanceArea(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的余额（元）',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1.45,
              color: Color.fromRGBO(130, 116, 96, 1),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            balance.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        '今日金币收益：',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          height: 1.45,
                          color: Color(0xFF999999),
                        ),
                      ),
                      Text(
                        '${score.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          height: 1.45,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '兑换现金',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF9500),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '提现会由于提现渠道不同，存在提现延迟，请耐心等待 请确认账号知否绑定支付宝登支付账户 活动截止时间由公告中确认。',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                  height: 1.45,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 签到区域
  Widget _buildSignInArea(double screenWidth) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '签到 7 天，提现 2.8 元',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '余额不足',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '剩余 30 天',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF9500),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '当前余额不足，满足金额后可提现',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                return _buildSignDayCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 签到天数卡片
  Widget _buildSignDayCard(int index) {
    final amounts = [0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 1.0];
    final labels = [
      '余额不足',
      '第 2 天',
      '第 3 天',
      '第 4 天',
      '第 5 天',
      '第 6 天',
      '第 7 天',
    ];
    final isLast = index == 6;

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFE8F4FF),
                  isLast ? const Color(0xFFFFE8D8) : const Color(0xFF4099FF),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${amounts[index]}元',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isLast
                            ? const Color(0xFFFF9500)
                            : const Color(0xFF4099FF),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 32,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.payment,
                    size: 14,
                    color: Color(0xFF4099FF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            labels[index],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  /// 提现区域
  Widget _buildWithdrawArea(double screenWidth) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '余额提现',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                scoreWithdrawalConfigList.map((item) {
                  return _buildWithdrawCard(
                    item.id ?? 0,
                    item.amount ?? 0,
                    item.score ?? 0,
                    screenWidth,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  /// 提现卡片
  Widget _buildWithdrawCard(
    int id,
    int amount,
    int requiredScore,
    double screenWidth,
  ) {
    return GestureDetector(
      onTap: () {
        if (score >= requiredScore) {
          // TODO: 执行提现逻辑
          showGeneralDialog(
            context: context,
            pageBuilder: (
              BuildContext buildContext,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return TDAlertDialog(
                title: "提醒",
                content: "兑换后金币将被清零，请问是否需要兑换",
                buttonStyle: TDDialogButtonStyle.text,
                rightBtnAction: () async {
                  Get.back();
                  await Api.createWithdrawal({"type": id});
                  await getCashData();
                  await getScore();
                  Fluttertoast.showToast(
                    msg: "提现成功，将会在三天内到账",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                },
              );
            },
          );
        } else {
          Fluttertoast.showToast(msg: "金币不足", toastLength: Toast.LENGTH_SHORT);
        }
      },
      child: Container(
        width: (screenWidth - 48) / 2,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFFE8A8), const Color(0xFFFFD46E)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 20,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8924A),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      amount.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB8924A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '提现$amount',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "提现需要$requiredScore",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 限时活动区域
  Widget _buildLimitedActivityArea(double screenWidth) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '限时活动',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActivityCard(
                '0.1 元现金红包',
                '提现立即到账',
                '立即提现',
                const Color(0xFFFFE8E8),
                const Color(0xFFFF6B6B),
                'assets/images/red_packet.png',
              ),
              const SizedBox(width: 12),
              _buildActivityCard(
                '砸蛋得好礼',
                '得金币、提现卡',
                '砸金蛋',
                const Color(0xFFFFF8E8),
                const Color(0xFFFFB84D),
                'assets/images/egg.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 活动卡片
  Widget _buildActivityCard(
    String title,
    String subtitle,
    String buttonText,
    Color bgColor,
    Color accentColor,
    String imagePath,
  ) {
    return Container(
      width: 160,
      height: 220,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // 图片占位
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.card_giftcard, size: 40, color: accentColor),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999999),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
