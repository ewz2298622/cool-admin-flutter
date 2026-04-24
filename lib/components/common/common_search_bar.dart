import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 通用搜索栏组件
class CommonSearchBar extends StatelessWidget {
  static const String _defaultPlaceholder = '';
  static const bool _defaultReadOnly = true;
  static const EdgeInsets _defaultPadding = EdgeInsets.symmetric(horizontal: 0, vertical: 4);
  static const Color _defaultBackgroundColor = Colors.transparent;
  static const double _defaultHeight = 45.0;
  static const TDSearchStyle _searchStyle = TDSearchStyle.round;

  final String placeholder;
  final bool readOnly;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final Color backgroundColor;
  final double height;

  const CommonSearchBar({
    super.key,
    this.placeholder = _defaultPlaceholder,
    this.readOnly = _defaultReadOnly,
    this.padding = _defaultPadding,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.backgroundColor = _defaultBackgroundColor,
    this.height = _defaultHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: _buildSearchBar(),
    );
  }

  Widget _buildSearchBar() {
    return TDSearchBar(
      controller: controller,
      placeHolder: placeholder,
      backgroundColor: backgroundColor,
      readOnly: readOnly,
      style: _searchStyle,
      padding: padding,
      onInputClick: onTap,
      onTextChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

