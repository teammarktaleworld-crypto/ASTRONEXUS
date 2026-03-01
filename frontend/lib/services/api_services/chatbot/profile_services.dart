import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../App/controller/Auth_Controller.dart';
import 'package:astro_tale/services/API/APIservice.dart';

class ProfileService {
  /// 🔹 Fetch logged-in user profile and save locally including astrology/chart data
  static Future<void> fetchMyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    if (token == null) throw Exception("Auth token missing");

    try {
      final response = await http.get(
        Uri.parse("$baseurl/user/me"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch profile: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);
      final user = data["user"] ?? {};

      // ───────── BASIC INFO ─────────
      await prefs.setString("userName", user["name"] ?? "Guest");
      await prefs.setString("email", user["email"] ?? "");
      await prefs.setString("phone", user["phone"] ?? "");
      await prefs.setString("userId", user["_id"] ?? "");
      await prefs.setString("sessionId", user["sessionId"] ?? "");
      await prefs.setString("role", user["role"] ?? "");

      // ───────── PROFILE IMAGE ─────────
      String avatarUrl = "";
      final profileImage = user["profileImage"];

      if (profileImage is Map) {
        if (profileImage["url"] != null) {
          avatarUrl = profileImage["url"];
        } else if (profileImage["publicId"] != null) {
          avatarUrl =
          "https://res.cloudinary.com/dgad4eoty/image/upload/${profileImage["publicId"]}";
        }
      }

      await prefs.setString("userAvatar", avatarUrl);

      // ───────── ASTRO PROFILE ─────────
      final astrology = user["astrologyProfile"] ?? {};

      await prefs.setString("zodiacSign", astrology["rashi"] ?? "");
      await prefs.setString("birthDate", astrology["dateOfBirth"] ?? "");
      await prefs.setString("birthTime", astrology["timeOfBirth"] ?? "");
      await prefs.setString("birthPlace", astrology["placeOfBirth"] ?? "");

      // ───────── CHARTS ─────────
      final charts = user["charts"] as List<dynamic>? ?? [];

      if (charts.isNotEmpty) {
        final latestChart = charts.last;
        final chartData = latestChart["chartData"] ?? {};

        final chartImageUrl =
            latestChart["chartImageUrl"] ?? latestChart["chartImage"];

        if (chartImageUrl != null && chartImageUrl.toString().isNotEmpty) {
          final finalUrl = chartImageUrl.toString().startsWith("http")
              ? chartImageUrl.toString()
              : "$baseurl$chartImageUrl";

          await prefs.setString("chartImage", finalUrl);

          debugPrint("✅ Chart image saved: $finalUrl");
        } else {
          debugPrint("⚠️ Chart image URL missing");
        }


        /// Signs & Nakshatra
        await prefs.setString("nakshatra", chartData["nakshatra"] ?? "");
        await prefs.setString(
            "lagnam", chartData["ascendant"]?["sign"] ?? "");
        await prefs.setString(
            "moonSign", chartData["Moon"]?["sign"] ?? "");
        await prefs.setString(
            "sunSign", chartData["Sun"]?["sign"] ?? "");

        /// Raw JSON
        await prefs.setString("planets", jsonEncode(chartData["planets"] ?? {}));
        await prefs.setString("houses", jsonEncode(chartData["houses"] ?? {}));
        await prefs.setString("dashas", jsonEncode(chartData["dashas"] ?? {}));

        await prefs.setInt(
            "planetCount",
            chartData["planets"] is Map
                ? chartData["planets"].length
                : 0);
        await prefs.setInt(
            "houseCount",
            chartData["houses"] is Map
                ? chartData["houses"].length
                : 0);

        await prefs.setString("allCharts", jsonEncode(charts));
      }

      debugPrint("✅ Profile & chart data stored successfully");
    } catch (e, stack) {
      debugPrint("❌ Profile fetch error: $e");
      debugPrintStack(stackTrace: stack);
      throw Exception("Failed to fetch profile");
    }
  }

  /// 🔹 Upload profile image
  static Future<String?> uploadProfileImage(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    if (token == null) throw Exception("Auth token missing");

    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseurl/user/profile-image"),
      );

      request.headers["Authorization"] = "Bearer $token";
      request.files.add(
        await http.MultipartFile.fromPath("profileImg", image.path),
      );

      final response =
      await http.Response.fromStream(await request.send());

      if (response.statusCode != 200) {
        throw Exception("Image upload failed");
      }

      final data = jsonDecode(response.body);
      final imageUrl = data["profileImage"]?["url"];

      if (imageUrl != null && imageUrl.toString().isNotEmpty) {
        await prefs.setString("userAvatar", imageUrl);
        return imageUrl;
      }

      return null;
    } catch (e) {
      debugPrint("❌ Image upload error: $e");
      throw Exception("Image upload failed");
    }
  }
}