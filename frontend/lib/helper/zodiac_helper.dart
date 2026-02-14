import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ZodiacHelper {
  /// Fetch Vedic Rashi from Astro Nexus API
  /// Async version, works per user DOB, time, and place
  static Future<String> getVedicZodiac(
      DateTime dob, {
        String name = "User",
        String gender = "male",
        String placeOfBirth = "Unknown",
        int hour = 0,
        int minute = 0,
        bool isAM = true,
        String astrologyType = "vedic",
        String ayanamsa = "lahiri",
      }) async {
    try {
      final payload = {
        "name": name,
        "gender": gender,
        "birth_date": {
          "year": dob.year,
          "month": dob.month,
          "day": dob.day,
        },
        "birth_time": {
          "hour": hour,
          "minute": minute,
          "ampm": isAM ? "AM" : "PM",
        },
        "place_of_birth": placeOfBirth,
        "astrology_type": astrologyType,
        "ayanamsa": ayanamsa
      };

      final response = await http.post(
        Uri.parse("https://astro-nexus-backend-9u1s.onrender.com/api/v1/chart"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("API Error: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);

      // Extract rashi from API response
      final rashi = (data["rashi"] ?? data["ascendant"]?["sign"] ?? "").toString().toLowerCase();

      // Save in SharedPreferences
      if (rashi.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("vedic_rashi", rashi);
      }

      return rashi.isNotEmpty ? rashi : "unknown";
    } catch (e) {
      print("Error fetching Rashi from API: $e");
      return "unknown";
    }
  }

  /// Get stored Rashi from SharedPreferences
  static Future<String?> getStoredRashi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("vedic_rashi");
  }
}
