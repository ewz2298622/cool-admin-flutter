# Flutter 影视应用

<p align="center">
  <img src="assets/images/app_icon.png" alt="App Logo" width="120" />
</p>

<h3 align="center">一个功能强大的跨平台影视娱乐平台</h3>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-3.x-blue.svg" alt="Flutter Version">
  </a>
  <a href="https://github.com/your-username/cool-flutter-app/stargazers">
    <img src="https://img.shields.io/github/stars/your-username/cool-flutter-app.svg" alt="GitHub Stars">
  </a>
  <a href="https://github.com/your-username/cool-flutter-app/network/members">
    <img src="https://img.shields.io/github/forks/your-username/cool-flutter-app.svg" alt="GitHub Forks">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/your-username/cool-flutter-app.svg" alt="License">
  </a>
</p>

## 📱 项目概述

这是一个基于 Flutter 开发的现代化影视娱乐平台，提供丰富的视频内容和优质的用户体验。应用采用 Clean Architecture 架构模式，具有良好的代码组织结构和可维护性。

### 🎯 核心亮点

- 🚀 **高性能**: 基于 Flutter 框架，提供流畅的用户体验
- 📱 **跨平台**: 一套代码同时支持 Android 和 iOS 平台
- 🔧 **模块化**: 清晰的架构设计，便于维护和扩展
- 💾 **离线支持**: 本地缓存机制，提升访问速度
- 🌐 **国际化**: 支持多语言切换

## 🌟 功能特性

### 🎬 核心功能

| 功能 | 描述 |
|------|------|
| **影视分类** | 电影、电视剧、综艺、动漫四大分类浏览 |
| **智能推荐** | 基于用户行为的个性化内容推荐 |
| **热门榜单** | 实时更新的各类影视排行榜 |
| **高级搜索** | 支持关键词、演员、导演等多维度搜索 |
| **筛选过滤** | 按地区、年份、类型等条件精准筛选 |

### ▶️ 播放体验

- **多清晰度支持**: 720P、1080P、4K 超高清画质选择
- **流畅播放**: 优化的视频加载和缓冲机制
- **断点续播**: 自动记录播放进度，随时继续观看
- **倍速播放**: 支持 0.5x-2x 多种播放速度
- **投屏功能**: 支持 Chromecast 等设备投屏
- **弹幕系统**: 实时弹幕互动体验

### 👤 用户系统

- **账号体系**: 手机号/邮箱注册登录
- **个人中心**: 观看历史、收藏夹、个人信息管理
- **偏好设置**: 个性化主题、播放设置
- **会员服务**: VIP 特权功能和专属内容
- **积分系统**: 观看、签到获取积分奖励

### 🤝 社交互动

- **评分系统**: 五星评分和详细评价
- **评论社区**: 用户讨论和交流平台
- **分享功能**: 一键分享到社交平台
- **关注机制**: 关注喜欢的创作者
- **消息通知**: 系统消息和个人互动提醒

## 🛠 技术架构

### 🏗 整体架构

本项目采用 **Clean Architecture** + **MVVM** 架构模式：

```
lib/
├── core/                   # 核心模块
│   ├── constants/          # 常量定义
│   ├── exceptions/         # 异常处理
│   ├── extensions/         # 扩展方法
│   ├── router/             # 路由管理
│   ├── theme/              # 主题配置
│   └── utils/              # 工具类
├── data/                   # 数据层
│   ├── datasources/        # 数据源
│   ├── models/             # 数据模型
│   └── repositories/       # 仓库实现
├── domain/                 # 领域层
│   ├── entities/           # 实体类
│   ├── repositories/       # 仓库接口
│   └── usecases/           # 业务用例
├── presentation/           # 表现层
│   ├── controllers/        # 控制器
│   ├── pages/              # 页面组件
│   ├── widgets/            # 通用组件
│   └── routes/             # 路由配置
└── main.dart               # 应用入口
```

### 🔧 主要技术栈

| 类别 | 技术/库 | 版本 | 用途 |
|------|---------|------|------|
| **核心框架** | Flutter | 3.x | 跨平台开发框架 |
| **状态管理** | GetX | ^4.6.5 | 状态管理和路由 |
| **网络请求** | Dio | ^4.0.6 | HTTP 客户端 |
| **JSON序列化** | json_serializable | ^6.5.4 | JSON 序列化 |
| **数据库** | Hive | ^2.2.3 | 本地数据存储 |
| **视频播放** | video_player | ^2.4.7 | 视频播放核心 |
| **播放器UI** | chewie | ^1.3.4 | 视频播放器组件 |
| **图片加载** | cached_network_image | ^3.2.1 | 图片缓存加载 |
| **UI组件** | flutter_svg | ^1.1.6 | SVG 图标支持 |
| **下拉刷新** | pull_to_refresh | ^2.0.0 | 下拉刷新组件 |
| **广告集成** | google_mobile_ads | ^2.3.0 | 广告投放 |

### 📊 性能优化

- **懒加载**: 列表和图片按需加载
- **内存管理**: 及时释放未使用的资源
- **缓存策略**: 多级缓存机制提升访问速度
- **代码分割**: 按需加载减少初始包大小
- **原生交互**: 关键功能使用原生实现

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio / VS Code
- Android SDK (Android 开发)
- Xcode (iOS 开发)

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/your-username/cool-flutter-app.git
cd cool-flutter-app
```

2. **获取依赖**
```bash
flutter pub get
```

3. **生成代码**
```bash
flutter pub run build_runner build
```

4. **运行应用**
```bash
# Android
dart run build_runner build && flutter run

# iOS (需要 macOS)
flutter run -d iphone
```

### 环境配置

创建 `lib/core/constants/env.dart` 文件：

```dart
class Env {
  static const String baseUrl = 'https://api.yourdomain.com';
  static const String apiKey = 'your_api_key';
  static const bool isDebug = true;
}
```

## 📖 使用指南

### 基础操作

1. **首页浏览**: 滑动查看推荐内容
2. **分类筛选**: 点击底部导航栏切换分类
3. **搜索功能**: 点击顶部搜索框进行搜索
4. **播放视频**: 点击视频封面开始播放
5. **个人中心**: 点击头像进入个人页面

### 高级功能

- **离线缓存**: 在 WiFi 环境下自动缓存热门内容
- **夜间模式**: 设置中开启深色主题
- **播放记录**: 自动同步观看进度
- **弹幕设置**: 调整弹幕透明度和大小

## 🤝 贡献指南

我们欢迎任何形式的贡献！

### 贡献流程

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 代码规范

- 遵循 Flutter 官方编码规范
- 使用 dartfmt 格式化代码
- 添加必要的注释和文档
- 编写单元测试覆盖核心功能

## 📱 屏幕截图

<div style="display: flex; justify-content: space-around;">
  <img src="screenshots/home.png" width="200" alt="首页">
  <img src="screenshots/detail.png" width="200" alt="详情页">
  <img src="screenshots/player.png" width="200" alt="播放器">
  <img src="screenshots/profile.png" width="200" alt="个人中心">
</div>

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 🙏 致谢

- [Flutter](https://flutter.dev/) - 强大的跨平台开发框架
- [GetX](https://pub.dev/packages/get) - 优秀的状态管理解决方案
- [Dio](https://pub.dev/packages/dio) - 强大的 HTTP 客户端
- 所有开源贡献者和支持者

## 📞 联系方式

- **作者**: Your Name
- **邮箱**: your.email@example.com
- **GitHub**: [@your-username](https://github.com/your-username)

---

<p align="center">Made with ❤️ using Flutter</p>