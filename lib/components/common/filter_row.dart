import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../common/common_filter_bar.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/dict_info_list_entity.dart';

typedef FilterLabelBuilder<T> = String Function(T? item);
typedef FilterSelectionCallback<T> = void Function(T? item);

class FilterRow<T> extends StatelessWidget {
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
    Key? key,
    required this.title,
    required this.items,
    required this.notifier,
    required this.labelBuilder,
    required this.onTap,
    this.activeColor = const Color.fromRGBO(255, 122, 27, 1),
    this.activeBgColor = const Color.fromRGBO(244, 244, 244, 1),
    this.tagBorderRadius = 15.0,
    this.tagSpacing = 1.0,
    this.tagListHeight = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (context, selectedId, child) {
        // 生成缓存键
        final brightnessKey =
            Theme.of(context).brightness == Brightness.dark ? 'dark' : 'light';
        final cacheKey = '$title-$selectedId-${items.length}-$brightnessKey';

        // 缓存 Theme 值，避免重复获取
        final theme = TDTheme.of(context);
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color unselectedColor =
            isDarkMode ? Colors.white70 : theme.fontGyColor2;

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

  int _getId(T item) {
    if (item is int) {
      return item;
    } else if (item is DictDataDataVideoCategory) {
      return item.id ?? 0;
    } else if (item is DictDataDataVideoTag) {
      return item.id ?? 0;
    } else if (item is DictInfoListData) {
      return item.id ?? 0;
    } else {
      // 如果无法获取ID，则使用列表索引
      final index = items.indexOf(item);
      return index >= 0 ? index + 1 : 0;
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
    final padding = EdgeInsets.symmetric(
      horizontal: selected ? 8 : 6,
      vertical: 6,
    );
    return Padding(
      padding: padding,
      child: TDTag(
        text,
        shape: TDTagShape.round,
        isLight: true,
        size: TDTagSize.large,
        textColor: selected ? selectedTextColor : unselectedTextColor,
        backgroundColor: selected ? selectedBgColor : Colors.transparent,
        isOutline: true,
        style: TDTagStyle(
          borderColor: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}