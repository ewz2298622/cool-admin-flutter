import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 通用空状态组件
class NoData extends StatelessWidget {
  static const String _defaultMessage = '找不到相关内容';
  static const double _defaultImageSize = 200.0;
  static const EdgeInsetsGeometry _defaultPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);
  static const double _defaultSpacing = 12.0;
  static const bool _defaultShowImage = true;
  static const double _textOpacity = 0.8;
  static const double _defaultFontSize = 14.0;
  static const String _noDataAssetUrl = 'assets/images/no_data.png';

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
    this.message = _defaultMessage,
    this.imageSize = _defaultImageSize,
    this.padding = _defaultPadding,
    this.spacing = _defaultSpacing,
    this.showImage = _defaultShowImage,
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
                  _buildImage(),
                  _buildSpacing(),
                ],
                _buildMessage(textTheme),
                if (action != null) ...[
                  _buildSpacing(),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return TDImage(
      assetUrl: _noDataAssetUrl,
      width: imageSize,
      height: imageSize,
    );
  }

  Widget _buildSpacing() {
    return SizedBox(height: spacing);
  }

  Widget _buildMessage(TextTheme textTheme) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: textTheme.bodyMedium?.copyWith(
            color: textTheme.bodyMedium?.color?.withValues(alpha: _textOpacity),
          ) ??
          const TextStyle(fontSize: _defaultFontSize),
    );
  }
}
