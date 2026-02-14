import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepPhone extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StepPhone({
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
          "Please enter your active mobile number. This number will be used for verification and important updates.",
          style: GoogleFonts.dmSans(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),

        // Phone input field
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: TextInputType.phone,
          style: GoogleFonts.dmSans(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Phone",
            labelStyle: GoogleFonts.dmSans(color: Colors.white),
            hintText: "Enter your phone number",
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
