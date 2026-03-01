import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepEmail extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const StepEmail({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Explanatory text
        Text(
          "Please enter your active email address. We will use this email to send important updates, reports, and notifications.",
          style: GoogleFonts.dmSans(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // White email input field with icon
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // white background
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.dmSans(
              color: Colors.black87,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email, color: Colors.grey),
              hintText: "example@domain.com",
              hintStyle: GoogleFonts.dmSans(
                color: Colors.black87,
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
