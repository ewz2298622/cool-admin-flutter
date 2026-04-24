import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/play_line_entity.dart';
import '../../entity/video_detail_entity.dart';
import '../../entity/video_line_entity.dart';
import 'episode_panel.dart';
import 'short_video_item.dart';
import 'speed_panel.dart';
import 'video_item.dart';

class ShortDrama extends StatefulWidget {
  const ShortDrama({super.key});

  @override
  _ShortDramaState createState() => _ShortDramaState();
}

class _ShortDramaState extends State<ShortDrama> {
  late final Future<String> _futureBuilderFuture;
  final PageController _pageController = PageController();
  VideoDetailData? videoData;
  List<VideoLineDataList> videoLineData = [];
  List<PlayLineDataList> playerLineData = [];
  List<DictDataDataArea>? area = [];
  List<DictDataDataVideoCategory>? videoCategory = [];
  List<DictDataDataLanguage>? language = [];
  final ValueNotifier<int> currentLine = ValueNotifier<int>(0);
  List<VideoItem> _videoList = [];
  final id = Get.arguments["id"];

  int _currentIndex = 0;
  bool _isFollowing = false;
  bool _isLiked = false;
  bool _isFavorited = false;
  int _likeCount = 0;
  int _commentCount = 0;
  int _shareCount = 0;
  bool _isExpanded = false;
  bool _showEpisodePanel = false;
  bool _showSpeedPanel = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  Future<String> init() async {
    try {
      await Future.wait([getVideoById(), getVideoLinePages()]);
      await getPlayLinePages();
      return "success";
    } catch (e) {
      return "success";
    }
  }

  Future<void> getVideoById() async {
    try {
      final response = await Api.getVideoById({"id": id});
      videoData = response.data as VideoDetailData;
      _likeCount =
          videoData?.popularity != null
              ? int.tryParse(videoData!.popularity!) ?? 0
              : 0;
      _commentCount = 120;
      _shareCount = 396;
    } catch (e) {
      debugPrint('getVideoById failed: $e');
    }
  }

  Future<void> getVideoLinePages() async {
    try {
      final response = await Api.getVideoLinePages({"video_id": id});
      videoLineData = response.data?.list ?? [];
    } catch (e) {
      debugPrint('getVideoLinePages failed: $e');
      videoLineData = [];
    }
  }

  Future<void> getPlayLinePages() async {
    try {
      playerLineData.clear();
      if (videoLineData.isEmpty) {
        _videoList = [];
        return;
      }
      final safeIndex = currentLine.value.clamp(0, videoLineData.length - 1);
      final currentVideoLineId = videoLineData[safeIndex].id;
      if (currentVideoLineId == null) {
        _videoList = [];
        return;
      }
      final response = await Api.getPlayLinePages({
        "video_id": id,
        "video_line_id": currentVideoLineId,
        "size": 10000,
      });
      final rawList = response.data?.list;
      playerLineData = rawList ?? [];
      _videoList = List.generate(
        playerLineData.length,
        (index) => VideoItem(
          id: index,
          title: videoData?.title ?? "",
          subTitle: playerLineData[index].subTitle ?? "",
          videoUrl: playerLineData[index].file ?? "",
          coverUrl: videoData?.surfacePlot ?? "",
        ),
      );
    } catch (e) {
      debugPrint('getPlayLinePages failed: $e');
      playerLineData = [];
      _videoList = [];
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  void _toggleEpisodePanel() {
    setState(() {
      _showEpisodePanel = !_showEpisodePanel;
    });
  }

  void _toggleSpeedPanel() {
    setState(() {
      _showSpeedPanel = !_showSpeedPanel;
    });
  }

  void _setPlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _showSpeedPanel = false;
    });
  }

  void _selectEpisode(int index) {
    setState(() {
      _showEpisodePanel = false;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final panelHeight = screenHeight * 0.65;
    final speedPanelHeight = screenHeight * 0.45;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildContent(),
          _buildTopBar(),
          if (_showEpisodePanel) ...[
            _buildEpisodePanelOverlay(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: panelHeight,
              child: EpisodePanel(
                episodes: playerLineData,
                currentIndex: _currentIndex,
                totalCount: _videoList.length,
                title: videoData?.title ?? '',
                coverUrl: videoData?.surfacePlot,
                introduce: videoData?.introduce,
                onEpisodeSelected: _selectEpisode,
                onFavorite: _toggleFavorite,
                isFavorited: _isFavorited,
              ),
            ),
          ],
          if (_showSpeedPanel) ...[
            _buildSpeedPanelOverlay(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: speedPanelHeight,
              child: SpeedPanel(
                currentSpeed: _playbackSpeed,
                onSpeedSelected: _setPlaybackSpeed,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PageLoading();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white54,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  '加载失败',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                  ),
                  child: const Text(
                    '返回',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else if (_videoList.isEmpty) {
          return const Center(
            child: Text(
              '暂无数据',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        return PageView.builder(
          controller: _pageController,
          itemCount: _videoList.length,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final videoItem = _videoList[index];
            return ShortVideoItemWidget(
              key: ValueKey(videoItem.id),
              videoItem: videoItem,
              isActive: index == _currentIndex,
              videoData: videoData!,
              currentIndex: index,
              totalCount: _videoList.length,
              isFollowing: _isFollowing,
              isLiked: _isLiked,
              isFavorited: _isFavorited,
              likeCount: _likeCount,
              commentCount: _commentCount,
              shareCount: _shareCount,
              onLike: _toggleLike,
              onFollow: _toggleFollow,
              onFavorite: _toggleFavorite,
              onEpisodeTap: _toggleEpisodePanel,
              isExpanded: _isExpanded,
              onExpandToggle: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              playbackSpeed: _playbackSpeed,
            );
          },
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '第${_currentIndex + 1}集',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _toggleSpeedPanel,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.av_timer, color: Colors.white, size: 22),
                  const SizedBox(width: 4),
                  Text(
                    '${_playbackSpeed}x',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.more_vert, color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodePanelOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showEpisodePanel = false),
        child: Container(color: Colors.black54),
      ),
    );
  }

  Widget _buildSpeedPanelOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showSpeedPanel = false),
        child: Container(color: Colors.black54),
      ),
    );
  }
}
