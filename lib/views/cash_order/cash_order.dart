import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../entity/cash_order_entity.dart';

class CashOrder extends StatefulWidget {
  const CashOrder({super.key});

  @override
  CashOrderState createState() => CashOrderState();
}

class CashOrderState extends State<CashOrder>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var _futureBuilderFuture;
  List<CashOrderDataList> cashOrderDataList = [];
  int currentPage = 1;
  bool disposed = false;
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  bool get wantKeepAlive => true;

  // 数据加载逻辑
  Future<void> cashOrders() async {
    try {
      List<CashOrderDataList> list =
          (await Api.scoreWithdrawal({"page": currentPage})).data?.list
              as List<CashOrderDataList>;
      setState(() {
        cashOrderDataList.addAll(list);
      });
    } catch (e) {
      debugPrint('Failed to load score orders: $e');
    }
  }

  Future<String> init() async {
    try {
      _scrollControllerAdd();
      await cashOrders();
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
    await cashOrders();
    if (disposed) {
      return;
    }
    setState(() {});
  }

  // 刷新方法
  Future<void> _onRefresh() async {
    currentPage = 1;
    cashOrderDataList.clear();
    await cashOrders();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  // 加载更多方法
  Future<void> _onLoading() async {
    currentPage++;
    await cashOrders();
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
    if (cashOrderDataList.isEmpty) {
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
                    "提现明细",
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
                  itemCount: cashOrderDataList.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = cashOrderDataList[index];
                    final createTime = item.createTime ?? "";
                    final amount = item.amount ?? 0;
                    final status = item.status;

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
                                  "提现$amount 元",
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
                            status == 0 ? "待处理" : "已完成",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  status == 0
                                      ? Color(0xFFFFB300)
                                      : Color(0xFF52C41A),
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
          "提现中心",
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
