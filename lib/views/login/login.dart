import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../components/bouncing_balls_screen.dart';
import '../../db/entity/TokenEntity.dart';
import '../../db/entity/UserEntity.dart';
import '../../db/manager/token_database_helper.dart';
import '../../db/manager/user_database_helper.dart';
import '../../entity/captcha_entity.dart';
import '../../entity/login_entity.dart';
import '../../entity/notice_Info_entity.dart';
import '../../entity/user_info_entity.dart';
import '../../style/layout.dart';
import '../../utils/routes.dart';
import '../../store/user/user.dart';

/// 登录页面常量定义
class LoginConstants {
  // 颜色常量
  static const Color inputBackgroundColor = Color.fromRGBO(238, 238, 238, 1);
  static const Color inputBorderColor = Color.fromRGBO(238, 238, 238, 1);
  static const Color primaryButtonBackgroundColor = Color.fromRGBO(247, 219, 74, 1);
  static const Color primaryButtonTextColor = Color.fromRGBO(30, 33, 33, 1);
  static const Color linkTextColor = Color.fromRGBO(22, 93, 255, 1);
  static const Color normalTextColor = Color.fromRGBO(30, 33, 33, 1);
  static const Color hintTextColor = Color.fromRGBO(150, 151, 153, 1);
  static const Color captchaLoadingColor = Color.fromRGBO(255, 162, 16, 1);
  static const Color errorTextColor = Colors.grey;
  
  // 尺寸常量
  static const double inputBorderRadius = 25.0;
  static const double inputPaddingHorizontal = 15.0;
  static const double inputMarginBottom = 10.0;
  static const double formTopPadding = 100.0;
  static const double titleBottomPadding = 30.0;
  static const double agreementBottomPadding = 40.0;
  static const double buttonWidthRatio = 0.9;
  static const double captchaContainerWidth = 150.0;
  static const double captchaContainerHeight = 50.0;
  static const double captchaLoadingSize = 20.0;
  
  // 字体大小
  static const double titleFontSize = 20.0;
  static const double subTitleFontSize = 12.0;
  static const double errorTextFontSize = 12.0;
  
  // 文本常量
  static const String pageTitle = "验证码登录/注册";
  static const String pageSubTitle = "未注册的手机号将自动注册并登录";
  static const String phoneHintText = '请输入手机号';
  static const String passwordHintText = '请输入密码';
  static const String captchaHintText = '请输入验证码';
  static const String inviteCodeHintText = '请输入邀请码(可选)';
  static const String loginButtonText = '登录';
  static const String captchaLoadingText = '加载失败';
  static const String phoneEmptyError = '账号或密码不能为空';
  static const String captchaEmptyError = "请输入验证码";
  static const String phoneInvalidError = '请输入合法手机号';
  static const String captchaLoadError = '验证码加载失败，请重试';
  static const String loginSuccessText = '登录成功';
  static const String loginFailedText = '登录失败';
  static const String agreementPrefix = "登录代表您已同意 ";
  static const String agreementSeparator = " 和 ";
  static const String privacyPolicyDefault = "隐私政策";
  static const String serviceAgreementDefault = "服务协议";
  
  // 通知类型常量
  static const int privacyType = 642; // 隐私政策类型
  static const int serviceType = 641; // 服务协议类型
  
  // 其他常量
  static const Duration loginSuccessDelay = Duration(milliseconds: 500);
  static const int phoneNumberLength = 11;
  static const String phoneNumberPrefix = '1';
}

/// 登录页面
class Login extends StatefulWidget {
  /// 构造函数
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

/// 登录页面状态
class LoginState extends State<Login>
    with SingleTickerProviderStateMixin {
  /// 异步初始化任务
  late Future<String> _futureBuilderFuture;

  /// 输入框控制器列表
  /// controller[0]: 手机号
  /// controller[1]: 密码
  /// controller[2]: 验证码
  /// controller[3]: 邀请码
  var controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  
  /// 密码是否可见
  var browseOn = false;
  
  /// 验证码数据
  CaptchaData? captchaData;
  
  /// 验证码加载状态
  bool _isCaptchaLoading = true; // 验证码默认加载状态
  
  /// 隐私政策数据
  List<NoticeInfoDataList>? privacyData = [];
  
  /// 服务协议数据
  List<NoticeInfoDataList>? serviceData = [];
  
  /// 上下文
  BuildContext? _context;
  /// 初始化数据
  /// 
  /// 初始化其他必要数据（不包括验证码）
  /// 
  /// Returns: 初始化结果，"init success" 表示成功，"init failed" 表示失败
  Future<String> init() async {
    try {
      /// 初始化其他必要数据（不包括验证码）
      await noticeInfo();
      return "init success";
    } catch (e, stackTrace) {
      _handleApiError('init', e, stackTrace);
      return "init failed";
    }
  }

  /// 获取通知信息
  /// 
  /// 并行获取隐私政策和服务协议数据
  /// 提高性能，避免串行请求
  Future<void> noticeInfo() async {
    try {
      // 并行执行两个 API 调用以提高性能
      final results = await Future.wait([
        Api.noticeInfo({
          "page": 1,
          "size": 1,
          "type": LoginConstants.privacyType,
          "status": 1,
        }),
        Api.noticeInfo({
          "page": 1,
          "size": 1,
          "type": LoginConstants.serviceType,
          "status": 1,
        }),
      ]);

      // 检查组件是否仍然挂载
      if (!mounted) {
        debugPrint('Component unmounted, skipping noticeInfo state update');
        return;
      }

      // 安全地提取数据，避免类型转换异常
      privacyData = results[0].data?.list ?? [];
      serviceData = results[1].data?.list ?? [];

      setState(() {});
    } catch (e, stackTrace) {
      _handleApiError('noticeInfo', e, stackTrace);
      // 发生错误时设置为空列表，避免后续使用 null
      privacyData = [];
      serviceData = [];
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// 获取验证码
  /// 
  /// 防止重复请求，只有在验证码未加载或加载失败时才允许重试
  /// 
  /// 加载成功后更新验证码数据并刷新 UI
  /// 加载失败时显示错误提示
  Future<void> getCaptcha() async {
    // 防止重复请求，但如果当前正在加载则允许重试
    if (_isCaptchaLoading && captchaData != null) return;

    if (!mounted) {
      return;
    }

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
    } catch (e, stackTrace) {
      _handleApiError('getCaptcha', e, stackTrace);
      if (mounted) {
        setState(() {
          _isCaptchaLoading = false;
        });
        // 显示错误提示
        TDToast.showText(LoginConstants.captchaLoadError, context: context);
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

  /// 构建页面内容
  /// 
  /// 使用 FutureBuilder 处理初始化异步操作
  /// 无论初始化结果如何，都显示登录表单
  Widget _buildContent(BuildContext context) {
    return FutureBuilder<String>(
      future: _futureBuilderFuture, // 异步操作
      builder: (context, snapshot) {
        return _buildForm(context);
      },
    );
  }

  /// 构建输入框容器
  Widget _buildInputContainer(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: LoginConstants.inputMarginBottom),
      padding: EdgeInsets.only(left: LoginConstants.inputPaddingHorizontal, right: LoginConstants.inputPaddingHorizontal),
      decoration: BoxDecoration(
        color: LoginConstants.inputBackgroundColor,
        border: Border.all(
          color: LoginConstants.inputBorderColor,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(LoginConstants.inputBorderRadius),
      ),
      child: child,
    );
  }

  /// 统一处理 API 错误
  void _handleApiError(String methodName, dynamic error, StackTrace stackTrace) {
    debugPrint('$methodName failed: $error');
    debugPrint('Stack trace: $stackTrace');
  }

  /// 构建登录表单
  /// 
  /// 包含手机号、密码、验证码和邀请码输入框
  /// 以及登录按钮和协议文本
  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(
          //top 为页面的30%
          left: Layout.paddingL,
          right: Layout.paddingB,
          top: LoginConstants.formTopPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: LoginConstants.titleBottomPadding),
              child: Center(
                child: Column(
                  spacing: 5,
                  children: [
                    Text(
                      LoginConstants.pageTitle,
                      style: TextStyle(
                        fontSize: LoginConstants.titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      LoginConstants.pageSubTitle,
                      style: TextStyle(
                        fontSize: LoginConstants.subTitleFontSize,
                        color: LoginConstants.hintTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildInputContainer(
              TDInput(
                size: TDInputSize.small,
                controller: controller[0],
                leftIcon: TDImage(
                  width: 20,
                  height: 20,
                  assetUrl: "assets/images/phone.png",
                ),
                hintText: LoginConstants.phoneHintText,
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
            _buildInputContainer(
              TDInput(
                size: TDInputSize.small,
                controller: controller[1],
                obscureText: !browseOn,
                leftIcon: TDImage(
                  width: 20,
                  height: 20,
                  assetUrl: "assets/images/password.png",
                ),
                hintText: LoginConstants.passwordHintText,
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
            _buildInputContainer(
              Flex(
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
                      hintText: LoginConstants.captchaHintText,
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
                    child: SizedBox(
                      width: LoginConstants.captchaContainerWidth,
                      height: LoginConstants.captchaContainerHeight,
                      child:
                          _isCaptchaLoading
                              ? Center(
                                child: SizedBox(
                                  width: LoginConstants.captchaLoadingSize,
                                  height: LoginConstants.captchaLoadingSize,
                                  child: TDLoading(
                                    size: TDLoadingSize.small,
                                    icon: TDLoadingIcon.circle,
                                    iconColor: LoginConstants.captchaLoadingColor,
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
                                  LoginConstants.captchaLoadingText,
                                  style: TextStyle(
                                    color: LoginConstants.errorTextColor,
                                    fontSize: LoginConstants.errorTextFontSize,
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
            _buildInputContainer(
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: TDInput(
                      size: TDInputSize.small,
                      leftIcon: TDImage(
                        width: 30,
                        height: 30,
                        assetUrl: "assets/images/inviteCode.png",
                      ),
                      controller: controller[3],
                      hintText: LoginConstants.inviteCodeHintText,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onClearTap: () {
                        controller[3].clear();
                        setState(() {});
                      },
                    ),
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
              text: LoginConstants.loginButtonText,
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              shape: TDButtonShape.round,
              //设置宽度90%
              width: MediaQuery.of(context).size.width * LoginConstants.buttonWidthRatio,
              //设置背景色
              style: TDButtonStyle(
                backgroundColor: LoginConstants.primaryButtonBackgroundColor,
                textColor: LoginConstants.primaryButtonTextColor,
              ),
              onTap: () {
                String phone = controller[0].text;
                String password = controller[1].text;
                String verifyCode = controller[2].text;
                if (phone.isEmpty || password.isEmpty) {
                  TDToast.showText(LoginConstants.phoneEmptyError, context: context);
                  return;
                }
                if (verifyCode.isEmpty) {
                  TDToast.showText(LoginConstants.captchaEmptyError, context: context);
                  return;
                }

                if (isPhoneNumberValid(phone)) {
                  // 处理登录逻辑
                  _login();
                } else {
                  TDToast.showText(LoginConstants.phoneInvalidError, context: context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 验证手机号是否合法
  /// 
  /// 规则：
  /// 1. 手机号长度为 11 位
  /// 2. 手机号以 '1' 开头
  /// 
  /// Returns: 手机号是否合法
  bool isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.length == LoginConstants.phoneNumberLength && 
           phoneNumber.startsWith(LoginConstants.phoneNumberPrefix);
  }

  /// 获取用户信息
  /// 
  /// 登录成功后获取用户信息并存储到本地数据库
  /// 同时更新全局用户状态并跳转到首页
  /// 
  /// 失败时显示错误提示并刷新验证码
  Future<void> getUserInfo() async {
    try {
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
          if (mounted) {
            TDToast.showText(LoginConstants.loginSuccessText, context: context);
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
            await Future.delayed(LoginConstants.loginSuccessDelay);
            if (mounted) {
              Get.offAllNamed(AppRoutes.main);
            }
          }
        } catch (e, stackTrace) {
          _handleApiError('getUserInfo (insert)', e, stackTrace);
          getCaptcha();
          if (mounted) {
            TDToast.showText(LoginConstants.loginFailedText, context: context);
          }
        }
      } else {
        getCaptcha();
        if (mounted) {
          TDToast.showText(LoginConstants.loginFailedText, context: context);
        }
      }
    } catch (e, stackTrace) {
      _handleApiError('getUserInfo', e, stackTrace);
      getCaptcha();
      if (mounted) {
        TDToast.showText(LoginConstants.loginFailedText, context: context);
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

  /// 执行登录操作
  /// 
  /// 1. 验证输入参数
  /// 2. 调用登录 API
  /// 3. 存储 token 到本地数据库
  /// 4. 获取用户信息
  /// 
  /// 失败时显示错误提示并刷新验证码
  Future<void> _login() async {
    if (!mounted) {
      return;
    }

    try {
      LoginData? data = (await Api.getLogin({
            'phone': controller[0].text.replaceAll(' ', ''),
            'password': controller[1].text.replaceAll(' ', ''),
            'code': controller[2].text.replaceAll(' ', ''),
            'captchaId': captchaData?.captchaId,
            'inviteCode': controller[3].text.replaceAll(' ', ''),
          })).data;
      
      if (!mounted) {
        return;
      }
      
      debugPrint(
        "登录成功邀请码 inviteCode ${controller[3].text.replaceAll(' ', '')}",
      );
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
        if (mounted) {
          TDToast.showText(LoginConstants.loginFailedText, context: context);
        }
      }
    } catch (e, stackTrace) {
      _handleApiError('_login', e, stackTrace);
      getCaptcha();
      if (mounted) {
        TDToast.showText(LoginConstants.loginFailedText, context: context);
      }
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

  /// 构建协议文本
  /// 
  /// 显示登录协议，包含隐私政策和服务协议链接
  /// 点击链接跳转到对应的协议详情页面
  Widget _buildAgreementText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(color: Colors.grey),
        children: [
          TextSpan(
            text: LoginConstants.agreementPrefix,
            style: TextStyle(color: LoginConstants.normalTextColor),
          ),
          TextSpan(
            text:
                privacyData?.isNotEmpty == true
                    ? (privacyData![0].title ?? LoginConstants.privacyPolicyDefault)
                    : LoginConstants.privacyPolicyDefault,
            style: TextStyle(
              color: LoginConstants.linkTextColor,
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
          TextSpan(
            text: LoginConstants.agreementSeparator,
            style: TextStyle(color: LoginConstants.normalTextColor),
          ),
          TextSpan(
            text:
                serviceData?.isNotEmpty == true
                    ? (serviceData![0].title ?? LoginConstants.serviceAgreementDefault)
                    : LoginConstants.serviceAgreementDefault,
            style: TextStyle(
              color: LoginConstants.linkTextColor,
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
