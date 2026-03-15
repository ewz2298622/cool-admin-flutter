import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../entity/score_order_entity.dart';

class ScoreOrder extends StatefulWidget {
  const ScoreOrder({super.key});

  @override
  ScoreOrderState createState() => ScoreOrderState();
}

class ScoreOrderState extends State<ScoreOrder>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var _futureBuilderFuture;
  List<ScoreOrderDataList> scoreOrderDataList = [];
  int currentPage = 1;
  bool disposed = false;
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  bool get wantKeepAlive => true;

  // 数据加载逻辑
  Future<void> loadScoreOrders() async {
    try {
      List<ScoreOrderDataList> list =
          (await Api.getScoreOrder({"page": currentPage})).data?.list
              as List<ScoreOrderDataList>;
      setState(() {
        scoreOrderDataList.addAll(list);
      });
    } catch (e) {
      debugPrint('Failed to load score orders: $e');
    }
  }

  Future<String> init() async {
    try {
      _scrollControllerAdd();
      await loadScoreOrders();
      return "init success";
    } catch (e) {
      return "init failed";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  _scrollControllerAdd() {
    _scrollController.addListener(listenLoadMoreCallback);
  }

  void listenLoadMoreCallback() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    debugPrint('loadMore');
    currentPage++;
    await loadScoreOrders();
    if (disposed) {
      return;
    }
    setState(() {});
  }

  // 刷新方法
  Future<void> _onRefresh() async {
    currentPage = 1;
    scoreOrderDataList.clear();
    await loadScoreOrders();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  // 加载更多方法
  Future<void> _onLoading() async {
    currentPage++;
    await loadScoreOrders();
    if (mounted) {
      setState(() {});
      _refreshController.loadComplete();
    }
  }

  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return contentIsEmpty(context);
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget contentIsEmpty(BuildContext context) {
    if (scoreOrderDataList.isEmpty) {
      return NoData();
    } else {
      return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // 顶部标题区域
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                //居中
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  //蓝色圆形
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFBAE7FF), Color(0xFF69C0FF)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Text(
                    "积分明细",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFBAE7FF), Color(0xFF69C0FF)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            // 列表区域
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                enablePullUp: true,
                child: ListView.builder(
                  itemCount: scoreOrderDataList.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = scoreOrderDataList[index];
                    final score = item.score ?? 0;
                    final isIncome = item.type == 1; // 1 为收入，0 为支出
                    final createTime = item.createTime ?? "";

                    return Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(241, 241, 241, 1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // 左侧：标题和时间
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.reason ?? "无描述",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  createTime,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 右侧：分数
                          Text(
                            "${score > 0 ? '+' : ''}$score",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFB300),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "积分中心",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 26.06 / 18,
          ),
        ),
        //返回按钮
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 50,
        automaticallyImplyLeading: false, //设置为 false
        backgroundColor: Colors.transparent, // 透明背景
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 渐变背景，固定高度 500
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 500,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromRGBO(80, 166, 255, 1),
                    const Color.fromRGBO(60, 156, 255, 1),
                    const Color.fromRGBO(60, 156, 255, 0),
                  ],
                  stops: const [0.0, 0.7561, 1.0],
                ),
              ),
            ),
          ),
          // 内容区域 - 添加 SafeArea 避免被状态栏遮挡
          SafeArea(child: _buildContent()),
        ],
      ),
    );
  }
}
