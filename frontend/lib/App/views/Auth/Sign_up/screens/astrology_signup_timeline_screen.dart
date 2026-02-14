import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../dash/DashboardScreen.dart';

import '../helper/step_name.dart';
import '../helper/step_email.dart';
import '../helper/step_phone.dart';
import '../helper/StepPassword.dart';
import '../helper/step_birth_date.dart';
import '../helper/step_birth_time.dart';
import '../helper/step_birth_place.dart';

import '../model/SignUp_Data_Model.dart';
import '../controller/controller.dart';

import '../widgets/signup_app_bar.dart';
import '../widgets/signup_background.dart';
import '../widgets/signup_card.dart';
import '../widgets/signup_stepper.dart';

class AstrologySignupTimeline extends StatefulWidget {
  const AstrologySignupTimeline({super.key});

  @override
  State<AstrologySignupTimeline> createState() =>
      _AstrologySignupTimelineState();
}

class _AstrologySignupTimelineState extends State<AstrologySignupTimeline> {
  int step = 0; // current step
  final SignupController controller = SignupController();
  bool _isSigningUp = false;


  // Controllers for TextFields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmController;
  late TextEditingController dobController;
  late TextEditingController placeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: controller.model.name);
    emailController = TextEditingController(text: controller.model.email);
    phoneController = TextEditingController(text: controller.model.phone);
    passwordController = TextEditingController(text: controller.model.password);
    confirmController = TextEditingController(text: controller.model.confirmPassword);
    dobController = TextEditingController(text: controller.model.dateOfBirth);
    placeController = TextEditingController(text: controller.model.place);

  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    dobController.dispose();
    placeController.dispose();
    super.dispose();
  }

  // ---------------- STEP NAVIGATION ----------------
  void nextStep() {
    if (step < 6) setState(() => step++);
  }

  void previousStep() {
    if (step > 0) setState(() => step--);
  }

  // ---------------- STEP VALIDATION ----------------
  bool validateStep() {
    final model = controller.model;

    switch (step) {
      case 0:
        return model.name.trim().isNotEmpty;
      case 1:
        return model.email.trim().isNotEmpty && model.email.contains("@");
      case 2:
        final phone = model.phone.replaceAll(' ', '');
        return phone.isNotEmpty && phone.length >= 10;
      case 3:
        return model.password.isNotEmpty &&
            model.confirmPassword.isNotEmpty &&
            model.password == model.confirmPassword;
      case 4:
        return model.dateOfBirth.trim().isNotEmpty;
      case 5:
        return model.hour >= 0 && model.minute >= 0;
      case 6:
        return model.place.trim().isNotEmpty;
      default:
        return false;
    }
  }


  // ---------------- SUBMIT SIGNUP ----------------
  Future<void> submitSignup() async {
    if (_isSigningUp) return; // 🚫 Block multiple taps

    setState(() => _isSigningUp = true);

    try {
      final astrologyData = await controller.submitSignup();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            zodiacSign: astrologyData['zodiacSign'] ?? "",
            daily: astrologyData['daily'],
            weekly: astrologyData['weekly'],
            monthly: astrologyData['monthly'],
          ),
        ),
      );
    }

    on TimeoutException {
      _showError("Server is busy. Please wait and try again.");
    }

    catch (e) {
      _showError(e.toString().replaceAll("Exception: ", ""));
    }

    finally {
      //  Small delay prevents instant re-click spam after failure
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _isSigningUp = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // removes old one if visible
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.dmSans(color: Colors.black)),
          backgroundColor: Colors.white70,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }





  // ---------------- STEP CONTENT ----------------
  Widget _buildStep() {
    switch (step) {
      case 0:
        return StepName(
          controller: nameController,
          onChanged: controller.setName,
          value: '',
        );

      case 1:
        return StepEmail(
          controller: emailController,
          onChanged: controller.setEmail,
          value: '',
        );

      case 2:
        return StepPhone(
          controller: phoneController,
          onChanged: controller.setPhone,
          value: '',
        );

      case 3:
        return StepPassword(
          passwordController: passwordController,
          confirmController: confirmController,
          onPasswordChanged: controller.setPassword,
          onConfirmChanged: controller.setConfirmPassword,
          password: '',
          confirmPassword: '',
        );

      case 4:
        return StepBirthDate(
          controller: dobController,
          onChanged: controller.setDateOfBirth,
          value: '',
        );

      case 5:
        return StepBirthTime(
          model: controller.model, // IMPORTANT
          onChanged: () => setState(() {}),
        );

      case 6:
        return StepBirthPlace(
          controller: placeController,
          onChanged: controller.setPlace,
          value: '',
        );

      default:
        return const SizedBox();
    }
  }



  // ---------------- NEXT BUTTON ----------------
  Widget _nextButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isSigningUp
              ? null // disable button while signup is in progress
              : () {
            if (!validateStep()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  width: 350,
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  content: Center(child: Text("Please complete this step correctly", style: TextStyle(color: Colors.red))),
                  backgroundColor: Colors.white,
                ),
              );
              return;
            }

            if (step == 6) {
              // ✅ Show loading only for signup (last step)
              submitSignup();
            } else {
              nextStep();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF201E43),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: step == 6 && _isSigningUp
              ? LoadingAnimationWidget.fourRotatingDots(
            color: Colors.white70,
            size: 24,
          )
              : Text(
            step == 6 ? "Done" : "Next",
            style: GoogleFonts.dmSans(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B1E),
      appBar: SignupAppBar(step: step, onBack: previousStep),
      body: Stack(
        children: [
          const SignupBackground(),
          Column(
            children: [
              const SizedBox(height: 50),
              SignupStepper(
                step: step,
                totalSteps: 7,
                onStepChanged: (i) => setState(() => step = i),
              ),
              const SizedBox(height: 20),
              Expanded(child: SignupCard(child: _buildStep())),
              _nextButton(),
            ],
          ),
        ],
      ),
    );
  }
}
