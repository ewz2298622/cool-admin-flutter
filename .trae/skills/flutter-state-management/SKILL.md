---
name: "flutter-state-management"
description: "Flutter 状态管理最佳实践。Invoke when: 1) 需要管理应用状态 2) 实现用户登录状态 3) 主题切换 4) 数据共享 between widgets"
---

# Flutter 状态管理最佳实践

## 项目使用的状态管理方案
本项目使用 **Provider + GetX** 混合模式：
- **Provider**: 用于应用级状态管理（用户、主题等）
- **GetX**: 用于路由管理和简单状态

## 目录结构
```
lib/utils/store/
├── app/
│   └── appState.dart           # 应用全局状态
├── home/
│   └── color_notifier.dart     # 首页颜色状态
├── ranking/
│   └── ranking_background_notifier.dart  # 排行榜背景
├── theme/
│   └── theme.dart              # 主题状态
└── user/
    └── user.dart               # 用户状态
```

## Provider 使用规范

### 1. 定义状态类
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app/entity/user_info_entity.dart';

class UserStore extends ChangeNotifier {
  UserInfoEntity? _userInfo;
  bool _isLogin = false;
  
  UserInfoEntity? get userInfo => _userInfo;
  bool get isLogin => _isLogin;
  
  void setUserInfo(UserInfoEntity userInfo) {
    _userInfo = userInfo;
    _isLogin = true;
    notifyListeners();
  }
  
  void logout() {
    _userInfo = null;
    _isLogin = false;
    notifyListeners();
  }
}
```

### 2. 在 main.dart 中注册
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserStore()),
        ChangeNotifierProvider(create: (_) => ThemeStore()),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MyApp(),
    ),
  );
}
```

### 3. 在页面中使用
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return Scaffold(
          body: userStore.isLogin 
            ? Text('欢迎, ${userStore.userInfo?.nickname}')
            : LoginButton(),
        );
      },
    );
  }
}
```

### 4. 选择性监听
```dart
// 只监听特定字段
class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<UserStore, String?>(
      selector: (store) => store.userInfo?.avatar,
      builder: (context, avatar, child) {
        return CircleAvatar(
          backgroundImage: avatar != null ? NetworkImage(avatar) : null,
        );
      },
    );
  }
}
```

## GetX 使用规范

### 1. 路由管理
```dart
// 定义路由
class AppPages {
  static final routes = [
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/detail/:id', page: () => VideoDetailPage()),
    GetPage(name: '/login', page: () => LoginPage()),
  ];
}

// 跳转页面
Get.toNamed('/detail/123');
Get.offNamed('/home');  // 清除之前的路由
Get.back();  // 返回
```

### 2. 简单状态管理
```dart
class CountController extends GetxController {
  var count = 0.obs;
  
  void increment() {
    count++;
  }
}

// 使用
class CounterPage extends StatelessWidget {
  final controller = Get.put(CountController());
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text('Count: ${controller.count}'));
  }
}
```

## 状态管理最佳实践

### 1. 状态分类
| 状态类型 | 管理方式 | 示例 |
|---------|---------|------|
| 应用级状态 | Provider | 用户信息、登录状态 |
| 页面级状态 | StatefulWidget | 表单输入、加载状态 |
| 临时状态 | GetX | 计数器、开关状态 |
| 共享状态 | Provider | 主题、语言设置 |

### 2. 避免过度使用
```dart
// ❌ 错误：所有状态都用 Provider
// ✅ 正确：简单状态用 StatefulWidget
class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _keyword = '';  // 页面级状态，不需要 Provider
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => setState(() => _keyword = value),
    );
  }
}
```

### 3. 状态初始化
```dart
class VideoDetailPage extends StatefulWidget {
  final int videoId;
  
  VideoDetailPage({required this.videoId});
  
  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late Future<VideoDetailEntity> _videoFuture;
  
  @override
  void initState() {
    super.initState();
    _videoFuture = VideoApi.getDetail(widget.videoId);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _videoFuture,
      builder: (context, snapshot) {
        // 处理不同状态
      },
    );
  }
}
```

## 常用模式

### 1. 用户登录状态管理
```dart
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        if (userStore.isLogin) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}
```

### 2. 主题切换
```dart
class ThemeStore extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
}

// 在 MaterialApp 中使用
MaterialApp(
  themeMode: context.watch<ThemeStore>().themeMode,
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
)
```

### 3. 数据缓存
```dart
class VideoCacheStore extends ChangeNotifier {
  final Map<int, VideoDetailEntity> _cache = {};
  
  VideoDetailEntity? getVideo(int id) => _cache[id];
  
  void cacheVideo(VideoDetailEntity video) {
    _cache[video.id] = video;
    notifyListeners();
  }
}
```
