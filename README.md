# Flutter 影视应用 README 模板

## 项目概述

一个功能完善的跨平台影视娱乐应用，使用 Flutter 框架开发，支持 Android 和 iOS 平台。

## 功能特性

### 核心功能
- 影视资源分类浏览（电影/电视剧/综艺/动漫）
- 热门榜单与个性化推荐
- 智能搜索与筛选

### 播放体验
- 多清晰度选择（720P/1080P/4K）
- 流畅播放技术
- 播放进度同步
- 收藏与历史记录

### 用户系统
- 注册/登录功能
- 个性化设置
- 观看偏好分析

### 社交互动
- 影视评分系统
- 用户评论社区
- 分享功能

## 技术架构

### 主要技术栈
- **框架**: Flutter 3.x
- **状态管理**: Riverpod
- **网络层**: Dio + Retrofit
- **数据存储**: Hive + Isar
- **视频播放**: video_player + chewie
- **UI组件**: 自定义组件 + 部分第三方库

### 项目结构
```markdown
lib/
├── application/           # 业务逻辑
├── domain/                # 领域模型
├── infrastructure/        # 技术实现
├── presentation/          # UI展示
│   ├── pages/             # 页面组件
│   ├── widgets/           # 通用组件
│   └── theme/             # 主题管理
└── main.dart              # 应用入口