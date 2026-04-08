import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../api/api.dart';
import '../../components/loading.dart';
import '../../entity/dict_data_entity.dart';

/// 反馈/求片页面常量类
class FeedbackConstants {
  // 布局常量
  static const double padding = 10.0;
  static const double spacingSmall = 10.0;
  static const double spacingMedium = 20.0;
  static const double spacingLarge = 40.0;
  
  // 网格布局常量
  static const int gridCrossAxisCount = 3;
  static const double gridMainAxisSpacing = 10.0;
  static const double gridCrossAxisSpacing = 10.0;
  static const double gridChildAspectRatio = 3.5;
  
  // 文本域常量
  static const int textareaMaxLines = 4;
  static const int textareaMinLines = 4;
  static const int textareaMaxLength = 500;
  
  // 防抖常量
  static const int debounceDuration = 1000; // 防抖时间间隔(毫秒)
  
  // 文本常量
  static const String pageTitle = "反馈/求片";
  static const String problemTypeTitle = "请选择遇到的问题类型";
  static const String problemDescriptionTitle = "详细问题描述(必填)";
  static const String submitButtonText = "提交";
  static const String textareaHintText = "输入您遇到的问题和意见以便我们提供更好的服务";
  static const String feedbackSuccessMessage = "反馈成功";
  static const String noDataText = "No data available";
  
  // API 相关常量
  static const String feedbackTypeKey = "feedback_type";
}

/// 反馈/求片页面
///
/// 用户可以选择问题类型并提交详细描述，支持视频相关反馈
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackState();
}

/// 反馈/求片页面状态管理
class _FeedbackState extends State<FeedbackPage> {
  // 控制器
  final TextEditingController _textareaController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // 状态变量
  late Future<String> _futureBuilderFuture;
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  List<DictDataDataFeedbackType> _feedbackTypeList = [];
  String _content = "";
  
  // 视频相关参数
  final String _videoId = Get.arguments?["videoId"]?.toString() ?? "";
  final String _videoName = Get.arguments?["videoName"]?.toString() ?? "";
  final String _playLineId = Get.arguments?["playLineId"]?.toString() ?? "";
  final String _videoUrl = Get.arguments?["videoUrl"]?.toString() ?? "";

  // 防抖相关的变量
  DateTime? _lastSubmitTime;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _init();
  }

  @override
  void dispose() {
    _textareaController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 初始化数据
  ///
  /// 加载反馈类型数据
  Future<String> _init() async {
    try {
      await _getFeedbackTypeList();
      return "init success";
    } catch (e, stackTrace) {
      debugPrint('初始化失败: $e');
      debugPrint('堆栈跟踪: $stackTrace');
      return "init success";
    }
  }

  /// 获取反馈类型列表
  ///
  /// 从 API 获取反馈分类数据
  Future<void> _getFeedbackTypeList() async {
    try {
      final response = await Api.getDictData({
        "types": [FeedbackConstants.feedbackTypeKey],
      });
      
      final data = response.data as DictDataData;
      _feedbackTypeList = data.feedbackType?.cast<DictDataDataFeedbackType>() ?? [];
    } catch (e, stackTrace) {
      debugPrint('获取反馈分类数据失败: $e');
      debugPrint('堆栈跟踪: $stackTrace');
      _feedbackTypeList = [];
    }
  }

  /// 构建页面内容
  ///
  /// 包含问题类型选择和详细描述输入
  Widget _buildContent(BuildContext context) {
    return FutureBuilder<String>(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const PageLoading();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return _buildFeedbackForm(context);
          default:
            return const Text(FeedbackConstants.noDataText);
        }
      },
    );
  }

  /// 构建反馈表单
  Widget _buildFeedbackForm(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      padding: const EdgeInsets.all(FeedbackConstants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 问题类型选择
          _buildProblemTypeSection(context),
          
          const SizedBox(height: FeedbackConstants.spacingSmall),
          
          // 详细描述输入
          _buildProblemDescriptionSection(context),
          
          const SizedBox(height: FeedbackConstants.spacingMedium),
          
          // 提交按钮
          _buildSubmitButton(context),
          
          const SizedBox(height: FeedbackConstants.spacingLarge), // 添加底部空间，确保内容不被遮挡
        ],
      ),
    );
  }

  /// 构建问题类型选择部分
  Widget _buildProblemTypeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(FeedbackConstants.problemTypeTitle),
        const SizedBox(height: FeedbackConstants.spacingSmall),
        _buildFeedbackTypeGrid(context),
      ],
    );
  }

  /// 构建问题描述输入部分
  Widget _buildProblemDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(FeedbackConstants.problemDescriptionTitle),
        const SizedBox(height: FeedbackConstants.spacingSmall),
        _buildTextarea(context),
      ],
    );
  }

  /// 构建提交按钮
  Widget _buildSubmitButton(BuildContext context) {
    return TDButton(
      text: FeedbackConstants.submitButtonText,
      size: TDButtonSize.large,
      isBlock: true,
      disabled: _content.isEmpty,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      onTap: () async {
        await _submitFeedback(context);
      },
    );
  }

  /// 提交反馈
  ///
  /// 添加防抖逻辑，防止重复提交
  Future<void> _submitFeedback(BuildContext context) async {
    // 添加防抖逻辑
    final now = DateTime.now();
    if (_lastSubmitTime != null &&
        now.difference(_lastSubmitTime!).inMilliseconds < FeedbackConstants.debounceDuration) {
      return;
    }

    // 更新上次提交时间
    _lastSubmitTime = now;
    
    try {
      if (_videoId.isEmpty) {
        await Api.addFeedback({
          "feedbackType": _feedbackTypeList[_currentIndex.value].id,
          "content": _content,
        });
      } else {
        await Api.addFeedback({
          "videoId": _videoId.isNotEmpty ? _videoId : null,
          "videoName": _videoName.isNotEmpty ? _videoName : null,
          "playLineId": _playLineId.isNotEmpty ? _playLineId : null,
          "videoUrl": _videoUrl.isNotEmpty ? _videoUrl : null,
          "feedbackType": _feedbackTypeList[_currentIndex.value].id,
          "content": _content,
        });
      }

      if (mounted) {
        TDToast.showText(FeedbackConstants.feedbackSuccessMessage, context: context);
      }
    } catch (e, stackTrace) {
      debugPrint('提交反馈失败: $e');
      debugPrint('堆栈跟踪: $stackTrace');
      if (mounted) {
        TDToast.showText('提交失败，请稍后重试', context: context);
      }
    }
  }

  /// 构建文本输入区域
  Widget _buildTextarea(BuildContext context) {
    return TDTextarea(
      controller: _textareaController,
      hintText: FeedbackConstants.textareaHintText,
      maxLines: FeedbackConstants.textareaMaxLines,
      minLines: FeedbackConstants.textareaMinLines,
      maxLength: FeedbackConstants.textareaMaxLength,
      indicator: true,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          TDTheme.of(context).radiusExtraLarge,
        ),
      ),
      onChanged: (value) {
        _content = value;
        setState(() {});
      },
    );
  }

  /// 构建反馈类型网格
  Widget _buildFeedbackTypeGrid(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (BuildContext context, int value, Widget? child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: FeedbackConstants.gridCrossAxisCount,
            mainAxisSpacing: FeedbackConstants.gridMainAxisSpacing,
            crossAxisSpacing: FeedbackConstants.gridCrossAxisSpacing,
            childAspectRatio: FeedbackConstants.gridChildAspectRatio,
          ),
          itemCount: _feedbackTypeList.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildFeedbackTypeItem(context, index, value);
          },
        );
      },
    );
  }

  /// 构建反馈类型项
  Widget _buildFeedbackTypeItem(BuildContext context, int index, int currentValue) {
    final isSelected = currentValue == index;
    return GestureDetector(
      onTap: () {
        _currentIndex.value = index;
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? TDTheme.of(context).brandNormalColor
              : TDTheme.of(context).grayColor1,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            _feedbackTypeList[index].name ?? "",
            style: TextStyle(
              color: isSelected
                  ? TDTheme.of(context).whiteColor1
                  : TDTheme.of(context).grayColor14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(FeedbackConstants.pageTitle, style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
      ),
      body: _buildContent(context),
    );
  }
}
