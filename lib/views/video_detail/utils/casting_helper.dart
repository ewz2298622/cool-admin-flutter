import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../entity/video_detail_data_entity.dart';
import '../../../utils/cast_screen_manager.dart';

/// 投屏助手类
/// 负责管理投屏相关的业务逻辑和 UI 展示
class CastingHelper {
  final CastScreenManager _castScreenManager = CastScreenManager();
  final VoidCallback? onDeviceListUpdate;
  
  StateSetter? showModalBottomSheetState;
  List<dynamic> deviceList = [];

  CastingHelper({this.onDeviceListUpdate}) {
    // 设置投屏设备列表更新回调
    _castScreenManager.onDeviceListUpdate = (devices) {
      deviceList = devices;
      onDeviceListUpdate?.call();
      showModalBottomSheetState?.call(() {});
    };
  }

  /// 搜索设备
  Future<void> searchDevices() async {
    await _castScreenManager.startSearchDevices();
  }

  /// 显示投屏对话框
  void showCastingDialog({
    required BuildContext context,
    required VideoDetailDataData videoInfoData,
    required int currentLine,
    required int currentPlay,
  }) {
    searchDevices();
    
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            showModalBottomSheetState = setState;
            return Card(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                height: 650,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "投屏",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: Navigator.of(context).pop,
                              child: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Text(
                                  "注意:",
                                  style: TextStyle(
                                    color: Color.fromARGB(142, 142, 142, 0),
                                  ),
                                ),
                                Text(
                                  "1、电视投屏的广告与本 APP 无关",
                                  style: TextStyle(
                                    color: Color.fromARGB(142, 142, 142, 0),
                                  ),
                                ),
                                Text(
                                  "2、投屏后无法再次投屏，请重置投屏或者退出投屏",
                                  style: TextStyle(
                                    color: Color.fromARGB(142, 142, 142, 0),
                                  ),
                                ),
                                Text(
                                  "3、设备扫描过程是持续的请静心等待 10 秒左右",
                                  style: TextStyle(
                                    color: Color.fromARGB(142, 142, 142, 0),
                                  ),
                                ),
                                _buildDeviceList(
                                  videoInfoData: videoInfoData,
                                  currentLine: currentLine,
                                  currentPlay: currentPlay,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  /// 构建设备列表
  Widget _buildDeviceList({
    required VideoDetailDataData videoInfoData,
    required int currentLine,
    required int currentPlay,
  }) {
    if (deviceList.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: TDLoading(
            size: TDLoadingSize.large,
            icon: TDLoadingIcon.circle,
          ),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: deviceList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TDButton(
              text: deviceList[index]["value"].info.friendlyName,
              size: TDButtonSize.large,
              onTap: () {
                _castToDevice(
                  device: deviceList[index],
                  videoInfoData: videoInfoData,
                  currentLine: currentLine,
                  currentPlay: currentPlay,
                );
              },
              type: TDButtonType.outline,
              shape: TDButtonShape.rectangle,
              theme: TDButtonTheme.primary,
            ),
          );
        },
      );
    }
  }

  /// 投屏到设备
  void _castToDevice({
    required dynamic device,
    required VideoDetailDataData videoInfoData,
    required int currentLine,
    required int currentPlay,
  }) {
    try {
      if (videoInfoData.lines != null &&
          videoInfoData.lines!.isNotEmpty &&
          currentLine < videoInfoData.lines!.length) {
        final selectedLine = videoInfoData.lines?[currentLine];
        if (selectedLine?.playLines != null &&
            currentPlay < (selectedLine?.playLines?.length ?? 0)) {
          final selectedPlayLine = selectedLine?.playLines?[currentPlay];
          _castScreenManager.castToDevice(
            device,
            selectedPlayLine?.file ?? "",
            "${videoInfoData.video?.title ?? ""}  ${selectedPlayLine?.name ?? ""} ",
          );
        }
      }
    } catch (e) {
      debugPrint("投屏错误：${e.toString()}");
    }
  }

  /// 释放资源
  void dispose() {
    _castScreenManager.dispose();
  }
}
