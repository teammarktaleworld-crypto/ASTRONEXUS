import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepPhone extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const StepPhone({
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
          "Please enter your active mobile number. This number will be used for verification and important updates.",
          style: GoogleFonts.dmSans(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // White phone input field with icon
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // bright background
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
            keyboardType: TextInputType.phone,
            style: GoogleFonts.dmSans(
              color: Colors.black87,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone, color: Colors.grey),
              hintText: "Enter your phone number",
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
