import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../sharedWidgets/common_input.dart';
import '../../sharedWidgets/step_image.dart';

class StepBirthPlace extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StepBirthPlace({
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
        const StepImage(path: "assets/images/place.png"),
        Text(
          "Your birthplace anchors planetary angles to Earth’s coordinates.",
          style: GoogleFonts.dmSans(color: Colors.white54),
        ),
        const SizedBox(height: 20),
        CommonInput(
          controller: controller,
          hint: "Place of Birth",
          icon: Icons.location_on,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
