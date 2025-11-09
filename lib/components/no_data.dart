import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 通用空状态组件
class NoData extends StatelessWidget {
  /// 显示的提示文案
  final String message;

  /// 图片尺寸
  final double imageSize;

  /// 内边距
  final EdgeInsetsGeometry padding;

  /// 元素间距
  final double spacing;

  /// 是否展示占位图片
  final bool showImage;

  /// 可选操作按钮或附加内容
  final Widget? action;

  const NoData({
    super.key,
    this.message = '找不到相关内容',
    this.imageSize = 200,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.spacing = 12,
    this.showImage = true,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: Center(
        child: RepaintBoundary(
          child: Semantics(
            label: message,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showImage) ...[
                  TDImage(
                    assetUrl: 'assets/images/no_data.png',
                    width: imageSize,
                    height: imageSize,
                  ),
                  SizedBox(height: spacing),
                ],
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                        color: textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ) ??
                      const TextStyle(fontSize: 14),
                ),
                if (action != null) ...[
                  SizedBox(height: spacing),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
