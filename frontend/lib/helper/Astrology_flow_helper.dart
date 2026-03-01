import '../services/api_services/horoscope_api.dart';
import 'zodiac_helper.dart';

class AstrologyFlowHelper {
  /// Prepare full dashboard data using birth chart generation
  /// Returns zodiac sign, tempChartId, and daily/weekly/monthly horoscopes
  static Future<Map<String, dynamic>> prepareDashboardData({
    required DateTime dob,
    String name = "User",
    String gender = "male",
    String placeOfBirth = "Unknown",
    int hour = 0,
    int minute = 0,
    bool isAM = true,
  }) async {
    // 1️⃣ Generate birth chart & get rashi + tempChartId
    final chartInfo = await ZodiacHelper.generateBirthChart(
      dob,
      name: name,
      gender: gender,
      placeOfBirth: placeOfBirth,
      hour: hour,
      minute: minute,
      isAM: isAM,
    );

    final zodiacSign = chartInfo['rashi'] ?? 'unknown';
    final tempChartId = chartInfo['tempChartId'] ?? '';

    /// Safe fetch function for horoscopes
    Future<Map<String, dynamic>> safeFetch(String type) async {
      try {
        return await HoroscopeApi.fetchHoroscope(sign: zodiacSign, type: type);
      } catch (_) {
        return _fallbackHoroscope(type, zodiacSign);
      }
    }

    // 2️⃣ Fetch horoscopes safely
    final daily = await safeFetch("daily");
    final weekly = await safeFetch("weekly");
    final monthly = await safeFetch("monthly");

    // 3️⃣ Return structured data
    return {
      "zodiac": zodiacSign,
      "tempChartId": tempChartId,
      "daily": daily,
      "weekly": weekly,
      "monthly": monthly,
    };
  }

  /// Fallback horoscope if API fails
  static Map<String, dynamic> _fallbackHoroscope(String type, String zodiac) {
    switch (type) {
      case "daily":
        return {
          "title": "Today",
          "horoscope": "Horoscope not available today for $zodiac",
          "extra": null,
        };
      case "weekly":
        return {
          "title": "This Week",
          "horoscope": "Horoscope not available this week for $zodiac",
          "extra": null,
        };
      case "monthly":
        return {
          "title": "This Month",
          "horoscope": "Horoscope not available this month for $zodiac",
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