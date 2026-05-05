import 'dart:async';

import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/material.dart';

import '../../components/danmaku_view_components.dart';
import '../../data/danmaku_mock_data.dart' as mock_data;

class DanmakuExamplePage extends StatefulWidget {
  const DanmakuExamplePage({super.key});

  @override
  State<DanmakuExamplePage> createState() => _DanmakuExamplePageState();
}

class _DanmakuExamplePageState extends State<DanmakuExamplePage> {
  List<mock_data.DanmakuItem> _danmakuList = [];

  @override
  void initState() {
    super.initState();
    _loadDanmakuData();
  }

  Future<void> _loadDanmakuData() async {
    final list = await mock_data.DanmakuMockData.loadDanmakuData();
    if (mounted) {
      setState(() => _danmakuList = list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('弹幕示例'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _danmakuList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : DanmakuViewComponents(
              danmakuList: _danmakuList,
              overlayWidget: Positioned(
                right: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '我爱你这个文本组件',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              showDanmaku: true,
            ),
    );
  }
}
