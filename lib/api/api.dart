import 'package:flutter/cupertino.dart';
import 'package:flutter_app/entity/dict_data_entity.dart';
import 'package:flutter_app/entity/login_entity.dart';

import '../entity/album_entity.dart';
import '../entity/album_video_list_entity.dart';
import '../entity/app_ads_entity.dart';
import '../entity/captcha_entity.dart';
import '../entity/dict_info_list_entity.dart';
import '../entity/hot_keyWord_entity.dart';
import '../entity/live_info_entity.dart';
import '../entity/notice_Info_entity.dart';
import '../entity/play_line_entity.dart';
import '../entity/score_total_entity.dart';
import '../entity/swiper_entity.dart';
import '../entity/user_info_entity.dart';
import '../entity/video_album_entity.dart';
import '../entity/video_category_entity.dart';
import '../entity/video_detail_entity.dart';
import '../entity/video_line_entity.dart';
import '../entity/video_live_entity.dart';
import '../entity/video_page_entity.dart';
import '../entity/views_entity.dart';
import '../entity/week_entity.dart';
import '../http/request.dart';

/// 请求接口
class Api {
  static DioHttp server = DioHttp();

  /// 异步获取轮播图页面数据
  ///
  /// 该方法通过POST请求从服务器获取轮播图页面数据，请求的参数包括：
  /// - page: 页码，当前固定为1
  /// - type: 类型，当前固定为1
  /// - status: 状态，当前固定为1
  /// - size: 请求的数据大小，当前固定为5
  ///
  /// 返回一个SwiperEntity对象，该对象是从服务器响应的JSON数据转换而来
  /// 如果在请求或解析过程中发生错误，会重新抛出异常
  static Future<SwiperEntity> getSwiperPage(Map<String, dynamic>? data) async {
    try {
      // 发起POST请求获取轮播图页面数据
      final response = await server.post("/app/video/swiper/page", data: data);
      // 将响应的JSON数据转换为SwiperEntity对象并返回
      return SwiperEntity.fromJson(response.data);
    } catch (error) {
      // 打印错误信息用于调试
      debugPrint("error");
      // 重新抛出错误，以便调用者可以处理
      rethrow;
    }
  }

  Future<SwiperEntity> getSwiperPages(Map<String, dynamic>? data) async {
    try {
      // 发起POST请求获取轮播图页面数据
      final response = await server.post("/app/swiper/swiper/page", data: data);
      // 将响应的JSON数据转换为SwiperEntity对象并返回
      return SwiperEntity.fromJson(response.data);
    } catch (error) {
      // 打印错误信息用于调试
      debugPrint("error");
      // 重新抛出错误，以便调用者可以处理
      rethrow;
    }
  }

  /// 异步获取视频分类页面信息
  ///
  /// 该方法通过发送POST请求到服务器，获取指定页面的视频分类数据
  /// 请求参数包括页面号、类型、状态和页面大小，这些参数用于服务器端查询和过滤数据
  /// 如果请求成功，将返回一个从JSON数据解析出来的[VideoCategoryEntity]对象
  /// 如果请求失败，将捕获异常并在开发模式下打印错误信息，然后重新抛出异常以便上层处理
  ///
  /// 参数:
  ///   无直接参数，但在方法内部构造了请求参数，包括:
  ///   - page: 页面号，表示请求第几页的数据
  ///   - type: 类型，表示视频的类型
  ///   - status: 状态，表示视频的状态
  ///   - size: 页面大小，表示每页返回的数据数量
  ///
  /// 返回值:
  ///   一个[VideoCategoryEntity]对象，包含请求的视频分类页面信息
  ///
  /// 异常:
  ///   如果网络请求失败或服务器返回错误，将捕获异常并重新抛出
  static Future<VideoCategoryEntity> getVideoCategoryPages(
    Map<String, dynamic>? data,
  ) async {
    try {
      // 发送POST请求到服务器获取视频分类页面信息
      final response = await server.post(
        "/app/video/category/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return VideoCategoryEntity.fromJson(response.data);
    } catch (error) {
      // 在开发模式下打印错误信息以便调试
      debugPrint("error");

      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<AlbumEntity> getVideoAlbumPages(
    Map<String, dynamic>? data,
  ) async {
    try {
      // 发送POST请求到服务器获取视频分类页面信息
      final response = await server.post(
        "/app/video/album/album",
        data: data,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return AlbumEntity.fromJson(response.data);
    } catch (error) {
      // 在开发模式下打印错误信息以便调试
      debugPrint("error");

      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  /// 根据视频分类列表的ID循环获取每一个分类下的轮播图列表
  ///
  /// 该方法通过POST请求从服务器获取指定视频分类ID的轮播图列表。
  /// 请求的参数包括：
  /// - videoCategoryIds: 视频分类ID列表
  ///
  /// 返回一个Map<int, List<SwiperEntity>>对象，其中键是视频分类ID，值是该分类下的轮播图列表。
  /// 如果在请求或解析过程中发生错误，会重新抛出异常。
  ///
  /// 参数:
  ///   - videoCategoryIds: 视频分类ID列表
  ///
  /// 返回值:
  ///   一个Map<int, List<SwiperEntity>>对象，包含请求的轮播图列表
  ///
  /// 异常:
  ///   如果网络请求失败或服务器返回错误，将捕获异常并重新抛出
  static Future<Map<int, List<SwiperDataList>>> getSwiperListByCategoryIds(
    List<int> videoCategoryIds,
  ) async {
    try {
      // 使用 Future.wait 并发请求每个分类的轮播图列表
      List<Future<MapEntry<int, List<SwiperDataList>>>> futures =
          videoCategoryIds.map((id) async {
            SwiperEntity swiperData = (await Api.getSwiperPage({
              "page": 1,
              "category": id,
              "status": 1,
              "size": 5,
            }));

            // 假设服务器返回的数据结构为 {"data": [...]}
            List<SwiperDataList> responseData = List.from(
              swiperData.data?.list as List<SwiperDataList>,
            );

            return MapEntry(id, responseData);
          }).toList();

      // 等待所有请求完成

      List<MapEntry<int, List<SwiperDataList>>> results = await Future.wait(
        futures,
      );

      // 将结果转换为 Map<int, List<SwiperEntity>>
      Map<int, List<SwiperDataList>> swiperMap = Map.fromEntries(results);

      return swiperMap;
    } catch (error) {
      // 打印错误信息用于调试
      rethrow;
    }
  }

  static Future<Map<int, List<AlbumDataList>>> getAlbumListByCategoryIds(
    List<int> videoCategoryIds,
  ) async {
    try {
      // 使用 Future.wait 并发请求每个分类的轮播图列表
      List<Future<MapEntry<int, List<AlbumDataList>>>> futures =
          videoCategoryIds.map((id) async {
            AlbumEntity videoAlbumData = (await Api.getVideoAlbumPages({
              "page": 1,
              "category_id": id,
              "status": 1,
              "size": 1000,
              "videoSize": 15,
            }));
            List<AlbumDataList> responseData = List.from(
              videoAlbumData.data?.list as List<AlbumDataList>,
            );
            return MapEntry(id, responseData);
          }).toList();

      List<MapEntry<int, List<AlbumDataList>>> results = await Future.wait(
        futures,
      );

      Map<int, List<AlbumDataList>> albumMap = Map.fromEntries(results);
      return albumMap;
    } catch (error) {
      // 打印错误信息用于调试
      rethrow;
    }
  }

  static Future<VideoDetailEntity> getVideoById(
    Map<String, dynamic>? param,
  ) async {
    try {
      // 发送POST请求到服务器获取视频分类页面信息
      final response = await server.get(
        "/app/video/videos/info",
        param: param,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return VideoDetailEntity.fromJson(response.data);
    } catch (error) {
      // 在开发模式下打印错误信息以便调试
      debugPrint("error");

      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<VideoPageEntity> getVideoPages(
    Map<String, dynamic>? data,
  ) async {
    try {
      // 发送POST请求到服务器获取视频分类页面信息
      final response = await server.post(
        "/app/video/videos/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return VideoPageEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<VideoLineEntity> getVideoLinePages(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await server.post(
        "/app/video/video_line/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return VideoLineEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  /**
   * 获取视频线路更新
   * @param data 请求参数
   */
  static VideoLineUpdate(Map<String, dynamic>? data) async {
    try {
      await server.post(
        "/app/video/play_line/update",
        data: data,
      ); // 添加注释说明 ONE 的含义});
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<PlayLineEntity> getPlayLinePages(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await server.post(
        "/app/video/play_line/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return PlayLineEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<VideoAlbumEntity> getAlbumById(
    Map<String, dynamic>? param,
  ) async {
    try {
      final response = await server.get(
        "/app/video/album/info",
        param: param,
      ); // 添加注释说明 ONE 的含义});
      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return VideoAlbumEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<AlbumVideoListEntity> getAlbumVideoList(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await server.post(
        "/app/video/album_video/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});
      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return AlbumVideoListEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<VideoPageEntity> getVideoSortPage(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await server.post(
        "/app/video/videos/sort",
        data: data,
      ); // 添加注释说明 ONE 的含义});
      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return VideoPageEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //获取某一个字典数据
  static Future<DictInfoListEntity> getDictInfoPages(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await server.post(
        "/app/dict/info/list",
        data: data,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return DictInfoListEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //获取某一个字典数据
  static Future<DictDataEntity> getDictData(Map<String, dynamic>? data) async {
    try {
      final response = await server.post(
        "/app/dict/info/data",
        data: data,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return DictDataEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //获取直播列表
  static Future<VideoLiveEntity> getVideoLivePages(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await server.post(
        "/app/video/live/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return VideoLiveEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //获取验证码
  static Future<CaptchaEntity> getCaptcha(Map<String, dynamic>? param) async {
    try {
      final response = await server.get(
        "/app/user/login/captcha",
        param: param,
      ); // 添加注释说明 ONE 的含义});

      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return CaptchaEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //获取登录信息
  static Future<LoginEntity> getLogin(Map<String, dynamic>? data) async {
    try {
      final response = await server.post(
        "/app/user/login/app_login",
        data: data,
      ); // 添加注释说明 ONE 的含义});
      // 将服务器返回的JSON数据解析为[VideoCategoryEntity]对象并返回
      return LoginEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //获取登录信息
  static Future<UserInfoEntity> getUserInfo(Map<String, dynamic>? data) async {
    try {
      final response = await server.get(
        "/app/user/info/person",
      ); // 添加注释说明 ONE 的含义});
      return UserInfoEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //获取浏览记录
  static Future<ViewsEntity> getViews(Map<String, dynamic>? data) async {
    try {
      final response = await server.post(
        "/app/user/views/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});
      return ViewsEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //添加浏览记录
  static Future<void> addViews(Map<String, dynamic>? data) async {
    try {
      await server.post(
        "/app/application/views/add",
        data: data,
      ); // 添加注释说明 ONE 的含义});
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //添加用户反馈
  static Future<void> addFeedback(Map<String, dynamic>? data) async {
    try {
      await server.post(
        "/app/application/feedbackInfo/add",
        data: data,
      ); // 添加注释说明 ONE 的含义});
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //添加浏览记录
  static Future<void> register(Map<String, dynamic>? data) async {
    try {
      await server.post(
        "/app/user/login/register",
        data: data,
      ); // 添加注释说明 ONE 的含义});
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //添加公告
  static Future<NoticeInfoEntity> noticeInfo(Map<String, dynamic>? data) async {
    try {
      final response = await server.post(
        "/app/application/noticeInfo/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});
      return NoticeInfoEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //添加公告
  static Future<LiveInfoEntity> liveInfo(Map<String, dynamic>? param) async {
    try {
      final response = await server.get(
        "/app/video/live/info",
        param: param,
      ); // 添加注释说明 ONE 的含义});
      return LiveInfoEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //添加浏览记录
  static Future<void> addContacts(Map<String, dynamic>? data) async {
    try {
      await server.post(
        "/app/user/contacts/add",
        data: data,
      ); // 添加注释说明 ONE 的含义});
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<WeekEntity> getWeek(Map<String, dynamic>? data) async {
    try {
      final response = await server.post(
        "/app/video/week/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});
      return WeekEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<HotKeyWordEntity> getHostKeyWord(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await server.post(
        "/app/video/hot_keyword/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});
      return HotKeyWordEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<AppAdsEntity> getAdsList(Map<String, dynamic>? data) async {
    try {
      final response = await server.post(
        "/app/application/ads/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});
      return AppAdsEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<void> addScore(Map<String, dynamic>? data) async {
    try {
      await server.post(
        "/app/member/score/add",
        data: data,
      ); // 添加注释说明 ONE 的含义});
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  static Future<void> memberExchangeConfigPage(
    Map<String, dynamic>? data,
  ) async {
    try {
      await server.post(
        "/app/member/memberExchangeConfig/page",
        data: data,
      ); // 添加注释说明 ONE 的含义});
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }

  //查询用户积分
  static Future<ScoreTotalEntity> getUserScore(
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await server.post("/app/member/score/total", data: data);
      return ScoreTotalEntity.fromJson(response.data);
    } catch (error) {
      // 重新抛出异常以便上层处理
      rethrow;
    }
  }
}
