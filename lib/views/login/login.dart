import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../components/bouncingBallsScreen.dart';
import '../../db/entity/TokenEntity.dart';
import '../../db/entity/UserEntity.dart';
import '../../db/manager/TokenDatabaseHelper.dart';
import '../../db/manager/UserDatabaseHelper.dart';
import '../../entity/captcha_entity.dart';
import '../../entity/login_entity.dart';
import '../../entity/user_info_entity.dart';
import '../../main.dart';
import '../../style/layout.dart';
import '../../utils/bus/bus.dart';
import '../../utils/bus/constant.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with SingleTickerProviderStateMixin {
  var controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var browseOn = false;
  CaptchaData? captchaData;

  Future<String> init() async {
    try {
      ///Todo: 获取验证码
      return "init success";
    } catch (e) {
      return "init success";
    }
  }

  Future<void> getCaptcha() async {
    captchaData =
        (await Api.getCaptcha({
          'width': 100,
          'height': 50,
          "type": 1,
          "color": "#ff5f01",
        })).data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  //获取用户信息
  Widget _buildContent() {
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
            // Container(
            //   margin: const EdgeInsets.only(bottom: 10),
            //   padding: EdgeInsets.only(left: 15, right: 15),
            //   decoration: BoxDecoration(
            //     color: Color.fromRGBO(238, 238, 238, 1),
            //     border: Border.all(
            //       color: Color.fromRGBO(238, 238, 238, 1),
            //       width: 0.5,
            //     ),
            //     borderRadius: BorderRadius.circular((25.0)),
            //   ),
            //   child: Flex(
            //     direction: Axis.horizontal,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Flexible(
            //         flex: 1,
            //         child: TDInput(
            //           size: TDInputSize.small,
            //           leftIcon: TDImage(
            //             width: 20,
            //             height: 20,
            //             assetUrl: "assets/images/code.png",
            //           ),
            //           controller: controller[2],
            //           hintText: '请输入验证码',
            //           onBtnTap: () {
            //             TDToast.showText('点击右侧按钮', context: context);
            //           },
            //           onChanged: (text) {
            //             setState(() {});
            //           },
            //           onClearTap: () {
            //             controller[2].clear();
            //             setState(() {});
            //           },
            //         ),
            //       ),
            //       GestureDetector(
            //         child: SvgPicture.string(
            //           captchaData?.data ?? "",
            //           width: 100,
            //         ),
            //         onTap: () async {
            //           getCaptcha();
            //           setState(() {});
            //         },
            //       ),
            //     ],
            //   ),
            // ),
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
                String code = controller[2].text;
                if (phone.isEmpty || password.isEmpty) {
                  TDToast.showText('账号或密码不能为空', context: context);
                } else {
                  // 处理登录逻辑
                  _login();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserInfo() async {
    UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
    UserInfoData? userInfoData = (await Api.getUserInfo({})).data;
    if (userInfoData != null) {
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
    LoginData? data =
        (await Api.getLogin({
          'phone': controller[0].text.replaceAll(' ', ''),
          'password': controller[1].text.replaceAll(' ', ''),
        })).data;
    TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
    tokenDatabaseHelper.insert(
      TokenEntity(
        expire: data?.expire,
        token: data?.token,
        refreshExpire: data?.refreshExpire,
        refreshToken: data?.refreshToken,
      ),
    );

    await getUserInfo();
    EventBus().emit(Constant.UserBusId, null);
    //跳转到My
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp(key: UniqueKey())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //设置背景色
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
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
          TDImage(
            assetUrl: "assets/images/background.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          BouncingBallsScreen(),
          // // 毛玻璃效果层
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildContent(),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {}

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
            text: "服务协议",
            style: const TextStyle(
              color: Color.fromRGBO(22, 93, 255, 1),
              decoration: TextDecoration.underline,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () => _launchUrl('https://example.com/terms'),
          ),
          const TextSpan(
            text: " 和 ",
            style: TextStyle(color: Color.fromRGBO(30, 33, 33, 1)),
          ),
          TextSpan(
            text: "隐私政策",
            style: const TextStyle(
              color: Color.fromRGBO(22, 93, 255, 1),
              decoration: TextDecoration.underline,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () => _launchUrl('https://example.com/privacy'),
          ),
        ],
      ),
    );
  }
}
