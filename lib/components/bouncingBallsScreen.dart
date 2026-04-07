import 'dart:math';

import 'package:flutter/cupertino.dart';

class BouncingBallsScreen extends StatefulWidget {
  @override
  _BouncingBallsScreenState createState() => _BouncingBallsScreenState();
}

class _BouncingBallsScreenState extends State<BouncingBallsScreen>
    with SingleTickerProviderStateMixin {
  static const double _minRadius = 20.0;
  static const double _maxRadius = 50.0;
  static const double _minSpeed = 0.5;
  static const double _maxSpeed = 3.0;
  static const Duration _animationDuration = Duration(days: 1);

  late AnimationController _controller;
  final Random _random = Random();
  final List<Ball> _balls = [];

  @override
  void initState() {
    super.initState();
    _initializeBalls();
    _initializeController();
  }

  void _initializeBalls() {
    final List<List<Color>> ballColorSets = [
      [Color.fromRGBO(255, 154, 158, 1), Color.fromRGBO(250, 208, 196, 1)],
      [Color.fromRGBO(132, 255, 176, 1), Color.fromRGBO(143, 211, 244, 1)],
      [Color.fromRGBO(43, 233, 123, 1), Color.fromRGBO(56, 249, 215, 1)],
      [Color.fromRGBO(255, 4, 68, 1), Color.fromRGBO(255, 184, 153, 1)],
      [Color.fromRGBO(248, 102, 0, 1), Color.fromRGBO(249, 212, 35, 1)],
      [Color.fromRGBO(252, 99, 118, 1), Color.fromRGBO(255, 154, 158, 1)],
      [Color.fromRGBO(232, 25, 139, 1), Color.fromRGBO(199, 234, 253, 1)],
    ];

    for (final colors in ballColorSets) {
      _balls.add(_createRandomBall(colors));
    }
  }

  void _initializeController() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
      setState(() {
        _updateBallsPosition();
      });
    });
    _controller.forward();
  }

  Ball _createRandomBall(List<Color> colors) {
    return Ball(
      radius: _minRadius + _random.nextDouble() * (_maxRadius - _minRadius),
      position: Offset.zero,
      velocity: Offset(
        (_minSpeed + _random.nextDouble() * (_maxSpeed - _minSpeed)) *
            (_random.nextBool() ? 1 : -1),
        (_minSpeed + _random.nextDouble() * (_maxSpeed - _minSpeed)) *
            (_random.nextBool() ? 1 : -1),
      ),
      colors: colors,
    );
  }

  void _updateBallsPosition() {
    for (var ball in _balls) {
      ball.updatePosition();
    }
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
        final Size screenSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        _updateBallsScreenSize(screenSize);

        return CustomPaint(painter: BallsPainter(_balls));
      },
    );
  }

  void _updateBallsScreenSize(Size screenSize) {
    for (var ball in _balls) {
      if (ball.screenSize == null) {
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
  }
}

class Ball {
  static const Alignment _gradientBegin = Alignment.topLeft;
  static const Alignment _gradientEnd = Alignment.bottomRight;
  static const List<double> _gradientStops = [0.0, 1.0];

  final double radius;
  final Gradient gradient;
  Offset position;
  Offset velocity;
  Size? screenSize;

  Ball({
    required this.radius,
    required this.position,
    required this.velocity,
    this.screenSize,
    List<Color>? colors,
  }) : gradient = _createGradient(colors);

  static Gradient _createGradient(List<Color>? colors) {
    if (colors == null || colors.isEmpty) {
      final Random random = Random();
      colors = [
        Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      ];
    }

    return LinearGradient(
      colors: colors,
      begin: _gradientBegin,
      end: _gradientEnd,
      stops: _gradientStops,
    );
  }

  void updatePosition() {
    if (screenSize == null) return;

    position += velocity;
    _checkBoundaries();
    _clampPosition();
  }

  void _checkBoundaries() {
    if (position.dx - radius <= 0 || position.dx + radius >= screenSize!.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy - radius <= 0 || position.dy + radius >= screenSize!.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }

  void _clampPosition() {
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
      _drawBall(canvas, ball);
    }
  }

  void _drawBall(Canvas canvas, Ball ball) {
    final Rect rect = Rect.fromCircle(
      center: ball.position,
      radius: ball.radius,
    );

    final Shader shader = ball.gradient.createShader(rect);
    final Paint paint = Paint()..shader = shader;
    canvas.drawCircle(ball.position, ball.radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
