import 'package:flutter/material.dart';

import '../../entity/play_line_entity.dart';
import '../../style/color_styles.dart';
import '../../utils/video.dart';

class EpisodePanel extends StatefulWidget {
  final List<PlayLineDataList> episodes;
  final int currentIndex;
  final int totalCount;
  final String title;
  final String? coverUrl;
  final String? introduce;
  final Function(int) onEpisodeSelected;
  final VoidCallback onFavorite;
  final bool isFavorited;

  const EpisodePanel({
    super.key,
    required this.episodes,
    required this.currentIndex,
    required this.totalCount,
    required this.title,
    required this.coverUrl,
    required this.introduce,
    required this.onEpisodeSelected,
    required this.onFavorite,
    required this.isFavorited,
  });

  @override
  State<EpisodePanel> createState() => _EpisodePanelState();
}

class _EpisodePanelState extends State<EpisodePanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentRangeIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ranges = <String>[];
    if (widget.totalCount <= 30) {
      ranges.add('1-${widget.totalCount}');
    } else {
      for (int i = 0; i < widget.totalCount; i += 30) {
        final end = (i + 30) < widget.totalCount ? (i + 30) : widget.totalCount;
        ranges.add('${i + 1}-$end');
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _buildHeader(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey.shade400,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              tabs: const [Tab(text: '简介'), Tab(text: '选集')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildIntroTab(), _buildEpisodeTab(ranges)],
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildIntroTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        VideoUtil.extractPlainText(widget.introduce ?? '暂无简介'),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildEpisodeTab(List<String> ranges) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: _buildEpisodeGrid(ranges),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.coverUrl ?? '',
              width: 48,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    width: 48,
                    height: 64,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.movie, color: Colors.grey),
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
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xFF000000),
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '已完结 共${widget.totalCount}集',
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeGrid(List<String> ranges) {
    final startRange = ranges[_currentRangeIndex.clamp(0, ranges.length - 1)];
    final parts = startRange.split('-');
    final start = int.tryParse(parts[0]) ?? 1;
    final end = int.tryParse(parts[1]) ?? widget.episodes.length;
    final displayCount = (end - start + 1).clamp(0, widget.episodes.length);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        childAspectRatio: 1.3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: displayCount,
      itemBuilder: (context, index) {
        final episodeNum = start + index;
        final isSelected = episodeNum - 1 == widget.currentIndex;
        final isCurrent = episodeNum == 1;

        return GestureDetector(
          onTap: () => widget.onEpisodeSelected(episodeNum - 1),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color:
                  isSelected ? const Color(0xFFFFF3E0) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border:
                  isSelected
                      ? Border.all(color: ColorStyles.colorPrimary, width: 1)
                      : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '$episodeNum',
                    style: TextStyle(
                      color:
                          isSelected
                              ? ColorStyles.colorPrimary
                              : Colors.black87,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isCurrent)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Text(
                      '小',
                      style: TextStyle(
                        color: ColorStyles.colorPrimary,
                        fontSize: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: widget.onFavorite,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorStyles.colorPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isFavorited ? Icons.star : Icons.star_border,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isFavorited ? '已收藏' : '收藏',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
