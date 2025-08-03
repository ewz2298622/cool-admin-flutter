import 'package:flutter/material.dart';

import '../entity/play_line_entity.dart';
import '../entity/video_line_entity.dart';

class DetailTabsView extends StatefulWidget {
  final List<List<PlayLineDataList>> tabData;
  final List<VideoLineDataList> tabs;
  // 添加回调函数参数，用于将选中的项目返回给父组件
  final Function(int tabIndex, Set<int> selectedIndices)? onSelectionChanged;

  const DetailTabsView({
    Key? key,
    required this.tabData,
    required this.tabs,
    this.onSelectionChanged,
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
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 生成网格视图
  Widget _buildGridView(List<PlayLineDataList> entry) {
    final int tabIndex = widget.tabData.indexOf(entry);

    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: entry.length,
      itemBuilder: (context, index) {
        final item = entry[index];
        final bool isSelected =
            _selectedItems.containsKey(tabIndex) &&
            _selectedItems[tabIndex]!.contains(index);

        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor:
                isSelected
                    ? const Color.fromRGBO(252, 119, 66, 1)
                    : Color.fromRGBO(255, 255, 255, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            setState(() {
              // 清空所有tabs的选中项
              _selectedItems.clear();

              // 为当前tab添加选中项
              _selectedItems[tabIndex] = {index};

              // 调用回调函数将选中项数据返回给父组件
              widget.onSelectionChanged?.call(
                tabIndex,
                _selectedItems[tabIndex]!,
              );
            });
          },
          child: Text(
            item.name ?? '',
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
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
              widget.tabs.map((tab) => Tab(text: tab.collectionName)).toList(),
        ),
        Flexible(
          flex: 1,
          child: TabBarView(
            controller: _tabController,
            children:
                widget.tabData.map((entry) => _buildGridView(entry)).toList(),
          ),
        ),
      ],
    );
  }
}
