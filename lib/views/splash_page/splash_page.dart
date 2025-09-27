import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../entity/app_ads_entity.dart';
import '../../utils/ads_cache_util.dart';
import '../../utils/ads_config.dart';

/// 描述：开屏广告页
/// @author guozi
/// @e-mail gstory0404@gmail.com
/// @time   2020/3/11

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _offstage = false;
  String androidCodeId = AdsConfig.SPLASH_AD_ANDROID;
  String iosCodeId = AdsConfig.INTERSTITIAL_AD_IOS;
  bool _isAdDataLoaded = false;

  @override
  void initState() {
    _loadAd().then((_) {
      setState(() {
        _isAdDataLoaded = true;
      });
    });
    super.initState();
  }

  // 跳转到下一页
  void _navigateToNextPage() {
    Get.offAllNamed('/main');
  }

  @override
  void dispose() {
    super.dispose();
  }

  //广告加载
  Future<void> _loadAd() async {
    bool hasCache = await AdsCacheUtil.hasCachedAdsData();
    if (hasCache) {
      List<AppAdsDataList>? cachedAds = await AdsCacheUtil.getAdsData();
      if (cachedAds != null && cachedAds.isNotEmpty) {
        //筛选cachedAds数组中adsPage="896"的数据
        List<AppAdsDataList> filteredAds =
            cachedAds.where((adsData) {
              return adsData.adsPage == 896;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Offstage(
          offstage: _offstage,
          child: Container(
            color: Colors.white,
            child:
                _isAdDataLoaded
                    ? FlutterUnionadSplashAdView(
                      //android 开屏广告广告id 必填 889033013 102729400
                      // androidCodeId: "892349010",
                      androidCodeId: androidCodeId,
                      //ios 开屏广告广告id 必填
                      iosCodeId: iosCodeId,
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
                          _navigateToNextPage();
                        },
                        onFinish: () {
                          print("开屏广告倒计时结束");
                          _navigateToNextPage();
                        },
                        onSkip: () {
                          print("开屏广告跳过");
                          _navigateToNextPage();
                        },
                        onTimeOut: () {
                          print("开屏广告超时");
                          _navigateToNextPage();
                        },
                        onEcpm: (info) {
                          print("开屏广告获取ecpm:$info");
                        },
                      ),
                    )
                    : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 100,
                      color: Colors.white,
                    ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            alignment: Alignment.center,
            child: Center(
              child: TDImage(
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                assetUrl: "assets/app/app_icon.png",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
