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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: EasyStepper(
        activeStep: step,
        enableStepTapping: true,
        activeStepBackgroundColor: const Color(0xFF4C5BD4), // gradient-like color
        finishedStepBackgroundColor: const Color(0xFF7C9CFF),
        finishedStepIconColor: Colors.white,
        activeStepIconColor: Colors.white,
        unreachedStepIconColor: Colors.grey[400],
        unreachedStepBackgroundColor: Colors.grey[700],
        lineStyle: LineStyle(
          activeLineColor: const Color(0xFF4C5BD4),
          finishedLineColor: const Color(0xFF7C9CFF),
          unreachedLineColor: Colors.grey[500]!,
          lineThickness: 3,
          lineLength: 50,
        ),
        stepBorderRadius: 12, // rounder steps
        stepRadius: 28,
        onStepReached: onStepChanged,
        titleTextStyle: GoogleFonts.dmSans(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        steps: const [
          EasyStep(
            icon: Icon(Icons.person, color: Colors.white),
            title: "Name",
          ),
          EasyStep(
            icon: Icon(Icons.email, color: Colors.white),
            title: "Email",
          ),
          EasyStep(
            icon: Icon(Icons.phone, color: Colors.white),
            title: "Phone",
          ),
          EasyStep(
            icon: Icon(Icons.lock, color: Colors.white),
            title: "Password",
          ),
          EasyStep(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            title: "Birth Date",
          ),
          EasyStep(
            icon: Icon(Icons.access_time, color: Colors.white),
            title: "Time",
          ),
          EasyStep(
            icon: Icon(Icons.location_on, color: Colors.white),
            title: "Place",
          ),
        ],
      ),
    );
  }
}
