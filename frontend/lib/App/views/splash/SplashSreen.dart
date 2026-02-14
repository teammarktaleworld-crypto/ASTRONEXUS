import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../services/api_services/refresh_token.dart';
import '../../Model/Horoscope/horoscope_model.dart';
import '../../controller/Auth_Controller.dart';
import '../Auth/Login_phone/screens/phone_login_screen.dart';
import '../Auth/login_phone__pass/screen/login_phone_screen.dart';
import '../dash/DashboardScreen.dart';
import 'package:astro_tale/App/views/onboard/Screens/onboarding.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();

    final bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
    String? token = prefs.getString('auth_token');

    // 1️⃣ Initialize AuthController
    AuthController.token = token ?? "";
    AuthController.refreshToken = prefs.getString('refresh_token') ?? "";
    AuthController.userId = prefs.getString('userId') ?? "";
    AuthController.role = prefs.getString('role') ?? "";

    // 2️⃣ Refresh token if expired
    if (token != null && JwtDecoder.isExpired(token)) {
      final refreshToken = AuthController.refreshToken;
      if (refreshToken.isNotEmpty) {
        try {
          final newToken = await APIService.refreshToken(refreshToken);
          if (newToken != null) {
            token = newToken;
            AuthController.token = newToken;
            await prefs.setString('auth_token', newToken);
          } else {
            token = null; // refresh failed
          }
        } catch (_) {
          token = null;
        }
      } else {
        token = null;
      }
    }

    if (!mounted) return;

    if (token != null) {
      // ✅ Logged in: load dashboard
      final zodiacSign = prefs.getString('zodiacSign') ?? "";
      final daily = HoroscopeData.fromJson(jsonDecode(prefs.getString('daily') ?? '{}'));
      final weekly = HoroscopeData.fromJson(jsonDecode(prefs.getString('weekly') ?? '{}'));
      final monthly = HoroscopeData.fromJson(jsonDecode(prefs.getString('monthly') ?? '{}'));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            zodiacSign: zodiacSign,
            daily: daily,
            weekly: weekly,
            monthly: monthly,
          ),
        ),
      );
    } else if (!onboardingSeen) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPhoneScreen()));
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff050B1E),
              Color(0xff1B1A3A),
              Color(0xff050B1E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Soft glow
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff1B1A3A),
                          blurRadius: 80,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  // Logo
                  Image.asset(
                    "assets/images/logo.png",
                    width: 140,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
