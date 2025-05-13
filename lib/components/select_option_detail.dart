// dynamic_select_option.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/components/video_one_small.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../components/loading.dart';
import '../entity/video_page_entity.dart';

typedef Future<List<dynamic>> DataLoader(Map<String, dynamic> params);

class DynamicSelectOption extends StatefulWidget {
  final String title;
  final List<String> items;
  final String paramsKey;
  final DataLoader loadData; // 外部传入的数据加载方法

  const DynamicSelectOption({
    Key? key,
    required this.title,
    required this.items,
    required this.paramsKey,
    required this.loadData,
  }) : super(key: key);

  @override
  State<DynamicSelectOption> createState() => _DynamicSelectOptionState();
}

class _DynamicSelectOptionState extends State<DynamicSelectOption> {
  List<VideoPageDataList> selectData = [];

  Future<void> _loadData(Map<String, dynamic> params) async {
    final result = await widget.loadData(params) as List<VideoPageDataList>;
    setState(() {
      selectData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children:
                  widget.items
                      .map((name) => _buildPopFromCenter(context, name))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopFromCenter(BuildContext context, String name) {
    Map<String, dynamic> params = {widget.paramsKey: name};

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (builder) {
            return FutureBuilder<void>(
              future: _loadData(params), // 加载数据
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: 650,
                    child: const Center(child: PageLoading()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: 650,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "已为您关联 $name 的相关影片",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: Navigator.of(context).pop,
                                  child: const Icon(Icons.close),
                                ),
                              ],
                            ),
                            // 示例组件，可以替换成实际组件如 VideoOneSmall
                            VideoOneSmall(videoPageData: selectData),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      },
      child: TDTag(name),
    );
  }
}
