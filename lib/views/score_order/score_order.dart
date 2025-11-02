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
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullUp: true,
        child: ListView.builder(
          itemCount: scoreOrderDataList.length ?? 0,
          itemBuilder: (context, index) {
            final item = scoreOrderDataList[index];
            final score = item.score ?? 0;
            final isIncome = item.type == 1; // 1为收入，0为支出

            // 根据主题确定卡片背景色
            Color cardBgColor = Theme.of(context).brightness == Brightness.dark 
                ? Color(0xFF1D1D1D) 
                : Colors.white;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: Theme.of(context).brightness == Brightness.dark ? 0 : 1,
              color: cardBgColor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient:
                      isIncome
                          ? LinearGradient(
                            colors: Theme.of(context).brightness == Brightness.dark
                                ? [Color(0xFF0D47A1), Color(0xFF1565C0)]
                                : [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : LinearGradient(
                            colors: Theme.of(context).brightness == Brightness.dark
                                ? [Color(0xFFE65100), Color(0xFFFF6D00)]
                                : [Color(0xFFFFF3E0), Color(0xFFFFCCBC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isIncome
                                      ? (Theme.of(context).brightness == Brightness.dark 
                                          ? Color(0xFF64B5F6) 
                                          : Color(0xFF2196F3))
                                      : (Theme.of(context).brightness == Brightness.dark 
                                          ? Color(0xFFFFB74D) 
                                          : Color(0xFFFF9800)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isIncome ? "收入" : "支出",
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.black 
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            item.createTime?.split(" ")[0] ?? "",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.reason ?? "无描述",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[300]
                              : Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        height: 1, 
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[700]
                            : Colors.grey[300]
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "积分变化",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${isIncome ? '+' : '-'}${score.abs()}",
                            style: TextStyle(
                              color:
                                  isIncome
                                      ? (Theme.of(context).brightness == Brightness.dark
                                          ? Color(0xFF64B5F6)
                                          : Color(0xFF2196F3))
                                      : (Theme.of(context).brightness == Brightness.dark
                                          ? Color(0xFFFFB74D)
                                          : Color(0xFFFF9800)),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "金币账单", 
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white 
                : Colors.black,
          ),
        ),
        //返回按钮
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios, 
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white 
                : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false, //设置为false
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? Color(0xFF1D1D1D) 
            : Theme.of(context).appBarTheme.backgroundColor, // 使用主题背景色
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Color(0xFF121212), Color(0xFF191919)]
                : [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }
}
