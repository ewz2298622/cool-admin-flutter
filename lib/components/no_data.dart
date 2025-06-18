import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TDImage(
            assetUrl: 'assets/images/no_data.png',
            width: 200,
            height: 200,
          ),
          Text("找不到相关内容"),
        ],
      ),
    );
  }
}
