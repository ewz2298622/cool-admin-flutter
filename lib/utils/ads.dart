import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../db/entity/UserEntity.dart';
import '../db/manager/user_database_helper.dart';
import '../entity/app_ads_entity.dart';
import 'ads_config.dart';

class Ads {
  static bool? _init;
  static String SDKVersion = "";
  static StreamSubscription? _adViewStream;
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  static UserEntity? user;
  //积分
  static int score = 0;
  static int adsId = 0;

  static String REWARD_VIDEO_AD_ANDROID =
      AdsConfig.FULL_SCREEN_VIDEO_AD_ANDROID;
  static String REWARD_VIDEO_AD_IOS = AdsConfig.FULL_SCREEN_VIDEO_AD_IOS;
  static Completer<bool>? _initCompleter;

  //注册
  static Future<bool> initRegister() async {
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }
    _initCompleter = Completer<bool>();

    try {
      _init = await FlutterUnionad.register(
        //穿山甲广告 Android appid 必填
        androidAppId: AdsConfig.APP_ID_ANDROID,
        //穿山甲广告 ios appid 必填
        iosAppId: AdsConfig.APP_ID_IOS,
        //appname 必填
        appName: AdsConfig.APP_NAME,
        //使用聚合功能一定要打开此开关，否则不会请求聚合广告，默认这个值为false
        //true使用GroMore下的广告位
        //false使用广告变现下的广告位
        useMediation: true,
        //是否为计费用户 选填
        paid: false,
        //用户画像的关键词列表 选填
        keywords: "",
        //是否允许sdk展示通知栏提示 选填
        allowShowNotify: true,
        //是否显示debug日志
        debug: true,
        //是否支持多进程 选填
        supportMultiProcess: false,
        //主题模式 默认FlutterUnionAdTheme.DAY,修改后需重新调用初始化
        //允许直接下载的网络状态集合 选填
        directDownloadNetworkType: [
          FlutterUnionadNetCode.NETWORK_STATE_2G,
          FlutterUnionadNetCode.NETWORK_STATE_3G,
          FlutterUnionadNetCode.NETWORK_STATE_4G,
          FlutterUnionadNetCode.NETWORK_STATE_WIFI,
        ],
        androidPrivacy: AndroidPrivacy(
          //是否允许SDK主动使用地理位置信息 true可以获取，false禁止获取。默认为true
          isCanUseLocation: false,
          //当isCanUseLocation=false时，可传入地理位置信息，穿山甲sdk使用您传入的地理位置信息lat
          lat: 0.0,
          //当isCanUseLocation=false时，可传入地理位置信息，穿山甲sdk使用您传入的地理位置信息lon
          lon: 0.0,
          // 是否允许SDK主动使用手机硬件参数，如：imei
          isCanUsePhoneState: false,
          //当isCanUsePhoneState=false时，可传入imei信息，穿山甲sdk使用您传入的imei信息
          imei: "",
          // 是否允许SDK主动使用ACCESS_WIFI_STATE权限
          isCanUseWifiState: false,
          // 当isCanUseWifiState=false时，可传入Mac地址信息
          macAddress: "",
          // 是否允许SDK主动使用WRITE_EXTERNAL_STORAGE权限
          isCanUseWriteExternal: false,
          // 开发者可以传入oaid
          // 是否允许SDK主动获取设备上应用安装列表的采集权限
          alist: false,
          // 是否能获取android ID
          isCanUseAndroidId: false,
          // 开发者可以传入android ID
          androidId: "",
          // 是否允许SDK在申明和授权了的情况下使用录音权限
          isCanUsePermissionRecordAudio: false,
          // 是否限制个性化推荐接口
          isLimitPersonalAds: false,
          // 是否启用程序化广告推荐 true启用 false不启用
          isProgrammaticRecommend: false,
          userPrivacyConfig: {
            //控制QQ真g获取频率，"0"表示关闭，“1"或者其他值表示打开。
            "mcod": "0",
          },
        ),
        iosPrivacy: IOSPrivacy(
          //允许个性化广告
          limitPersonalAds: false,
          //允许程序化广告
          limitProgrammaticAds: false,
          //允许CAID
          forbiddenCAID: false,
        ),
        //配置拉取失败时导入本地配置 https://www.csjplatform.com/supportcenter/5885
        //android导入/android/app/src/main/assets/下，文件必须为json文件，传入文件名
        //ios导入/ios/下，文件必须为json文件，传入文件名
      );
      if (_init == true) {
        SDKVersion = await FlutterUnionad.getSDKVersion();
        addListener();
        debugPrint("initRegister success SDKVersion $SDKVersion");
        _initCompleter?.complete(true);
      } else {
        debugPrint("initRegister fail");
        _initCompleter?.complete(false);
      }
    } catch (e) {
      debugPrint("initRegister error: $e");
      _initCompleter?.complete(false);
    }
    return _initCompleter?.future ?? Future.value(false);
  }

  //请求权限
  static requestPermission() async {
    try {
      await FlutterUnionad.requestPermissionIfNecessary(
        callBack: FlutterUnionadPermissionCallBack(
          notDetermined: () {
            print("权限未确定");
          },
          restricted: () {
            print("权限限制");
          },
          denied: () {
            print("权限拒绝");
          },
          authorized: () {
            print("权限同意");
          },
        ),
      );
    } catch (e) {
      debugPrint("requestPermission error: $e");
    }
  }

  //插屏广告
  static loadFullScreenVideoAdInteraction() async {
    try {
      await FlutterUnionad.loadFullScreenVideoAdInteraction(
        //android 全屏广告id 必填
        androidCodeId: AdsConfig.FULL_SCREEN_VIDEO_AD_ANDROID,
        //ios 全屏广告id 必填
        iosCodeId: AdsConfig.FULL_SCREEN_VIDEO_AD_IOS,
        //视屏方向 选填
        orientation: FlutterUnionadOrientation.VERTICAL,
      );
    } catch (e) {
      debugPrint("插屏广告加载失败: $e");
    }
  }

  // 广告数据缓存，避免重复请求
  static List<AppAdsDataList>? _cachedAdsList;
  static DateTime? _cacheTime;
  static const Duration _cacheValidDuration = Duration(
    minutes: 5,
  ); // 缓存有效期 5 分钟

  //广告加载（直接从 API 请求，带缓存机制）
  static Future<void> _loadAd() async {
    try {
      // 检查缓存是否有效
      if (_cachedAdsList != null &&
          _cacheTime != null &&
          DateTime.now().difference(_cacheTime!) < _cacheValidDuration) {
        debugPrint("使用缓存的激励广告数据");
        _updateRewardAdConfig(_cachedAdsList!);
        return;
      }

      // 设置请求超时为 2 秒，避免长时间阻塞
      AppAdsEntity response = await Api.getAdsList({
        'status': 1,
        "adsPage": 898,
        'type': 683,
      }).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint("激励广告请求超时");
          throw TimeoutException("激励广告请求超时");
        },
      );

      List<AppAdsDataList>? adsList = response.data?.list as List<AppAdsDataList>?;

      if (adsList != null) {
        // 更新缓存
        _cachedAdsList = adsList;
        _cacheTime = DateTime.now();

        _updateRewardAdConfig(adsList);
      }
    } catch (e) {
      debugPrint("_loadAd激励广告加载失败: $e");
      // 如果请求失败但有缓存，使用缓存
      if (_cachedAdsList != null) {
        debugPrint("请求失败，使用缓存的激励广告数据");
        _updateRewardAdConfig(_cachedAdsList!);
      }
    }
  }

  // 更新激励广告配置
  static void _updateRewardAdConfig(List<AppAdsDataList> adsList) {
    if (adsList.isNotEmpty) {
      //筛选adsList数组中adsPage=898且type=683的数据
      List<AppAdsDataList> filteredAds =
          adsList.where((adsData) {
            return adsData.adsPage == 898 && adsData.type == 683;
          }).toList();
      if (filteredAds.isNotEmpty) {
        AppAdsDataList adsData = filteredAds[0];
        score = filteredAds[0].score ?? 0;
        adsId = filteredAds[0].id ?? 0;
        REWARD_VIDEO_AD_ANDROID = adsData.adsId ?? REWARD_VIDEO_AD_ANDROID;
        REWARD_VIDEO_AD_IOS = adsData.adsId ?? REWARD_VIDEO_AD_IOS;

        debugPrint("_loadAd激励广告数据:$filteredAds");
      }
    }
  }

  static Future<void> getUserInfo() async {
    try {
      Iterable<UserEntity> list = userDatabaseHelper.list();
      if (list.isNotEmpty) {
        // 修改：取第一个用户，或者根据业务逻辑选择合适的用户
        user = list.first;
      }
    } catch (e) {
      // 捕获并处理异常
      debugPrint('getUserInfo failed: $e');
    }
  }

  //预加载激励广告（异步加载，不阻塞）
  static Future<void> loadRewardVideoAd() async {
    try {
      // 异步加载广告配置，不阻塞广告预加载
      _loadAd().catchError((e) {
        debugPrint("加载广告配置失败，使用默认配置: $e");
      });

      // 如果广告 ID 为空，等待一下配置加载完成（最多等待 500ms）
      if (REWARD_VIDEO_AD_ANDROID.isEmpty || REWARD_VIDEO_AD_IOS.isEmpty) {
        await Future.any([
          _loadAd(),
          Future.delayed(const Duration(milliseconds: 500)),
        ]);
        if(REWARD_VIDEO_AD_ANDROID.isEmpty || REWARD_VIDEO_AD_IOS.isEmpty){
            Fluttertoast.showToast(msg: "广告服务未开通", toastLength: Toast.LENGTH_SHORT);
        }
      }

      await FlutterUnionad.loadRewardVideoAd(
        //是否个性化 选填
        androidCodeId: REWARD_VIDEO_AD_ANDROID,
        //Android 激励视频广告id  必填
        iosCodeId: REWARD_VIDEO_AD_IOS,
        //ios 激励视频广告id  必填
        rewardName: AdsConfig.REWARD_NAME,
        //奖励名称 选填
        rewardAmount: score,
        //奖励数量 选填
        userID: user?.id?.toString() ?? '',
        //  用户id 选填
        orientation: FlutterUnionadOrientation.VERTICAL,
        //视屏方向 选填
        mediaExtra: null,
        //扩展参数 选填
      );
    } catch (e) {
      debugPrint("激励广告加载失败: $e");
    }
  }

  //显示激励广告
  static Future<void> showRewardVideoAd() async {
    try {
      await FlutterUnionad.showRewardVideoAd();
    } catch (e) {
      debugPrint("显示激励广告失败: $e");
    }
  }

  //监听广告
  static void addListener() {
    // 先取消之前的订阅，避免重复监听
    _adViewStream?.cancel();
    
    _adViewStream = FlutterUnionadStream.initAdStream(
      flutterUnionadFullVideoCallBack: FlutterUnionadFullVideoCallBack(
        onShow: () {
          print("全屏广告显示");
        },
        onSkip: () {
          print("全屏广告跳过");
        },
        onClick: () {
          print("全屏广告点击");
        },
        onFinish: () {
          print("全屏广告结束");
        },
        onFail: (error) {
          print("全屏广告错误 $error");
        },
        onClose: () {
          print("全屏广告关闭");
        },
      ),
      //插屏广告回调
      flutterUnionadInteractionCallBack: FlutterUnionadInteractionCallBack(
        onShow: () {
          print("插屏广告展示");
        },
        onClose: () {
          print("插屏广告关闭");
        },
        onFail: (error) {
          print("插屏广告失败 $error");
        },
        onClick: () {
          print("插屏广告点击");
        },
        onDislike: (message) {
          print("插屏广告不喜欢  $message");
        },
      ),
      // 新模板渲染插屏广告回调
      flutterUnionadNewInteractionCallBack:
          FlutterUnionadNewInteractionCallBack(
            onShow: () {
              print("新模板渲染插屏广告显示");
            },
            onSkip: () {
              print("新模板渲染插屏广告跳过");
            },
            onClick: () {
              print("新模板渲染插屏广告点击");
            },
            onFinish: () {
              print("新模板渲染插屏广告结束");
            },
            onFail: (error) {
              print("新模板渲染插屏广告错误 $error");
            },
            onClose: () {
              print("新模板渲染插屏广告关闭");
            },
            onReady: () async {
              print("新模板渲染插屏广告预加载准备就绪");
              //显示新模板渲染插屏
              await FlutterUnionad.showFullScreenVideoAdInteraction();
            },
            onUnReady: () {
              print("新模板渲染插屏广告预加载未准备就绪");
            },
            onEcpm: (info) {
              print("新模板渲染插屏广告ecpm $info");
            },
          ),
      //激励广告
      flutterUnionadRewardAdCallBack: FlutterUnionadRewardAdCallBack(
        onShow: () {
          print("激励广告显示");
        },
        onClick: () {
          print("激励广告点击");
        },
        onFail: (error) {
          print("激励广告失败 $error");
        },
        onClose: () {
          print("激励广告关闭");
        },
        onSkip: () {
          print("激励广告跳过");
        },
        onReady: () async {
          print("激励广告预加载准备就绪");
          await FlutterUnionad.showRewardVideoAd();
        },
        onCache: () async {
          print("激励广告物料缓存成功。建议在这里进行广告展示，可保证播放流畅和展示流畅，用户体验更好。");
        },
        onUnReady: () {
          print("激励广告预加载未准备就绪");
        },
        onVerify: (rewardVerify, rewardAmount, rewardName, errorCode, error) {
          print(
            "激励广告奖励  验证结果=$rewardVerify 奖励=$rewardAmount  奖励名称$rewardName 错误码=$errorCode 错误$error",
          );
        },
        onRewardArrived: (
          rewardVerify,
          rewardType,
          rewardAmount,
          rewardName,
          errorCode,
          error,
          propose,
        ) async {
          print(
            "阶段激励广告奖励  验证结果=$rewardVerify 奖励类型<FlutterUnionadRewardType>=$rewardType 奖励=$rewardAmount"
            "奖励名称$rewardName 错误码=$errorCode 错误$error 建议奖励$propose",
          );
          try {
            await Api.addScore({"businessType": 0, "businessId": adsId});
          } catch (e) {
            debugPrint("Api.addScore error: $e");
          }
          Fluttertoast.showToast(msg: "奖励已发放", toastLength: Toast.LENGTH_SHORT);
        },
        onEcpm: (info) {
          print("激励广告 ecpm: $info");
        },
      ),
    );
  }
}