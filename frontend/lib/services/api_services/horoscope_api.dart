import 'dart:convert';
import 'package:http/http.dart' as http;

class HoroscopeApi {
  static const String _baseUrl =
      "https://astronexus-horoscope-ogbl.onrender.com/api/horoscope";

  /// Fetch horoscope with fallback in case of failure
  static Future<Map<String, dynamic>> fetchHoroscope({
    required String sign,
    required String type,
  }) async {
    try {
      final uri = Uri.parse(
        "$_baseUrl?sign=${sign.toLowerCase()}&type=$type",
      );

      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        try {
          final err = json.decode(response.body);
          throw Exception(err["message"] ?? "Failed to load horoscope");
        } catch (_) {
          throw Exception("Failed to load horoscope");
        }
      }

      final jsonBody = json.decode(response.body);
      final data = jsonBody["data"] ?? {};

      // DAILY
      if (type == "daily") {
        return {
          "title": data["date"] ?? "Today",
          "horoscope": data["horoscope_data"] ?? "Horoscope not available today",
          "extra": null,
        };
      }

      // WEEKLY
      if (type == "weekly") {
        return {
          "title": data["week"] ?? "This Week",
          "horoscope": data["horoscope_data"] ?? "Horoscope not available this week",
          "extra": null,
        };
      }

      // MONTHLY
      if (type == "monthly") {
        return {
          "title": data["month"] ?? "This Month",
          "horoscope": data["horoscope_data"] ?? "Horoscope not available this month",
          "extra": {
            "standout_days": data["standout_days"] ?? [],
            "challenging_days": data["challenging_days"] ?? [],
          },
        };
      }

      throw Exception("Unsupported horoscope type");
    } catch (e) {
      // Fallback for API/network failure
      return _fallback(sign: sign, type: type);
    }
  }

  /// Default fallback horoscope
  static Map<String, dynamic> _fallback({required String sign, required String type}) {
    switch (type) {
      case "daily":
        return {
          "title": "Today",
          "horoscope": "Horoscope not available today for $sign",
          "extra": null,
        };
      case "weekly":
        return {
          "title": "This Week",
          "horoscope": "Horoscope not available this week for $sign",
          "extra": null,
        };
      case "monthly":
        return {
          "title": "This Month",
          "horoscope": "Horoscope not available this month for $sign",
          "extra": {
            "standout_days": [],
            "challenging_days": [],
          },
        };
      default:
        return {
          "title": "",
          "horoscope": "Horoscope not available",
          "extra": null,
        };
    }
  }
}
