import 'dart:convert';
import 'dart:math';

import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/material.dart';

const String _danmakuJsonString = '''
[
  {
    "time": 3000,
    "text": "来了来了",
    "type": "scroll",
    "color": "#FFFFFF"
  },
  {
    "time": 5000,
    "text": "哈哈哈哈哈",
    "type": "scroll",
    "color": "#FF6B6B"
  },
  {
    "time": 8000,
    "text": "太好看了！",
    "type": "scroll",
    "color": "#4ECDC4"
  },
  {
    "time": 1200,
    "text": "前方高能",
    "type": "top",
    "color": "#FFE66D"
  },
  {
    "time": 1500,
    "text": "666",
    "type": "scroll",
    "color": "#95E1D3"
  },
  {
    "time": 1800,
    "text": "awsl",
    "type": "scroll",
    "color": "#F38181"
  },
  {
    "time": 2200,
    "text": "名场面！",
    "type": "top",
    "color": "#AA96DA"
  },
  {
    "time": 2500,
    "text": "泪目了",
    "type": "scroll",
    "color": "#FCBAD3"
  },
  {
    "time": 2800,
    "text": "爷青回",
    "type": "scroll",
    "color": "#FFFFD2"
  },
  {
    "time": 3200,
    "text": "笑死我了",
    "type": "scroll",
    "color": "#A8E6CF"
  },
  {
    "time": 3500,
    "text": "这也太帅了吧",
    "type": "scroll",
    "color": "#FFD3B6"
  },
  {
    "time": 3800,
    "text": "我哭了",
    "type": "bottom",
    "color": "#FFAAA5"
  },
  {
    "time": 4200,
    "text": "绝了",
    "type": "scroll",
    "color": "#FF8B94"
  },
  {
    "time": 4500,
    "text": "这也太可爱了吧",
    "type": "scroll",
    "color": "#FF6F91"
  },
  {
    "time": 4800,
    "text": "啊啊啊啊啊",
    "type": "scroll",
    "color": "#FF9671"
  },
  {
    "time": 5200,
    "text": "我没了",
    "type": "scroll",
    "color": "#FFC75F"
  },
  {
    "time": 5500,
    "text": "神仙打架",
    "type": "top",
    "color": "#F9F871"
  },
  {
    "time": 5800,
    "text": "太燃了",
    "type": "scroll",
    "color": "#D65DB1"
  },
  {
    "time": 6200,
    "text": "这也太美了吧",
    "type": "scroll",
    "color": "#FF6F61"
  },
  {
    "time": 6500,
    "text": "我直接好家伙",
    "type": "scroll",
    "color": "#00C9A7"
  },
  {
    "time": 6800,
    "text": "破防了",
    "type": "scroll",
    "color": "#FFB6B9"
  },
  {
    "time": 7200,
    "text": "这也太厉害了吧",
    "type": "scroll",
    "color": "#FA7070"
  },
  {
    "time": 7500,
    "text": "我直接泪目",
    "type": "scroll",
    "color": "#845EC2"
  },
  {
    "time": 7800,
    "text": "这也太绝了吧",
    "type": "scroll",
    "color": "#D65DB1"
  },
  {
    "time": 8200,
    "text": "我直接跪了",
    "type": "scroll",
    "color": "#FF6F91"
  },
  {
    "time": 8500,
    "text": "这也太强了吧",
    "type": "scroll",
    "color": "#00C9A7"
  },
  {
    "time": 8800,
    "text": "我直接傻了",
    "type": "scroll",
    "color": "#FFC75F"
  },
  {
    "time": 9200,
    "text": "这也太牛了吧",
    "type": "scroll",
    "color": "#F9F871"
  },
  {
    "time": 9500,
    "text": "我直接惊了",
    "type": "scroll",
    "color": "#FF9671"
  },
  {
    "time": 9800,
    "text": "这也太秀了吧",
    "type": "scroll",
    "color": "#FFD3B6"
  }
]
''';

class DanmakuItem {
  final int time;
  final String text;
  final DanmakuItemType type;
  final Color color;

  const DanmakuItem({
    required this.time,
    required this.text,
    this.type = DanmakuItemType.scroll,
    required this.color,
  });

  factory DanmakuItem.fromJson(Map<String, dynamic> json) {
    return DanmakuItem(
      time: json['time'] as int,
      text: json['text'] as String,
      type: _parseDanmakuType(json['type'] as String?),
      color: _parseColor(json['color'] as String?),
    );
  }

  static DanmakuItemType _parseDanmakuType(String? type) {
    switch (type) {
      case 'top':
        return DanmakuItemType.top;
      case 'bottom':
        return DanmakuItemType.bottom;
      case 'scroll':
      default:
        return DanmakuItemType.scroll;
    }
  }

  static Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return _getRandomColor();
    }
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return _getRandomColor();
    }
  }

  static Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }
}

class DanmakuMockData {
  static List<DanmakuItem>? _danmakuList;

  static Future<List<DanmakuItem>> loadDanmakuData() async {
    if (_danmakuList != null) {
      return _danmakuList!;
    }

    try {
      final List<dynamic> jsonList = jsonDecode(_danmakuJsonString) as List<dynamic>;
      _danmakuList = jsonList
          .map((json) => DanmakuItem.fromJson(json as Map<String, dynamic>))
          .toList();
      return _danmakuList!;
    } catch (e) {
      print('加载弹幕数据失败: $e');
      _danmakuList = [];
      return _danmakuList!;
    }
  }

  static List<DanmakuItem> get danmakuList {
    return _danmakuList ?? [];
  }
}

