import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepEmail extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StepEmail({
    super.key,
    required this.value,
    required this.onChanged, required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Explanatory paragraph
        Text(
          "Please enter your active email address. We will use this email to send important updates, reports, and notifications.",
          style: GoogleFonts.dmSans(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),

        // Email input field
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.dmSans(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Email",
            labelStyle: GoogleFonts.dmSans(color: Colors.white),
            hintText: "example@domain.com",
            hintStyle: GoogleFonts.dmSans(color: Colors.white54),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
