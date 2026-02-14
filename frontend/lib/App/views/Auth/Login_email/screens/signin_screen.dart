import 'package:astro_tale/App/views/Auth/Forget_Password/forgetpassword.dart';
import 'package:astro_tale/App/views/Auth/Sign_up/screens/astrology_signup_timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astro_tale/ui_componets/glass/glass_card.dart';

import '../../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../terms and condition/termsandconditions.dart';
import '../controller/signin_controller.dart';
import '../helper/signin_helpers.dart';
import '../widgets/signin_widgets.dart';
import '../../Create_SignUp/screens/signup_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool obscure = true;
  bool remember = false;
  bool loading = false;

  final email = TextEditingController();
  final password = TextEditingController();

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
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            // Logo
            Image.asset(
              "assets/images/logo.png",
              height: 120,
            ),
            const SizedBox(height: 12),
            Text(
              "Discover the stars within you",
              style: GoogleFonts.dmSans(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            glassCard(
              child: Column(
                children: [
                  Text(
                    "Sign In",
                    style: GoogleFonts.dmSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Continue your cosmic journey",
                    style: GoogleFonts.dmSans(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email
                  TextField(
                    controller: email,
                    decoration: authInput("Email", Icons.person),
                  ),
                  const SizedBox(height: 14),

                  // Password
                  TextField(
                    controller: password,
                    obscureText: obscure,
                    decoration: authInput("Password", Icons.password_sharp).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => obscure = !obscure),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: remember,
                            onChanged: (v) => setState(() => remember = v!),
                          ),
                          const Text(
                            "Remember me",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPassword(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Login Button
                  LoginButton(
                    loading: loading,
                    onTap: () => SignInController.login(
                      context: context,
                      email: email,
                      password: password,
                      rememberMe: remember,
                      onStart: () => setState(() => loading = true),
                      onStop: () => setState(() => loading = false),
                    ),
                  ),

                  const SizedBox(height: 16),
                  orDivider(),
                  const SizedBox(height: 16),

                  // Outlined Button for alternate login (like phone login)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Sign in with Phone",
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff050B1E),
            // Color(0xff1C4D8D),
            // Color(0xff0F2854),
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
