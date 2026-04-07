import 'package:flutter/material.dart';

typedef FilterLabelBuilder<T> = String Function(T? item);
typedef FilterSelectedPredicate<T> = bool Function(T? item);
typedef FilterTapCallback<T> = void Function(T? item);
typedef FilterChipBuilder = Widget Function(String label, bool selected);

/// 通用筛选栏组件
class CommonFilterBar<T> extends StatelessWidget {
  static const double _defaultHeight = 40.0;
  static const double _defaultSpacing = 0.0;
  static const int _cacheExtent = 200;
  static const ScrollPhysics _scrollPhysics = BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );

  final List<T> items;
  final FilterLabelBuilder<T> labelBuilder;
  final FilterSelectedPredicate<T> isSelected;
  final FilterTapCallback<T> onTap;
  final FilterChipBuilder chipBuilder;
  final double height;
  final double spacing;

  const CommonFilterBar({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.isSelected,
    required this.onTap,
    required this.chipBuilder,
    this.height = _defaultHeight,
    this.spacing = _defaultSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final entries = <T?>[null, ...items];
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: _scrollPhysics,
          itemCount: entries.length,
          cacheExtent: _cacheExtent.toDouble(),
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final label = labelBuilder(entry);
            final selected = isSelected(entry);
            final key = _buildItemKey(entry, index);
            
            return RepaintBoundary(
              key: key,
              child: _buildFilterItem(entry, label, selected, index),
            );
          },
        ),
      ),
    );
  }

  ValueKey<String> _buildItemKey(T? entry, int index) {
    return entry != null 
        ? ValueKey('filter_${entry.hashCode}_$index')
        : ValueKey('filter_null_$index');
  }

  Widget _buildFilterItem(T? entry, String label, bool selected, int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: index == 0 ? 0 : spacing,
      ),
      child: GestureDetector(
        onTap: () => onTap(entry),
        child: chipBuilder(label, selected),
      ),
    );
  }
}
