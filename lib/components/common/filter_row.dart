import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../common/common_filter_bar.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/dict_info_list_entity.dart';

typedef FilterLabelBuilder<T> = String Function(T? item);
typedef FilterSelectionCallback<T> = void Function(T? item);

/// 筛选行组件
class FilterRow<T> extends StatelessWidget {
  static const Color _defaultActiveColor = Color.fromRGBO(255, 122, 27, 1);
  static const Color _defaultActiveBgColor = Color.fromRGBO(244, 244, 244, 1);
  static const double _defaultTagBorderRadius = 15.0;
  static const double _defaultTagSpacing = 1.0;
  static const double _defaultTagListHeight = 40.0;
  static const int _defaultId = 0;
  static const int _defaultIndexOffset = 1;
  static const double _selectedHorizontalPadding = 8.0;
  static const double _unselectedHorizontalPadding = 6.0;
  static const double _verticalPadding = 6.0;
  static const TDTagShape _tagShape = TDTagShape.round;
  static const bool _isLight = true;
  static const TDTagSize _tagSize = TDTagSize.large;
  static const bool _isOutline = true;
  static const Color _borderColor = Colors.transparent;

  final String title;
  final List<T> items;
  final ValueNotifier<int> notifier;
  final FilterLabelBuilder<T> labelBuilder;
  final FilterSelectionCallback<T> onTap;
  final Color activeColor;
  final Color activeBgColor;
  final double tagBorderRadius;
  final double tagSpacing;
  final double tagListHeight;

  const FilterRow({
    super.key,
    required this.title,
    required this.items,
    required this.notifier,
    required this.labelBuilder,
    required this.onTap,
    this.activeColor = _defaultActiveColor,
    this.activeBgColor = _defaultActiveBgColor,
    this.tagBorderRadius = _defaultTagBorderRadius,
    this.tagSpacing = _defaultTagSpacing,
    this.tagListHeight = _defaultTagListHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (context, selectedId, child) {
        final unselectedColor = _getUnselectedColor(context);

        return CommonFilterBar<T>(
          items: items,
          labelBuilder: (item) => item == null ? title : labelBuilder(item),
          isSelected: (item) => 
              item == null ? selectedId == 0 : _getId(item) == selectedId,
          onTap: onTap,
          chipBuilder: (label, isSelected) => _buildTagChip(
            text: label,
            selected: isSelected,
            selectedTextColor: activeColor,
            unselectedTextColor: unselectedColor,
            selectedBgColor: activeBgColor,
            borderRadius: tagBorderRadius,
          ),
          height: tagListHeight,
          spacing: tagSpacing,
        );
      },
    );
  }

  Color _getUnselectedColor(BuildContext context) {
    final theme = TDTheme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white70 : theme.fontGyColor2;
  }

  int _getId(T item) {
    if (item is int) {
      return item;
    } else if (item is DictDataDataVideoCategory) {
      return item.id ?? _defaultId;
    } else if (item is DictDataDataVideoTag) {
      return item.id ?? _defaultId;
    } else if (item is DictInfoListData) {
      return item.id ?? _defaultId;
    } else {
      final index = items.indexOf(item);
      return index >= 0 ? index + _defaultIndexOffset : _defaultId;
    }
  }

  Widget _buildTagChip({
    required String text,
    required bool selected,
    required Color selectedTextColor,
    required Color unselectedTextColor,
    required Color selectedBgColor,
    required double borderRadius,
  }) {
    final padding = _getTagPadding(selected);
    return Padding(
      padding: padding,
      child: TDTag(
        text,
        shape: _tagShape,
        isLight: _isLight,
        size: _tagSize,
        textColor: selected ? selectedTextColor : unselectedTextColor,
        backgroundColor: selected ? selectedBgColor : Colors.transparent,
        isOutline: _isOutline,
        style: TDTagStyle(
          borderColor: _borderColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  EdgeInsets _getTagPadding(bool selected) {
    return EdgeInsets.symmetric(
      horizontal: selected ? _selectedHorizontalPadding : _unselectedHorizontalPadding,
      vertical: _verticalPadding,
    );
  }
}