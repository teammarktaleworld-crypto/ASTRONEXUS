import 'dart:async';
import 'dart:convert';
import 'package:astro_tale/services/api_services/refresh_token.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../../helper/Astrology_flow_helper.dart';
import '../../../../Model/Horoscope/horoscope_model.dart';
import '../../../../controller/Auth_Controller.dart';
import '../../../dash/DashboardScreen.dart';
import '../helper/login_api.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Timer? _timer;
  int _secondsLeft = 0;

  bool get isLocked => _secondsLeft > 0;
  int get secondsLeft => _secondsLeft;

  void _startTimer() {
    _secondsLeft = 30;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsLeft--;
      notifyListeners();

      if (_secondsLeft <= 0) {
        timer.cancel();
      }
    });
  }

  /// ---------------- LOGIN FUNCTION ----------------
  Future<void> login(
      BuildContext context,
      String phone,
      String password,
      ) async {
    if (isLocked) {
      errorMessage = "Too many attempts. Try again in $secondsLeft sec";
      notifyListeners();
      return;
    }

    if (phone.isEmpty || password.isEmpty) {
      errorMessage = "Enter phone and password";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await LoginApi.loginWithPhone(
        phone: phone,
        password: password,
      );

      if (response["token"] == null) {
        throw Exception(response["message"] ?? "Token missing");
      }

      final prefs = await SharedPreferences.getInstance();
      final token = response["token"];
      final refreshToken = response["refreshToken"] ?? "";
      final user = response["user"] ?? {};

      /// ================= SAVE BASIC USER DATA =================
      await prefs.setString("auth_token", token);
      await prefs.setString("refresh_token", refreshToken);
      await prefs.setString("userName", user["name"] ?? "");
      await prefs.setString("userEmail", user["email"] ?? "");
      await prefs.setString("userPhone", user["phone"] ?? "");
      await prefs.setString("userId", user["id"] ?? "");
      await prefs.setString("role", user["role"] ?? "");
      await prefs.setBool("isLoggedIn", true);

      /// ⭐ SAVE SESSION ID (IMPORTANT FOR CHATBOT)
      await prefs.setString("sessionId", user["sessionId"] ?? "");

      AuthController.token = token;
      AuthController.userId = user["id"] ?? "";
      AuthController.role = user["role"] ?? "";

      /// ================= TOKEN REFRESH CHECK =================
      if (JwtDecoder.isExpired(token)) {
        if (refreshToken.isNotEmpty) {
          final newToken = await APIService.refreshToken(refreshToken);
          if (newToken != null) {
            await prefs.setString("auth_token", newToken);
            AuthController.token = newToken;
          } else {
            throw Exception("Session expired. Please login again.");
          }
        } else {
          throw Exception("Session expired. Please login again.");
        }
      }

      /// ================= ASTROLOGY PROFILE =================
      final profile = user["astrologyProfile"];
      if (profile == null || profile["dateOfBirth"] == null) {
        throw Exception("Birth details missing in profile");
      }

      final dob = DateTime.parse(profile["dateOfBirth"]);
      final timeString = profile["timeOfBirth"] ?? "00:00";
      final place = profile["placeOfBirth"] ?? "Unknown";
      final gender = user["gender"] ?? "male";

      /// Save raw data for chatbot birth_input
      await prefs.setString("dob", profile["dateOfBirth"]);
      await prefs.setString("tob", timeString);
      await prefs.setString("pob", place);

      /// Convert time "HH:mm" → hour/minute/isAM
      final parts = timeString.split(":");
      int hour24 = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      bool isAM = hour24 < 12;
      int hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;

      /// ================= DASHBOARD ASTRO DATA =================
      final astroData = await AstrologyFlowHelper.prepareDashboardData(
        dob: dob,
        name: user["name"] ?? "User",
        gender: gender,
        placeOfBirth: place,
        hour: hour12,
        minute: minute,
        isAM: isAM,
      );

      final dailyData = HoroscopeData.fromJson(astroData['daily']);
      final weeklyData = HoroscopeData.fromJson(astroData['weekly']);
      final monthlyData = HoroscopeData.fromJson(astroData['monthly']);

      await prefs.setString("zodiacSign", astroData['zodiac'] ?? '');
      await prefs.setString("daily", jsonEncode(dailyData.toJson()));
      await prefs.setString("weekly", jsonEncode(weeklyData.toJson()));
      await prefs.setString("monthly", jsonEncode(monthlyData.toJson()));

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
    }

    on TimeoutException {
      _startTimer();
      errorMessage = "Server timeout. Try again in 30 seconds.";
      notifyListeners();
    }

    on Exception catch (e) {
      _startTimer();
      errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
    }

    catch (_) {
      _startTimer();
      errorMessage = "Login failed. Try again later.";
      notifyListeners();
    }

    finally {
      isLoading = false;
      notifyListeners();
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
