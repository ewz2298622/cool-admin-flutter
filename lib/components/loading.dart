import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class PageLoading extends StatelessWidget {
  final TDLoadingSize size;
  final TDLoadingIcon icon;
  final Color iconColor;

  const PageLoading({
    super.key,
    this.size = TDLoadingSize.small,
    this.icon = TDLoadingIcon.circle,
    this.iconColor = const Color.fromRGBO(255, 162, 16, 1),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TDLoading(size: size, icon: icon, iconColor: iconColor),
    );
  }
}
