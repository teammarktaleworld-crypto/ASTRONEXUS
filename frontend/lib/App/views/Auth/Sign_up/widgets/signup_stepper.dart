import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupStepper extends StatelessWidget {
  final int step;
  final ValueChanged<int> onStepChanged;
  final int totalSteps;

  const SignupStepper({
    super.key,
    required this.step,
    required this.onStepChanged,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: EasyStepper(
        activeStep: step,
        enableStepTapping: true,
        activeStepBackgroundColor: Colors.white,
        onStepReached: onStepChanged,
        finishedStepIconColor: Colors.black,

        finishedStepBackgroundColor: Colors.white,
        lineStyle: const LineStyle(
          lineThickness: 2,
          lineLength: 40,
          activeLineColor: Colors.green,
          finishedLineColor: Colors.white,
          unreachedLineColor: Colors.white,

        ),
        titleTextStyle: GoogleFonts.dmSans(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        steps: const [
          EasyStep(icon: Icon(Icons.person, color: Colors.white), title: "Name"),
          EasyStep(icon: Icon(Icons.email, color: Colors.white), title: "Email"),
          EasyStep(icon: Icon(Icons.phone, color: Colors.white), title: "Phone"),
          EasyStep(icon: Icon(Icons.lock, color: Colors.white), title: "Password"),
          EasyStep(icon: Icon(Icons.calendar_today, color: Colors.white), title: "Birth Date"),
          EasyStep(icon: Icon(Icons.access_time, color: Colors.white), title: "Time"),
          EasyStep(icon: Icon(Icons.location_on, color: Colors.white), title: "Place"),
        ],
      ),
    );
  }
}
