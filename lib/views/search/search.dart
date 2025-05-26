import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/views/search/result/search_result.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../components/video_scroll.dart';
import '../../components/video_three.dart';
import '../../db/entity/SearchHistoryEntity.dart';
import '../../db/manager/SearchHistoryDatabaseHelper.dart';
import '../../entity/video_page_entity.dart';
import '../../style/layout.dart';

class VideoSearch extends StatefulWidget {
  const VideoSearch({super.key});

  @override
  VideoSearchState createState() => VideoSearchState();
}

class VideoSearchState extends State<VideoSearch>
    with SingleTickerProviderStateMixin {
  late final String inputText;
  List<VideoPageDataList> videoPageData = [];
  //定义猜你喜欢数据
  List<VideoPageDataList> videoPageDataList = [];
  final searchHistory = SearchHistoryDatabaseHelper();
  Iterable<SearchHistoryEntity> searchHistoryList = [];

  var _futureBuilderFuture;

  Future<String> init() async {
    try {
      await getVideoPages();
      await getSearchHistoryEntity();
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
      return "init success";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  Future<void> getVideoPages() async {
    try {
      videoPageData =
          (await Api.getVideoPages({
            "page": Random().nextInt(30) + 1,
          })).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageDataList =
          (await Api.getVideoPages({
            "page": Random().nextInt(30) + 1,
          })).data?.list ??
          [] as List<VideoPageDataList>;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getSearchHistoryEntity() async {
    try {
      searchHistoryList = searchHistory.getSearchHistoryByPage(1, 4);
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  goToSearchResult() {
    FocusScope.of(context).unfocus(); // 移除焦点
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchResult(keyWord: inputText)),
    );
  }

  Widget _buildDefaultSearchBar() {
    return TDSearchBar(
      placeHolder: '',
      action: "搜索",
      backgroundColor: Colors.transparent,
      style: TDSearchStyle.round,
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
        searchHistory.insertSearchHistory(
          SearchHistoryEntity(query: inputText, timestamp: DateTime.now()),
        );
      },
      onActionClick: (contexts) {
        goToSearchResult();
      },
    );
  }

  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildDefaultSearchBar(),
                  Container(
                    padding: EdgeInsets.only(
                      left: Layout.paddingL,
                      right: Layout.paddingR,
                      bottom: Layout.paddingB,
                      top: Layout.paddingT,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle('搜索历史'),
                        const SizedBox(height: 12),
                        SearchItem(),
                        const SizedBox(height: 24),
                        _buildRecommendations(),
                        _buildAlbumItems(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          default:
            return PageLoading();
        }
      },
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SectionWithMore(title: '猜你想搜'),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: HorizontalVideoList(videoPageData: videoPageData),
        ),
      ],
    );
  }

  Widget _buildAlbumItems() {
    return Column(
      spacing: 10,
      children: [
        SectionWithMore(title: '视频热搜榜'),
        VideoThree(videoPageData: videoPageDataList),
      ],
    );
  }

  // 区块标题组件
  Widget SectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // 搜索历史项组件
  Widget SearchItem() {
    return Row(
      spacing: 5,
      children:
          searchHistoryList.map((entity) {
            return GestureDetector(
              child: TDTag(entity.query),
              onTap: () {
                inputText = entity.query;
                goToSearchResult();
              },
            );
          }).toList(),
    );
  }

  // 推荐项组件
  Widget RecommendItem(String keyword, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(keyword, style: const TextStyle(fontSize: 16, color: Colors.blue)),
        Text(info, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // 热搜项组件
  Widget HotItem(String title, double heat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Text(
          '${heat}万热搜值',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // 提取常量
  static const _gradientColors = [
    Color.fromRGBO(255, 218, 112, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ];
  static const _gradientStops = [0.2, 0.8];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        automaticallyImplyLeading: false, //设置为false
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [Container(child: _buildContent())],
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await getSearchHistoryEntity();
    setState(() {});
  }
}
