import 'package:flutter/material.dart';
import 'package:flutter_app/entity/swiper_entity.dart';

class SwiperItemComponent extends StatelessWidget {
  final SwiperDataList item;
  final double borderRadius;

  const SwiperItemComponent({
    Key? key,
    required this.item,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
            image: NetworkImage(item.image ?? ''),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
          child: Column(
            //居左
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '彭于晏艾伦首次合作火花十足！',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8), // opacity: .8
                  fontSize: 12, // 假设 1rem = 16px，根据你的设计系统调整
                  fontFamily: 'PingFang SC', // 注意：Flutter需要确保字体已添加
                  fontWeight: FontWeight.normal, // font-weight: 400
                  height: 0.333 / 0.32, // line-height相对于font-size的比例
                  overflow: TextOverflow.ellipsis, // text-overflow: ellipsis
                ),
                maxLines: 1, // white-space: nowrap 的效果
                overflow: TextOverflow.ellipsis, // 这里再设置一次确保效果
              ),
            ],
          ),
        ),
      ),
    );
  }
}
