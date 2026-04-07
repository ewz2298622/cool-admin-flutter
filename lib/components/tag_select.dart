import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/dict_info_list_entity.dart';

/// 通用的标签选择行组件
class GenericRowBuilder extends StatelessWidget {
  static const EdgeInsets _outerPadding = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets _titlePadding = EdgeInsets.only(left: 8);
  static const EdgeInsets _buttonPadding = EdgeInsets.only(left: 8);
  static const double _titleSpacing = 12;
  static const Color _selectedColor = Color(0xFFF9AE3D);
  static const Color _unselectedTextColor = Colors.black;
  static const Color _emptyTextColor = Colors.grey;
  static const String _emptyText = '暂无选项';

  final String title;
  final List<DictInfoListData> items;
  final ValueNotifier<int> currentValue;
  final Function(DictInfoListData) onItemTap;

  const GenericRowBuilder({
    super.key,
    required this.title,
    required this.items,
    required this.currentValue,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (title.trim().isEmpty && items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<int>(
      valueListenable: currentValue,
      builder: (context, selectedId, child) {
        if (items.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildTagList(context, selectedId);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: _outerPadding,
      child: Row(
        children: [
          if (title.trim().isNotEmpty) _buildTitle(context),
          const SizedBox(width: _titleSpacing),
          const Expanded(
            child: Text(
              _emptyText,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _emptyTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagList(BuildContext context, int selectedId) {
    return Padding(
      padding: _outerPadding,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          overscroll: false,
          physics: const BouncingScrollPhysics(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (title.trim().isNotEmpty) _buildTitle(context),
              ...items.map(
                (item) => _buildOptionButton(item, selectedId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: _titlePadding,
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildOptionButton(DictInfoListData item, int selectedId) {
    final itemId = item.id;
    final displayName = item.name?.trim();
    if (displayName == null || displayName.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isSelected = itemId != null && itemId == selectedId;

    return Padding(
      padding: _buttonPadding,
      child: RepaintBoundary(
        child: TDButton(
          text: displayName,
          size: TDButtonSize.small,
          style: TDButtonStyle(
            backgroundColor: isSelected ? _selectedColor : Colors.transparent,
            textColor: isSelected ? Colors.white : _unselectedTextColor,
          ),
          onTap: () {
            if (itemId == null) {
              return;
            }
            onItemTap(item);
          },
        ),
      ),
    );
  }
}
