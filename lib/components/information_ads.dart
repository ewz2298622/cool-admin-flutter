import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:flutter_unionad/nativead/NativeAdView.dart';

class InformationAds extends StatelessWidget {
  /// Android 信息流广告 ID
  final String androidCodeId;

  /// iOS 信息流广告 ID
  final String iosCodeId;

  const InformationAds({
    Key? key,
    required this.androidCodeId,
    required this.iosCodeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return //个性化模板信息流广告
    FlutterUnionadNativeAdView(
      //android 信息流广告id 必填
      androidCodeId: androidCodeId,
      //ios banner广告id 必填
      iosCodeId: iosCodeId,
      //是否支持 DeepLink 选填
      supportDeepLink: true,
      // 期望view 宽度 dp 必填
      width: 375.5,
      //期望view高度 dp 必填
      height: 0,
      callBack: FlutterUnionadNativeCallBack(
        onShow: () {
          print("信息流广告显示");
        },
        onFail: (error) {
          print("信息流广告失败 $error");
        },
        onDislike: (message) {
          print("信息流广告不感兴趣 $message");
        },
        onClick: () {
          print("信息流广告点击");
        },
      ),
    );
  }
}
