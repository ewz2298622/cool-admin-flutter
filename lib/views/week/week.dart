import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/week_entity.dart';
import '../../utils/video.dart';
import '../video_detail/detail.dart';

class WeekPage extends StatefulWidget {
  @override
  _WeekPageState createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> with TickerProviderStateMixin {
  var _futureBuilderFuture;
  late TabController _tabController;
  List<TDTab> tabs = [];

  List<List<WeekDataList>> weekList = [];

  List<DictDataDataWeek> week = [];

  Future<void> getDictInfoPages() async {
    try {
      week =
          ((await Api.getDictData({
                    "types": ["week"],
                  })).data
                  as DictDataData)
              .week!;

      tabs.clear();
      for (var element in week) {
        tabs.add(TDTab(text: element.name));
        await getWeekList(element.id ?? 0);
      }
    } catch (e) {
      // 捕获并处理异常
      print('获取视频分类数据失败: $e');
    }
  }

  List<String> formatString(String str) {
    if (str.contains(',')) {
      return str.split(',');
    }
    if (str.contains('/')) {
      return str.split('/');
    }
    return [str];
  }

  Widget _buildWeekItem(WeekDataList item) {
    return GestureDetector(
      child: Container(
        height: 150,
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
          spacing: 10,
          children: [
            // 封面
            TDImage(
              fit: BoxFit.cover,
              width: 110,
              height: 140,
              imgUrl: item.surfacePlot ?? "",
              errorWidget: const TDImage(
                width: 150,
                assetUrl: 'assets/images/loading.gif',
              ),
            ),
            // 内容
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 标题
                    Text(
                      item.title ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    // 更新信息
                    SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children:
                              formatString(item.videoClass ?? "")
                                  .map(
                                    (name) => TDTag(
                                      name,
                                      isLight: true,
                                      theme: TDTagTheme.danger,
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                    // 简介
                    Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      VideoUtil.extractPlainText(item.introduce ?? ""),
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    // 底部信息
                    Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        Text(
                          item.time ?? "",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Video_Detail(id: item.videoId ?? 0),
          ),
        );
      },
    );
  }

  Future<void> getWeekList(int week) async {
    try {
      List<WeekDataList> list =
          ((await Api.getWeek({
                "page": 1,
                "size": 100,
                "week": week,
              })).data?.list
              as List<WeekDataList>);
      debugPrint('getWeekList: ${list.length}');
      weekList.add(list);
    } catch (e) {
      // 捕获并处理异常
      print('获取视频分类数据失败: $e');
    }
  }

  Future<String> init() async {
    try {
      await getDictInfoPages();
      _tabController = TabController(length: tabs.length, vsync: this);
      return "init success";
    } catch (e) {
      return "init err";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent(BuildContext context) {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        debugPrint('snapshot: ${snapshot.hasData}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.hasData) {
          return _buildTabs(context);
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Color.fromRGBO(255, 153, 0, 1),
            indicatorWeight: 3.0,
            labelColor: Color.fromRGBO(255, 153, 0, 1),
            unselectedLabelColor: Colors.black54,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            tabs: week.map((e) => Tab(text: e.name)).toList(),
            isScrollable: true,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(
              week.length,
              (index) => _buildAnimeList(index),
            ),
          ),
        ),
      ],
    );
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
      body: _buildContent(context),
    );
  }

  Widget _buildAnimeList(int day) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: weekList[day].length,
      itemBuilder: (context, index) {
        return _buildWeekItem(weekList[day][index]);
      },
    );
  }
}
