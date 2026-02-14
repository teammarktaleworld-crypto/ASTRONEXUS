import 'package:astro_tale/App/views/Auth/Login_email/helper/signin_helpers.dart';
import 'package:astro_tale/App/views/Auth/Sign_up/screens/astrology_signup_timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:astro_tale/App/views/Auth/terms%20and%20condition/termsandconditions.dart';

import '../../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../../ui_componets/glass/glass_card.dart';
import '../../Login_email/screens/signin_screen.dart';
import '../controller/login_controller.dart';
import '../widgets/phone_input.dart';
import '../widgets/password_input.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Scaffold(
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
              child: Consumer<LoginController>(
                builder: (context, controller, _) {
                  return Column(
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
                        "Enter your phone and password",
                        style: GoogleFonts.dmSans(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 28),

                      /// 📱 Phone Field
                      PhoneInput(controller: phoneController),
                      const SizedBox(height: 16),

                      /// 🔒 Password Field
                      PasswordInput(controller: passwordController),
                      const SizedBox(height: 24),

                      /// ❌ Error Message
                      if (controller.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            controller.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      /// 🔑 Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () {
                            controller.login(
                              context,
                              phoneController.text.trim(),
                              passwordController.text.trim(),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff332D56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                          ),
                          child: controller.isLoading
                              ? Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                              color: Colors.white,
                              size: 40,
                            ),
                          )

                              : Text(
                            "LOGIN",
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      orDivider(),
                      const SizedBox(height: 16),

                      /// 📧 Email Login
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

                      /// 🆕 Signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don’t have an account?",
                              style: GoogleFonts.dmSans(color: Colors.white70)),
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
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TermsAndConditions()),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff050B1E),
            Color(0xff393053),
            Color(0xff050B1E),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
