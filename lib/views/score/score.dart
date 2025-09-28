import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ScoreCenterPage extends StatelessWidget {
  const ScoreCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('积分中心'), centerTitle: true, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 我的资产区域
            _buildAssetSection(),

            // 主要兑换区
            _buildExchangeSection(),

            // 限时活动
            _buildLimitedTimeActivity(),

            // 每日签到
            _buildDailyCheckIn(),

            // 日常任务
            _buildDailyTasks(context),
          ],
        ),
      ),
    );
  }

  /// 我的资产区域
  Widget _buildAssetSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '我的资产',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '404',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text('积分', style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          SizedBox(height: 16),
          TDButton(
            text: '积分明细',
            size: TDButtonSize.large,
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// 主要兑换区
  Widget _buildExchangeSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '主要兑换区',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              _buildExchangeCard(
                '少量积分\n兑换',
                Icons.card_giftcard_outlined,
                Color(0xFFFF9A9E),
              ),
              SizedBox(width: 16),
              _buildExchangeCard(
                '大量积分\n兑换',
                Icons.workspace_premium_outlined,
                Color(0xFFA1C4FD),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 兑换卡片
  Widget _buildExchangeCard(String title, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: color),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 限时活动
  Widget _buildLimitedTimeActivity() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '限时活动',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '看10秒，领会员',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 16),
                TDButton(
                  text: '立即参与',
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  theme: TDButtonTheme.light,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Icon(Icons.local_fire_department, color: Colors.white, size: 60),
        ],
      ),
    );
  }

  /// 每日签到
  Widget _buildDailyCheckIn() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '每日签到',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '连续签到7天可获得递增的金币奖励',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCheckInDay('第1天\n10金币', true),
              _buildCheckInDay('第2天\n30金币', true),
              _buildCheckInDay('第3天\n50金币', true),
              _buildCheckInDay('第4天\n80金币', true),
              _buildCheckInDay('第5天\n120金币', true),
              _buildCheckInDay('第6天\n150金币', false),
              _buildCheckInDay('第7天\n188金币', false),
            ],
          ),
          SizedBox(height: 16),
          TDButton(
            text: '今日签到领取188金币',
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            theme: TDButtonTheme.primary,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// 签到日期组件
  Widget _buildCheckInDay(String text, bool isChecked) {
    List<String> parts = text.split('\n');
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isChecked ? Color(0xFF4CAF50) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            parts[0].replaceAll('第', '').replaceAll('天', ''),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Text(
          parts[1],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isChecked ? Color(0xFF4CAF50) : Colors.grey,
          ),
        ),
      ],
    );
  }

  /// 日常任务
  Widget _buildDailyTasks(BuildContext context) {
    List<Map<String, dynamic>> tasks = [
      {'title': '下载"得物"App', 'points': 1888, 'icon': Icons.download_outlined},
      {
        'title': '访问"快手极速版"',
        'points': 588,
        'icon': Icons.open_in_browser_outlined,
      },
      {'title': '看广告赚积分', 'points': 2880, 'icon': Icons.video_library_outlined},
    ];

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '日常任务',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...tasks.map((task) => _buildTaskItem(task, context)).toList(),
        ],
      ),
    );
  }

  /// 任务项
  Widget _buildTaskItem(Map<String, dynamic> task, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(task['icon'], color: Theme.of(context).primaryColor),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  '+${task['points']}积分',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TDButton(
            text: '去完成',
            size: TDButtonSize.small,
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
