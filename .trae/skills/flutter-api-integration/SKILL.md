---
name: "flutter-api-integration"
description: "Flutter HTTP API 集成规范。Invoke when: 1) 添加新的 API 接口 2) 处理网络请求 3) 实现数据缓存 4) 处理请求错误"
---

# Flutter HTTP API 集成规范

## 项目使用的 HTTP 库
- **dio**: ^5.8.0+1 - 主要的 HTTP 客户端
- **json 序列化**: 使用自定义 JSON 生成器

## HTTP 目录结构
```
lib/http/
├── request.dart                 # 主要请求类
├── requestConfig.dart          # 请求配置
├── http_method.dart            # HTTP 方法枚举
├── dioResponse.dart            # 响应封装
├── cacheInterceptor.dart       # 缓存拦截器
├── errorInterceptor.dart       # 错误拦截器
├── responseInterceptor.dart    # 响应拦截器
├── tokenInterceptors.dart      # Token 拦截器
├── print_log_interceptor.dart  # 日志拦截器
└── whitelistPaths.dart         # 白名单路径
```

## API 请求规范

### 1. 基础请求类使用
```dart
import 'package:flutter_app/http/request.dart';

class VideoApi {
  // GET 请求
  static Future<VideoPageEntity> getVideoList({
    int page = 1,
    int size = 20,
    int? categoryId,
  }) async {
    final response = await Request.get(
      '/video/list',
      params: {
        'page': page,
        'size': size,
        if (categoryId != null) 'categoryId': categoryId,
      },
    );
    return VideoPageEntity.fromJson(response.data);
  }
  
  // POST 请求
  static Future<bool> addFavorite(int videoId) async {
    final response = await Request.post(
      '/video/favorite',
      data: {'videoId': videoId},
    );
    return response.code == 200;
  }
  
  // 上传文件
  static Future<String> uploadAvatar(File file) async {
    final response = await Request.upload(
      '/upload/avatar',
      file: file,
      filename: 'avatar.jpg',
    );
    return response.data['url'];
  }
}
```

### 2. 响应处理
```dart
class DioResponse<T> {
  final int code;
  final String message;
  final T data;
  final bool success;
  
  DioResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.success,
  });
  
  factory DioResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return DioResponse(
      code: json['code'],
      message: json['message'],
      data: fromJsonT(json['data']),
      success: json['code'] == 200,
    );
  }
}
```

### 3. 错误处理
```dart
class ApiException implements Exception {
  final int code;
  final String message;
  
  ApiException(this.code, this.message);
  
  @override
  String toString() => 'ApiException: $code - $message';
}

// 使用 try-catch
try {
  final video = await VideoApi.getVideoDetail(id);
} on ApiException catch (e) {
  if (e.code == 401) {
    // 未登录，跳转到登录页
    Get.toNamed('/login');
  } else {
    // 显示错误提示
    Fluttertoast.showToast(msg: e.message);
  }
} catch (e) {
  // 未知错误
  Fluttertoast.showToast(msg: '网络错误，请稍后重试');
}
```

## 数据实体定义

### 1. 实体类模板
```dart
import 'package:flutter_app/generated/json/base/json_convert_content.dart';

@JsonConvert()
class VideoEntity {
  int? id;
  String? title;
  String? cover;
  String? url;
  int? duration;
  int? viewCount;
  
  VideoEntity({
    this.id,
    this.title,
    this.cover,
    this.url,
    this.duration,
    this.viewCount,
  });
  
  VideoEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cover = json['cover'];
    url = json['url'];
    duration = json['duration'];
    viewCount = json['viewCount'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['cover'] = cover;
    data['url'] = url;
    data['duration'] = duration;
    data['viewCount'] = viewCount;
    return data;
  }
}
```

### 2. 分页实体
```dart
@JsonConvert()
class VideoPageEntity {
  List<VideoEntity>? list;
  int? total;
  int? page;
  int? size;
  bool? hasMore;
  
  VideoPageEntity({
    this.list,
    this.total,
    this.page,
    this.size,
    this.hasMore,
  });
  
  VideoPageEntity.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = (json['list'] as List)
          .map((e) => VideoEntity.fromJson(e))
          .toList();
    }
    total = json['total'];
    page = json['page'];
    size = json['size'];
    hasMore = json['hasMore'];
  }
}
```

## 请求拦截器

### 1. Token 拦截器
```dart
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 白名单路径不需要 Token
    if (WhitelistPaths.contains(options.path)) {
      handler.next(options);
      return;
    }
    
    final token = await TokenDatabaseHelper().getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token 过期，清除登录状态
      EventBus().emit('logout');
    }
    handler.next(err);
  }
}
```

### 2. 缓存拦截器
```dart
class CacheInterceptor extends Interceptor {
  final Map<String, Response> _cache = {};
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // GET 请求且带有 cache=true 参数时启用缓存
    if (options.method == 'GET' && options.extra['cache'] == true) {
      final cached = _cache[options.uri.toString()];
      if (cached != null) {
        handler.resolve(cached);
        return;
      }
    }
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.extra['cache'] == true) {
      _cache[response.requestOptions.uri.toString()] = response;
    }
    handler.next(response);
  }
}
```

## 页面中使用 API

### 1. 基础用法
```dart
class VideoListPage extends StatefulWidget {
  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List<VideoEntity> _videos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  
  Future<void> _loadData({bool refresh = false}) async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      if (refresh) _page = 1;
      
      final result = await VideoApi.getVideoList(page: _page);
      
      setState(() {
        if (refresh) {
          _videos = result.list ?? [];
        } else {
          _videos.addAll(result.list ?? []);
        }
        _hasMore = result.hasMore ?? false;
        _page++;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: '加载失败');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadData(refresh: true),
      child: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) => VideoItem(video: _videos[index]),
      ),
    );
  }
}
```

### 2. 使用 FutureBuilder
```dart
class VideoDetailPage extends StatelessWidget {
  final int videoId;
  
  VideoDetailPage({required this.videoId});
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VideoDetailEntity>(
      future: VideoApi.getVideoDetail(videoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }
        
        if (snapshot.hasError) {
          return ErrorWidget(message: '加载失败');
        }
        
        final video = snapshot.data!;
        return VideoPlayerWidget(url: video.url!);
      },
    );
  }
}
```

## 注意事项
1. 所有 API 请求必须处理错误情况
2. 分页请求需要防止重复加载
3. 敏感操作需要验证登录状态
4. 大文件上传需要显示进度
5. 列表数据需要支持下拉刷新和上拉加载
