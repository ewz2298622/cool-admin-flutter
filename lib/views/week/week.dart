import 'package:flutter/material.dart';

class WeekPage extends StatefulWidget {
  @override
  _WeekPageState createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentDay = (DateTime.now().weekday % 7);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: _currentDay,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("时间表", style: TextStyle(fontSize: 16)),
        //返回
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false, //设置为false
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.pink,
              indicatorWeight: 3.0,
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              tabs: [
                Tab(text: '周日'),
                Tab(text: '周一'),
                Tab(text: '周二'),
                Tab(text: '周三'),
                Tab(text: '周四'),
                Tab(text: '周五'),
                Tab(text: '周六'),
              ],
              isScrollable: true,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAnimeList(0),
                _buildAnimeList(1),
                _buildAnimeList(2),
                _buildAnimeList(3),
                _buildAnimeList(4),
                _buildAnimeList(5),
                _buildAnimeList(6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeList(int day) {
    List<Anime> animeList = _getAnimeDataForDay(day);

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: animeList.length,
      itemBuilder: (context, index) {
        Anime anime = animeList[index];
        return _buildAnimeItem(anime);
      },
    );
  }

  Widget _buildAnimeItem(Anime anime) {
    return Container(
      height: 130,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 封面
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Image.network(
              anime.cover,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          // 内容
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    anime.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  // 更新信息
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: anime.isNew ? Colors.pink : Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          anime.isNew ? '新品' : '更新',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '第${anime.episode}话',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  // 简介
                  Text(
                    anime.description,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  // 底部信息
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 4),
                      Text(
                        anime.time,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Anime> _getAnimeDataForDay(int day) {
    // 模拟真实数据
    Map<int, List<Anime>> data = {
      0: [
        // 周日
        Anime(
          title: '鬼灭之刃 无限列车篇',
          cover:
              'https://cool-file-1300398902.cos.ap-nanjing.myqcloud.com/app%2Fbase%2F78011bd50aa34171ace792e196f6010c_t01d5292bbb53569e2e.jpg',
          episode: 8,
          description: '炭治郎与同伴们在无限列车上与恶鬼战斗的故事',
          time: '23:00',
          isNew: true,
          isFollowed: true,
        ),
        Anime(
          title: '咒术回战',
          cover: 'https://dummyimage.com/200x300/67C23A/fff&text=咒术回战',
          episode: 24,
          description: '虎杖悠仁为了祓除诅咒而战斗的故事',
          time: '22:30',
          isNew: false,
          isFollowed: true,
        ),
      ],
      1: [
        // 周一
        Anime(
          title: '进击的巨人 最终季',
          cover: 'https://dummyimage.com/200x300/E6A23C/fff&text=进击的巨人',
          episode: 16,
          description: '艾伦与巨人之间的最终决战',
          time: '21:00',
          isNew: false,
          isFollowed: true,
        ),
      ],
      2: [
        // 周二
        Anime(
          title: '我的英雄学院',
          cover: 'https://dummyimage.com/200x300/F56C6C/fff&text=我的英雄学院',
          episode: 5,
          description: '绿谷出久成为英雄的故事',
          time: '19:30',
          isNew: true,
          isFollowed: false,
        ),
        Anime(
          title: '约定的梦幻岛',
          cover: 'https://dummyimage.com/200x300/8557D3/fff&text=梦幻岛',
          episode: 12,
          description: '孩子们逃离孤儿院的故事',
          time: '20:00',
          isNew: false,
          isFollowed: true,
        ),
      ],
      3: [
        // 周三
        Anime(
          title: '火影忍者',
          cover: 'https://dummyimage.com/200x300/409EFF/fff&text=火影忍者',
          episode: 220,
          description: '鸣人成为火影的成长之路',
          time: '18:00',
          isNew: false,
          isFollowed: true,
        ),
      ],
      4: [
        // 周四
        Anime(
          title: '全职猎人',
          cover: 'https://dummyimage.com/200x300/67C23A/fff&text=全职猎人',
          episode: 148,
          description: '小杰成为猎人的冒险故事',
          time: '20:30',
          isNew: false,
          isFollowed: false,
        ),
      ],
      5: [
        // 周五
        Anime(
          title: '海贼王',
          cover: 'https://dummyimage.com/200x300/E6A23C/fff&text=海贼王',
          episode: 1000,
          description: '路飞成为海贼王的冒险故事',
          time: '21:30',
          isNew: true,
          isFollowed: true,
        ),
        Anime(
          title: '死神',
          cover: 'https://dummyimage.com/200x300/F56C6C/fff&text=死神',
          episode: 366,
          description: '黑崎一护成为死神的故事',
          time: '22:00',
          isNew: false,
          isFollowed: true,
        ),
      ],
      6: [
        // 周六
        Anime(
          title: '龙珠超',
          cover: 'https://dummyimage.com/200x300/8557D3/fff&text=龙珠超',
          episode: 131,
          description: '孙悟空保护地球的战斗',
          time: '23:30',
          isNew: false,
          isFollowed: true,
        ),
        Anime(
          title: '名侦探柯南',
          cover: 'https://dummyimage.com/200x300/409EFF/fff&text=柯南',
          episode: 1030,
          description: '柯南解决各种案件的故事',
          time: '19:00',
          isNew: false,
          isFollowed: false,
        ),
      ],
    };

    return data[day] ?? [];
  }
}

class Anime {
  final String title;
  final String cover;
  final int episode;
  final String description;
  final String time;
  final bool isNew;
  final bool isFollowed;

  Anime({
    required this.title,
    required this.cover,
    required this.episode,
    required this.description,
    required this.time,
    required this.isNew,
    required this.isFollowed,
  });
}
