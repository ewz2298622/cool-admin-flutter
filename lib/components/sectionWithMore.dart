import 'package:flutter/material.dart';

/// 通用的分区标题组件，支持自定义“更多”操作或自定义尾部组件
class SectionWithMore extends StatelessWidget {
  final String title;
  final VoidCallback? onMorePressed;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final TextStyle? titleStyle;
  final String? semanticsLabel;

  const SectionWithMore({
    super.key,
    required this.title,
    this.onMorePressed,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.spacing = 8,
    this.titleStyle,
    this.semanticsLabel,
  }) : assert(trailing == null || onMorePressed == null,
            '提供自定义 trailing 时请不要再提供 onMorePressed');

  @override
  Widget build(BuildContext context) {
    if (title.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveTitleStyle = titleStyle ??
        theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500) ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

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
        const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF666666));

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onMorePressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('更多', style: textStyle),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}
