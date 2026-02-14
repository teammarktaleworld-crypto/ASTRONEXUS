import 'package:astro_tale/App/views/Auth/OTP/otpScreen.dart';
import 'package:astro_tale/App/views/Auth/terms%20and%20condition/termsandconditions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Create_SignUp/screens/signup_screen.dart';
import '../Login_email/screens/signin_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => OTPVerification(phoneNumber: _,)),
    // );
  }

  InputDecoration inputStyle(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54),
      hintStyle: GoogleFonts.dmSans(color: Colors.black87),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF585023), width: 1.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF585023), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Background
          Positioned.fill(
            child: Image.asset("assets/images/bg.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo2.png",
                    height: 100,
                    width: 300,
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      children: const [
                        TextSpan(text: "Recover your "),
                        TextSpan(
                          text: "Account",
                          style: TextStyle(
                            color: Color(0xFFDBC33F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🔲 Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xff1E1E1E),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Forget Password",
                          style: GoogleFonts.dmSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Enter your phone number to receive OTP",
                          style: GoogleFonts.dmSans(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 📱 Phone Field
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: inputStyle(
                            "Phone Number",
                            Icons.phone_android,
                          ).copyWith(
                            counterText: "",
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 12),
                                const Icon(Icons.phone_android, color: Colors.black54),
                                const SizedBox(width: 8),
                                Text("+91",
                                    style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 🔘 Send OTP Button
                        SizedBox(
                          width: 300,
                          height: 52,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF916DBA), Color(0xFF413154)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFDBC33F),
                                width: 1.6,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : sendOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                              ),
                              child: _isLoading
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
                          ),
                        ),
                        const SizedBox(height: 20),

                        // OR Divider
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Colors.white54)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text("OR", style: GoogleFonts.dmSans(color: Colors.white54)),
                            ),
                            const Expanded(child: Divider(color: Colors.white54)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Email Login Button
                        SizedBox(
                          width: 300,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignIn()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              "Login with Email",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Signup Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don’t have an account?", style: GoogleFonts.dmSans(color: Colors.white70)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => SignUp()),
                                );
                              },
                              child: Text(
                                "Sign up",
                                style: GoogleFonts.dmSans(
                                  color: const Color(0xFFDBC33F),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Terms & Conditions
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TermsAndConditions()),
                            );
                          },
                          child: Text(
                            "Terms and Conditions",
                            style: GoogleFonts.dmSans(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
