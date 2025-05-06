import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/video_view.dart';
import '../../db/entity/UserEntity.dart';
import '../../db/manager/UserDatabaseHelper.dart';
import '../../entity/video_page_entity.dart';
import '../../entity/views_entity.dart';
import '../../style/layout.dart';

class My extends StatefulWidget {
  const My({super.key});

  @override
  MyState createState() => MyState();
}

class MyState extends State<My> with SingleTickerProviderStateMixin {
  var _futureBuilderFuture;
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  UserEntity? user;

  List<VideoPageDataList> videoPageData = [];

  List<ViewsDataList> viewsData = [];

  Future<String> init() async {
    try {
      await getVideoPages();
      await getUserInfo();
      await getViews();
      return "init success";
    } catch (e) {
      print('Initialization failed: $e');
      return "init success";
    }
  }

  Future<void> getUserInfo() async {
    try {
      Iterable<UserEntity> list = userDatabaseHelper.list();
      if (list.isNotEmpty) {
        user = list.first;
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getViews() async {
    try {
      viewsData =
          (await Api.getViews({
                "createUserId": user?.id,
                "type": 19,
              })).data?.list
              as List<ViewsDataList>;
      debugPrint('Initialization getViews success: ${viewsData.length}');
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getVideoPages() async {
    try {
      List<VideoPageDataList> list =
          (await Api.getVideoPages({})).data?.list ??
          [] as List<VideoPageDataList>;
      videoPageData = list;
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

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("猜你喜欢", style: TextStyle(fontSize: 14)),
        VideoViews(videoPageData: viewsData),
      ],
    );
  }

  Widget _buildHead() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TDAvatar(
          size: TDAvatarSize.large,
          type: TDAvatarType.normal,
          avatarUrl: user?.avatarUrl ?? "",
        ),
        SizedBox(height: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.nickName ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            //进度条组件 Slider
            Text(
              user?.phone.toString() ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        // 用户姓名
        SizedBox(height: 8.0),
        // 用户电子邮件
        // 你可以继续添加更多信息
      ],
    );
  }

  Widget buildPricingLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(right: 25, left: 25, top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white, // 背景颜色
            border: Border.all(
              color: Color.fromRGBO(224, 209, 178, 1), // 边框颜色
              width: 1.5, // 边框宽度
            ),
            borderRadius: BorderRadius.circular(3.0), // 圆角边框
          ),
          child: Row(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        '首3月每月6元',
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '限时专享',
                        style: TextStyle(color: Colors.brown, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    margin: EdgeInsets.only(right: 12, left: 12),
                    //设置背景色
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(225, 225, 225, 1.0),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '年卡6折',
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '限时专享',
                        style: TextStyle(color: Colors.brown, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 25, left: 25, top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white, // 背景颜色
            border: Border.all(
              color: Color.fromRGBO(224, 209, 178, 1), // 边框颜色
              width: 1.5, // 边框宽度
            ),
          ),
          child: Row(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        '首月五元',
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '月月省',
                        style: TextStyle(color: Colors.brown, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModelList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "常用功能",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        GridView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
          ),
          children: [
            _buildModelItem("assets/images/opinion.png", "系统公告"),
            _buildModelItem("assets/images/collect.png", "我的收藏"),
            _buildModelItem("assets/images/share.png", "分享好友"),
            _buildModelItem("assets/images/customersService.png", "在线客服"),
            _buildModelItem("assets/images/install.png", "设置"),
            _buildModelItem("assets/images/about.png", "关于"),
          ],
        ),
      ],
    );
  }

  Widget _buildModelItem(String assetUrl, String label) {
    return GestureDetector(
      onTap: () => _handleModelItemClick(label),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TDImage(assetUrl: assetUrl, width: 20, height: 20),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
          ),
        ],
      ),
    );
  }

  void _handleModelItemClick(String label) {
    switch (label) {
      case "系统公告":
        break;
      case "我的收藏":
        // 处理我的收藏点击事件
        break;
      case "分享好友":
        // 处理分享好友点击事件
        break;
      case "在线客服":
        // 处理在线客服点击事件
        break;
      case "设置":
        // 处理设置点击事件
        break;
      case "关于":
        // 处理关于点击事件
        break;
    }
  }

  Widget _buildContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              spacing: Layout.paddingT,
              children: [
                _buildHead(),
                buildPricingLayout(),
                _buildRecommendations(),
                _buildModelList(),
              ],
            ),
          );
        } else {
          // 修改：在snapshot.hasData为false时，仍然显示页面内容
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHead(),
                _buildRecommendations(),
                _buildModelList(),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Color.fromRGBO(255, 218, 112, 1),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: Layout.paddingL,
              right: Layout.paddingR,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 0.8],
                colors: [
                  Color.fromRGBO(255, 218, 112, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
              ),
            ),
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}
