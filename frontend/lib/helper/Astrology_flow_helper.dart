import '../services/api_services/horoscope_api.dart';
import 'zodiac_helper.dart';

class AstrologyFlowHelper {
  /// Prepare dashboard data using Vedic zodiac
  static Future<Map<String, dynamic>> prepareDashboardData({
    required DateTime dob,
    String name = "User",
    String gender = "male",
    String placeOfBirth = "Unknown",
    int hour = 0,
    int minute = 0,
    bool isAM = true,
  }) async {
    // ✅ Get Vedic Rashi from API
    final sign = await ZodiacHelper.getVedicZodiac(
      dob,
      name: name,
      gender: gender,
      placeOfBirth: placeOfBirth,
      hour: hour,
      minute: minute,
      isAM: isAM,
    );

    /// Safe fetch with fallback
    Future<Map<String, dynamic>> safeFetch(String type) async {
      try {
        return await HoroscopeApi.fetchHoroscope(sign: sign, type: type);
      } catch (_) {
        // Fallback if API fails
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

    // Fetch horoscopes safely
    final daily = await safeFetch("daily");
    final weekly = await safeFetch("weekly");
    final monthly = await safeFetch("monthly");

    return {
      "zodiac": sign,  // Vedic Rashi
      "daily": daily,
      "weekly": weekly,
      "monthly": monthly,
    };
  }
}
