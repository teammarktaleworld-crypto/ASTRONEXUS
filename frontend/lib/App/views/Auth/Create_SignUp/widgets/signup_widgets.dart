import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Login_email/screens/signin_screen.dart';

class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onTap;

  const PrimaryAuthButton({
    super.key,
    required this.text,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff393053),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        )
            : Text(
          text,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LoginText extends StatelessWidget {
  const LoginText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.dmSans(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignIn()),
          ),
          child: Text(
            "Login",
            style: GoogleFonts.dmSans(
              color: const Color(0xFFDBC33F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
