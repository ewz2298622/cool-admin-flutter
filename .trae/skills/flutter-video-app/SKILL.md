---
name: "flutter-video-app"
description: "橘子剧场 Flutter 视频应用开发规范。Invoke when: 1) 创建新的视频相关页面或组件 2) 处理视频播放功能 3) 实现视频列表/详情/筛选功能 4) 添加广告或会员功能"
---

# 橘子剧场 Flutter 视频应用开发规范

## 项目概述
- **项目名称**: 橘子剧场 (flutter_app)
- **版本**: 1.3.1
- **Flutter SDK**: ^3.7.2
- **应用类型**: 视频播放应用，支持短视频、直播、专辑等功能

## 核心依赖
```yaml
dio: ^5.8.0+1                    # HTTP 请求
video_player: ^2.9.3            # 视频播放
fplayer: ^1.1.3                 # 播放器
provider: ^6.1.5                # 状态管理
get: ^4.7.2                     # 路由管理
shared_preferences: ^2.5.3      # 本地存储
sqlite3: ^2.7.5                 # 数据库
event_bus: ^2.0.1               # 事件总线
flutter_unionad: ^2.1.12        # 广告 SDK
tdesign_flutter: ^0.2.4         # UI 组件库
```

## 项目结构
```
lib/
├── main.dart                    # 应用入口
├── api/                         # API 接口定义
├── components/                  # 公共组件
│   ├── common/                  # 通用组件
│   ├── video_*.dart            # 视频相关组件
│   └── banner_ads.dart         # 广告组件
├── db/                          # 数据库
│   ├── entity/                  # 数据实体
│   └── manager/                 # 数据库管理
├── entity/                      # 业务实体
├── generated/json/              # JSON 序列化
├── http/                        # HTTP 拦截器
├── services/                    # 服务层
├── style/                       # 样式定义
├── utils/                       # 工具类
│   └── store/                   # 状态存储
└── views/                       # 页面视图
```

## 代码规范

### 1. 文件命名
- 页面文件: `snake_case.dart` (如: `video_detail.dart`)
- 组件文件: `snake_case.dart` (如: `video_player.dart`)
- 实体文件: `snake_case_entity.dart` (如: `video_entity.dart`)
- 工具文件: `snake_case.dart` (如: `date_util.dart`)

### 2. 类命名
- 页面类: `PascalCase` + 后缀 (如: `VideoDetailPage`, `HomePage`)
- 组件类: `PascalCase` (如: `VideoPlayerWidget`)
- 实体类: `PascalCase` + `Entity` (如: `VideoEntity`)
- 工具类: `PascalCase` + `Util` (如: `DateUtil`)

### 3. 状态管理
使用 Provider + GetX 混合模式:
```dart
// 状态定义
class UserState extends ChangeNotifier {
  UserEntity? _user;
  UserEntity? get user => _user;
  
  void setUser(UserEntity user) {
    _user = user;
    notifyListeners();
  }
}

// 页面使用
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserState(),
      child: _MyPageContent(),
    );
  }
}
```

### 4. API 调用规范
```dart
// 统一使用封装的 Request 类
import 'package:flutter_app/http/request.dart';

class VideoApi {
  static Future<VideoEntity> getVideoDetail(int id) async {
    final response = await Request.get('/video/detail', params: {'id': id});
    return VideoEntity.fromJson(response.data);
  }
}
```

### 5. 视频组件规范
```dart
// 视频播放组件
class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool autoPlay;
  
  const VideoPlayerWidget({
    Key? key,
    required this.url,
    this.autoPlay = false,
  }) : super(key: key);
  
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}
```

### 6. 广告集成规范
```dart
// 使用 flutter_unionad
import 'package:flutter_unionad/flutter_unionad.dart';

class BannerAdsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterUnionadBannerView(
      androidCodeId: AdsConfig.bannerId,
      iosCodeId: AdsConfig.bannerId,
      width: 300,
      height: 150,
    );
  }
}
```

### 7. 数据库操作规范
```dart
// 使用 sqlite3
class VideoHistoryHelper {
  static final VideoHistoryHelper _instance = VideoHistoryHelper._internal();
  factory VideoHistoryHelper() => _instance;
  VideoHistoryHelper._internal();
  
  Future<void> insertHistory(VideoEntity video) async {
    final db = await DBManager().database;
    // 实现插入逻辑
  }
}
```

## 页面开发模板

### 新页面模板
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/style/layout.dart';
import 'package:flutter_app/components/loading.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);
  
  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _initData();
  }
  
  Future<void> _initData() async {
    // 初始化数据
    setState(() => _isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.background,
      appBar: AppBar(
        title: Text('页面标题'),
        backgroundColor: ColorStyles.primary,
      ),
      body: _isLoading 
        ? LoadingWidget() 
        : _buildContent(),
    );
  }
  
  Widget _buildContent() {
    return Container();
  }
}
```

## 注意事项
1. 所有页面必须使用 `ColorStyles` 定义的颜色
2. 视频播放页面需要处理生命周期，页面销毁时释放资源
3. 广告展示需要遵循平台政策
4. 数据库操作需要异步处理，避免阻塞 UI
5. 图片资源统一放在 `assets/images/` 目录
