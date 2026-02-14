import 'package:flutter/cupertino.dart';

import '../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../Home/Screens/HomeScreen.dart';

class CosmicBackground extends StatelessWidget {
  final AnimationController controller;
  final FallingStarPainter? painter;

  const CosmicBackground({
    super.key,
    required this.controller,
    required this.painter,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff050B1E),
                // Color(0xff1C4D8D),
                // Color(0xff0F2854),
                Color(0xff393053),
                Color(0xff050B1E),

              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned.fill(child: SmoothShootingStars()),
        // AnimatedBuilder(
        //   animation: controller,
        //   builder: (_, __) {
        //     if (painter == null) return const SizedBox.shrink();
        //     return CustomPaint(
        //       size: size,
        //       painter: FallingStarPainter(
        //         controller.value,
        //         stars: painter!.stars,
        //         sizes: painter!.sizes,
        //         speeds: painter!.speeds,
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
