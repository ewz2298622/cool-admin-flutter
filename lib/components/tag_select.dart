import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/dict_info_list_entity.dart';

class GenericRowBuilder extends StatelessWidget {
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
    return ValueListenableBuilder<int>(
      valueListenable: currentValue,
      builder: (context, key, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Center(child: Text(title ?? "")),
                ),
                ...(items ?? [])
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TDButton(
                          text: item.name ?? "",
                          size: TDButtonSize.small,
                          style: TDButtonStyle(
                            backgroundColor:
                                key == item.id
                                    ? const Color.fromRGBO(249, 174, 61, 1)
                                    : Colors.transparent,
                            textColor:
                                key == item.id ? Colors.white : Colors.black,
                          ),
                          onTap: () => onItemTap(item),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
