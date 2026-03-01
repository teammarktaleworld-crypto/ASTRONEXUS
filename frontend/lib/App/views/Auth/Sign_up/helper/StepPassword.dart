import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepPassword extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmChanged;

  const StepPassword({
    super.key,
    required this.passwordController,
    required this.confirmController,
    required this.onPasswordChanged,
    required this.onConfirmChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Explanatory text
        Text(
          "Create a strong password to secure your account. Use at least 8 characters with a mix of letters, numbers, and symbols.",
          style: GoogleFonts.dmSans(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // Password field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
            controller: passwordController,
            onChanged: onPasswordChanged,
            obscureText: true,
            style: GoogleFonts.dmSans(
              color: Colors.black87,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
              hintText: "Enter password",
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
        const SizedBox(height: 16),

        // Confirm password field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
            controller: confirmController,
            onChanged: onConfirmChanged,
            obscureText: true,
            style: GoogleFonts.dmSans(
              color: Colors.black87,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
              hintText: "Re-enter password",
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
