import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../services/API/APIservice.dart';
import '../../../../../helper/Astrology_flow_helper.dart';
import '../../../../Model/Horoscope/horoscope_model.dart';
import '../model/SignUp_Data_Model.dart';

class SignupController {
  final AstrologySignupModel model = AstrologySignupModel();

  String birthCity = '';
  String birthCountry = '';
  double birthLat = 0.0;
  double birthLon = 0.0;

  // ------------------ SETTERS ------------------
  void setName(String name) => model.name = name.trim();
  void setEmail(String email) => model.email = email.trim();
  void setPhone(String phone) => model.phone = phone.trim();
  void setPassword(String password) => model.password = password;
  void setConfirmPassword(String confirmPassword) =>
      model.confirmPassword = confirmPassword;
  void setDateOfBirth(String date) => model.dateOfBirth = date;

  void setBirthTime(int hour, int minute, bool isAM) {
    model.hour = hour;
    model.minute = minute;
    model.isAM = isAM;
  }

  void setPlace(String place) => model.place = place.trim();

  void setTimezone(double timezone) => model.timezone = timezone;

  // ------------------ SUBMIT SIGNUP ------------------
  Future<Map<String, dynamic>> submitSignup() async {
    final url = Uri.parse('$baseurl/user/signup/astrology');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    final res = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();

      // 1️⃣ Save JWT token & mark user as logged in
      final token = res['token'] ?? '';
      await prefs.setString('auth_token', token);
      await prefs.setBool('isLoggedIn', true);

      // 2️⃣ Prepare astrology dashboard data
      final dob = DateTime.parse(model.dateOfBirth);
      final astroData = await AstrologyFlowHelper.prepareDashboardData(dob: dob);

      final dailyData = HoroscopeData.fromJson(astroData['daily']);
      final weeklyData = HoroscopeData.fromJson(astroData['weekly']);
      final monthlyData = HoroscopeData.fromJson(astroData['monthly']);

      // 3️⃣ Save dashboard locally
      await prefs.setString("zodiacSign", astroData['zodiac'] ?? '');
      await prefs.setString("daily", jsonEncode(dailyData.toJson()));
      await prefs.setString("weekly", jsonEncode(weeklyData.toJson()));
      await prefs.setString("monthly", jsonEncode(monthlyData.toJson()));

      return {
        'token': token,
        'zodiacSign': astroData['zodiac'] ?? '',
        'daily': dailyData,
        'weekly': weeklyData,
        'monthly': monthlyData,
      };
    }

    throw Exception(res['message'] ?? res['error'] ?? "Signup failed");
  }
}
