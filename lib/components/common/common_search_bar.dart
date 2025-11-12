import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CommonSearchBar extends StatelessWidget {
  const CommonSearchBar({
    super.key,
    this.placeholder = '',
    this.readOnly = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.backgroundColor = Colors.transparent,
    this.height = 45,
  });

  final String placeholder;
  final bool readOnly;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TDSearchBar(
        controller: controller,
        placeHolder: placeholder,
        backgroundColor: backgroundColor,
        readOnly: readOnly,
        style: TDSearchStyle.round,
        padding: padding,
        onInputClick: onTap,
        onTextChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

