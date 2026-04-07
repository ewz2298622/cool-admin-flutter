import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 页面加载组件
class PageLoading extends StatelessWidget {
  static const TDLoadingSize _defaultSize = TDLoadingSize.small;
  static const TDLoadingIcon _defaultIcon = TDLoadingIcon.circle;
  static const Color _defaultIconColor = Color.fromRGBO(255, 162, 16, 1);

  /// 加载图标大小
  final TDLoadingSize size;

  /// 加载图标类型
  final TDLoadingIcon icon;

  /// 加载图标颜色
  final Color iconColor;

  const PageLoading({
    super.key,
    this.size = _defaultSize,
    this.icon = _defaultIcon,
    this.iconColor = _defaultIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildLoading(),
    );
  }

  Widget _buildLoading() {
    return TDLoading(
      size: size,
      icon: icon,
      iconColor: iconColor,
    );
  }
}
