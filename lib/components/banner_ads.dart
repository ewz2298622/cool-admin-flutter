import 'package:flutter/material.dart';
import 'package:flutter_unionad/bannerad/BannerAdView.dart';
import 'package:flutter_unionad/flutter_unionad.dart';

class BannerAds extends StatefulWidget {
  final String androidCodeId;
  final String iosCodeId;

  const BannerAds({
    super.key,
    required this.androidCodeId,
    required this.iosCodeId,
  });

  @override
  State<BannerAds> createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  FlutterUnionadBannerView? _bannerView;
  bool _loadFailed = false;

  @override
  Widget build(BuildContext context) {
    // 如果加载失败，不显示组件
    if (_loadFailed) {
      return SizedBox.shrink();
    }

    // 移除单例模式，每个实例独立创建banner view
    _bannerView ??= FlutterUnionadBannerView(
      key: Key(
        '${widget.androidCodeId}_${widget.iosCodeId}_${DateTime.now().millisecondsSinceEpoch}',
      ),
      //andrrid banner广告id 必填
      androidCodeId: widget.androidCodeId,
      //ios banner广告id 必填
      iosCodeId: widget.iosCodeId,
      // 期望view 宽度 dp 必填
      width: double.infinity,
      //期望view高度 dp 必填
      height: 150.5,
      //广告事件回调 选填
      callBack: FlutterUnionadBannerCallBack(
        onShow: () {
          print("banner广告加载完成");
        },
        onDislike: (message) {
          print("banner不感兴趣 $message");
        },
        onFail: (error) {
          print("banner广告加载失败 $error");
          // 加载失败时更新状态，隐藏组件
          setState(() {
            _loadFailed = true;
          });
        },
        onClick: () {
          print("banner广告点击");
        },
      ),
    );

    return _bannerView!;
  }
}
