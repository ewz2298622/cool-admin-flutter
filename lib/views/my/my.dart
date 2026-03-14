import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/store/user/user.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/banner_ads.dart';
import '../../components/loading.dart';
import '../../components/sectionWithMore.dart';
import '../../components/video_view.dart';
import '../../db/entity/UserEntity.dart';
import '../../db/manager/UserDatabaseHelper.dart';
import '../../entity/app_ads_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../entity/views_entity.dart';
import '../../style/layout.dart';
import '../../utils/ads.dart';
import '../../utils/ads_config.dart';
import '../../utils/bus/bus.dart';
import '../../utils/bus/constant.dart';
import '../../utils/share_util.dart';
import '../../utils/user.dart';
import '../history/history.dart';
import '../login/login.dart';
import '../setting/setting.dart';

class My extends StatefulWidget {
  const My({super.key});

  @override
  MyState createState() => MyState();
}

class MyState extends State<My>
    with SingleTickerProviderStateMixin, RouteAware {
  var _futureBuilderFuture;
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  UserEntity? user;

  List<VideoPageDataList> videoPageData = [];

  List<ViewsDataList> viewsData = [];

  List<NoticeInfoDataList> noticeInfoData = [];
  StreamSubscription? subscription;

  String androidCodeId = AdsConfig.BANNER_AD_ANDROID;
  String iosCodeId = AdsConfig.BANNER_AD_IOS;

  bool isValidMember = false;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Future<void> noticeInfo() async {
    try {
      List<NoticeInfoDataList> list =
          (await Api.noticeInfo({
                "page": 1,
                "size": 1,
                "type": 640,
                "status": 1,
              })).data?.list
              as List<NoticeInfoDataList>;
      noticeInfoData = list;
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<String> init() async {
    try {
      await _loadAd();
      await noticeInfo();
      await getUserInfo();
      if (user != null) {
        await getVideoPages();
        await getViews();
        await checkMember();
        didChangeAppLifecycleState();
        User.isLogin();
      } else {
        videoPageData.clear();
        viewsData.clear();
        isValidMember = false;
      }
      debugPrint("init success");
      return "init success";
    } catch (e) {
      return "init success";
    }
  }

  //检查会员是否可用
  Future<void> checkMember() async {
    isValidMember = (await Api.checkMember({})).data!.isValidMember ?? false;
    setState(() {});
  }

  //广告加载（直接从 API 请求，带超时保护，不阻塞页面显示）
  Future<void> _loadAd() async {
    try {
      // 设置请求超时为 2 秒，避免长时间阻塞
      AppAdsEntity response = await Api.getAdsList({
        'status': 1,
        "adsPage": 898,
        'type': 680,
      }).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint("Banner广告请求超时");
          throw TimeoutException("Banner广告请求超时");
        },
      );

      List<AppAdsDataList> adsList =
          response.data?.list ?? [] as List<AppAdsDataList>;

      if (!mounted) return;

      if (adsList.isNotEmpty) {
        //筛选adsList数组中adsPage=898且type=680的数据
        List<AppAdsDataList> filteredAds =
            adsList.where((adsData) {
              return adsData.adsPage == 898 && adsData.type == 680;
            }).toList();
        if (filteredAds.isNotEmpty) {
          AppAdsDataList adsData = filteredAds[0];
          if (mounted) {
            setState(() {
              androidCodeId = adsData.adsId ?? androidCodeId;
              iosCodeId = adsData.adsId ?? iosCodeId;
            });
            debugPrint("_loadAd Banner广告数据:$filteredAds");
          }
        }
      }
    } catch (e) {
      debugPrint("_loadAd Banner广告加载失败: $e");
    }
  }

  //事件监听
  void didChangeAppLifecycleState() {
    subscription = eventBus.on<RefreshViewEvent>().listen((data) {
      getViews();
      setState(() {});
    });
  }

  Future<void> getUserInfo() async {
    try {
      Iterable<UserEntity> list = userDatabaseHelper.list();
      if (list.isNotEmpty) {
        // 修改：取第一个用户，或者根据业务逻辑选择合适的用户
        user = list.first;
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('Initialization getAlbumListByCategoryIds failed: $e');
    }
  }

  Future<void> getViews() async {
    try {
      if (user == null) {
        viewsData = [];
        return;
      }
      viewsData =
          (await Api.getViews({
                "createUserId": user?.userId,
                "type": 19,
              })).data?.list
              as List<ViewsDataList>;
      //重构数据将associationId赋值给id
      for (var element in viewsData) {
        element.id = element.associationId;
      }
      setState(() {});
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
    super.initState();
    _futureBuilderFuture = init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 订阅路由变化
    debugPrint("didChangeDependencies");
  }

  // 当页面从导航栈中返回时调用
  @override
  void didPopNext() {
    // 从目标页面返回时刷新数据
    debugPrint('从其他页面返回，刷新数据');
    _refreshData();
  }

  // 刷新数据的方法，改为公开方法以便外部调用
  void _refreshData() {
    setState(() {
      _futureBuilderFuture = init();
    });
  }

  Widget _buildRecommendations(UserEntity? userInfoData) {
    if (viewsData.isEmpty || userInfoData == null) {
      return Container();
    } else {
      return Card(
        child: Padding(
          padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
          child: Column(
            spacing: 10,
            children: [
              SectionWithMore(
                title: "浏览记录", // 传入标题
                onMorePressed: () {
                  Get.to(() => History());
                },
              ),
              VideoViews(videoPageData: viewsData),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildLogin(BuildContext context, UserEntity? userInfoData) {
    if (userInfoData == null) {
      return GestureDetector(
        onTap: () {
          Get.to(() => Login());
        },
        child: Text(
          "点击登录",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            spacing: 10,
            children: [
              Text(
                userInfoData.phone ?? "",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // 显示积分
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 14,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 4),
                  ],
                ),
              ),
            ],
          ),

          Text(
            "尊贵会员",
            style: TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(161, 151, 141, 1),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildHead(BuildContext context, UserEntity? userInfoData) {
    if (userInfoData?.userId == null) {
      return Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  width: 2,
                ),
              ),
              child: TDImage(
                imgUrl: userInfoData?.avatarUrl ?? "",
                width: 70,
                height: 70,
                type: TDImageType.circle,
                errorWidget: TDImage(
                  width: 80,
                  height: 80,
                  type: TDImageType.circle,
                  assetUrl: 'assets/images/user.png',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: _buildLogin(context, userInfoData),
            ),

            // 用户姓名
            SizedBox(height: 8.0),
            // 用户电子邮件
            // 你可以继续添加更多信息
          ],
        ),
      );
    }

    return GestureDetector(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          width: 2,
                        ),
                      ),
                      child: TDImage(
                        imgUrl: userInfoData?.avatarUrl ?? "",
                        width: 70,
                        height: 70,
                        type: TDImageType.circle,
                        errorWidget: TDImage(
                          width: 80,
                          height: 80,
                          type: TDImageType.circle,
                          assetUrl: 'assets/images/user.png',
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        // 用户ID
                        Text(
                          User.getPhoneNumber(
                            userInfoData?.phone.toString() ?? "",
                          ),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            height: 24.62 / 17,
                            color: Color.fromRGBO(5, 3, 2, 1),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TDProgress(
                            showLabel: false,
                            type: TDProgressType.linear,
                            customProgressLabel: Center(),
                            color: Color.fromRGBO(255, 238, 208, 1),
                            backgroundColor: Color.fromRGBO(93, 146, 252, 1),
                            value: 0.5,
                            strokeWidth: 2,
                            progressLabelPosition:
                                TDProgressLabelPosition.right,
                          ),
                        ),
                        // 虚拟货币数量
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(242, 240, 241, 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Text(
                                  'VIP 会员:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0,
                                    height: 21.72 / 15,
                                    color: Color.fromRGBO(255, 227, 177, 1),
                                  ),
                                ),
                                Text(
                                  isValidMember == false ? '已过期' : '续期',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(190, 190, 190, 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // 特惠信息
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            right: 0,
            child: GestureDetector(
              child: Container(
                height: 27,
                width: 92,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/gole.svg',
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      "签到赚金币",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                        height: 17.38 / 12,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isValidMember == true)
            Positioned(
              child: const TDBadge(
                TDBadgeType.subscript,
                message: 'VIP',
                size: TDBadgeSize.large,
              ),
            ),
        ],
      ),
      onTap: () {
        //跳转/score
        Get.toNamed("/score");
        checkMember();
      },
    );
  }

  Widget buildPricingLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Flexible(
        //   flex: 2,
        //   child: Card(
        //     child: Container(
        //       padding: EdgeInsets.only(
        //         right: 25,
        //         left: 25,
        //         top: 15,
        //         bottom: 15,
        //       ),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(3.0), // 圆角边框
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 '首3月每月6元',
        //                 style: TextStyle(
        //                   color: Colors.brown,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w500,
        //                 ),
        //               ),
        //               Text(
        //                 '限时专享',
        //                 style: TextStyle(color: Colors.brown, fontSize: 12),
        //               ),
        //             ],
        //           ),
        //
        //           Container(
        //             height: 30,
        //             width: 1,
        //             margin: EdgeInsets.only(right: 12, left: 12),
        //             //设置背景色
        //             decoration: BoxDecoration(
        //               color: Color.fromRGBO(225, 225, 225, 1.0),
        //             ),
        //           ),
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 '年卡6折',
        //                 style: TextStyle(
        //                   color: Colors.brown,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w500,
        //                 ),
        //               ),
        //               Text(
        //                 '限时专享',
        //                 style: TextStyle(color: Colors.brown, fontSize: 12),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // Flexible(
        //   flex: 1,
        //   child: Card(
        //     child: Container(
        //       padding: EdgeInsets.only(top: 15, bottom: 15),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(3.0), // 圆角边框
        //       ),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 '首3月每月6元',
        //                 style: TextStyle(
        //                   color: Colors.brown,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w500,
        //                 ),
        //               ),
        //               Text(
        //                 '限时专享',
        //                 style: TextStyle(color: Colors.brown, fontSize: 12),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        TDImage(
          assetUrl: 'assets/images/adsbanner.png',
          width: MediaQuery.of(context).size.width - 20,
          //宽度100%
          height: 100,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildModelList() {
    return Card(
      //白色
      color: Colors.white,
      //修改圆角
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.only(right: 5, left: 5, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "常用功能",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                height: 21.72 / 15,
                color: Color.fromRGBO(51, 51, 51, 1),
              ),
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
                _buildModelItem(
                  Icon(
                    Icons.message_outlined,
                    size: 20,
                    color: Color.fromRGBO(20, 19, 22, 1),
                  ),
                  "系统通知",
                ),
                _buildModelItem(
                  Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: Color.fromRGBO(20, 19, 22, 1),
                  ),
                  "分享好友",
                ),
                // _buildModelItem("assets/images/collect.png", "我的收藏"),
                _buildModelItem(
                  Icon(
                    Icons.settings_outlined,
                    size: 20,
                    color: Color.fromRGBO(20, 19, 22, 1),
                  ),
                  "设置",
                ),
                _buildModelItem(
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 20,
                    color: Color.fromRGBO(20, 19, 22, 1),
                  ),
                  "关于",
                ),
                _buildModelItem(
                  Icon(
                    Icons.feedback_outlined,
                    size: 20,
                    color: Color.fromRGBO(20, 19, 22, 1),
                  ),
                  "意见反馈",
                ),
                _buildModelItem(
                  Icon(
                    Icons.feedback_outlined,
                    size: 20,
                    color: Color.fromRGBO(20, 19, 22, 1),
                  ),
                  "邀请好友",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelItem(Widget icon, String label) {
    return GestureDetector(
      onTap: () => _handleModelItemClick(label),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          // TDImage(assetUrl: assetUrl, width: 20, height: 20),
          icon,
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              height: 18.82 / 13,
              color: Color.fromRGBO(51, 51, 51, 1),
            ),
          ),
        ],
      ),
    );
  }

  void _handleModelItemClick(String label) {
    switch (label) {
      case "系统通知":
        //跳转Notice
        Get.toNamed("/notice");
        break;
      case "我的收藏":
        // 处理我的收藏点击事件
        break;
      case "分享好友":
        // 处理分享好友点击事件
        ShareUtil.shareImage();
        break;
      case "在线客服":
        // 处理在线客服点击事件
        break;
      case "设置":
        // 处理设置点击事件 - 统一使用GetX路由系统
        Get.to(() => Setting(userStatus: user != null ? true : false));
        break;
      case "关于":
        // 跳转About页面
        if (noticeInfoData.isEmpty) {
          TDToast.showText('暂无数据', context: context);
          return;
        }
        Get.toNamed(
          "/html",
          arguments: {
            "title": noticeInfoData[0].title ?? "",
            "content": noticeInfoData[0].content ?? "",
          },
        );
        break;
      case "意见反馈":
        if (User.isUserLoginView(context)) {
          Get.toNamed("/feedback");
        }
        break;
      case "邀请好友":
        // 退出登录
        Get.toNamed("/invite_record");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "我的",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Selector<UserState, UserEntity?>(
        selector:
            (context, value) => value.userInfoData, // 假设 UserState 中有 user 属性
        builder: (context, UserEntity? data, child) {
          return Stack(
            children: [
              // 渐变背景，固定高度 500
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                // 高度设置为整个屏幕高度
                height: MediaQueryData.fromWindow(window).size.height,
                child: Stack(
                  children: [
                    // 底层：整个区域填充最后一种渐变颜色
                    // Container(color: const Color.fromRGBO(245, 245, 245, 1)),
                    // 上层：300高度的渐变区域
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 300, // 渐变区域高度固定为 300
                      child: ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white, // 顶部不透明
                                Colors.white.withOpacity(0.0), // 底部透明
                              ],
                            ).createShader(bounds),
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/downloaded-image.jpg",
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 内容区域 - 添加 SafeArea 避免被状态栏遮挡
              SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder<String>(
                    future: _futureBuilderFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return PageLoading(); // 显示加载动画
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            spacing: Layout.paddingT,
                            children: [
                              _buildHead(context, data),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Column(
                                  spacing: Layout.paddingT,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (User.isUserLoginView(context)) {
                                          await Ads.loadRewardVideoAd();
                                          Ads.showRewardVideoAd();
                                        }
                                      },
                                      child: buildPricingLayout(),
                                    ),
                                    _buildRecommendations(data),
                                    _buildModelList(),
                                    BannerAds(
                                      androidCodeId: androidCodeId,
                                      iosCodeId: iosCodeId,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // 修改：在 snapshot.hasData 为 false 时，仍然显示页面内容
                        return SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              _buildHead(context, data),
                              _buildRecommendations(data),
                              _buildModelList(),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
