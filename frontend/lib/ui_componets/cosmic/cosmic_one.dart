import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmoothShootingStars extends StatefulWidget {
  const SmoothShootingStars({super.key});

  @override
  State<SmoothShootingStars> createState() => _SmoothShootingStarsState();
}

class _SmoothShootingStarsState extends State<SmoothShootingStars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ShootingStar> stars = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(() {
      _spawnStars();
      setState(() {});
    });

    _controller.repeat();
  }

  void _spawnStars() {
    // Rare spawn = cinematic feel
    if (Random().nextDouble() > 0.985 && stars.length < 3) {
      stars.add(ShootingStar.create());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SmoothShootingStarPainter(stars),
    );
  }
}

class ShootingStar {
  late Offset start;
  late Offset end;
  late double progress;
  late double speed;
  late double opacity;
  late double length;

  ShootingStar._();

  factory ShootingStar.create() {
    final r = Random();

    // Start slightly off-screen (left/top)
    final startX = -0.2;
    final startY = r.nextDouble() * 0.4;

    final star = ShootingStar._();
    star.start = Offset(startX, startY);

    // End far bottom-right
    star.end = Offset(
      1.2,
      startY + 0.8,
    );

    star.progress = 0;
    star.speed = r.nextDouble() * 0.0018 + 0.0012; // smooth & slow
    star.length = r.nextDouble() * 20 + 20;
    star.opacity = 0;
    return star;
  }
}

class SmoothShootingStarPainter extends CustomPainter {
  final List<ShootingStar> stars;
  SmoothShootingStarPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    stars.removeWhere((s) => s.progress >= 1);

    for (final s in stars) {
      s.progress += s.speed;

      final t = s.progress.clamp(0.0, 1.0); // clamp to [0,1]

      // Fade in / out
      if (t < 0.2) {
        s.opacity = t * 5;
      } else if (t > 0.8) {
        s.opacity = (1 - t) * 5;
      } else {
        s.opacity = 1;
      }

      final position = Offset.lerp(
        Offset(s.start.dx * size.width, s.start.dy * size.height),
        Offset(s.end.dx * size.width, s.end.dy * size.height),
        Curves.easeOutCubic.transform(t), // safe now
      )!;

      final tail = Offset(
        position.dx - s.length,
        position.dy - s.length * 0.7,
      );

      final paint = Paint()
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Colors.white.withOpacity(s.opacity),
            Colors.white.withOpacity(0),
          ],
        ).createShader(Rect.fromPoints(position, tail));

      canvas.drawLine(position, tail, paint);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
