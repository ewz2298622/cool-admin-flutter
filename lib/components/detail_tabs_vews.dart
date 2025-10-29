import 'package:flutter/material.dart';

import '../entity/video_detail_data_entity.dart';

class DetailTabsView extends StatefulWidget {
  final List<VideoDetailDataDataLines> tabData;
  // 添加回调函数参数，用于将选中的项目返回给父组件
  final Function(int tabIndex, Set<int> selectedIndices)? onSelectionChanged;
  // 添加默认选中项参数
  final Map<int, Set<int>>? defaultSelectedItems;

  const DetailTabsView({
    Key? key,
    required this.tabData,
    this.onSelectionChanged,
    this.defaultSelectedItems,
  }) : super(key: key);

  @override
  _DetailTabsViewState createState() => _DetailTabsViewState();
}

class _DetailTabsViewState extends State<DetailTabsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 用于跟踪每个tab中选中的项目
  final Map<int, Set<int>> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabData.length, vsync: this);

    // 初始化默认选中项，只有第一个tab有默认选中项
    if (widget.defaultSelectedItems != null) {
      _selectedItems.addAll(widget.defaultSelectedItems!);
    } else {
      // 如果没有提供默认选中项，则默认选中第一个tab的第一个项目
      _selectedItems[0] = {0};
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 生成列表视图，每行元素数量根据父组件尺寸动态分配
  Widget _buildListView(VideoDetailDataDataLines entry) {
    final int tabIndex = widget.tabData.indexOf(entry);

    // 获取当前tab的播放线路列表
    final playLines = entry.playLines ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        // 计算每行可以容纳的元素数量
        // 元素宽度80 + 间距10
        final elementWidth = 80.0 + 0;
        final crossAxisCount =
            ((constraints.maxWidth - 16.0) / elementWidth).floor().toInt();

        // 将播放线路分组，每组crossAxisCount个
        final List<List<dynamic>> rows = [];
        if (crossAxisCount > 0) {
          for (int i = 0; i < playLines.length; i += crossAxisCount) {
            int end =
                (i + crossAxisCount < playLines.length)
                    ? i + crossAxisCount
                    : playLines.length;
            rows.add(playLines.sublist(i, end));
          }
        }

        return Container(
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, rowIndex) {
              final rowItems = rows[rowIndex];
              return Container(
                margin: EdgeInsets.only(bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(crossAxisCount, (index) {
                    if (index < rowItems.length) {
                      final item = rowItems[index];
                      final bool isSelected =
                          _selectedItems.containsKey(tabIndex) &&
                          _selectedItems[tabIndex]!.contains(
                            rowIndex * crossAxisCount + index,
                          );

                      return SizedBox(
                        width: 80,
                        height: 35,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                isSelected
                                    ? const Color.fromRGBO(252, 119, 66, 1)
                                    : Color.fromRGBO(255, 255, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(80, 35),
                            maximumSize: Size(80, 35),
                          ),
                          onPressed: () {
                            setState(() {
                              // 清空所有tabs的选中项
                              _selectedItems.clear();

                              // 为当前tab添加选中项
                              _selectedItems[tabIndex] = {
                                rowIndex * crossAxisCount + index,
                              };

                              // 调用回调函数将选中项数据返回给父组件
                              widget.onSelectionChanged?.call(
                                tabIndex,
                                _selectedItems[tabIndex]!,
                              );
                            });
                          },
                          child: Text(
                            item.name ?? '',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      // 填充空位置
                      return Container(width: 80, height: 35);
                    }
                  }),
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
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          dividerHeight: 0,
          //移除下划线
          // 使用空的指示器来移除下划线
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 0.0,
              color: Colors.transparent,
            ), // 将宽度设置为0来隐藏下划线
          ),
          //选中的字体颜色
          labelColor: const Color.fromRGBO(252, 119, 66, 1),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelColor: const Color.fromRGBO(102, 102, 102, 1),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          controller: _tabController,
          tabs:
              widget.tabData
                  .map((tab) => Tab(text: tab.collectionName))
                  .toList(),
        ),
        Flexible(
          flex: 1,
          child: TabBarView(
            controller: _tabController,
            children:
                widget.tabData.map((entry) => _buildListView(entry)).toList(),
          ),
        ),
      ],
    );
  }
}
