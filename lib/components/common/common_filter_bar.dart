import 'package:flutter/material.dart';

typedef FilterLabelBuilder<T> = String Function(T? item);
typedef FilterSelectedPredicate<T> = bool Function(T? item);
typedef FilterTapCallback<T> = void Function(T? item);
typedef FilterChipBuilder = Widget Function(String label, bool selected);

class CommonFilterBar<T> extends StatelessWidget {
  const CommonFilterBar({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.isSelected,
    required this.onTap,
    required this.chipBuilder,
    this.height = 40,
    this.spacing = 0,
  });

  final List<T> items;
  final FilterLabelBuilder<T> labelBuilder;
  final FilterSelectedPredicate<T> isSelected;
  final FilterTapCallback<T> onTap;
  final FilterChipBuilder chipBuilder;
  final double height;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final entries = <T?>[null, ...items];
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: entries.length,
          cacheExtent: 200, // 预缓存范围，提升滚动性能
          addAutomaticKeepAlives: false, // 禁用自动保持活跃，提升性能
          addRepaintBoundaries: false, // 已手动添加 RepaintBoundary，禁用自动添加
          itemBuilder: (context, index) {
            final entry = entries[index];
            final label = labelBuilder(entry);
            final selected = isSelected(entry);
            // 使用稳定的 key，基于 index 和 entry 的标识
            final key = entry != null 
                ? ValueKey('filter_${entry.hashCode}_$index')
                : ValueKey('filter_null_$index');
            return RepaintBoundary(
              key: key,
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : spacing,
                ),
                child: GestureDetector(
                  onTap: () => onTap(entry),
                  child: chipBuilder(label, selected),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
