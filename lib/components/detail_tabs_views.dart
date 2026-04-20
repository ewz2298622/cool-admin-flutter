import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../entity/video_detail_data_entity.dart';

/// 视频详情页的线路选择标签页组件
/// 支持多标签页切换，每个标签页显示可选择的播放线路列表
class DetailTabsView extends StatefulWidget {
  final List<VideoDetailDataDataLines> tabData;
  /// 选中项改变时的回调函数
  final Function(int tabIndex, Set<int> selectedIndices)? onSelectionChanged;
  /// 默认选中项，key为tab索引，value为选中项的索引集合
  final Map<int, Set<int>>? defaultSelectedItems;

  const DetailTabsView({
    super.key,
    required this.tabData,
    this.onSelectionChanged,
    this.defaultSelectedItems,
  });

  @override
  _DetailTabsViewState createState() => _DetailTabsViewState();
}

class _DetailTabsViewState extends State<DetailTabsView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  /// 用于跟踪每个tab中选中的项目
  final Map<int, Set<int>> _selectedItems = {};

  // 布局常量
  static const double kElementWidth = 100.0;
  static const double kElementHeight = 35.0;
  static const double kContainerPadding = 8.0;
  static const double kRowMargin = 6.0;
  static const double kBorderRadius = 6.0;
  static const double kFontSize = 12.0;
  static const int kMinCrossAxisCount = 1;

  // 颜色常量
  static const Color kSelectedColor = Color.fromRGBO(252, 119, 66, 1);
  static const Color kUnselectedColor = Color.fromRGBO(246, 247, 248, 1);
  static const Color kSelectedTextColor = Colors.white;
  static const Color kUnselectedTextColor = Colors.black;
  static const Color kUnselectedLabelColor = Color.fromRGBO(102, 102, 102, 1);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 容错处理：确保tabData不为空
    final tabLength = widget.tabData.isEmpty ? 1 : widget.tabData.length;
    _tabController = TabController(length: tabLength, vsync: this);

    // 初始化默认选中项
    if (widget.defaultSelectedItems != null &&
        widget.defaultSelectedItems!.isNotEmpty) {
      _selectedItems.addAll(widget.defaultSelectedItems!);
    } else if (widget.tabData.isNotEmpty) {
      // 如果没有提供默认选中项，则默认选中第一个tab的第一个项目
      _selectedItems[0] = {0};
    }
  }

  @override
  void didUpdateWidget(DetailTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当tabData长度改变时，更新TabController
    if (oldWidget.tabData.length != widget.tabData.length) {
      final tabLength = widget.tabData.isEmpty ? 1 : widget.tabData.length;
      _tabController.dispose();
      _tabController = TabController(length: tabLength, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 计算每行可以容纳的元素数量
  int _calculateCrossAxisCount(double maxWidth) {
    if (maxWidth <= 0) return kMinCrossAxisCount;
    final availableWidth = maxWidth - (kContainerPadding * 2);
    final count = (availableWidth / kElementWidth).floor();
    return count < kMinCrossAxisCount ? kMinCrossAxisCount : count;
  }

  /// 将播放线路列表分组为行
  List<List<dynamic>> _groupPlayLinesIntoRows(
    List<dynamic> playLines,
    int crossAxisCount,
  ) {
    if (playLines.isEmpty || crossAxisCount <= 0) {
      return [];
    }

    final List<List<dynamic>> rows = [];
    for (int i = 0; i < playLines.length; i += crossAxisCount) {
      final end = (i + crossAxisCount < playLines.length)
          ? i + crossAxisCount
          : playLines.length;
      rows.add(playLines.sublist(i, end));
    }
    return rows;
  }

  /// 检查项目是否被选中
  bool _isItemSelected(int tabIndex, int itemIndex) {
    return _selectedItems.containsKey(tabIndex) &&
        _selectedItems[tabIndex]!.contains(itemIndex);
  }

  /// 处理项目点击事件
  void _handleItemTap(
    int tabIndex,
    int itemIndex,
    dynamic item,
  ) {
    // 容错处理：检查VIP状态
    if (item.vip == 1 && (item.file ?? "").isEmpty) {
      Fluttertoast.showToast(
        msg: "请开通VIP后重试",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    setState(() {
      // 清空所有tabs的选中项
      _selectedItems.clear();

      // 为当前tab添加选中项
      _selectedItems[tabIndex] = {itemIndex};

      // 调用回调函数将选中项数据返回给父组件
      widget.onSelectionChanged?.call(tabIndex, _selectedItems[tabIndex]!);
    });
  }

  /// 构建单个播放线路按钮
  Widget _buildPlayLineButton({
    required dynamic item,
    required bool isSelected,
    required int tabIndex,
    required int itemIndex,
  }) {
    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          SizedBox(
            width: kElementWidth,
            height: kElementHeight,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? kSelectedColor : kUnselectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(80, kElementHeight),
                maximumSize: const Size(80, kElementHeight),
              ),
              onPressed: () => _handleItemTap(tabIndex, itemIndex, item),
              child: Text(
                item.name ?? '',
                style: TextStyle(
                  color: isSelected ? kSelectedTextColor : kUnselectedTextColor,
                  fontSize: kFontSize,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
          // VIP角标右上角位置
          if (item.vip == 1)
            const Positioned(
              right: 0,
              top: 0,
              child: TDBadge(
                TDBadgeType.subscript,
                size: TDBadgeSize.large,
                message: 'VIP',
              ),
            ),
        ],
      ),
    );
  }

  /// 构建空占位符
  Widget _buildEmptyPlaceholder() {
    return const SizedBox(
      width: 80,
      height: kElementHeight,
    );
  }

  /// 构建列表视图，每行元素数量根据父组件尺寸动态分配
  Widget _buildListView(VideoDetailDataDataLines entry) {
    // 容错处理：检查tabIndex是否有效
    final int tabIndex = widget.tabData.indexOf(entry);
    if (tabIndex < 0) {
      return const Center(child: Text('无效的标签页'));
    }

    // 获取当前tab的播放线路列表
    final playLines = entry.playLines ?? [];
    if (playLines.isEmpty) {
      return const Center(child: Text('暂无播放线路'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // 计算每行可以容纳的元素数量
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

        // 将播放线路分组为行
        final rows = _groupPlayLinesIntoRows(playLines, crossAxisCount);

        if (rows.isEmpty) {
          return const Center(child: Text('暂无数据'));
        }

        return Container(
          padding: const EdgeInsets.all(kContainerPadding),
          child: ListView.builder(
            itemCount: rows.length,
            cacheExtent: 300, // 增加缓存范围，提高滚动性能
            physics: const BouncingScrollPhysics(), // 使用弹性滚动，提升体验
            itemBuilder: (context, rowIndex) {
              final rowItems = rows[rowIndex];
              // 为每行创建唯一的key，提高ListView的性能
              final rowKey = ValueKey('row_$tabIndex$rowIndex');
              
              return RepaintBoundary(
                child: Container(
                  key: rowKey,
                  margin: const EdgeInsets.only(bottom: kRowMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                      rowItems.length,
                      (index) {
                        final item = rowItems[index];
                        final itemIndex = rowIndex * crossAxisCount + index;
                        final isSelected = _isItemSelected(tabIndex, itemIndex);
                        // 为每个按钮创建唯一的key，提高渲染性能
                        final buttonKey = ValueKey('button_$tabIndex$itemIndex');

                        return Padding(
                          key: buttonKey,
                          padding: EdgeInsets.only(right: index < rowItems.length - 1 ? 8.0 : 0),
                          child: _buildPlayLineButton(
                            item: item,
                            isSelected: isSelected,
                            tabIndex: tabIndex,
                            itemIndex: itemIndex,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用，因为使用了AutomaticKeepAliveClientMixin

    // 容错处理：如果tabData为空，显示提示
    if (widget.tabData.isEmpty) {
      return const Center(child: Text('暂无数据'));
    }

    return Column(
      children: [
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          dividerHeight: 0,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 0.0,
              color: Colors.transparent,
            ),
          ),
          labelColor: kSelectedColor,
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelColor: kUnselectedLabelColor,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          controller: _tabController,
          tabs: widget.tabData
              .map((tab) => Tab(text: tab.collectionName ?? '线路'))
              .toList(),
        ),
        Flexible(
          flex: 1,
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(), // 使用弹性滚动，提升体验
            children: widget.tabData
                .map((entry) => _buildListView(entry))
                .toList(),
          ),
        ),
      ],
    );
  }
}
