import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../components/no_data.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/video_live_entity.dart';
import '../../style/layout.dart';
import '../live_detail/live_detail.dart';

/// 直播页面主组件
class VideoService extends StatefulWidget {
  const VideoService({super.key});

  @override
  State<VideoService> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<VideoService> {
  List<DictInfoListData> dictInfoListData = [];
  List<VideoLiveDataList> videoLiveData = [];
  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey();
  final _sideBarController = TDSideBarController();
  var _futureBuilderFuture;
  // 选中的分类
  int _selectedCategory = 0;
  String keyWord = "";

  Future<void> getDictInfoPages() async {
    try {
      dictInfoListData =
          (await Api.getDictInfoPages({
            "order": "orderNum",
            "sort": "desc",
            "typeId": 34,
          })).data ??
          [] as List<DictInfoListData>;
    } catch (e) {
      // 捕获并处理异常
      print('获取视频分类数据失败: $e');
    }
  }

  Future<void> getVideoLivePages() async {
    try {
      videoLiveData.clear();
      final categoryId = _selectedCategory != 0 ? _selectedCategory : null;
      final response = await Api.getVideoLivePages({
        "page": 1,
        "size": 9999,
        "keyword": keyWord,
        if (categoryId != null) "category_id": categoryId,
      });
      videoLiveData = response.data?.list ?? [] as List<VideoLiveDataList>;
      setState(() {});
    } catch (e) {
      // 捕获并处理异常
      print('获取视频直播数据失败: $e');
    }
  }

  Future<String> init() async {
    try {
      await getDictInfoPages();
      await getVideoLivePages();
      return "init success";
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
      return "init success";
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  Future<void> onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        automaticallyImplyLeading: false, //设置为false
      ),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        child: Container(
          padding: const EdgeInsets.only(
            left: Layout.paddingL,
            right: Layout.paddingR,
          ),
          //设置一个下到上以此是白色向黄色渐变的背景色
          child: _buildContent(),
        ),
      ),
    );
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        debugPrint('snapshot: ${snapshot.hasData}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.hasData) {
          return Row(
            children: [
              // 左侧分类侧边栏
              _buildCategorySidebar(),

              // 右侧内容区域
              Expanded(
                child: Column(
                  children: [
                    // 顶部搜索框
                    // _buildDefaultSearchBar(),

                    // 列表
                    Expanded(child: _buildStreamList()),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  /// 构建分类侧边栏
  Widget _buildCategorySidebar() {
    return SizedBox(
      width: 120,
      child: Card(
        child: TDSideBar(
          style: TDSideBarStyle.normal,
          value: _selectedCategory,
          controller: _sideBarController,
          unSelectedBgColor: Colors.transparent,
          selectedBgColor: Colors.transparent,
          selectedColor: Color.fromRGBO(255, 197, 6, 1),
          children:
              dictInfoListData
                  .map(
                    (ele) => TDSideBarItem(
                      label: ele.name ?? '',
                      value: ele.id ?? 0,
                    ),
                  )
                  .toList(),
          onSelected: onSelected,
        ),
      ),
    );
  }

  Future<void> onSelected(int value) async {
    _selectedCategory = value;
    getVideoLivePages();
  }

  /// 构建直播列表
  Widget _buildStreamList() {
    if (videoLiveData.isEmpty) {
      return const NoData();
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 4.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: videoLiveData.length,
      itemBuilder: (context, index) {
        return videoCard(videoLiveData[index]);
      },
    );
  }

  Widget videoCard(VideoLiveDataList item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Live_Detail(id: item.id ?? 0),
          ),
        );
      },
      child: Card(
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            TDImage(width: 40, height: 40, imgUrl: item.image),
            Text(
              item.title ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultSearchBar() {
    return TDSearchBar(
      placeHolder: '',
      backgroundColor: Colors.transparent,
      style: TDSearchStyle.round,
      onTextChanged: (String text) {
        keyWord = text;
      },
      // 防止键盘闪退问题
      focusNode: FocusNode(),
    );
  }
}
