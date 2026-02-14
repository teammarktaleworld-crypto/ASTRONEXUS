import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../../ui_componets/glass/glass_card.dart';
import '../controller/signup_controller.dart';
import '../helper/signup_helpers.dart';
import '../widgets/signup_widgets.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int step = 1;
  bool loading = false;
  bool obscurePwd = true;
  bool obscureConfirmPwd = true;

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

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
        child: glassCard(
          child: Column(
            children: [
              Text(
                step == 1 ? "Create Account" : "Secure Account",
                style: GoogleFonts.dmSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                step == 1
                    ? "Tell us about yourself"
                    : "Set your password",
                style: GoogleFonts.dmSans(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 26),

              if (step == 1) _stepOne(),
              if (step == 2) _stepTwo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepOne() {
    return Column(
      children: [
        TextField(
          controller: name,
          decoration: signupInput("Full Name", Icons.person_outline),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: email,
          decoration: signupInput("Email Address", Icons.email_outlined),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: phone,
          decoration: signupInput("Phone Number", Icons.call_outlined),
        ),
        const SizedBox(height: 22),

        PrimaryAuthButton(
          text: "Next",
          onTap: () => setState(() => step = 2),
        ),

        const SizedBox(height: 16),
        const LoginText(),
      ],
    );
  }

  Widget _stepTwo() {
    return Column(
      children: [
        TextField(
          controller: password,
          obscureText: obscurePwd,
          decoration: signupInput("Password", Icons.lock_outline).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                obscurePwd ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => obscurePwd = !obscurePwd),
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: confirmPassword,
          obscureText: obscureConfirmPwd,
          decoration:
          signupInput("Confirm Password", Icons.lock_outline).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPwd
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () => setState(
                    () => obscureConfirmPwd = !obscureConfirmPwd,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),

        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => setState(() => step = 1),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PrimaryAuthButton(
                text: "Create Account",
                loading: loading,
                onTap: () => SignupController.signup(
                  context: context,
                  name: name,
                  email: email,
                  phone: phone,
                  password: password,
                  confirmPassword: confirmPassword,
                  onStart: () => setState(() => loading = true),
                  onStop: () => setState(() => loading = false),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _background() {
    return  Container(
      decoration: BoxDecoration(
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
