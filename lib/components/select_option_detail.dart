import 'package:flutter/material.dart';
import 'package:flutter_app/components/video_one_small.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../components/loading.dart';
import '../entity/video_page_entity.dart';

typedef Future<List<dynamic>> DataLoader(Map<String, dynamic> params);

class DynamicSelectOption extends StatefulWidget {
  static const double _titleBottomPadding = 8;
  static const double _titleFontSize = 18;
  static const double _containerHeight = 40;
  static const double _wrapSpacing = 12;
  static const double _wrapRunSpacing = 8;
  static const double _modalTopPadding = 10;
  static const double _modalBorderRadius = 20;
  static const double _modalHeight = 650;
  static const double _modalHorizontalPadding = 10;
  static const double _contentTopMargin = 30;
  static const double _textSpacing = 5;
  static const double _normalFontSize = 14;
  static const double _highlightFontSize = 16;
  static const Color _highlightColor = Colors.blue;

  final String title;
  final List<String> items;
  final String paramsKey;
  final DataLoader loadData;

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
        if (widget.title.isNotEmpty) _buildTitle(),
        _buildItemList(),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: DynamicSelectOption._titleBottomPadding),
      child: Text(
        widget.title,
        style: const TextStyle(
          fontSize: DynamicSelectOption._titleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return SizedBox(
      height: DynamicSelectOption._containerHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: DynamicSelectOption._wrapSpacing,
          runSpacing: DynamicSelectOption._wrapRunSpacing,
          children: widget.items
              .map((name) => _buildPopFromCenter(context, name))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildVideoList() {
    if (selectData.isNotEmpty) {
      return VideoOneSmall(videoPageData: selectData);
    }
    return const Center();
  }

  Widget _buildPopFromCenter(BuildContext context, String name) {
    final params = {widget.paramsKey: name};

    return GestureDetector(
      onTap: () => _showModalBottomSheet(context, name, params),
      child: TDTag('@$name', isLight: true, theme: TDTagTheme.danger),
    );
  }

  void _showModalBottomSheet(BuildContext context, String name, Map<String, dynamic> params) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return FutureBuilder<void>(
          future: _loadData(params),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingModal();
            } else if (snapshot.hasError) {
              return _buildErrorModal(snapshot.error);
            } else {
              return _buildContentModal(context, name);
            }
          },
        );
      },
    );
  }

  Widget _buildLoadingModal() {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: DynamicSelectOption._modalTopPadding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(DynamicSelectOption._modalBorderRadius),
            topRight: Radius.circular(DynamicSelectOption._modalBorderRadius),
          ),
        ),
        height: DynamicSelectOption._modalHeight,
        child: const Center(child: PageLoading()),
      ),
    );
  }

  Widget _buildErrorModal(Object? error) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(DynamicSelectOption._modalBorderRadius),
            topRight: Radius.circular(DynamicSelectOption._modalBorderRadius),
          ),
        ),
        height: 200,
        child: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildContentModal(BuildContext context, String name) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: DynamicSelectOption._modalTopPadding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(DynamicSelectOption._modalBorderRadius),
            topRight: Radius.circular(DynamicSelectOption._modalBorderRadius),
          ),
        ),
        height: DynamicSelectOption._modalHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DynamicSelectOption._modalHorizontalPadding,
          ),
          child: Stack(
            children: [
              _buildVideoContent(),
              _buildModalHeader(context, name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    return Container(
      margin: const EdgeInsets.only(top: DynamicSelectOption._contentTopMargin),
      child: SingleChildScrollView(
        child: _buildVideoList(),
      ),
    );
  }

  Widget _buildModalHeader(BuildContext context, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Text(
              "已为您关联 ",
              style: TextStyle(
                fontSize: DynamicSelectOption._normalFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: DynamicSelectOption._highlightFontSize,
                fontWeight: FontWeight.w800,
                color: DynamicSelectOption._highlightColor,
              ),
            ),
            const Text(
              " 的相关影片",
              style: TextStyle(
                fontSize: DynamicSelectOption._normalFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: Navigator.of(context).pop,
          child: const Icon(Icons.close),
        ),
      ],
    );
  }
}
