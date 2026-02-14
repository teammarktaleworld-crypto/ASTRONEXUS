import 'package:flutter/material.dart';

import '../../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../../ui_componets/cosmic/cosmic_two.dart';

class SignupBackground extends StatelessWidget {
  const SignupBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff18122B),
                // Color(0xff1C4D8D),
                // Color(0xff0F2854),
                Color(0xff393053),


                Color(0xff18122B),

              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        const Positioned.fill(child: SmoothShootingStars()),
        Container(color: Colors.black.withOpacity(0.55)),
      ],
    );
  }
}
