import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotService {
  static const String baseUrl =
      "https://astro-nexus-new-6.onrender.com/api/chatbot/ask";

  static Future<String> askQuestion(String question) async {
    final prefs = await SharedPreferences.getInstance();

    final sessionId = prefs.getString("sessionId");
    final token = prefs.getString("auth_token");   // ⭐ GET TOKEN

    print("📡 Sending sessionId: $sessionId");
    print("🔐 Sending token: $token");
    print("❓ Question: $question");

    if (sessionId == null || sessionId.isEmpty) {
      throw Exception("Session ID missing. User not logged in properly.");
    }

    if (token == null || token.isEmpty) {
      throw Exception("Auth token missing. Please login again.");
    }

    final response = await http
        .post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",   // ⭐ REQUIRED
      },
      body: jsonEncode({
        "session_id": sessionId,
        "question": question,
      }),
    )
        .timeout(const Duration(seconds: 25));

    print("📩 Status Code: ${response.statusCode}");
    print("📩 Response Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return data["answer"];
    } else {
      throw Exception(data["message"] ?? "Server error");
    }
  }
}
