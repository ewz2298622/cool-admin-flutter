import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 通用的分区标题组件，支持自定义"更多"操作或自定义尾部组件
class SectionWithMore extends StatelessWidget {
  static const EdgeInsetsGeometry _defaultPadding = EdgeInsets.symmetric(horizontal: 0, vertical: 4);
  static const double _defaultSpacing = 8;
  static const double _iconSize = 16;
  static const double _arrowIconSize = 14;
  static const double _inkWellBorderRadius = 16;
  static const EdgeInsetsGeometry _inkWellPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const double _textIconSpacing = 4;
  static const String _moreText = '更多';
  static const String _defaultAssetUrl = 'assets/images/kMAfmcQvtjAhwk72KQvTn.png';
  static const TextStyle _defaultTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle _defaultTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF666666),
  );

  final String title;
  final VoidCallback? onMorePressed;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final TextStyle? titleStyle;
  final String? semanticsLabel;
  final bool showIcon;

  const SectionWithMore({
    super.key,
    required this.title,
    this.onMorePressed,
    this.trailing,
    this.padding = _defaultPadding,
    this.spacing = _defaultSpacing,
    this.titleStyle,
    this.semanticsLabel,
    this.showIcon = false,
  }) : assert(
         trailing == null || onMorePressed == null,
         '提供自定义 trailing 时请不要再提供 onMorePressed',
       );

  @override
  Widget build(BuildContext context) {
    if (title.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveTitleStyle = titleStyle ??
        theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500) ??
        _defaultTitleStyle;

    return Padding(
      padding: padding,
      child: RepaintBoundary(
        child: Semantics(
          label: semanticsLabel ?? title,
          header: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showIcon) _buildIcon(),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: effectiveTitleStyle,
                ),
              ),
              SizedBox(width: spacing),
              _buildTrailing(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return TDImage(
      assetUrl: _defaultAssetUrl,
      width: _iconSize,
      height: _iconSize,
    );
  }

  Widget _buildTrailing(ThemeData theme) {
    if (trailing != null) {
      return trailing!;
    }

    if (onMorePressed == null) {
      return const SizedBox.shrink();
    }

    final textStyle = theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ) ??
        _defaultTextStyle;

    return InkWell(
      borderRadius: BorderRadius.circular(_inkWellBorderRadius),
      onTap: onMorePressed,
      child: Padding(
        padding: _inkWellPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_moreText, style: textStyle),
            const SizedBox(width: _textIconSpacing),
            Icon(
              Icons.arrow_forward_ios,
              size: _arrowIconSize,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}
