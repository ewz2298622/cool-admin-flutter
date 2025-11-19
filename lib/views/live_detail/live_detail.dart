import 'dart:async';

import 'package:dlna_dart/dlna.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fplayer/fplayer.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../components/video_three.dart';
import '../../entity/live_info_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../style/layout.dart';

String TAG = 'Video_Detail';

class Live_Detail extends StatefulWidget {
  //接受路由传递过来的props id
  final int id;
  const Live_Detail({super.key, required this.id});

  @override
  Live_DetailState createState() => Live_DetailState();
}

class Live_DetailState extends State<Live_Detail>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0);
  //获取当前时间戳
  final int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

  late Future<void> _loadFuture;
  LiveInfoData? videoData;
  List<VideoPageDataList> videoPageData = [];
  List<VideoItem> videoList = [];
  final FPlayer player = FPlayer();
  List<dynamic> deviceList = [];
  StateSetter? TVshowModalBottomSheetListSate;
  String? _errorMessage;
  late final int _viewerSeed;

  Future<void> liveInfo() async {
    try {
      videoData = (await Api.liveInfo({"id": widget.id})).data as LiveInfoData;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getVideoPages() async {
    try {
      List<VideoPageDataList> list =
          (await Api.getVideoPages({})).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageData = list;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> _loadInitialData() async {
    _errorMessage = null;
    try {
      await Future.wait([liveInfo(), getVideoPages()]);
      final streamUrl = videoData?.pullUrl ?? '';
      if (streamUrl.isNotEmpty) {
        await setVideoUrl(streamUrl);
      } else {
        debugPrint('Live detail pullUrl is empty.');
      }
      debugPrint('videoData: $streamUrl');
      if (mounted) {
        setState(() {});
      }
    } catch (e, stackTrace) {
      _errorMessage = e.toString();
      debugPrint('Initialization failed: $e');
      debugPrint('$stackTrace');
      rethrow;
    }
  }

  Future<void> setVideoUrl(String url) async {
    try {
      final trimmed = url.trim();
      if (trimmed.isEmpty) {
        debugPrint('setVideoUrl skip: empty url');
        return;
      }
      try {
        await player.reset();
      } catch (_) {
        // ignore reset error
      }
      await player.setDataSource(trimmed, autoPlay: true, showCover: true);
      debugPrint('setVideoUrl success: $trimmed');
    } catch (error) {
      debugPrint('setVideoUrl error: $error');
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _viewerSeed = 1200 + (widget.id % 7300);
    _loadFuture = _loadInitialData();
  }

  @override
  void dispose() {
    currentPlay.dispose();
    player.release();
    super.dispose();
  }

  Widget _buildRecommendations(BuildContext context) {
    if (videoPageData.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Layout.paddingL,
        0,
        Layout.paddingR,
        Layout.paddingB,
      ),
      child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionWithMore(
                title: "猜你喜欢",
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              VideoThree(videoPageData: videoPageData),
            ],
          ),
    );
  }

  Widget _buildContent() {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        }
        if (snapshot.hasError || _errorMessage != null) {
          final message = snapshot.error?.toString() ?? _errorMessage ?? '加载直播信息失败';
          return _buildErrorView(message);
        }
        if (videoData == null) {
          return _buildErrorView('暂未获取到直播间信息');
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _playerHeight,
              child: _buildVideo(context),
            ),
            Positioned.fill(
              top: _playerHeight - 22,
              child: _buildScrollableSheet(context),
            ),
          ],
        );
      },
    );
  }

  //实现一个格式化函数 判断传入的字符串是否含有,或者/ 如果有就按照这两个字符串分割返回一个list
  List<String> formatString(String str) {
    if (str.contains(',')) {
      return str.split(',');
    }
    if (str.contains('/')) {
      return str.split('/');
    }
    return [str];
  }

  Widget _buildScrollableSheet(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.3 : 0.09,
            ),
            blurRadius: 24,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
            sliver: SliverToBoxAdapter(child: _buildMetaSection(context)),
          ),
          if (videoPageData.isNotEmpty)
            SliverToBoxAdapter(child: _buildRecommendations(context)),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaSection(BuildContext context) {
    final live = videoData;
    if (live == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final viewersLabel =
        '${_formatViewers(_viewerSeed + DateTime.now().second * 12)} 人正在观看';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          live.title ?? '精彩直播',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildStatsChip(
                context,
                icon: Icons.visibility_outlined,
                label: viewersLabel,
              ),
              const SizedBox(width: 12),
              _buildStatsChip(
                context,
                icon: Icons.live_tv_rounded,
                label: _formatLiveStatus(live.status),
              ),
              // const SizedBox(width: 12),
              // if (live.categoryId != null)
              //   _buildStatsChip(
              //     context,
              //     icon: Icons.category_outlined,
              //     label: '#${_formatLiveStatus(live.categoryId)}',
              //   ),
              const SizedBox(width: 12),
              if (live.updateTime != null)
                _buildStatsChip(
                  context,
                  icon: Icons.shield_outlined,
                  label: '已同步',
                ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildAttributeCell(ThemeData theme, _AttributeItem item) {
    final bool isDark = theme.brightness == Brightness.dark;
    final background = isDark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.22)
        : theme.colorScheme.surfaceVariant.withOpacity(0.7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : theme.colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 52, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              '加载失败',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _loadFuture = _loadInitialData();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('重新加载'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelButton(
    BuildContext context, {
    required IconData icon,
    BorderRadius? shape,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: shape ?? BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: theme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildLiveBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF4F5A), Color(0xFFFF8D46)],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'LIVE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewerBadge(ThemeData theme) {
    final viewers =
        _formatViewers(_viewerSeed + DateTime.now().second * 12);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility_outlined, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            viewers,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatViewers(int count) {
    if (count >= 10000) {
      final double wan = count / 10000.0;
      final String formatted =
          wan >= 10 ? wan.toStringAsFixed(0) : wan.toStringAsFixed(1);
      return '$formatted万';
    }
    return count.toString();
  }

  String _formatLiveStatus(int? status) {
    if (status == 1) {
      return '直播中';
    }
    if (status == 0) {
      return '已结束';
    }
    return '未开播';
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) {
      return '--';
    }
    if (dateTime.contains(' ')) {
      return dateTime.split(' ').first;
    }
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: _buildContent(),
    );
  }

  Future<void> searchDevice() async {
    final searcher = DLNAManager();
    final manager = await searcher.start();
    manager.devices.stream.listen((dataList) {
      for (var entry in dataList.entries) {
        final key = entry.key;
        final value = entry.value;

        TVshowModalBottomSheetListSate?.call(() {
          if (deviceList.isEmpty) {
            deviceList.add({'key': key, 'value': value});
          } else {
            final exists = deviceList.any((element) => element['key'] == key);
            if (!exists) {
              deviceList.add({'key': key, 'value': value});
            }
          }
        });
      }
    });
  }

  static const double _playerHeight = 250.0;

  Widget _buildVideo(BuildContext context) {
    final theme = Theme.of(context);
    final cover = videoData?.image ?? '';

    return SizedBox(
      height: _playerHeight,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (cover.isNotEmpty)
              FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: cover,
                fit: BoxFit.cover,
              )
            else
              Container(color: Colors.black),
            FView(
              player: player,
              width: double.infinity,
              height: _playerHeight,
              color: Colors.transparent,
              fsFit: FFit.contain,
              fit: FFit.fill,
              panelBuilder: (FPlayer player, FData data, BuildContext context, Size viewSize, Rect texturePos) {
                // 自定义面板，隐藏播放/暂停按钮和全屏按钮
                // 直播流不需要显示进度条和播放控制按钮
                return Stack(
                  children: [
                    // 右侧自定义按钮
                    // Positioned(
                    //   right: 8,
                    //   top: 8,
                    //   child: Column(
                    //     children: [
                    //       _buildPanelButton(
                    //         context,
                    //         icon: Icons.favorite_border_rounded,
                    //         shape: const BorderRadius.vertical(top: Radius.circular(8)),
                    //       ),
                    //       _buildPanelButton(
                    //         context,
                    //         icon: Icons.thumb_up_alt_outlined,
                    //         shape: const BorderRadius.vertical(bottom: Radius.circular(8)),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                );
              },
            ),
            IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x66000000),
                      Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 30,
              child: _buildLiveBadge(theme),
            ),
            Positioned(
              right: 16,
              bottom: 30,
              child: _buildViewerBadge(theme),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttributeItem {
  const _AttributeItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}
