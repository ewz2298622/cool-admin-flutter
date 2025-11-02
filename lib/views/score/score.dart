import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/member_exchange_config_entity.dart';
import '../../entity/monthly_checkinConfig_entity.dart';
import '../../utils/ads.dart';
import '../../utils/requestMultiplePermissions.dart';

class TaskCenterPage extends StatefulWidget {
  const TaskCenterPage({super.key});

  @override
  TaskCenterPageState createState() => TaskCenterPageState();
}

class TaskCenterPageState extends State<TaskCenterPage> {
  var _futureBuilderFuture;
  bool _isDailyTaskExpanded = true; // 控制日常任务区域是否展开
  bool _isSignTaskExpanded = true; // 控制签到任务区域是否展开
  int score = 0;
  List<MemberExchangeConfigDataList> memberExchangeConfigDataList = [];
  //签到数据
  List<MonthlyCheckinConfigDataList> signData = [];

  // 天气图标列表
  final List<IconData> weatherIcons = [
    Icons.wb_sunny, // 晴天
    Icons.cloud, // 多云
    Icons.grain, // 雨天
    Icons.ac_unit, // 雪天
    Icons.thunderstorm, // 雷暴
    Icons.foggy, // 雾天
    Icons.nightlight, // 月亮（备用）
  ];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  //获取会员配置
  Future<void> getMemberConfig() async {
    memberExchangeConfigDataList =
        (await Api.getMemberConfig({})).data?.list ??
        [] as List<MemberExchangeConfigDataList>;
  }

  //获取积分
  Future<void> getScore() async {
    score = (await Api.getUserScore({})).data ?? 0;
    setState(() {});
  }

  //获取当月签到数据
  Future<void> getSignData() async {
    signData = (await Api.getSignInData({})).data?.list ?? [];
    setState(() {});
  }

  Future<String> init() async {
    try {
      //使用并发
      await Future.wait([
        getScore(), // 获取用户积分
        getMemberConfig(), // 获取会员配置信息
        getSignData(),
      ]);
      debugPrint("TaskCenterPage init success");
      return "init success";
    } catch (e) {
      debugPrint("TaskCenterPage init failed: $e");
      return "init failed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("任务中心", style: TextStyle(fontSize: 16)),
        //返回按钮
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
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor, // 使用主题背景色
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                // 金币与会员兑换区
                _buildCoinVipArea(screenWidth),

                // 会员分类兑换区
                _buildVipExchangeArea(screenWidth),

                // 签到任务区
                _buildSignTaskArea(screenWidth),

                // 日常任务区
                _buildDailyTaskArea(screenWidth),
              ],
            ),
          );
        }
      },
    );
  }

  // 顶部栏
  Widget _buildTopBar(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "任务中心",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text("规则", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // 金币与会员兑换区
  Widget _buildCoinVipArea(double screenWidth) {
    return Container(
      width: screenWidth,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 1),
      child: Column(
        children: [
          // 我的金币
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7D00),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "我的金币",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      score.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF7D00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 添加圆角
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed("/score_order");
                  },
                  child: const Text("金币账单", style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 签到任务区
  Widget _buildSignTaskArea(double screenWidth) {
    if (signData.isNotEmpty) {
      final coin =
          signData
              .where((element) => element.day == DateTime.now().day)
              .firstWhere(
                (element) => element.day == DateTime.now().day,
                orElse: () => MonthlyCheckinConfigDataList(),
              )
              .score ??
          0;

      return Container(
        width: screenWidth,
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "今日签到领 $coin金币",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignTaskExpanded = !_isSignTaskExpanded;
                    });
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
              // 连续签到进度
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(signData.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        if (signData[index].isSigned == 3) {
                          // 签到
                          try {
                            await Api.addScore({
                              "businessType": 1,
                              "businessId": signData[index].id,
                            });
                            Fluttertoast.showToast(
                              msg: "签到成功",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                            getSignData();
                            getScore();
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: "签到失败",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "当前无法签到",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                      },
                      child: _buildSignCard(
                        signData[index].isSigned == 1
                            ? "已签到"
                            : signData[index].isSigned == 3
                            ? "签到"
                            : "未签到",
                        "${(signData[index].score ?? 0)}",
                        signData[index].isSigned == 3,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  // 签到卡片组件
  Widget _buildSignCard(String day, String coin, bool isActive) {
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFF3B30) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? const Color(0xFFFF3B30) : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/gole.svg',
            width: 20,
            height: 20,
          ), // 使用奖章图标代替金币图标
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

  // 日常任务区
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
              setState(() {
                _isDailyTaskExpanded = !_isDailyTaskExpanded;
              });
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
            // 任务列表
            _buildTaskItem(
              "允许安装应用",
              "可在应用内直接更新",
              "",
              Icons.download,
              "去授权",
              Colors.red[100]!,
              Colors.red,
              () async {
                if (await RequestMultiplePermissions.checkPermissionGranted(
                  Permission.requestInstallPackages,
                )) {
                  return TDToast.showText('已授权，请勿重复授权', context: context);
                }
                await RequestMultiplePermissions.requestPermissions(
                  Permission.requestInstallPackages,
                );
                getScore();
              },
            ),
            _buildTaskItem(
              "允许存储权限",
              "可在应用内直接更新",
              "",
              Icons.video_collection,
              "去授权",
              Colors.blue[100]!,
              Colors.blue,
              () async {
                if (await RequestMultiplePermissions.checkPermissionGranted(
                  Permission.storage,
                )) {
                  return TDToast.showText('已授权，请勿重复授权', context: context);
                }
                await RequestMultiplePermissions.requestPermissions(
                  Permission.storage,
                );
                getScore();
              },
            ),
            _buildTaskItem(
              "看广告赚金币",
              "最高得2880金币",
              "",
              Icons.ad_units,
              "领福利",
              Colors.green[100]!,
              Colors.green,
              () async {
                await Ads.loadRewardVideoAd();
                Ads.showRewardVideoAd();
                getScore();
              },
            ),
            // _buildVideoTask(
            //   "看短视频任务",
            //   "再看30秒，可得10金币",
            //   Icons.video_camera_back,
            //   "去观看",
            //   Colors.blue[100]!,
            //   Colors.blue,
            // ),
          ],
        ],
      ),
    );
  }

  // 普通任务项组件
  Widget _buildTaskItem(
    String title,
    String subTitle,
    String desc,
    IconData icon,
    String buttonText,
    Color iconBgColor,
    Color iconColor,
    VoidCallback onButtonPressed, // 添加按钮点击回调函数参数
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100]!,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(6),
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

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7D00),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 添加圆角
                ),
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: onButtonPressed, // 使用传入的回调函数
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  // 视频任务项组件
  Widget _buildVideoTask(
    String title,
    String subTitle,
    IconData icon,
    String buttonText,
    Color iconBgColor,
    Color iconColor,
    VoidCallback onButtonPressed, // 添加按钮点击回调函数参数
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100]!,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(6),
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
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 100),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7D00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 添加圆角
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  onPressed: onButtonPressed, // 使用传入的回调函数
                  child: Text(buttonText),
                ),
              ),
            ],
          ),

          // 时长-金币进度
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeCoinItem("10金币", "30秒"),
                _buildTimeCoinItem("10金币", "1分钟"),
                _buildTimeCoinItem("20金币", "2分钟"),
                _buildTimeCoinItem("60金币", "5分钟"),
                _buildTimeCoinItem("100金币", "10分钟"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 时长-金币项
  Widget _buildTimeCoinItem(String coin, String time) {
    return Column(
      children: [
        Text(
          coin,
          style: const TextStyle(fontSize: 10, color: Color(0xFFFF7D00)),
        ),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // 会员分类兑换区
  Widget _buildVipExchangeArea(double screenWidth) {
    return Container(
      width: screenWidth,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 视频7天卡分类
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
              // 使用ListView.builder根据memberExchangeConfigDataList动态创建会员卡片
              ...memberExchangeConfigDataList
                  .map((item) => _buildVipCard(item))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  //会员卡片
  Widget _buildVipCard(MemberExchangeConfigDataList item) {
    return Container(
      decoration: BoxDecoration(
        //从左到右紫色渐变
        gradient: LinearGradient(
          colors: [
            Color(0xFFE0E0FF).withOpacity(0.9), // 浅淡紫色
            Color(0xFFE0E0FF), // 淡紫色
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/vip.svg', width: 50, height: 50),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.days}天会员',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '剩余: ${item.requiredScore}积分',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange[300], // 橙色文字
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // 按钮背景色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  // 按钮点击事件
                  await Api.memberExchange({"userMmemberExchangeId": item.id});
                  await getScore();
                  Fluttertoast.showToast(
                    msg: "兑换成功",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                  debugPrint('点击了会员兑换按钮');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    '立即兑换',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
