import 'dart:convert';

import 'package:flutter_app/entity/app_ads_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 广告数据缓存工具类
class AdsCacheUtil {
  static const String _adsCacheKey = 'cached_ads_data';

  /// 将广告数据存储到本地缓存
  static Future<void> saveAdsData(List<AppAdsDataList> adsData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String adsDataJson = jsonEncode(
        adsData.map((ad) => ad.toJson()).toList(),
      );
      await prefs.setString(_adsCacheKey, adsDataJson);
    } catch (e) {
      print('保存广告数据到缓存失败: $e');
    }
  }

  /// 从本地缓存获取广告数据
  static Future<List<AppAdsDataList>?> getAdsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? adsDataJson = prefs.getString(_adsCacheKey);

      if (adsDataJson != null && adsDataJson.isNotEmpty) {
        final List<dynamic> decodedData = jsonDecode(adsDataJson);
        return decodedData
            .map(
              (item) => AppAdsDataList.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return null;
    } catch (e) {
      print('从缓存获取广告数据失败: $e');
      return null;
    }
  }

  /// 清除缓存的广告数据
  static Future<void> clearAdsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_adsCacheKey);
    } catch (e) {
      print('清除广告数据缓存失败: $e');
    }
  }

  /// 检查是否存在缓存的广告数据
  static Future<bool> hasCachedAdsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? adsDataJson = prefs.getString(_adsCacheKey);
      return adsDataJson != null && adsDataJson.isNotEmpty;
    } catch (e) {
      print('检查广告数据缓存状态失败: $e');
      return false;
    }
  }
}

// // 保存广告数据
// AdsCacheUtil.saveAdsData(adsList);
//
// // 获取广告数据
// List<AppAdsDataList>? cachedAds = await AdsCacheUtil.getAdsData();
//
// // 检查是否有缓存数据
// bool hasCache = await AdsCacheUtil.hasCachedAdsData();
//
// // 清除缓存数据
// AdsCacheUtil.clearAdsData();
