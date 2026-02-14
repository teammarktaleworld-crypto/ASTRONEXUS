import 'package:astro_tale/App/views/Auth/Sign_up/screens/astrology_signup_timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_mobile_field/intl_mobile_field.dart';
import 'package:astro_tale/App/views/Auth/terms%20and%20condition/termsandconditions.dart';

import '../../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../../ui_componets/glass/glass_card.dart';
import '../../Create_SignUp/screens/signup_screen.dart';
import '../../Login_email/screens/signin_screen.dart';
import '../controller/phone_login_controller.dart';
import '../helper/phone_login_helpers.dart';
import '../widgets/phone_login_widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? phoneNumber;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background(),
          const Positioned.fill(child: SmoothShootingStars()),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),
          _content(),
        ],
      ),
    );
  }

  Widget _content() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Image.asset("assets/images/logo.png", height: 150),
            Text(
              "Discover the stars within you",
              style: GoogleFonts.dmSans(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),

            glassCard(
              child: Column(
                children: [
                  Text(
                    "Login with Phone",
                    style: GoogleFonts.dmSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "OTP verification for secure login",
                    style: GoogleFonts.dmSans(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),

                  intlPhoneInput(
                    initialCountryCode: 'IN',
                    onChanged: (value) => phoneNumber = value,
                  ),




                  const SizedBox(height: 16),

                  SendOtpButton(
                    loading: loading,
                    onTap: () => PhoneLoginController.sendOtp(
                      context: context,
                      phoneNumber: phoneNumber,
                      onStart: () => setState(() => loading = true),
                      onStop: () => setState(() => loading = false),
                    ),
                  ),

                  const SizedBox(height: 16),
                  orDivider(),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignIn()),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Login with Email",
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have an account?",
                          style:
                          GoogleFonts.dmSans(color: Colors.white70)),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AstrologySignupTimeline()),
                        ),
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
                ],
              ),
            ),

            const SizedBox(height: 30),

            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const TermsAndConditions()),
              ),
              child: Text(
                "Terms And Conditions",
                style: GoogleFonts.dmSans(
                  color: const Color(0xFFDBC33F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff050B1E),
            // Color(0xff1C4D8D),
            // Color(0xff0F2854),
            Color(0xff393053),
            Color(0xff050B1E),          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
