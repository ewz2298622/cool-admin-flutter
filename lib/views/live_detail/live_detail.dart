import 'dart:async';
import 'dart:math';

import 'package:dlna_dart/dlna.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../db/entity/LiveCommentEntity.dart';
import '../../db/manager/live_comment_database_helper.dart';
import '../../entity/live_info_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../utils/user.dart';
import '../../utils/video.dart';

String TAG = 'Video_Detail';

class Live_Detail extends StatefulWidget {
  const Live_Detail({super.key});

  @override
  Live_DetailState createState() => Live_DetailState();
}

class Live_DetailState extends State<Live_Detail>
    with SingleTickerProviderStateMixin {
  final int id = Get.arguments?["id"] ?? 0;

  final ValueNotifier<int> currentPlay = ValueNotifier<int>(0);
  late Future<void> _loadFuture;
  LiveInfoData? videoData;
  List<VideoPageDataList> videoPageData = [];
  late Player player;
  late VideoController videoController;
  List<dynamic> deviceList = [];
  StateSetter? TVshowModalBottomSheetListSate;
  String? _errorMessage;
  late final int _viewerSeed;
  String _currentTime = '';
  Timer? _timeTimer;

  final LiveCommentDatabaseHelper _commentDatabaseHelper = LiveCommentDatabaseHelper();
  List<LiveCommentEntity> _commentList = [];
  final TextEditingController _commentController = TextEditingController();

  Future<void> liveInfo() async {
    try {
      videoData = (await Api.liveInfo({"id": id})).data as LiveInfoData;
    } catch (e) {
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
      _loadComments();
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

  void _loadComments() {
    try {
      _commentList = _commentDatabaseHelper.findByLiveId(id).toList();
    } catch (e) {
      debugPrint('Failed to load comments: $e');
      _commentList = [];
    }
  }

  Future<void> setVideoUrl(String url) async {
    try {
      final trimmed = url.trim();
      if (trimmed.isEmpty) {
        debugPrint('setVideoUrl skip: empty url');
        return;
      }
      await player.open(Media(trimmed), play: true);
      debugPrint('setVideoUrl success: $trimmed');
    } catch (error) {
      debugPrint('setVideoUrl error: $error');
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    player = Player(
      configuration: VideoUtil.getConfig(),
    );
    videoController = VideoController(player);
    _viewerSeed = 1200 + (id % 7300);
    _loadFuture = _loadInitialData();
    _startTimeTimer();
  }

  @override
  void dispose() {
    currentPlay.dispose();
    player.dispose();
    _timeTimer?.cancel();
    _commentController.dispose();
    super.dispose();
  }

  void _startTimeTimer() {
    _updateTime();
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  Widget _buildContent() {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        }
        if (snapshot.hasError || _errorMessage != null) {
          final message =
              snapshot.error?.toString() ?? _errorMessage ?? '加载直播信息失败';
          return _buildErrorView(message);
        }
        if (videoData == null) {
          return _buildErrorView('暂未获取到直播间信息');
        }
        return Column(
          children: [
            _buildLiveSection(context),
            Expanded(
              child: _buildCommentSection(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLiveSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVideo(context),
        _buildVideoInfoSection(context),
      ],
    );
  }

  Widget _buildVideoInfoSection(BuildContext context) {
    final live = videoData;
    if (live == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1A1A1A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  live.title ?? 'CCTV5+体育赛事',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '在线: ${_viewerSeed + DateTime.now().second * 12}人',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.star_border,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  // 收藏功能
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      '官',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '官方',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4F5A),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '置顶',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '亲爱的用户：\n影片卡顿、加载缓慢、内容错误、跳进度等请先切换线路尝试观看，谢谢！',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.thumb_up_off_alt,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    // 点赞功能
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        
        return Container(
          color: const Color(0xFF121212),
          child: Column(
            children: [
              Expanded(
                child: _commentList.isEmpty
                    ? const Center(
                        child: Text(
                          '暂无留言，快来抢沙发吧~',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _commentList.length,
                        itemBuilder: (context, index) {
                          final comment = _commentList[index];
                          return _buildCommentItem(comment);
                        },
                      ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 8,
                  bottom: 8 + keyboardHeight,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF333333),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _commentController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: '请输入留言内容~',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _submitComment(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '发表',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentItem(LiveCommentEntity comment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[700],
            ),
            child: comment.avatarUrl != null && comment.avatarUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      comment.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            comment.nickName?.substring(0, 1) ?? '用',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      comment.nickName?.substring(0, 1) ?? '用',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      User.getPhoneNumber(comment.nickName) ?? '用户',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(comment.createTime),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(time);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return '刚刚';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}分钟前';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}小时前';
      } else {
        return '${difference.inDays}天前';
      }
    } catch (e) {
      return '';
    }
  }

  void _submitComment(BuildContext context) {
    if (!User.isUserLoginView(context)) {
      return;
    }

    final content = _commentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入留言内容'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final userInfo = User.userInfoData;
      final comment = LiveCommentEntity(
        liveId: id,
        userId: userInfo?.userId,
        nickName: userInfo?.nickName ?? '用户',
        avatarUrl: userInfo?.avatarUrl,
        content: content,
      );

      _commentDatabaseHelper.insert(comment);
      _commentController.clear();
      _loadComments();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('留言成功'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('Failed to submit comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('留言失败，请稍后重试'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildErrorView(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 52,
              color: theme.colorScheme.primary,
            ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          videoData?.title ?? 'CCTV5+体育赛事',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
         
          const SizedBox(width: 8),
        ],
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

  Widget _buildVideo(BuildContext context) {
    final cover = videoData?.image ?? '';

    return AspectRatio(
      aspectRatio: 16 / 9,
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
          Video(
            controller: videoController,
            fill: Colors.transparent,
            fit: BoxFit.contain,
            controls: null,
          ),
        ],
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
