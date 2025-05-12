import 'package:flustars/flustars.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../components/loading.dart';
import '../../db/entity/TokenEntity.dart';
import '../../db/entity/UserEntity.dart';
import '../../db/manager/TokenDatabaseHelper.dart';
import '../../db/manager/UserDatabaseHelper.dart';
import '../../entity/captcha_entity.dart';
import '../../entity/login_entity.dart';
import '../../entity/user_info_entity.dart';

class Login extends StatefulWidget {
  final BuildContext parentContext;
  const Login({super.key, required this.parentContext});
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
  var loginBrowseOn = false;
  var registerBrowseOn = false;
  CaptchaData? captchaData;
  bool isChecked = false;

  Future<String> init() async {
    try {
      await getCaptcha();
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
    debugPrint("captchaData: ${captchaData?.data}");
  }

  @override
  void initState() {
    _futureBuilderFuture = init();
    super.initState();
  }

  //实现登录头部组件
  Widget _buildLoginHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        //两端对齐
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 6,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    //设置标题
                    isScrollControlled: true,
                    //设置高度
                    builder: (builder) {
                      return Container(
                        height: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [_buildRegisterContent(context)],
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    TDImage(
                      assetUrl: "assets/images/left_and_right.png",
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      '注册',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(241, 95, 9, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(child: Text('登录', style: TextStyle(fontSize: 20))),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(widget.parentContext);
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  //实现注册头部组件
  Widget _buildRegisterHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        //两端对齐
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 6,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    TDImage(
                      assetUrl: "assets/images/left_and_right.png",
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      '登录',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(241, 95, 9, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(child: Text('新用户注册', style: TextStyle(fontSize: 20))),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  //获取用户信息
  Widget _buildLoginContent() {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: PageLoading());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLoginHeader(),
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
                    hintText: '请输入账号',
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
                    obscureText: !loginBrowseOn,
                    hintText: '请输入密码',
                    rightBtn:
                        loginBrowseOn
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
                        loginBrowseOn = !loginBrowseOn;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TDInput(
                          size: TDInputSize.small,
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
                        child: SvgPicture.string(
                          captchaData?.data ?? "",
                          width: 100,
                        ),
                        onTap: () async {
                          getCaptcha();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildAgreementText(),
                ),
                TDButton(
                  text: '登录',
                  size: TDButtonSize.large,
                  shape: TDButtonShape.round,
                  //设置宽度90%
                  width: MediaQuery.of(context).size.width * 0.9,
                  //设置背景色
                  style: TDButtonStyle(
                    backgroundColor: Color.fromRGBO(255, 95, 1, 1),
                    textColor: Colors.white,
                  ),
                  onTap: () {
                    _login();
                  },
                ),
              ],
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  //登录用户信息
  Widget _buildRegisterContent(BuildContext context) {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildRegisterHeader(context),
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
                    hintText: '请输入账号',
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
                    obscureText: !registerBrowseOn,
                    hintText: '请输入密码',
                    rightBtn:
                        registerBrowseOn
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
                        registerBrowseOn = !registerBrowseOn;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TDInput(
                          size: TDInputSize.small,
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
                        child: SvgPicture.string(
                          captchaData?.data ?? "",
                          width: 100,
                        ),
                        onTap: () async {
                          getCaptcha();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildAgreementText(),
                ),
                TDButton(
                  text: '注册',
                  size: TDButtonSize.large,
                  shape: TDButtonShape.round,
                  //设置宽度90%
                  width: MediaQuery.of(context).size.width * 0.9,
                  //设置背景色
                  style: TDButtonStyle(
                    backgroundColor: Color.fromRGBO(255, 95, 1, 1),
                    textColor: Colors.white,
                  ),
                  onTap: () {
                    _register();
                  },
                ),
              ],
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Future<void> getUserInfo() async {
    LogUtil.e("getUserInfo", tag: "getUserInfo");
    UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
    UserInfoData? userInfoData = (await Api.getUserInfo({})).data;
    if (userInfoData != null) {
      userDatabaseHelper.insert(
        UserEntity(
          unionid: userInfoData.unionid,
          avatarUrl: userInfoData.avatarUrl ?? "",
          nickName: userInfoData.nickName ?? "",
          phone: userInfoData.phone,
          gender: userInfoData.gender,
          status: userInfoData.status,
          loginType: userInfoData.loginType,
          password: userInfoData.password ?? "",
          userId: userInfoData.id,
        ),
      );
    }
  }

  //实现登录
  Future<void> _login() async {
    String phone = controller[0].text;
    String password = controller[1].text;
    String code = controller[2].text;
    if (phone.isEmpty || password.isEmpty || code.isEmpty) {
      return TDToast.showText('账号或密码或验证码不能为空', context: context);
    }
    LoginData? data =
        (await Api.getLogin({
          'phone': controller[0].text,
          'password': controller[1].text,
          'code': controller[2].text,
          'captchaId': captchaData?.captchaId,
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

    TDToast.showText('登录成功', context: context);
    await getUserInfo();
  }

  //实现注册
  Future<void> _register() async {
    String phone = controller[0].text;
    String password = controller[1].text;
    String code = controller[2].text;
    if (phone.isEmpty || password.isEmpty || code.isEmpty) {
      return TDToast.showText('账号或密码或验证码不能为空', context: context);
    }
    await Api.register({
      'phone': controller[0].text,
      'password': controller[1].text,
      'code': controller[2].text,
      'captchaId': captchaData?.captchaId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Column(children: [_buildLoginContent()]),
    );
  }

  Future<void> _launchUrl(String url) async {}

  Widget _verticalRadios() {
    return TDRadioGroup(
      selectId: 'index:1',
      child: TDRadio(
        id: 'index',
        //设置颜色
        selectColor: Color.fromRGBO(255, 95, 1, 1),
      ),
    );
  }

  Widget _buildAgreementText() {
    return Row(
      children: [
        //实现一个单选框
        _verticalRadios(),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: Colors.grey),
            children: [
              const TextSpan(text: "登录代表您已同意 "),
              TextSpan(
                text: "《服务协议》",
                style: const TextStyle(
                  color: Color.fromRGBO(203, 107, 44, 1),
                  decoration: TextDecoration.underline,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () => _launchUrl('https://example.com/terms'),
              ),
              const TextSpan(text: " 和 "),
              TextSpan(
                text: "《隐私政策》",
                style: const TextStyle(
                  color: Color.fromRGBO(203, 107, 44, 1),
                  decoration: TextDecoration.underline,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () => _launchUrl('https://example.com/privacy'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
