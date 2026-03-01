import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../helper/Astrology_flow_helper.dart';
import '../../../../../helper/zodiac_helper.dart';
import '../../../../../services/API/APIservice.dart';
import '../../../../Model/Horoscope/horoscope_model.dart';
import '../Model/SignUp_Data_Model.dart';

class SignupController {
  final AstrologySignupModel model = AstrologySignupModel();

  // ------------------ SETTERS ------------------
  void setName(String name) => model.name = name.trim();
  void setEmail(String email) => model.email = email.trim();
  void setPhone(String phone) => model.phone = phone.trim();
  void setPassword(String password) => model.password = password;
  void setConfirmPassword(String confirmPassword) => model.confirmPassword = confirmPassword;
  void setDateOfBirth(String date) => model.dateOfBirth = date;
  void setBirthTime(int hour, int minute, bool isAM) {
    model.hour = hour;
    model.minute = minute;
    model.isAM = isAM;
  }
  void setPlace(String place) => model.place = place.trim();

  // ------------------ SUBMIT SIGNUP ------------------
  Future<Map<String, dynamic>> submitSignup() async {
    final dob = DateTime.parse(model.dateOfBirth);

    // ✅ Generate birth chart + zodiac + horoscopes in one call
    final astroData = await AstrologyFlowHelper.prepareDashboardData(
      dob: dob,
      name: model.name,
      placeOfBirth: model.place,
      hour: model.hour,
      minute: model.minute,
      isAM: model.isAM,
    );

    // Add tempChartId to signup model
    model.tempChartId = astroData['tempChartId'] ?? '';

    // ✅ Send signup request
    final url = Uri.parse('$baseurl/user/signup/astrology');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    final res = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();

      final token = res['token'] ?? '';
      await prefs.setString('auth_token', token);
      await prefs.setBool('isLoggedIn', true);

      // Save zodiac sign locally
      final rashi = astroData['zodiac'] ?? 'unknown';
      await prefs.setString('vedic_rashi', rashi);

      // Save horoscope data locally
      await prefs.setString("zodiacSign", rashi);
      await prefs.setString("daily", jsonEncode(HoroscopeData.fromJson(astroData['daily']).toJson()));
      await prefs.setString("weekly", jsonEncode(HoroscopeData.fromJson(astroData['weekly']).toJson()));
      await prefs.setString("monthly", jsonEncode(HoroscopeData.fromJson(astroData['monthly']).toJson()));

      return {
        'token': token,
        'zodiacSign': rashi,
        'tempChartId': model.tempChartId,
        'daily': astroData['daily'],
        'weekly': astroData['weekly'],
        'monthly': astroData['monthly'],
      };
    }

    throw Exception(res['message'] ?? res['error'] ?? "Signup failed");
  }
}