import 'package:flutter/material.dart';

import '../../../components/banner_ads.dart';
import '../../../components/loading.dart';
import '../../../style/layout.dart';
import '../Components/guess_you_like.dart';
import '../Components/video_info_view.dart';
import '../../../entity/dict_data_entity.dart';
import '../../../entity/video_detail_data_entity.dart';
import '../../../entity/video_page_entity.dart';
import 'video_info_section.dart';

class DetailContentView extends StatelessWidget {
  final Future<String> future;
  final VideoDetailDataData videoInfoData;
  final List<DictDataDataArea>? area;
  final List<DictDataDataVideoCategory>? videoCategory;
  final List<DictDataDataLanguage>? language;
  final List<VideoPageDataList> videoPageData;
  final ValueNotifier<int> currentLine;
  final ValueNotifier<int> currentPlay;
  final VoidCallback showModalBottomSheetList;
  final Function(String) setVideoUrl;
  final VoidCallback onVideoTap;
  final VoidCallback onFeedbackTap;
  final String androidCodeId;
  final String iosCodeId;
  final bool isAdAvailable;

  const DetailContentView({
    super.key,
    required this.future,
    required this.videoInfoData,
    required this.area,
    required this.videoCategory,
    required this.language,
    required this.videoPageData,
    required this.currentLine,
    required this.currentPlay,
    required this.showModalBottomSheetList,
    required this.setVideoUrl,
    required this.onVideoTap,
    required this.onFeedbackTap,
    required this.androidCodeId,
    required this.iosCodeId,
    required this.isAdAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return _buildLoadedContent();
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  Widget _buildLoadedContent() {
    return Padding(
      padding: const EdgeInsets.only(left: Layout.paddingL, right: Layout.paddingR),
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildVideoInfo(),
                          _buildBanner(),
                          _buildRecommendations(),
                        ],
                      ),
                    ),
                    SingleChildScrollView(child: _buildTabsVideoInfo()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TabBar(
          dividerHeight: 0,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorPadding: const EdgeInsets.all(0),
          indicator: UnderlineTabIndicator(
            borderSide: const BorderSide(width: 0.0, color: Colors.transparent),
          ),
          unselectedLabelColor: const Color(0xFF9CA3AF),
          labelColor: const Color(0xFF111827),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [Tab(text: '详情'), Tab(text: '简介')],
        ),
        IconButton(
          onPressed: onFeedbackTap,
          icon: const Icon(Icons.warning_rounded, color: Color(0xFF6B7280)),
          iconSize: 24,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildVideoInfo() {
    return VideoInfoSection(
      videoInfoData: videoInfoData,
      area: area,
      videoCategory: videoCategory,
      language: language,
      currentLine: currentLine,
      currentPlay: currentPlay,
      showModalBottomSheetList: showModalBottomSheetList,
      setVideoUrl: setVideoUrl,
    );
  }

  Widget _buildBanner() {
    if (isAdAvailable) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: Layout.paddingL, right: Layout.paddingR),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: BannerAds(androidCodeId: androidCodeId, iosCodeId: iosCodeId),
      );
    }
    return Container();
  }

  Widget _buildRecommendations() {
    return GuessYouLike(videoPageData: videoPageData, onVideoTap: onVideoTap);
  }

  Widget _buildTabsVideoInfo() {
    return VideoInfoView(
      videoInfoData: videoInfoData,
      area: area,
      videoCategory: videoCategory,
      language: language,
    );
  }
}
