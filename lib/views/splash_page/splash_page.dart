import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../entity/app_ads_entity.dart';
import '../../api/api.dart';
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
  bool _hasNavigated = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    // 设置超时机制，如果 2 秒内广告未加载完成，直接跳转
    _timeoutTimer = Timer(const Duration(seconds: 2), () {
      if (!_hasNavigated && mounted) {
        debugPrint("开屏广告加载超时，直接跳转");
        _navigateToNextPage();
      }
    });
    
    // 异步加载广告，不阻塞页面显示
    _loadAd();
  }

  // 跳转到下一页
  void _navigateToNextPage() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    _timeoutTimer?.cancel();
    Get.offAllNamed('/main');
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  //广告加载（直接从 API 请求，带超时保护）
  Future<void> _loadAd() async {
    try {
      // 设置请求超时为 1.5 秒
      AppAdsEntity response = await Api.getAdsList({'status':1})
          .timeout(
            const Duration(milliseconds: 1500),
            onTimeout: () {
              debugPrint("开屏广告请求超时");
              throw TimeoutException("开屏广告请求超时");
            },
          );
      
      List<AppAdsDataList> adsList = response.data?.list ?? [] as List<AppAdsDataList>;
      
      if (!mounted || _hasNavigated) return;
      
      if (adsList.isNotEmpty) {
        //筛选adsList数组中adsPage=896的数据
        List<AppAdsDataList> filteredAds =
            adsList.where((adsData) {
              return adsData.adsPage == 896;
            }).toList();
        if (filteredAds.isNotEmpty) {
          AppAdsDataList adsData = filteredAds[0];
          final String? adsId = adsData.adsId;
          // 如果广告 ID 不为空，说明有有效的广告，取消超时定时器，让广告自己控制跳转
          if (adsId != null && adsId.isNotEmpty) {
            _timeoutTimer?.cancel();
            debugPrint("开屏广告加载成功，取消超时定时器，等待广告倒计时结束");
          }
          if (mounted && !_hasNavigated) {
            setState(() {
              androidCodeId = adsId ?? androidCodeId;
              iosCodeId = adsId ?? iosCodeId;
              _isAdDataLoaded = true;
            });
            debugPrint("_loadAd开屏广告数据:$filteredAds");
          }
        } else {
          // 没有找到匹配的广告，直接跳转
          if (mounted && !_hasNavigated) {
            _navigateToNextPage();
          }
        }
      } else {
        // 没有广告数据，直接跳转
        if (mounted && !_hasNavigated) {
          _navigateToNextPage();
        }
      }
    } catch (e) {
      debugPrint("_loadAd开屏广告加载失败: $e");
      // 加载失败时，如果还没跳转，则跳转
      if (mounted && !_hasNavigated) {
        _navigateToNextPage();
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
                          // 广告成功显示后，取消超时定时器，让广告自己控制跳转时机
                          _timeoutTimer?.cancel();
                          debugPrint("开屏广告已显示，取消超时定时器，等待广告倒计时结束");
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
