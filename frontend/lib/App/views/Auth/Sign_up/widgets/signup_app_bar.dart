import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int step;
  final VoidCallback onBack;

  const SignupAppBar({
    super.key,
    required this.step,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xff18122B)
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          // Show back button only after step 0
          leading: step > 0
              ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack,
          )
              : const SizedBox(),

          title: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                _title(step),
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                "Cosmic Step ${step + 1} / 7",
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _title(int step) {
    const titles = [
      "Enter Your Name",
      "Enter Your Email",
      "Enter Your Phone",
      "Set Password",
      "Enter Birth Date",
      "Select Time of Birth",
      "Enter Place of Birth",
    ];

    if (step < 0 || step >= titles.length) return "";
    return titles[step];
  }
}
