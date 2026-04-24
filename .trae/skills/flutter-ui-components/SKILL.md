---
name: "flutter-ui-components"
description: "Flutter UI 组件开发规范。Invoke when: 1) 创建新的 UI 组件 2) 实现视频列表/卡片 3) 添加广告组件 4) 实现筛选/搜索功能"
---

# Flutter UI 组件开发规范

## 项目使用的 UI 库
- **tdesign_flutter**: ^0.2.4 - 腾讯 TDesign 组件库
- **flutter_svg**: ^2.0.17 - SVG 图标支持
- **pull_to_refresh**: ^2.0.0 - 下拉刷新
- **flutter_sticky_header**: ^0.7.0 - 粘性头部

## 组件目录结构
```
lib/components/
├── common/                      # 通用组件
│   ├── common_filter_bar.dart  # 筛选栏
│   ├── common_search_bar.dart  # 搜索栏
│   └── filter_row.dart         # 筛选行
├── video_*.dart                # 视频相关组件
├── banner_ads.dart             # 横幅广告
├── loading.dart                # 加载组件
├── no_data.dart                # 空数据组件
└── ...
```

## 样式规范

### 1. 颜色定义 (lib/style/color_styles.dart)
```dart
class ColorStyles {
  // 主色调
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8A5B);
  static const Color primaryDark = Color(0xFFE55A2B);
  
  // 背景色
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // 文字色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  
  // 功能色
  static const Color success = Color(0xFF52C41A);
  static const Color warning = Color(0xFFFAAD14);
  static const Color error = Color(0xFFF5222D);
}
```

### 2. 文字样式 (lib/style/text_styles.dart)
```dart
class TextStyles {
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ColorStyles.textPrimary,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ColorStyles.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: ColorStyles.textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: ColorStyles.textTertiary,
  );
}
```

### 3. 布局常量 (lib/style/layout.dart)
```dart
class Layout {
  // 边距
  static const double paddingXS = 4;
  static const double paddingSM = 8;
  static const double paddingMD = 16;
  static const double paddingLG = 24;
  static const double paddingXL = 32;
  
  // 圆角
  static const double radiusSM = 4;
  static const double radiusMD = 8;
  static const double radiusLG = 12;
  static const double radiusXL = 16;
  
  // 间距
  static const double gapXS = 4;
  static const double gapSM = 8;
  static const double gapMD = 12;
  static const double gapLG = 16;
  static const double gapXL = 24;
}
```

## 组件开发模板

### 1. 视频卡片组件
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app/entity/video_entity.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/style/layout.dart';
import 'package:flutter_app/style/text_styles.dart';

class VideoCard extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback? onTap;
  final double width;
  
  const VideoCard({
    Key? key,
    required this.video,
    this.onTap,
    this.width = 160,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: ColorStyles.cardBackground,
          borderRadius: BorderRadius.circular(Layout.radiusMD),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Layout.radiusMD),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  video.cover ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: ColorStyles.background,
                    child: Icon(Icons.image, color: ColorStyles.textTertiary),
                  ),
                ),
              ),
            ),
            // 标题
            Padding(
              padding: EdgeInsets.all(Layout.paddingSM),
              child: Text(
                video.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.bodyMedium,
              ),
            ),
            // 播放量
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Layout.paddingSM),
              child: Row(
                children: [
                  Icon(Icons.play_circle_outline, 
                    size: 14, 
                    color: ColorStyles.textTertiary,
                  ),
                  SizedBox(width: Layout.gapXS),
                  Text(
                    _formatCount(video.viewCount ?? 0),
                    style: TextStyles.caption,
                  ),
                ],
              ),
            ),
            SizedBox(height: Layout.paddingSM),
          ],
        ),
      ),
    );
  }
  
  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    }
    return count.toString();
  }
}
```

### 2. 加载组件
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;
  
  const LoadingWidget({
    Key? key,
    this.size = 40,
    this.color,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? ColorStyles.primary,
          ),
        ),
      ),
    );
  }
}
```

### 3. 空数据组件
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/style/text_styles.dart';

class NoDataWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRefresh;
  
  const NoDataWidget({
    Key? key,
    this.message,
    this.onRefresh,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_data.png',
            width: 120,
            height: 120,
          ),
          SizedBox(height: 16),
          Text(
            message ?? '暂无数据',
            style: TextStyles.bodyMedium,
          ),
          if (onRefresh != null) ...[
            SizedBox(height: 16),
            TextButton(
              onPressed: onRefresh,
              child: Text('点击刷新'),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 4. 广告横幅组件
```dart
import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:flutter_app/ads/config.dart';

class BannerAdsWidget extends StatelessWidget {
  final double width;
  final double height;
  
  const BannerAdsWidget({
    Key? key,
    this.width = 300,
    this.height = 150,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: FlutterUnionadBannerView(
        androidCodeId: AdsConfig.bannerAndroidId,
        iosCodeId: AdsConfig.bannerIOSId,
        width: width.toInt(),
        height: height.toInt(),
        callBack: FlutterUnionadBannerCallBack(
          onShow: () => print('Banner 展示'),
          onFail: (error) => print('Banner 错误: $error'),
          onClick: () => print('Banner 点击'),
        ),
      ),
    );
  }
}
```

### 5. 筛选栏组件
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app/style/color_styles.dart';
import 'package:flutter_app/style/layout.dart';
import 'package:flutter_app/style/text_styles.dart';

class FilterBar extends StatelessWidget {
  final List<FilterItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  
  const FilterBar({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: ColorStyles.cardBackground,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Layout.paddingMD),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: Layout.gapLG),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  items[index].label,
                  style: isSelected 
                    ? TextStyles.titleMedium.copyWith(
                        color: ColorStyles.primary,
                      )
                    : TextStyles.bodyMedium,
                ),
                if (isSelected)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      color: ColorStyles.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FilterItem {
  final String label;
  final dynamic value;
  
  FilterItem({required this.label, this.value});
}
```

## 视频列表布局

### 1. 双列网格
```dart
class VideoGrid extends StatelessWidget {
  final List<VideoEntity> videos;
  final Function(VideoEntity) onVideoTap;
  
  @override
  Widget build(BuildContext context) {
    final crossAxisCount = 2;
    final spacing = Layout.gapMD;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - spacing * 3) / crossAxisCount;
    
    return SliverPadding(
      padding: EdgeInsets.all(Layout.paddingMD),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.75,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => VideoCard(
            video: videos[index],
            width: itemWidth,
            onTap: () => onVideoTap(videos[index]),
          ),
          childCount: videos.length,
        ),
      ),
    );
  }
}
```

### 2. 横向滚动列表
```dart
class HorizontalVideoList extends StatelessWidget {
  final String title;
  final List<VideoEntity> videos;
  final VoidCallback? onMore;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题栏
        SectionHeader(
          title: title,
          onMore: onMore,
        ),
        // 横向列表
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: Layout.paddingMD),
            itemCount: videos.length,
            separatorBuilder: (_, __) => SizedBox(width: Layout.gapMD),
            itemBuilder: (context, index) => VideoCard(
              video: videos[index],
              width: 140,
            ),
          ),
        ),
      ],
    );
  }
}
```

## 注意事项
1. 所有组件必须使用 `ColorStyles` 定义的颜色
2. 间距必须使用 `Layout` 定义的常量
3. 文字样式必须使用 `TextStyles` 定义的样式
4. 图片加载需要处理错误情况
5. 组件需要支持主题切换
6. 交互组件需要提供适当的反馈
