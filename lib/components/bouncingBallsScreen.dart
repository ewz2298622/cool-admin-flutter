import 'dart:math';

import 'package:flutter/cupertino.dart';

class BouncingBallsScreen extends StatefulWidget {
  @override
  _BouncingBallsScreenState createState() => _BouncingBallsScreenState();
}

class _BouncingBallsScreenState extends State<BouncingBallsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<Ball> _balls = [];

  @override
  void initState() {
    super.initState();
    _balls.add(
      _createRandomBall([
        Color.fromRGBO(255, 154, 158, 1),
        Color.fromRGBO(250, 208, 196, 1),
      ]),
    );
    _balls.add(
      _createRandomBall([
        Color.fromRGBO(132, 255, 176, 1),
        Color.fromRGBO(143, 211, 244, 1),
      ]),
    );
    //020 New LifeGet .PNG#43e97b→#38f9d7
    _balls.add(
      _createRandomBall([
        Color.fromRGBO(43, 233, 123, 1),
        Color.fromRGBO(56, 249, 215, 1),
      ]),
    );

    //#ff0844→#ffb199
    _balls.add(
      _createRandomBall([
        Color.fromRGBO(255, 4, 68, 1),
        Color.fromRGBO(255, 184, 153, 1),
      ]),
    );
    // //#f83600→#f9d423
    _balls.add(
      _createRandomBall([
        Color.fromRGBO(248, 102, 0, 1),
        Color.fromRGBO(249, 212, 35, 1),
      ]),
    );
    //#fc6076→#ff9a44
    _balls.add(
      _createRandomBall([
        Color.fromRGBO(252, 99, 118, 1),
        Color.fromRGBO(255, 154, 158, 1),
      ]),
    );
    //#e8198b→#c7eafd
    _balls.add(
      _createRandomBall([
        Color.fromRGBO(232, 25, 139, 1),
        Color.fromRGBO(199, 234, 253, 1),
      ]),
    );
    _controller = AnimationController(
      vsync: this,
      duration: Duration(days: 1), // 长时间运行
    )..addListener(() {
      setState(() {
        // 更新每个球的位置
        for (var ball in _balls) {
          ball.updatePosition();
        }
      });
    });
    _controller.forward();
  }

  Ball _createRandomBall([List<Color>? colors]) {
    const double minRadius = 20.0;
    const double maxRadius = 50.0;
    const double minSpeed = 0.5;
    const double maxSpeed = 3.0;

    return Ball(
      radius: minRadius + _random.nextDouble() * (maxRadius - minRadius),
      position: Offset.zero,
      velocity: Offset(
        (minSpeed + _random.nextDouble() * (maxSpeed - minSpeed)) *
            (_random.nextBool() ? 1 : -1),
        (minSpeed + _random.nextDouble() * (maxSpeed - minSpeed)) *
            (_random.nextBool() ? 1 : -1),
      ),
      colors: colors, // 可选参数，如果未传入则为 null
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 初始化或更新球的边界
        final Size screenSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        for (var ball in _balls) {
          if (ball.screenSize == null) {
            // 第一次布局时设置初始随机位置
            ball.screenSize = screenSize;
            ball.position = Offset(
              ball.radius +
                  _random.nextDouble() * (screenSize.width - 2 * ball.radius),
              ball.radius +
                  _random.nextDouble() * (screenSize.height - 2 * ball.radius),
            );
          } else {
            ball.screenSize = screenSize;
          }
        }

        return CustomPaint(painter: BallsPainter(_balls));
      },
    );
  }
}

class Ball {
  final double radius;
  final Gradient gradient; // 使用 Gradient 替代 Color
  Offset position;
  Offset velocity;
  Size? screenSize;

  Ball({
    required this.radius,
    required this.position,
    required this.velocity,
    this.screenSize,
    List<Color>? colors, // 添加可选颜色参数
  }) : gradient = _createGradient(colors); // 初始化渐变

  // 创建径向渐变
  static Gradient _createGradient(List<Color>? colors) {
    if (colors == null || colors.isEmpty) {
      // 如果没有提供颜色，则使用随机颜色
      final Random random = Random();
      colors = [
        Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      ];
    }

    return LinearGradient(
      colors: [
        colors[0],
        colors[1], // 将透明度从 0.0 调整为 0.5
      ],
      begin: Alignment.topLeft,
      stops: [0.0, 1.0], // 可以添加此行明确指定颜色过渡位置
    );
  }

  void updatePosition() {
    if (screenSize == null) return;

    position += velocity;

    // 边界检查并反弹
    if (position.dx - radius <= 0 ||
        position.dx + radius >= screenSize!.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy - radius <= 0 ||
        position.dy + radius >= screenSize!.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }

    position = Offset(
      position.dx.clamp(radius, screenSize!.width - radius),
      position.dy.clamp(radius, screenSize!.height - radius),
    );
  }
}

class BallsPainter extends CustomPainter {
  final List<Ball> balls;

  BallsPainter(this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    for (var ball in balls) {
      final Rect rect = Rect.fromCircle(
        center: ball.position,
        radius: ball.radius,
      );

      // 创建渐变着色器
      final Shader shader = ball.gradient.createShader(rect);

      final Paint paint = Paint()..shader = shader;
      canvas.drawCircle(ball.position, ball.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
