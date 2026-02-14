import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendOtpButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const SendOtpButton({
    super.key,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff332D56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: Colors.black54,
        ),
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          "Send OTP",
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
