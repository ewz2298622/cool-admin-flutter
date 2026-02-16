import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../components/bouncingBallsScreen.dart';
import '../../db/entity/TokenEntity.dart';
import '../../db/entity/UserEntity.dart';
import '../../db/manager/TokenDatabaseHelper.dart';
import '../../db/manager/UserDatabaseHelper.dart';
import '../../entity/captcha_entity.dart';
import '../../entity/login_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../../entity/user_info_entity.dart';
import '../../style/layout.dart';
import '../../utils/store/user/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with SingleTickerProviderStateMixin {
  var _futureBuilderFuture;

  var controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var browseOn = false;
  CaptchaData? captchaData;
  bool _isCaptchaLoading = true; // 验证码默认加载状态
  List<NoticeInfoDataList>? privacyData = [];
  List<NoticeInfoDataList>? serviceData = [];
  BuildContext? _context;
  Future<String> init() async {
    try {
      /// 初始化其他必要数据（不包括验证码）
      await noticeInfo();
      return "init success";
    } catch (e) {
      debugPrint('初始化失败: $e');
      return "init failed";
    }
  }

  // 数据加载逻辑分离
  Future<void> noticeInfo() async {
    // 通知类型常量
    const int privacyType = 642; // 隐私政策类型
    const int serviceType = 641; // 服务协议类型

    try {
      // 并行执行两个 API 调用以提高性能
      final results = await Future.wait([
        Api.noticeInfo({
          "page": 1,
          "size": 1,
          "type": privacyType,
          "status": 1,
        }),
        Api.noticeInfo({
          "page": 1,
          "size": 1,
          "type": serviceType,
          "status": 1,
        }),
      ]);

      // 安全地提取数据，避免类型转换异常
      privacyData = results[0].data?.list ?? [];
      serviceData = results[1].data?.list ?? [];

      if (mounted) {
        setState(() {});
      }
    } catch (e, stackTrace) {
      debugPrint('获取通知信息失败 (noticeInfo): $e');
      debugPrint('错误堆栈: $stackTrace');
      // 发生错误时设置为空列表，避免后续使用 null
      privacyData = [];
      serviceData = [];
    }
  }

  Future<void> getCaptcha() async {
    // 防止重复请求，但如果当前正在加载则允许重试
    if (_isCaptchaLoading && captchaData != null) return;

    setState(() {
      _isCaptchaLoading = true;
    });

    try {
      captchaData = (await Api.getCaptcha({})).data;
      if (mounted) {
        setState(() {
          _isCaptchaLoading = false;
        });
      }
    } catch (e) {
      debugPrint('获取验证码失败: $e');
      if (mounted) {
        setState(() {
          _isCaptchaLoading = false;
        });
        // 显示错误提示
        TDToast.showText('验证码加载失败，请重试', context: context);
      }
    }
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
    // 页面初始化后立即开始加载验证码，不阻塞页面显示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCaptcha();
    });
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        return _buildForm(context);
      },
    );
  }

  //获取用户信息
  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(
          //top 为页面的30%
          left: Layout.paddingL,
          right: Layout.paddingB,
          top: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Center(
                child: Column(
                  spacing: 5,
                  children: [
                    Text(
                      "验证码登录/注册",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "未注册的手机号将自动注册并登录",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(150, 151, 153, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1),
                border: Border.all(
                  color: Color.fromRGBO(238, 238, 238, 1),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular((25.0)),
              ),
              child: TDInput(
                size: TDInputSize.small,
                controller: controller[0],
                leftIcon: TDImage(
                  width: 20,
                  height: 20,
                  assetUrl: "assets/images/phone.png",
                ),
                hintText: '请输入手机号',
                onBtnTap: () {
                  TDToast.showText('点击右侧按钮', context: context);
                },
                onChanged: (text) {
                  setState(() {});
                },
                onClearTap: () {
                  controller[0].clear();
                  setState(() {});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1),
                border: Border.all(
                  color: Color.fromRGBO(238, 238, 238, 1),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular((25.0)),
              ),
              child: TDInput(
                size: TDInputSize.small,
                controller: controller[1],
                obscureText: !browseOn,
                leftIcon: TDImage(
                  width: 20,
                  height: 20,
                  assetUrl: "assets/images/password.png",
                ),
                hintText: '请输入密码',
                rightBtn:
                    browseOn
                        ? Icon(
                          TDIcons.browse,
                          color: TDTheme.of(context).fontGyColor3,
                        )
                        : Icon(
                          TDIcons.browse_off,
                          color: TDTheme.of(context).fontGyColor3,
                        ),
                onBtnTap: () {
                  setState(() {
                    browseOn = !browseOn;
                  });
                },
                needClear: false,
                onChanged: (text) {
                  setState(() {});
                },
                onClearTap: () {
                  controller[1].clear();
                  setState(() {});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1),
                border: Border.all(
                  color: Color.fromRGBO(238, 238, 238, 1),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular((25.0)),
              ),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: TDInput(
                      size: TDInputSize.small,
                      leftIcon: TDImage(
                        width: 20,
                        height: 20,
                        assetUrl: "assets/images/code.png",
                      ),
                      controller: controller[2],
                      hintText: '请输入验证码',
                      onBtnTap: () {
                        TDToast.showText('点击右侧按钮', context: context);
                      },
                      onChanged: (text) {
                        setState(() {});
                      },
                      onClearTap: () {
                        controller[2].clear();
                        setState(() {});
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 150,
                      height: 50,
                      child:
                          _isCaptchaLoading
                              ? Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: TDLoading(
                                    size: TDLoadingSize.small,
                                    icon: TDLoadingIcon.circle,
                                    iconColor: Color.fromRGBO(255, 162, 16, 1),
                                  ),
                                ),
                              )
                              : captchaData?.svg?.isNotEmpty == true
                              ? SvgPicture.string(
                                captchaData!.svg!,
                                fit: BoxFit.contain,
                                colorFilter: const ColorFilter.mode(
                                  Colors.blue,
                                  BlendMode.srcIn,
                                ),
                              )
                              : Center(
                                child: Text(
                                  '加载失败',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                    ),
                    onTap: () async {
                      if (!_isCaptchaLoading) {
                        await getCaptcha();
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Layout.paddingL,
                right: Layout.paddingB,
                bottom: 40,
              ),
              child: _buildAgreementText(),
            ),
            TDButton(
              text: '登录',
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              shape: TDButtonShape.round,
              //设置宽度90%
              width: MediaQuery.of(context).size.width * 0.9,
              //设置背景色
              style: TDButtonStyle(
                backgroundColor: Color.fromRGBO(247, 219, 74, 1),
                textColor: Color.fromRGBO(30, 33, 33, 1),
              ),
              onTap: () {
                String phone = controller[0].text;
                String password = controller[1].text;
                String verifyCode = controller[2].text;
                if (phone.isEmpty || password.isEmpty) {
                  TDToast.showText('账号或密码不能为空', context: context);
                  return;
                }
                if (verifyCode.isEmpty) {
                  TDToast.showText("请输入验证码", context: context);
                  return;
                }

                if (isPhoneNumberValid(phone)) {
                  // 处理登录逻辑
                  _login();
                } else {
                  TDToast.showText('请输入合法手机号', context: context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  //验证手机号是否合法
  bool isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.length == 11 && phoneNumber.startsWith('1');
  }

  Future<void> getUserInfo() async {
    UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
    userDatabaseHelper.deleteAll();
    UserInfoData? userInfoData = (await Api.getUserInfo({})).data;
    if (userInfoData != null) {
      try {
        userDatabaseHelper.insert(
          UserEntity(
            unionid: userInfoData.unionid,
            avatarUrl: userInfoData.avatarUrl,
            nickName: userInfoData.nickName,
            phone: userInfoData.phone,
            gender: userInfoData.gender,
            status: userInfoData.status,
            loginType: userInfoData.loginType,
            password: userInfoData.password,
            userId: userInfoData.id,
          ),
        );
        TDToast.showText('登录成功', context: context);
        _context?.read<UserState>().updateUserInfoData(
          UserEntity(
            unionid: userInfoData.unionid,
            avatarUrl: userInfoData.avatarUrl,
            nickName: userInfoData.nickName,
            phone: userInfoData.phone,
            gender: userInfoData.gender,
            status: userInfoData.status,
            loginType: userInfoData.loginType,
            password: userInfoData.password,
            userId: userInfoData.id,
          ),
        );
        //等待500ms
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.of(context).pushReplacementNamed('/');
      } catch (e) {
        debugPrint("登录失败${e.toString()}");
        getCaptcha();
        TDToast.showText('登录失败', context: context);
      }
    }
  }

  @override
  void dispose() {
    for (var c in controller) {
      c.dispose();
    }
    super.dispose();
  }

  //实现登录
  Future<void> _login() async {
    try {
      LoginData? data =
          (await Api.getLogin({
            'phone': controller[0].text.replaceAll(' ', ''),
            'password': controller[1].text.replaceAll(' ', ''),
            'code': controller[2].text.replaceAll(' ', ''),
            'captchaId': captchaData?.captchaId,
          })).data;
      if (data != null) {
        debugPrint("登录成功${data.toString()}");
        TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
        tokenDatabaseHelper.deleteAll();
        tokenDatabaseHelper.insert(
          TokenEntity(
            expire: data.expire,
            token: data.token,
            refreshExpire: data.refreshExpire,
            refreshToken: data.refreshToken,
          ),
        );

        await getUserInfo();
      } else {
        getCaptcha();
      }
    } catch (e) {
      getCaptcha();
      debugPrint("登录失败${e.toString()}");
    }
    // EventBus().emit(Constant.UserBusId, null);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        //设置背景色
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Get.back();
          },
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false, //设置为false
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BouncingBallsScreen(),
          // // 毛玻璃效果层
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildAgreementText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(color: Colors.grey),
        children: [
          const TextSpan(
            text: "登录代表您已同意 ",
            style: TextStyle(color: Color.fromRGBO(30, 33, 33, 1)),
          ),
          TextSpan(
            text:
                privacyData?.isNotEmpty == true
                    ? (privacyData![0].title ?? "隐私政策")
                    : "隐私政策",
            style: const TextStyle(
              color: Color.fromRGBO(22, 93, 255, 1),
              decoration: TextDecoration.underline,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    if (privacyData?.isNotEmpty == true) {
                      Get.toNamed(
                        "/html",
                        arguments: {
                          "title": privacyData![0].title ?? "",
                          "content": privacyData![0].content ?? "",
                        },
                      );
                    }
                  },
          ),
          const TextSpan(
            text: " 和 ",
            style: TextStyle(color: Color.fromRGBO(30, 33, 33, 1)),
          ),
          TextSpan(
            text:
                serviceData?.isNotEmpty == true
                    ? (serviceData![0].title ?? "服务协议")
                    : "服务协议",
            style: const TextStyle(
              color: Color.fromRGBO(22, 93, 255, 1),
              decoration: TextDecoration.underline,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    if (serviceData?.isNotEmpty == true) {
                      Get.toNamed(
                        "/html",
                        arguments: {
                          "title": serviceData![0].title ?? "",
                          "content": serviceData![0].content ?? "",
                        },
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
