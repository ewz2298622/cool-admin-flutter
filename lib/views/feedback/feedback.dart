import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/dict_data_entity.dart';

// 定义一个名为 Setting 的有状态组件，用于展示一个包含 WebView 的页面
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  // 创建该组件对应的状态类实例
  @override
  State<FeedbackPage> createState() => _FeedbackState();
}

// 定义 Setting 组件对应的状态类
class _FeedbackState extends State<FeedbackPage> {
  TextEditingController TDTextareaController = TextEditingController();
  var _futureBuilderFuture;
  final ScrollController _scrollController = ScrollController();
  // 组件状态初始化方法，在组件创建时调用
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  List<DictDataDataFeedbackType> feedback_type = [];
  String content = "";
  final videoId = Get.arguments?["videoId"]?.toString() ?? "";
  final videoName = Get.arguments?["videoName"]?.toString() ?? "";
  final playLineId = Get.arguments?["playLineId"]?.toString() ?? "";
  final videoUrl = Get.arguments?["videoUrl"]?.toString() ?? "";

  // 添加防抖相关的变量
  DateTime? _lastSubmitTime;
  static const int _debounceDuration = 1000; // 防抖时间间隔(毫秒)

  @override
  void initState() {
    _futureBuilderFuture = init();
    // 调用父类的 initState 方法，确保父类的初始化逻辑正常执行
    super.initState();
  }

  Future<String> init() async {
    try {
      await getDictInfoPages();
      return "init success";
    } catch (e) {
      return "init success";
    }
  }

  Future<void> getDictInfoPages() async {
    try {
      feedback_type =
          ((await Api.getDictData({
                    "types": ["feedback_type"],
                  })).data
                  as DictDataData)
              .feedbackType!
              .cast<DictDataDataFeedbackType>();
    } catch (e) {
      // 捕获并处理异常
      print('获取反馈分类数据失败: $e');
    }
  }

  /// 返回一个Widget自动填充剩余高度 且可以滑动
  Widget _buildContent(BuildContext context) {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PageLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("请选择遇到的问题类型"),
                            _horizontalCardStyle(context),
                          ],
                        ),
                        Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("详细问题描述(必填)"), _cardStyle(context)],
                        ),
                        TDButton(
                          text: '提交',
                          size: TDButtonSize.large,
                          isBlock: true,
                          disabled: content.isEmpty ? true : false,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          onTap: () async {
                            addFeedback(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  /// addFeedback 防抖函数
  Future<void> addFeedback(BuildContext context) async {
    // 添加防抖逻辑
    final now = DateTime.now();
    if (_lastSubmitTime != null &&
        now.difference(_lastSubmitTime!).inMilliseconds < _debounceDuration) {
      // 如果距离上次提交时间小于防抖间隔，则忽略此次提交
      return;
    }

    // 更新上次提交时间
    _lastSubmitTime = now;
    if (videoId.isEmpty) {
      await Api.addFeedback({
        "feedbackType": feedback_type[currentIndex.value].id,
        "content": content,
      });
    } else {
      await Api.addFeedback({
        "videoId": videoId.isNotEmpty ? videoId : null,
        "videoName": videoName.isNotEmpty ? videoName : null,
        "playLineId": playLineId.isNotEmpty ? playLineId : null,
        "videoUrl": videoUrl.isNotEmpty ? videoUrl : null,
        "feedbackType": feedback_type[currentIndex.value].id,
        "content": content,
      });
    }

    TDToast.showText('反馈成功', context: context);
  }

  Widget _cardStyle(BuildContext context) {
    return TDTextarea(
      controller: TDTextareaController,
      hintText: '输入您遇到的问题和意见以便我们提供更好的服务',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          TDTheme.of(context).radiusExtraLarge,
        ),
      ),
      onChanged: (value) {
        content = value;
        setState(() {});
      },
    );
  }

  Widget _horizontalCardStyle(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndex,
      builder: (BuildContext context, int value, Widget? child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.5,
          ),
          itemCount: feedback_type.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                currentIndex.value = index;
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      currentIndex.value == index
                          ? TDTheme.of(context).brandNormalColor
                          : TDTheme.of(context).grayColor1,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    feedback_type[index].name!,
                    style: TextStyle(
                      color:
                          currentIndex.value == index
                              ? TDTheme.of(context).whiteColor1
                              : TDTheme.of(context).grayColor14,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("反馈/求片", style: TextStyle(fontSize: 16)),
        //返回
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        //标题居中
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false, //设置为false
      ),
      body: Container(child: _buildContent(context)),
    );
  }
}
