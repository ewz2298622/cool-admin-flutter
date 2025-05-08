// second_page.dart

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/auto_height_page_view/auto_height_page_view.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../entity/album_entity.dart';
import '../../entity/dict_info_list_entity.dart';
import '../../entity/swiper_entity.dart';
import '../../style/layout.dart';
import '../../utils/user.dart';
import '../album/album.dart';
import '../search/search.dart';
import '../video_detail/detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> with SingleTickerProviderStateMixin {
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
      User.isUserLoginView(context);
      return "init success";
    } catch (e) {
      return "init err";
    }
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
    return Swiper(
      autoplay: true,
      itemCount: 3,
      loop: true,
      pagination: const TDSwiperPagination(
        alignment: Alignment.bottomCenter,
        builder: TDSwiperPagination.dotsBar,
      ),
      itemBuilder: (BuildContext context, int index) {
        return TDImage(
          fit: BoxFit.cover,
          imgUrl: swiperMap[id]?[index].image ?? '',
          errorWidget: const TDImage(
            //宽度100%
            width: double.infinity,
            fit: BoxFit.cover,
            assetUrl: 'assets/images/loading.gif',
          ),
        );
      },
    );
  }

  Widget _buildDefaultSearchBar() {
    return TDSearchBar(
      placeHolder: '',
      backgroundColor: Colors.transparent,
      style: TDSearchStyle.round,
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
          return Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  _buildDefaultSearchBar(),
                  _buildTabsContent(),
                  _buildTabs(),
                ],
              ),
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Widget _buildTabs() {
    return AutoHeightPageView(
      pageController: pageController,
      onPageChanged: (index) {
        _tabController?.animateTo(index);
      },
      children: _getTabViews(),
    );
  }

  /// tabs 视图
  Widget _buildTabsContent() {
    // 返回一个Widget自动填充剩余高度
    return Column(
      children: [
        TDTabBar(
          tabs: tabs,
          controller: _tabController,
          showIndicator: false,
          dividerHeight: 0,
          isScrollable: true,
          labelColor: const Color.fromRGBO(252, 119, 66, 1),
          unselectedLabelColor: const Color.fromRGBO(102, 102, 102, 1),
          labelPadding: const EdgeInsets.only(left: 16, right: 16),
          onTap: (index) {
            pageController.jumpToPage(index);
          },
        ),
      ],
    );
  }

  List<Widget> _getTabViews() {
    if (dictInfoListData.isEmpty) {
      return [];
    } else {
      List<Widget> tabViews;
      tabViews = List.generate(tabs.length, (index) {
        return SizedBox(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: _buildDotsSwiper(dictInfoListData[index].id ?? 0),
              ),
              Column(
                children: _buildAlbumContentList(
                  albumMap[dictInfoListData[index].id] ?? [],
                ),
              ),
            ],
          ),
        );
      });
      return tabViews;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: const Color.fromRGBO(255, 218, 112, 1),
      ),
      resizeToAvoidBottomInset: false, //添加这一行
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        child: Container(
          padding: const EdgeInsets.only(
            left: Layout.paddingL,
            right: Layout.paddingR,
          ),
          //设置一个下到上以此是白色向黄色渐变的背景色
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              //设置颜色占比
              stops: [0.2, 0.8],
              colors: [
                Color.fromRGBO(255, 218, 112, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  List<Widget> _buildAlbumContentList(List<AlbumDataList> list) {
    return List<Widget>.generate(
      list.length,
      (index) => Column(
        children: [
          _buildAlbumHeader(list[index]),
          _buildAlbumItems(list[index]),
        ],
      ),
    );
  }

  Widget _buildAlbumHeader(AlbumDataList album) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
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

  Widget _buildAlbumItems(AlbumDataList album) {
    return Wrap(
      // spacing 屏幕尺寸减掉 380
      spacing: (MediaQuery.of(context).size.width - 380),
      runSpacing: 16,
      children: List<Widget>.generate(
        album.list?.length ?? 0,
        (index) => _buildAlbumItem(album.list?[index] ?? AlbumDataListList()),
      ),
    );
  }

  void _buildAlbumItem_onClick(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Video_Detail(id: id)),
    );
  }

  Widget _buildAlbumItem(AlbumDataListList item) {
    return GestureDetector(
      onTap: () => _buildAlbumItem_onClick(item.id ?? 0), //写入方法名称就可以了，但是是无参的
      child: Column(
        //添加点击事件
        children: [
          Stack(
            children: [
              _buildAlbumItemImage(item),
              _buildAlbumItemOverlay(item),
            ],
            //添加点击事件
          ),
          _buildAlbumItemTitle(item),
        ],
      ),
    );
  }

  Widget _buildAlbumItemImage(dynamic item) {
    return SizedBox(
      width: 180,
      height: 140,
      child: TDImage(
        height: 20,
        fit: BoxFit.cover,
        width: 200,
        imgUrl: item?.surfacePlot ?? '',
        errorWidget: const TDImage(
          height: 140,
          fit: BoxFit.cover,
          width: 180,
          assetUrl: 'assets/images/loading.gif',
        ),
      ),
    );
  }

  Widget _buildAlbumItemOverlay(dynamic item) {
    return SizedBox(
      width: 180,
      height: 140,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildAlbumItemHDTag(), _buildAlbumItemNote(item)],
        ),
      ),
    );
  }

  Widget _buildAlbumItemHDTag() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(59, 101, 244, 1),
                Color.fromRGBO(64, 177, 254, 1),
              ],
            ),
          ),
          child: const Text(
            "高清",
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumItemNote(dynamic item) {
    if (item?.note == null) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4, top: 2),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromRGBO(0, 0, 0, 0.302),
          ),
          child: Text(
            item?.note ?? '',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumItemTitle(dynamic item) {
    return SizedBox(
      width: 180,
      child: Text(
        item?.title ?? '',
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
