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
    // 计算标题宽度，避免重复计算
    final screenWidth = MediaQuery.of(context).size.width;
    final titleWidth = screenWidth * 0.7;

    return RepaintBoundary(
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片
            Image.network(
              item.image ?? '',
              fit: BoxFit.cover,
              loadingBuilder: (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[300], // 占位颜色
                );
              },
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) {
                return Container(
                  color: Colors.grey[400], // 错误占位颜色
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                );
              },
            ),
            // 渐变遮罩层
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            // 文字内容
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: titleWidth),
                    child: Text(
                      item.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if ((item.subTitle ?? '').isNotEmpty)
                    const SizedBox(
                      height: 5,
                    ), // 使用 SizedBox 分离元素而不是 Column spacing
                  if ((item.subTitle ?? '').isNotEmpty)
                    Text(
                      item.subTitle ?? "",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
