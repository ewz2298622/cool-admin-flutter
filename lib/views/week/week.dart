import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../entity/dict_data_entity.dart';
import '../../entity/week_entity.dart';
import '../../router/routes.dart';
import '../../utils/video.dart';

/// 周播放时间表页面
///
/// 显示按星期分类的视频列表，用户可以通过顶部Tab切换不同日期的视频内容
class WeekPage extends StatefulWidget {
  @override
  _WeekPageState createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> with TickerProviderStateMixin {
  late Future<String> _futureBuilderFuture;
  late TabController _tabController;
  List<TDTab> tabs = [];

  /// 存储每周的视频列表数据
  /// 结构: List<每日视频列表>
  List<List<WeekDataList>> weekList = [];

  /// 存储星期字典数据
  List<DictDataDataWeek> week = [];
  List<RefreshController> tabRefreshControllers = [];

  /// 获取字典信息和对应的星期数据
  ///
  /// 从 API 获取星期分类数据，并为每个分类获取对应的视频列表
  /// 通过单次请求获取所有星期的数据，减少网络请求次数
  Future<void> getDictInfoPages() async {
    try {
      final dictResponse = await Api.getDictData({
        "types": ["week"],
      });
      
      final dictData = dictResponse.data;
      if (dictData == null || dictData.week == null) {
        throw Exception('Failed to get week data');
      }
      
      week = dictData.week!;

      tabs.clear();
      weekList.clear();

      // 为每个星期创建一个空列表
      for (var element in week) {
        tabs.add(TDTab(text: element.name));
        weekList.add([]);
      }

      // 单次请求获取所有星期的数据
      await getAllWeekList();
    } catch (e) {
      // 清空数据以防止不一致
      tabs.clear();
      weekList.clear();
      // 可以在这里添加日志记录
      debugPrint('Error in getDictInfoPages: $e');
    }
  }

  /// 格式化字符串，支持逗号和斜杠分隔符
  ///
  /// [str] 输入的字符串，可能包含逗号或斜杠分隔的多个值
  /// 返回分割后的字符串列表
  List<String> formatString(String str) {
    if (str.contains(',')) {
      return str.split(',');
    }
    if (str.contains('/')) {
      return str.split('/');
    }
    return [str];
  }

  /// 构建单个星期视频项的UI组件
  ///
  /// [item] 视频数据对象
  /// 返回包含视频封面、标题、标签和简介的列表项组件
  Widget _buildWeekItem(WeekDataList item) {
    return GestureDetector(
      child: Container(
        height: 150,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white, // 使用主题色适配黑夜模式
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1), // 使用主题阴影色
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          // 使用spacing替代手动添加间距
          spacing: 10,
          children: [
            // 视频封面图片
            TDImage(
              fit: BoxFit.cover,
              width: 110,
              height: 140,
              imgUrl: item.surfacePlot ?? "",
              errorWidget: const TDImage(
                width: 110,
                height: 140,
                assetUrl: 'assets/images/loading.gif',
              ),
            ),
            // 视频信息内容区域
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 视频标题
                    Text(
                      item.title ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(
                              context,
                            ).textTheme.bodyLarge?.color, // 使用主题文字颜色
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    // 视频分类标签区域
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
                    // 视频简介
                    Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      VideoUtil.extractPlainText(item.introduce ?? ""),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color
                            ?.withOpacity(0.6), // 使用主题文字颜色并调整透明度
                        fontSize: 12,
                      ),
                    ),
                    // 底部时间信息
                    Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color
                              ?.withOpacity(0.6), // 使用主题图标颜色
                        ),
                        Text(
                          VideoUtil.formatTime(item.time ?? "00:00:00"),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color
                                ?.withOpacity(0.6), // 使用主题文字颜色
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
      onTap:
          () => Get.toNamed(AppRoutes.videoDetail, arguments: {"id": item.videoId}),
    );
  }

  /// 获取所有星期的视频列表
  ///
  /// 一次性获取所有星期的数据，减少网络请求次数
  Future<void> getAllWeekList() async {
    try {
      // 构建包含所有星期ID的数组
      List<int> weekIds = week.map((element) => element.id ?? 0).toList();
      
      // 单次请求获取所有星期的数据
      final response = await Api.getWeek({
        "page": 1,
        "size": 100,
        "week": weekIds,
      });
      
      final allList = response.data?.list ?? [];

      // 为每个星期分配对应的数据
      for (int i = 0; i < week.length; i++) {
        int weekId = week[i].id ?? 0;
        // 筛选出当前星期的数据
        List<WeekDataList> weekData = allList.where((item) => item.week == weekId).toList();
        weekList[i] = weekData;
      }
    } catch (e) {
      // 发生错误时，保持空列表
      for (int i = 0; i < weekList.length; i++) {
        weekList[i] = [];
      }
      // 记录错误日志
      debugPrint('Error in getAllWeekList: $e');
    }
  }

  /// 获取指定星期的视频列表
  ///
  /// [weekId] 星期ID，用于查询对应日期的视频
  /// 从API获取视频列表并添加到weekList中
  Future<void> getWeekList(int weekId) async {
    try {
      // 单次请求获取指定星期的数据
      final response = await Api.getWeek({
        "page": 1,
        "size": 100,
        "week": weekId,
      });
      
      final list = response.data?.list ?? [];

      // 在初始化阶段添加新列表
      if (weekList.length < week.length) {
        weekList.add(list);
      } else {
        // 在刷新阶段更新对应的列表（通过weekId找到对应的索引）
        final index = week.indexWhere((element) => element.id == weekId);
        if (index != -1 && index < weekList.length) {
          weekList[index] = list;
        }
      }
    } catch (e) {
      // 在初始化阶段添加空列表
      if (weekList.length < week.length) {
        weekList.add([]);
      } else {
        // 在刷新阶段更新对应的空列表
        final index = week.indexWhere((element) => element.id == weekId);
        if (index != -1 && index < weekList.length) {
          weekList[index] = [];
        }
      }
      // 记录错误日志
      debugPrint('Error in getWeekList for weekId $weekId: $e');
    }
  }

  /// 初始化页面数据
  ///
  /// 调用getDictInfoPages获取所有数据，并初始化TabController
  /// 返回初始化结果字符串
  Future<String> init() async {
    try {
      await getDictInfoPages();
      // 确保在有数据的情况下才初始化TabController
      if (tabs.isNotEmpty) {
        _tabController = TabController(length: tabs.length, vsync: this);
        // 初始化tabRefreshControllers数组
        tabRefreshControllers = List.generate(
          tabs.length,
          (index) => RefreshController(),
        );
      }
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
    // 释放TabController资源
    _tabController.dispose();

    // 释放所有RefreshController资源
    for (var controller in tabRefreshControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  /// 检查内容是否为空并返回相应组件
  ///
  /// 如果tabs为空则显示无数据组件，否则显示Tab内容
  Widget contentIsEmpty(BuildContext context) {
    if (tabs.isEmpty) {
      return NoData();
    } else {
      return _buildTabs(context);
    }
  }

  /// 构建页面主要内容
  ///
  /// 使用FutureBuilder处理异步数据加载状态
  /// 显示加载中、错误或实际内容
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
          return contentIsEmpty(context);
        } else {
          return Text('No data available');
        }
      },
    );
  }

  /// 构建Tab导航和内容视图
  ///
  /// 包含可滚动的TabBar和对应的TabBarView内容区域
  Widget _buildTabs(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabCount = week.length;
    // 计算每个tab的最小宽度，假设每个tab至少需要80像素
    const double minTabWidth = 80.0;
    // 计算当所有tab平均分布时需要的最小屏幕宽度
    final double requiredWidth = tabCount * minTabWidth;
    
    // 判断是否需要平均分布
    final bool shouldDistributeEvenly = screenWidth >= requiredWidth;

    return Column(
      children: [
        // 顶部Tab导航栏
        Container(
          color: Theme.of(context).appBarTheme.backgroundColor, // 使用主题背景色
          child: TabBar(
            tabAlignment: shouldDistributeEvenly ? TabAlignment.fill : TabAlignment.center,
            controller: _tabController,
            indicatorColor: Color.fromRGBO(255, 153, 0, 1),
            indicatorWeight: 3.0,
            labelColor: Color.fromRGBO(255, 153, 0, 1),
            unselectedLabelColor:
                Theme.of(context).textTheme.bodyMedium?.color, // 使用主题文字颜色
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            tabs: week.map((e) => Tab(text: e.name)).toList(),
            isScrollable: !shouldDistributeEvenly,
          ),
        ),
        // Tab内容区域
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

  // 添加刷新控制器

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("时间表", style: TextStyle(fontSize: 16)),
        //返回按钮
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false, //设置为false
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor, // 使用主题背景色
      ),
      body: _buildContent(context),
    );
  }

  /// 构建指定日期的动漫列表
  ///
  /// [day] 日期索引
  /// 使用ListView.builder构建可滚动的视频列表
  Widget _buildAnimeList(int day) {
    // 检查空状态
    if (_isAnimeListEmpty(day)) {
      return NoData();
    }

    debugPrint('weekList[day]: $day');

    // 确保刷新控制器存在
    _ensureRefreshControllerExists(day);

    return SmartRefresher(
      controller: tabRefreshControllers[day],
      onRefresh: () async {
        // 刷新当前tab的数据
        await _refreshAnimeList(day);
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: weekList[day].length,
        itemBuilder: (context, index) {
          return _buildWeekItem(weekList[day][index]);
        },
      ),
    );
  }

  /// 检查动漫列表是否为空
  ///
  /// [day] 日期索引
  /// 返回是否为空
  bool _isAnimeListEmpty(int day) {
    return day >= weekList.length || weekList[day].isEmpty;
  }

  /// 确保刷新控制器存在
  ///
  /// [day] 日期索引
  void _ensureRefreshControllerExists(int day) {
    while (tabRefreshControllers.length <= day) {
      tabRefreshControllers.add(RefreshController());
    }
  }

  /// 刷新动漫列表数据
  ///
  /// [day] 日期索引
  Future<void> _refreshAnimeList(int day) async {
    await getWeekList(week[day].id ?? 0);
    if (mounted) {
      setState(() {});
    }
    tabRefreshControllers[day].refreshCompleted();
  }
}
