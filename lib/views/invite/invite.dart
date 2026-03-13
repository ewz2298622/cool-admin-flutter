import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../components/loading.dart';
import '../../utils/share_util.dart';

/// 邀请中心页面
class InviteCenterPage extends StatefulWidget {
  const InviteCenterPage({super.key});

  @override
  InviteCenterPageState createState() => InviteCenterPageState();
}

class InviteCenterPageState extends State<InviteCenterPage> {
  late Future<String> _futureBuilderFuture;
  bool _isLoading = false;

  // 假数据
  final String inviteCode = 'AK233';
  final int totalInvites = 8;
  final List<Map<String, dynamic>> inviteRecords = [
    {
      'avatar': 'assets/images/monkey.png',
      'title': '使用时长大于 30s',
      'time': '2023.07.11 20:55:45',
      'score': 40,
    },
    {
      'avatar': 'assets/images/monkey.png',
      'title': '使用时长大于 30s',
      'time': '2023.07.11 20:55:45',
      'score': 40,
    },
  ];

  // 常量定义
  static const double _toolbarHeight = 40.0;
  static const double _iconSize = 20.0;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
  }

  /// 获取邀请数据
  Future<void> getInviteData() async {
    try {
      if (!mounted || _isLoading) return;
      _isLoading = true;

      // 模拟网络请求延迟
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('getInviteData failed: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// 初始化数据
  Future<String> init() async {
    try {
      if (!mounted) return "init failed";

      await getInviteData();

      debugPrint("InviteCenterPage init success");
      return "init success";
    } catch (e) {
      debugPrint("InviteCenterPage init failed: $e");
      return "init failed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6BB6FF),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: _iconSize,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "邀请好友",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        toolbarHeight: _toolbarHeight,
      ),
      body: SafeArea(top: true, child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
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
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '加载失败：${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
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
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                spacing: 10,
                children: [
                  _buildInviteCard(),
                  _buildActionButtons(),
                  _buildInviteRecords(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          default:
            return const PageLoading();
        }
      },
    );
  }

  /// 邀请卡片（二维码区域）
  Widget _buildInviteCard() {
    return Container(
      width: 305,
      height: 306,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        image: const DecorationImage(
          image: AssetImage('assets/images/share_banner.png'),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// 操作按钮区域
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 分享给好友按钮
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF58AAFF), Color(0xFF2992FF)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextButton(
              onPressed: _handleShareApp,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                '分享给好友',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // 填写邀请码按钮
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.34),
                  Color.fromRGBO(255, 255, 255, 0),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextButton(
              onPressed: _handleInputInviteCode,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                '复制邀请码',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 邀请记录区域
  Widget _buildInviteRecords() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 标题
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBAE7FF), Color(0xFF69C0FF)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Text(
                '累计邀请',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF40A9FF),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBAE7FF), Color(0xFF69C0FF)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 记录列表
          ...inviteRecords.map((record) => _buildRecordItem(record)),
          const SizedBox(height: 12),
          const Text(
            '没有更多啦',
            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  /// 单条邀请记录
  Widget _buildRecordItem(Map<String, dynamic> record) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          // 头像
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.person, color: Color(0xFF69C0FF), size: 28),
          ),
          const SizedBox(width: 12),
          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record['time'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          // 积分
          Text(
            '+${record['score']}积分',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFB03A),
            ),
          ),
        ],
      ),
    );
  }

  /// 复制邀请码
  void _copyInviteCode() {
    Clipboard.setData(ClipboardData(text: inviteCode));
    TDToast.showText('已复制', context: context);
  }

  /// 处理输入邀请码
  void _handleInputInviteCode() {
    //复制字符串到剪贴板
    Clipboard.setData(ClipboardData(text: inviteCode));
  }

  /// 处理分享应用
  Future<void> _handleShareApp() async {
    try {
      ShareUtil.shareImage();
    } catch (e) {
      debugPrint('分享应用失败：$e');
      if (mounted) {
        TDToast.showText('分享失败', context: context);
      }
    }
  }
}
