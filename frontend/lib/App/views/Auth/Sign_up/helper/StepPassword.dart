import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepPassword extends StatelessWidget {
  final String password;
  final String confirmPassword;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmChanged;

  const StepPassword({
    super.key,
    required this.password,
    required this.confirmPassword,
    required this.onPasswordChanged,
    required this.onConfirmChanged, required TextEditingController passwordController, required TextEditingController confirmController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Explanatory paragraph
        Text(
          "Create a strong password to secure your account. Use at least 8 characters with a mix of letters, numbers, and symbols.",
          style: GoogleFonts.dmSans(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),

        // Password field
        TextFormField(
          initialValue: password,
          onChanged: onPasswordChanged,
          obscureText: true,
          style: GoogleFonts.dmSans(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Password",
            labelStyle: GoogleFonts.dmSans(color: Colors.white),
            hintText: "Enter password",
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
        const SizedBox(height: 16),

        // Confirm password field
        TextFormField(
          initialValue: confirmPassword,
          onChanged: onConfirmChanged,
          obscureText: true,
          style: GoogleFonts.dmSans(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Confirm Password",
            labelStyle: GoogleFonts.dmSans(color: Colors.white),
            hintText: "Re-enter password",
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
