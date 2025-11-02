import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/store/user/user.dart';
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
import '../../utils/ads_cache_util.dart';
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
          (await Api.noticeInfo({"page": 1, "size": 1, "type": 640})).data?.list
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
      await getVideoPages();
      await getUserInfo();
      await getViews();
      await noticeInfo();
      await checkMember();
      didChangeAppLifecycleState();
      User.isLogin();
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

  //广告加载
  Future<void> _loadAd() async {
    bool hasCache = await AdsCacheUtil.hasCachedAdsData();
    if (hasCache) {
      List<AppAdsDataList>? cachedAds = await AdsCacheUtil.getAdsData();
      if (cachedAds != null && cachedAds.isNotEmpty) {
        //筛选cachedAds数组中adsPage="896"且type=680的数据
        List<AppAdsDataList> filteredAds =
            cachedAds.where((adsData) {
              return adsData.adsPage == 898 && adsData.type == 680;
            }).toList();
        if (filteredAds.isNotEmpty) {
          AppAdsDataList adsData = filteredAds[0];
          setState(() {
            androidCodeId = adsData.adsId ?? androidCodeId;
            iosCodeId = adsData.adsId ?? iosCodeId;
          });
          debugPrint("_loadAd开屏广告数据:$filteredAds");
        }
      }
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
      if (user != null) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => History()),
                  );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
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
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TDImage(
            imgUrl: userInfoData?.avatarUrl ?? "",
            width: 50,
            height: 50,
            type: TDImageType.circle,
            errorWidget: TDImage(
              width: 80,
              height: 80,
              type: TDImageType.circle,
              assetUrl: 'assets/images/user.png',
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
      );
    }

    return GestureDetector(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      TDImage(
                        imgUrl: userInfoData?.avatarUrl ?? "",
                        width: 80,
                        height: 80,
                        type: TDImageType.circle,
                        errorWidget: TDImage(
                          width: 80,
                          height: 80,
                          type: TDImageType.circle,
                          assetUrl: 'assets/images/user.png',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 用户ID
                          Text(
                            User.getPhoneNumber(
                              userInfoData?.phone.toString() ?? "",
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
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
                                    'VIP会员:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(245, 164, 33, 1),
                                      fontWeight: FontWeight.bold,
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
      child: Padding(
        padding: EdgeInsets.only(right: 5, left: 5, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "常用功能",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                _buildModelItem(Icon(Icons.message_outlined, size: 20), "系统通知"),
                _buildModelItem(Icon(Icons.share_outlined, size: 20), "分享好友"),
                // _buildModelItem("assets/images/collect.png", "我的收藏"),
                // _buildModelItem("assets/images/customersService.png", "在线客服"),
                _buildModelItem(Icon(Icons.settings_outlined, size: 20), "设置"),
                _buildModelItem(
                  Icon(Icons.warning_amber_outlined, size: 20),
                  "关于",
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
        children: [
          // TDImage(assetUrl: assetUrl, width: 20, height: 20),
          icon,
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
        // 处理设置点击事件
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Setting(userStatus: user != null ? true : false),
          ),
        );
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Selector<UserState, UserEntity?>(
        selector:
            (context, value) => value.userInfoData, // 假设 UserState 中有 user 属性
        builder: (context, UserEntity? data, child) {
          return Container(
            padding: const EdgeInsets.only(
              left: Layout.paddingL,
              right: Layout.paddingR,
              top: 40,
            ),
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
                  );
                } else {
                  // 修改：在snapshot.hasData为false时，仍然显示页面内容
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
          );
        },
      ),
    );
  }
}
