// // second_page.dart
//
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/home_two_video.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../components/video_scroll.dart';
import '../../entity/album_entity.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../../entity/swiper_entity.dart';
import '../../style/layout.dart';
import '../album/album.dart';
import '../notice/notice.dart';
import '../search/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //定义swiperData
  SwiperData? swiperData;
  TabController? _tabController;
  String inputText = '';
  List<TDTab> tabs = [];
  List<int> videoCategoryIds = [];
  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey();
  final PageController pageController = PageController(initialPage: 0);
  bool disposed = false;
  bool isLogin = false;
  var _futureBuilderFuture;
  List<DictInfoListData> dictInfoListData = [];

  Map<int, List<SwiperDataList>> swiperMap = {};
  Map<int, List<AlbumDataList>> albumMap = {};
  List<NoticeInfoDataList>? noticeInfoData = [];

  Future<void> getDictInfoPages() async {
    try {
      dictInfoListData =
          (await Api.getDictInfoPages({
                "order": "orderNum",
                "sort": "desc",
                "typeId": 49,
              })).data
              as List<DictInfoListData>;
      //返回parentId :  null 的数据
      dictInfoListData =
          dictInfoListData
              .where((element) => element.parentId == null)
              .toList();
      videoCategoryIds = dictInfoListData.map((e) => e.id ?? 0).toList() ?? [];
      tabs.clear();
      for (var element in dictInfoListData ?? []) {
        tabs.add(TDTab(text: element.name));
      }
    } catch (e) {
      // 捕获并处理异常
      print('获取视频分类数据失败: $e');
    }
  }

  Future<void> getSwiperListByCategoryIds() async {
    try {
      swiperMap = await Api.getSwiperListByCategoryIds(videoCategoryIds);
    } catch (e) {
      // 捕获并处理异常
      print('Initialization failed: $e');
    }
  }

  Future<void> getAlbumListByCategoryIds() async {
    try {
      albumMap = await Api.getAlbumListByCategoryIds(videoCategoryIds);
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  Future<String> init() async {
    try {
      await getDictInfoPages();
      _initTabController(0);
      await getSwiperListByCategoryIds();
      await getAlbumListByCategoryIds();
      await noticeInfo();
      //判斷noticeInfoData是否有數據
      if (noticeInfoData?.isNotEmpty ?? false) {
        message();
      }
      return "init success";
    } catch (e) {
      return "init err";
    }
  }

  // 数据加载逻辑分离
  Future<void> noticeInfo() async {
    try {
      List<NoticeInfoDataList> list =
          (await Api.noticeInfo({
                "page": 1,
                "size": 1,
                "type": 637,
                "status": 1,
              })).data?.list
              as List<NoticeInfoDataList> ??
          [];
      noticeInfoData = list;
    } catch (e) {
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  message() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // 动态宽度
            height: 250, // 固定高度
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 10,
                  children: [
                    Text(noticeInfoData?[0].title ?? ""),
                    Text(
                      noticeInfoData?[0].summary ?? "",
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: TDTheme.of(context).fontGyColor2,
                      ),
                    ),
                  ],
                ),
                TDButton(
                  text: '我知道了',
                  isBlock: true,
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: () {
                    Navigator.of(context).pop(); //退出弹出框
                  },
                  style: TDButtonStyle(
                    backgroundColor: Color.fromRGBO(255, 95, 1, 1),
                    textColor: Colors.white,
                    radius: BorderRadius.circular(20),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    '查看更多',
                    style: TextStyle(color: TDTheme.of(context).fontGyColor4),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notice()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> onRefresh() async {
    swiperMap.clear();
    albumMap.clear();
    tabs.clear();
    await getDictInfoPages();
    await getSwiperListByCategoryIds();
    await getAlbumListByCategoryIds();
    setState(() {});
    if (disposed) {
      return;
    }
    setState(() {});
  }

  /// 轮播图视图
  Widget _buildDotsSwiper(int id) {
    debugPrint('_buildDotsSwiper${swiperMap[id]}');
    super.build(context); // 必须调用 super.build
    return Swiper(
      autoplay: true,
      itemCount: (swiperMap[id]?.length) ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            TDImage(
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              imgUrl: swiperMap[id]?[index].image ?? '',
              errorWidget: const TDImage(
                //宽度100%
                width: double.infinity,
                fit: BoxFit.cover,
                assetUrl: 'assets/images/loading.gif',
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // 关键：让 Column 子组件左对齐
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      swiperMap[id]![index].title ?? "",
                      maxLines: 1,
                      //溢出省略号
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left, // 改为左对齐
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDefaultSearchBar() {
    return TDSearchBar(
      placeHolder: '',
      backgroundColor: Colors.transparent,
      style: TDSearchStyle.round,
      readOnly: true,
      onInputClick: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VideoSearch()),
        );
      },
    );
  }

  /// 初始化tab
  void _initTabController(int initialIndex) {
    _tabController = TabController(
      initialIndex: initialIndex,
      length: tabs.length,
      vsync: this,
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
          return Center(
            child: Stack(
              children: <Widget>[_buildTabs(), _buildDefaultSearchBar()],
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: DefaultTabController(
        //清理下边框的样式
        length: tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerHeight: 0,
              //移除下划线
              // 使用空的指示器来移除下划线
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 0.0,
                  color: Colors.transparent,
                ), // 将宽度设置为0来隐藏下划线
              ),
              //选中的字体颜色
              labelColor: const Color.fromRGBO(252, 119, 66, 1),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelColor: const Color.fromRGBO(102, 102, 102, 1),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              tabs: tabs,
            ),
            Expanded(
              child: TabBarView(
                children: List.generate(tabs.length, (index) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: _buildDotsSwiper(
                              dictInfoListData[index].id ?? 0,
                            ),
                          ),
                          Column(
                            children: _buildAlbumContentList(
                              albumMap[dictInfoListData[index].id] ?? [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).unfocus(); // 移除焦点
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20),
      resizeToAvoidBottomInset: true, //添加这一行
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

  List<Widget> _buildAlbumContentList(List<AlbumDataList> list) {
    return List<Widget>.generate(
      list.length,
      (index) => Column(
        spacing: 16,
        children: [
          _buildAlbumHeader(list[index]),
          _buildAlbumItemWidgetType(list[index], index),
        ],
      ),
    );
  }

  Widget _buildAlbumItemWidgetType(AlbumDataList item, int index) {
    if (index % 2 == 0) {
      return HomeTwoVideo(videoPageData: _buildAlbumItem(item, index));
    } else {
      return HorizontalVideoList(
        videoPageData: _buildAlbumItem(item, index).list as List<dynamic>,
      );
    }
  }

  //传入AlbumDataList 和index 如果是偶数 就去AlbumDataList.list四个元素 否则就取出所有元素
  AlbumDataList _buildAlbumItem(AlbumDataList item, int index) {
    if (index % 2 == 0) {
      item.list = item.list?.sublist(0, 4);
      return item;
    } else {
      return item;
    }
  }

  Widget _buildAlbumHeader(AlbumDataList album) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: SectionWithMore(
        title: album.title ?? "", // 传入标题
        onMorePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoAlbum(id: album.id ?? 0),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
