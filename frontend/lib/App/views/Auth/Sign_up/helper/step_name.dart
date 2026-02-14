import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../sharedWidgets/common_input.dart';
import '../../sharedWidgets/step_image.dart';


class StepName extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StepName({
    super.key,
    required this.value,
    required this.onChanged, required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepImage(path: "assets/images/birth_one.png"),
        Text(
          "Your name carries vibrational energy. It forms the identity through which the universe recognizes your cosmic blueprint.",
          style: GoogleFonts.dmSans(color: Colors.white54),
        ),
        const SizedBox(height: 20),
        CommonInput(
          controller: controller,
          hint: "Full Name",
          icon: Icons.person,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
