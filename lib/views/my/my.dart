import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/store/user/user.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/banner_ads.dart';
import '../../components/loading.dart';
import '../../components/section_with_more.dart';
import '../../components/video_view.dart';
import '../../db/entity/UserEntity.dart';
import '../../db/manager/user_database_helper.dart';
import '../../entity/app_ads_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../../entity/video_page_entity.dart';
import '../../entity/views_entity.dart';
import '../../utils/ads.dart';
import '../../utils/ads_config.dart';
import '../../utils/bus/bus.dart';
import '../../utils/bus/constant.dart';
import '../../utils/routes.dart';
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
  late Future<String> _futureBuilderFuture;
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  UserEntity? user;

  List<VideoPageDataList> videoPageData = [];
  List<ViewsDataList> viewsData = [];
  List<NoticeInfoDataList> noticeInfoData = [];
  StreamSubscription? subscription;

  String androidCodeId = AdsConfig.BANNER_AD_ANDROID;
  String iosCodeId = AdsConfig.BANNER_AD_IOS;

  bool isValidMember = false;

  // 常量定义
  static const String _loginText = '点击登录';
  static const String _memberText = '尊贵会员';
  static const String _signInText = '签到赚金币';
  static const String _vipMemberText = 'VIP 会员:';
  static const String _expiredText = '已过期';
  static const String _renewText = '续期';
  static const String _browseHistoryText = '浏览记录';
  static const String _commonFunctionsText = '常用功能';
  static const String _noDataText = '暂无数据';
  static const String _initSuccessText = 'init success';
  static const String _adTimeoutText = 'Banner广告请求超时';
  static const String _adLoadFailedText = '_loadAd Banner广告加载失败: ';
  static const String _adDataText = '_loadAd Banner广告数据:';
  static const String _returnFromPageText = '从其他页面返回，刷新数据';
  static const String _didChangeDependenciesText = 'didChangeDependencies';

  // API 参数常量
  static const int _noticePage = 1;
  static const int _noticeSize = 1;
  static const int _noticeType = 640;
  static const int _noticeStatus = 1;
  static const int _adsStatus = 1;
  static const int _adsPage = 898;
  static const int _adsType = 680;
  static const int _viewsType = 19;
  static const int _adTimeout = 2;

  // 尺寸常量
  static const double _avatarSize = 70.0;
  static const double _avatarErrorSize = 80.0;
  static const double _avatarBorderWidth = 2.0;
  static const double _headPaddingLeft = 10.0;
  static const double _loginPaddingLeft = 15.0;
  static const double _buttonHeight = 27.0;
  static const double _buttonWidth = 92.0;
  static const double _buttonPadding = 5.0;
  static const double _buttonBorderRadius = 15.0;
  static const double _coinIconSize = 20.0;
  static const double _progressWidth = 200.0;
  static const double _progressHeight = 2.0;
  static const double _progressValue = 0.5;
  static const double _vipPaddingHorizontal = 8.0;
  static const double _vipTextSize = 15.0;
  static const double _vipStatusTextSize = 13.0;
  static const double _spacing12 = 12.0;
  static const double _spacing16 = 16.0;
  static const double _spacing8 = 8.0;
  static const double _spacing6 = 6.0;
  static const double _spacing5 = 5.0;
  static const double _gridCrossAxisSpacing = 10.0;
  static const int _gridCrossAxisCount = 4;
  static const double _iconSize = 20.0;
  static const double _labelTextSize = 13.0;
  static const double _sectionTextSize = 16.0;
  static const double _loginTextSize = 18.0;
  static const double _phoneTextSize = 17.0;
  static const double _memberTextSize = 14.0;
  static const double _signInTextSize = 12.0;
  static const double _appBarHeight = 50.0;
  static const double _appBarIconSize = 20.0;
  static const double _bannerHeight = 100.0;
  static const double _bannerHorizontalMargin = 20.0;
  static const double _containerBorderRadius = 10.0;
  static const double _containerMarginTop = 10.0;
  static const double _cardPadding = 5.0;

  // 颜色常量
  static const Color _whiteColor = Colors.white;
  static const Color _orangeColor = Colors.orange;
  static const Color _backgroundColor = Color.fromRGBO(245, 245, 245, 1);
  static const Color _avatarBorderColor = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color _phoneTextColor = Color.fromRGBO(5, 3, 2, 1);
  static const Color _memberTextColor = Color.fromRGBO(161, 151, 141, 1);
  static const Color _progressColor = Color.fromRGBO(255, 238, 208, 1);
  static const Color _progressBackgroundColor = Color.fromRGBO(93, 146, 252, 1);
  static const Color _vipTextColor = Color.fromRGBO(255, 227, 177, 1);
  static const Color _vipStatusTextColor = Color.fromRGBO(190, 190, 190, 1.0);
  static const Color _signInBackgroundColor = Color.fromRGBO(0, 0, 0, 0.3);
  static const Color _signInTextColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color _sectionTextColor = Color.fromRGBO(51, 51, 51, 1);
  static const Color _labelTextColor = Color.fromRGBO(51, 51, 51, 1);
  static const Color _iconColor = Color.fromRGBO(20, 19, 22, 1);

  // 布局常量
  static const BorderRadius _buttonBorder = BorderRadius.only(
    topLeft: Radius.circular(_buttonBorderRadius),
    bottomLeft: Radius.circular(_buttonBorderRadius),
  );
  static const BorderRadius _containerBorder = BorderRadius.all(Radius.circular(_containerBorderRadius));
  static const BorderRadius _orangeBorder = BorderRadius.all(Radius.circular(12));
  static const EdgeInsets _cardPaddingAll = EdgeInsets.only(right: _cardPadding, left: _cardPadding, top: _cardPadding, bottom: _cardPadding);
  static const EdgeInsets _cardPaddingTop = EdgeInsets.only(right: _cardPadding, left: _cardPadding, top: _cardPadding);
  static const EdgeInsets _padding10 = EdgeInsets.only(left: 10, right: 10);
  static const EdgeInsets _vipPadding = EdgeInsets.only(left: _vipPaddingHorizontal, right: _vipPaddingHorizontal);
  static const EdgeInsets _buttonPaddingAll = EdgeInsets.all(_buttonPadding);
  static const EdgeInsets _orangePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const SizedBox _spacingBox16 = SizedBox(height: _spacing16);
  static const SizedBox _spacingBox8 = SizedBox(height: _spacing8);
  static const SizedBox _spacingBox4 = SizedBox(width: 4);
  static const SizedBox _spacingBox10 = SizedBox(width: 10);
  static const SliverGridDelegateWithFixedCrossAxisCount _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: _gridCrossAxisCount,
    crossAxisSpacing: _gridCrossAxisSpacing,
  );

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Future<void> noticeInfo() async {
    try {
      final response = await Api.noticeInfo({
        "page": _noticePage,
        "size": _noticeSize,
        "type": _noticeType,
        "status": _noticeStatus,
      });
      final list = response.data?.list ?? [] as List<NoticeInfoDataList>;
      noticeInfoData = list;
    } catch (e) {
      debugPrint('noticeInfo failed: $e');
    }
  }

  Future<String> init() async {
    try {
      // 并发执行初始化任务
      await Future.wait<void>([
        _loadAd(),
        noticeInfo(),
        getUserInfo(),
      ]);

      if (user != null) {
        await Future.wait<void>([
          User.refreshToken(),
          getVideoPages(),
          getViews(),
          checkMember(),
        ]);
        _setupEventListeners();
        User.isLogin();
      } else {
        _clearUserData();
      }
      debugPrint(_initSuccessText);
      return _initSuccessText;
    } catch (e) {
      debugPrint('init failed: $e');
      return _initSuccessText;
    }
  }

  // 清除用户数据
  void _clearUserData() {
    videoPageData.clear();
    viewsData.clear();
    isValidMember = false;
  }

  // 检查会员是否可用
  Future<void> checkMember() async {
    try {
      final response = await Api.checkMember({});
      isValidMember = response.data?.isValidMember ?? false;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('checkMember failed: $e');
      isValidMember = false;
    }
  }

  // 广告加载（直接从 API 请求，带超时保护，不阻塞页面显示）
  Future<void> _loadAd() async {
    try {
      // 设置请求超时为 2 秒，避免长时间阻塞
      final response = await Api.getAdsList({
        'status': _adsStatus,
        "adsPage": _adsPage,
        'type': _adsType,
      }).timeout(
        const Duration(seconds: _adTimeout),
        onTimeout: () {
          debugPrint(_adTimeoutText);
          throw TimeoutException(_adTimeoutText);
        },
      );

      final adsList = response.data?.list ?? [] as List<AppAdsDataList>;

      if (!mounted) return;

      if (adsList.isNotEmpty) {
        // 筛选adsList数组中adsPage=898且type=680的数据
        final filteredAds = adsList.where((adsData) {
          return adsData.adsPage == _adsPage && adsData.type == _adsType;
        }).toList();
        if (filteredAds.isNotEmpty) {
          final adsData = filteredAds[0];
          if (mounted) {
            setState(() {
              androidCodeId = adsData.adsId ?? androidCodeId;
              iosCodeId = adsData.adsId ?? iosCodeId;
            });
            debugPrint('$_adDataText$filteredAds');
          }
        }
      }
    } catch (e) {
      debugPrint('$_adLoadFailedText$e');
    }
  }

  // 事件监听
  void _setupEventListeners() {
    subscription = eventBus.on<RefreshViewEvent>().listen((data) {
      getViews();
    });
  }

  Future<void> getUserInfo() async {
    try {
      final list = userDatabaseHelper.list();
      if (list.isNotEmpty) {
        user = list.first;
      }
    } catch (e) {
      debugPrint('getUserInfo failed: $e');
    }
  }

  Future<void> getViews() async {
    try {
      if (user == null) {
        viewsData = [];
        return;
      }
      final response = await Api.getViews({
        "createUserId": user?.userId,
        "type": _viewsType,
      });
      viewsData = response.data?.list ?? [] as List<ViewsDataList>;
      // 重构数据将associationId赋值给id
      for (final element in viewsData) {
        element.id = element.associationId;
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('getViews failed: $e');
    }
  }

  Future<void> getVideoPages() async {
    try {
      final response = await Api.getVideoPages({});
      final list = response.data?.list ?? [] as List<VideoPageDataList>;
      videoPageData = list;
    } catch (e) {
      debugPrint('getVideoPages failed: $e');
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
    debugPrint(_didChangeDependenciesText);
  }

  // 当页面从导航栈中返回时调用
  @override
  void didPopNext() {
    // 从目标页面返回时刷新数据
    debugPrint(_returnFromPageText);
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
    }
    return Card(
      elevation: 0,
      color: _whiteColor,
      child: Padding(
        padding: _cardPaddingAll,
        child: Column(
          spacing: _spacing5,
          children: [
            SectionWithMore(
              title: _browseHistoryText,
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

  Widget _buildLogin(BuildContext context, UserEntity? userInfoData) {
    if (userInfoData == null) {
      return GestureDetector(
        onTap: () {
          Get.to(() => Login());
        },
        child: Text(
          _loginText,
          style: const TextStyle(fontSize: _loginTextSize, fontWeight: FontWeight.bold),
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
            children: [
              Text(
                userInfoData.phone ?? "",
                style: const TextStyle(fontSize: _loginTextSize, fontWeight: FontWeight.bold),
              ),
              _spacingBox10,
              // 显示积分
              Container(
                padding: _orangePadding,
                decoration: BoxDecoration(
                  color: _orangeColor.withValues(alpha: 0.2),
                  borderRadius: _orangeBorder,
                  border: Border.all(color: _orangeColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 14,
                      color: _orangeColor,
                    ),
                    _spacingBox4,
                  ],
                ),
              ),
            ],
          ),
          Text(
            _memberText,
            style: TextStyle(
              fontSize: _memberTextSize,
              color: _memberTextColor,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildHead(BuildContext context, UserEntity? userInfoData) {
    if (userInfoData?.userId == null) {
      return Padding(
        padding: EdgeInsets.only(left: _headPaddingLeft),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildAvatar(userInfoData),
            _spacingBox16,
            Padding(
              padding: EdgeInsets.only(left: _loginPaddingLeft),
              child: _buildLogin(context, userInfoData),
            ),
            _spacingBox8,
          ],
        ),
      );
    }

    return GestureDetector(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: EdgeInsets.only(left: _headPaddingLeft),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildAvatar(userInfoData),
                    _spacingBox10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: _spacing6,
                      children: [
                        // 用户ID
                        Text(
                          User.getPhoneNumber(
                            userInfoData?.phone.toString() ?? "",
                          ),
                          style: TextStyle(
                            fontSize: _phoneTextSize,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            height: 24.62 / _phoneTextSize,
                            color: _phoneTextColor,
                          ),
                        ),
                        SizedBox(
                          width: _progressWidth,
                          child: TDProgress(
                            showLabel: false,
                            type: TDProgressType.linear,
                            customProgressLabel: const Center(),
                            color: _progressColor,
                            backgroundColor: _progressBackgroundColor,
                            value: _progressValue,
                            strokeWidth: _progressHeight,
                            progressLabelPosition: TDProgressLabelPosition.right,
                          ),
                        ),
                        // 虚拟货币数量
                        Padding(
                          padding: _vipPadding,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _vipMemberText,
                                style: TextStyle(
                                  fontSize: _vipTextSize,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0,
                                  height: 21.72 / _vipTextSize,
                                  color: _vipTextColor,
                                ),
                              ),
                              _spacingBox4,
                              Text(
                                isValidMember == false ? _expiredText : _renewText,
                                style: TextStyle(
                                  fontSize: _vipStatusTextSize,
                                  color: _vipStatusTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: _spacing12),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 18,
            right: 0,
            child: _buildSignInButton(),
          ),
        ],
      ),
      onTap: () {
        // 跳转/score
        Get.toNamed(AppRoutes.score);
        checkMember();
      },
    );
  }

  // 构建头像
  Widget _buildAvatar(UserEntity? userInfoData) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _avatarBorderColor,
          width: _avatarBorderWidth,
        ),
      ),
      child: TDImage(
        imgUrl: userInfoData?.avatarUrl ?? "",
        width: _avatarSize,
        height: _avatarSize,
        type: TDImageType.circle,
        errorWidget: TDImage(
          width: _avatarErrorSize,
          height: _avatarErrorSize,
          type: TDImageType.circle,
          assetUrl: 'assets/images/user.png',
        ),
      ),
    );
  }

  // 构建签到按钮
  Widget _buildSignInButton() {
    return GestureDetector(
      child: Container(
        height: _buttonHeight,
        width: _buttonWidth,
        padding: _buttonPaddingAll,
        decoration: BoxDecoration(
          color: _signInBackgroundColor,
          borderRadius: _buttonBorder,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/gole.svg',
              width: _coinIconSize,
              height: _coinIconSize,
            ),
            Text(
              _signInText,
              style: TextStyle(
                fontSize: _signInTextSize,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                height: 17.38 / _signInTextSize,
                color: _signInTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPricingLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TDImage(
          assetUrl: 'assets/images/adsbanner.png',
          width: MediaQuery.of(context).size.width - _bannerHorizontalMargin,
          height: _bannerHeight,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildModelList() {
    return Card(
      color: _whiteColor,
      elevation: 0,
      child: Padding(
        padding: _cardPaddingTop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _commonFunctionsText,
              style: TextStyle(
                fontSize: _sectionTextSize,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                height: 21.72 / 15,
                color: _sectionTextColor,
              ),
            ),
            GridView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: _gridDelegate,
              children: [
                _buildModelItem(
                  Icon(
                    CupertinoIcons.bubble_left,
                    size: _iconSize,
                    color: _iconColor,
                  ),
                  "系统通知",
                ),
                _buildModelItem(
                  Icon(
                    CupertinoIcons.share,
                    size: _iconSize,
                    color: _iconColor,
                  ),
                  "分享好友",
                ),
                _buildModelItem(
                  Icon(
                    CupertinoIcons.gear,
                    size: _iconSize,
                    color: _iconColor,
                  ),
                  "应用设置",
                ),
                _buildModelItem(
                  Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    size: _iconSize,
                    color: _iconColor,
                  ),
                  "关于我们",
                ),
                _buildModelItem(
                  Icon(
                    CupertinoIcons.pencil,
                    size: _iconSize,
                    color: _iconColor,
                  ),
                  "意见反馈",
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
          icon,
          _spacingBox4,
          Text(
            label,
            style: TextStyle(
              fontSize: _labelTextSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              height: 18.82 / _labelTextSize,
              color: _labelTextColor,
            ),
          ),
        ],
      ),
    );
  }

  void _handleModelItemClick(String label) {
    switch (label) {
      case "系统通知":
        Get.toNamed(AppRoutes.notice);
        break;
      case "分享好友":
        Get.toNamed(AppRoutes.inviteRecord);
        break;
      case "应用设置":
        Get.to(() => Setting(userStatus: user != null));
        break;
      case "关于我们":
        if (noticeInfoData.isEmpty) {
          TDToast.showText(_noDataText, context: context);
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
          Get.toNamed(AppRoutes.feedback);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _whiteColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: _appBarIconSize, color: _whiteColor),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        toolbarHeight: _appBarHeight,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Selector<UserState, UserEntity?>(
        selector: (context, value) => value.userInfoData,
        builder: (context, UserEntity? data, child) {
          final view = View.of(context);
          return Container(
            color: _backgroundColor,
            child: Stack(
              children: [
                // 背景
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQueryData.fromView(view).size.height,
                  child: Stack(
                    children: [
                      // 上层：300高度的渐变区域
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 300,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _whiteColor,
                              _whiteColor.withValues(alpha: 0.0),
                            ],
                          ).createShader(bounds),
                          blendMode: BlendMode.dstIn,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: const AssetImage(
                                  "assets/images/downloaded-image.png",
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
                          return const PageLoading();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                _buildHead(context, data),
                                Column(
                                  children: [
                                    Padding(
                                      padding: _padding10,
                                      child: Column(
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
                                          BannerAds(
                                            androidCodeId: androidCodeId,
                                            iosCodeId: iosCodeId,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: _padding10,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: _whiteColor,
                                              borderRadius: _containerBorder,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: _containerBorder,
                                              child: Column(
                                                children: [
                                                  _buildRecommendations(data),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: _containerMarginTop),
                                            decoration: BoxDecoration(
                                              color: _whiteColor,
                                              borderRadius: _containerBorder,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: _containerBorder,
                                              child: Column(
                                                children: [_buildModelList()],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
