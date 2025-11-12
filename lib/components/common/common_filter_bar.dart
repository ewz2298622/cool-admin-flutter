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
    this.spacing = 6,
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
          itemBuilder: (context, index) {
            final entry = entries[index];
            final label = labelBuilder(entry);
            final selected = isSelected(entry);
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : spacing),
              child: GestureDetector(
                onTap: () => onTap(entry),
                child: chipBuilder(label, selected),
              ),
            );
          },
        ),
      ),
    );
  }
}

