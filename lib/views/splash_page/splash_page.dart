import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 描述：开屏广告页
/// @author guozi
/// @e-mail gstory0404@gmail.com
/// @time   2020/3/11

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _offstage = true;
  int _countdown = 3;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  // 开始倒计时
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _navigateToNextPage();
        }
      });
    });
  }

  // 跳转到下一页
  void _navigateToNextPage() {
    _timer.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Offstage(
          offstage: _offstage,
          child: FlutterUnionadSplashAdView(
            //android 开屏广告广告id 必填 889033013 102729400
            androidCodeId: "892349010",
            //ios 开屏广告广告id 必填
            iosCodeId: "892349010",
            //是否支持 DeepLink 选填
            supportDeepLink: true,
            // 期望view 宽度 dp 选填
            width: MediaQuery.of(context).size.width,
            //期望view高度 dp 选填
            height: MediaQuery.of(context).size.height - 100,
            //是否影藏跳过按钮(当影藏的时候显示自定义跳过按钮) 默认显示
            hideSkip: false,
            //超时时间
            timeout: 3000,
            //是否摇一摇
            isShake: true,
            callBack: FlutterUnionadSplashCallBack(
              onShow: () {
                print("开屏广告显示");
                setState(() => _offstage = false);
              },
              onClick: () {
                print("开屏广告点击");
              },
              onFail: (error) {
                print("开屏广告失败 $error");
                // Navigator.pop(context);
              },
              onFinish: () {
                print("开屏广告倒计时结束");
                // Navigator.pop(context);
              },
              onSkip: () {
                print("开屏广告跳过");
                Navigator.pop(context);
              },
              onTimeOut: () {
                print("开屏广告超时");
              },
              onEcpm: (info) {
                print("开屏广告获取ecpm:$info");
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Stack(
              children: [
                TDImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  assetUrl:
                      "assets/images/272bac7e-635a-4b1c-904a-679365a6fed5.jpg",
                ),
                // 添加倒计时按钮
                Positioned(
                  top: 50,
                  right: 20,
                  child: GestureDetector(
                    onTap: _navigateToNextPage,
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        //半透明背景色
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '跳过$_countdown',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
