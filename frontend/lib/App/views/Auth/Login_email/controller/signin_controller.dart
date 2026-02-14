import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../helper/Astrology_flow_helper.dart';
import '../../../../../services/API/APIservice.dart';
import '../../../../Model/Horoscope/horoscope_model.dart';
import '../../../../controller/Auth_Controller.dart';
import '../../../dash/DashboardScreen.dart';

class SignInController {
  /// Logs in the user and fetches astrology dashboard data
  static Future<void> login({
    required BuildContext context,
    required TextEditingController email,
    required TextEditingController password,
    required bool rememberMe,
    required VoidCallback onStart,
    required VoidCallback onStop,
  }) async {
    // ✅ Validate input
    if (email.text.isEmpty || password.text.isEmpty) {
      _snack(context, "Fill all fields");
      return;
    }

    onStart();

    try {
      // 🔹 Send login request
      final res = await http.post(
        Uri.parse("$baseurl/user/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.text.trim(),
          "password": password.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);
      debugPrint("LOGIN RESPONSE => $data");

      if (res.statusCode == 200 && data["token"] != null) {
        final prefs = await SharedPreferences.getInstance();

        final String token = data["token"];
        final String refreshToken = data["refreshToken"] ?? "";

        final Map<String, dynamic> user = data["user"] ?? {};
        final String userId = user["_id"] ?? "";
        final String role = user["role"] ?? "";

        // ✅ Save auth info
        await prefs.setString("auth_token", token);
        await prefs.setString("refresh_token", refreshToken);
        await prefs.setString("userName", user["name"] ?? "");
        await prefs.setString("userEmail", user["email"] ?? "");
        await prefs.setString("userPhone", user["phone"] ?? "");
        await prefs.setString("userAvatar", user["avatar"] ?? "");
        await prefs.setString("userId", userId);
        await prefs.setString("role", role);
        await prefs.setBool("isLoggedIn", true);

        AuthController.token = token;

        // ✅ ASTROLOGY FLOW: process DOB & fetch dashboard
        final dobString = user["astrologyProfile"]?["dateOfBirth"];
        final gender = user["astrologyProfile"]?["gender"] ?? "male";
        final place = user["astrologyProfile"]?["placeOfBirth"] ?? "Unknown";
        final hour = user["astrologyProfile"]?["birthHour"] ?? 0;
        final minute = user["astrologyProfile"]?["birthMinute"] ?? 0;
        final isAM = user["astrologyProfile"]?["isAM"] ?? true;

        if (dobString != null) {
          final dob = DateTime.parse(dobString);

          final astroData = await AstrologyFlowHelper.prepareDashboardData(
            dob: dob,
            name: user["name"] ?? "User",
            gender: gender,
            placeOfBirth: place,
            hour: hour,
            minute: minute,
            isAM: isAM,
          );

          // 🔹 Convert API maps → HoroscopeData objects
          final dailyData = HoroscopeData.fromJson(astroData['daily']);
          final weeklyData = HoroscopeData.fromJson(astroData['weekly']);
          final monthlyData = HoroscopeData.fromJson(astroData['monthly']);

          // ✅ Save locally for splash auto-login
          await prefs.setString("zodiacSign", astroData['zodiac'] ?? '');
          await prefs.setString("daily", jsonEncode(dailyData.toJson()));
          await prefs.setString("weekly", jsonEncode(weeklyData.toJson()));
          await prefs.setString("monthly", jsonEncode(monthlyData.toJson()));

          // 🚀 Navigate to Dashboard with structured data
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardScreen(
                  zodiacSign: astroData['zodiac'] ?? '',
                  daily: dailyData,
                  weekly: weeklyData,
                  monthly: monthlyData,
                ),
              ),
            );
          }
        } else {
          _snack(context, "Date of birth missing in profile");
        }
      } else {
        _snack(context, data["message"] ?? "Login failed");
      }
    } catch (e) {
      _snack(context, e.toString());
    } finally {
      onStop();
    }
  }

  /// Simple snackbar helper
  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
