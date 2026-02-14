import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_services/api_endpoints.dart';
import '../api_services/api_service.dart';

class FeedbackApi {
  final ApiService _api = ApiService();

  /// ================= GET PRODUCT FEEDBACK =================
  Future<List<dynamic>> getProductFeedback(String productId) async {
    final res = await http.get(
      Uri.parse(
          "https://astro-nexus-new-6.onrender.com/api/feedback/$productId"),
    );

    print("FEEDBACK STATUS: ${res.statusCode}");
    print("FEEDBACK BODY: ${res.body}");

    final data = jsonDecode(res.body);

    if (res.statusCode != 200 || data["success"] != true) {
      throw Exception(data["message"] ?? "Failed to load feedback");
    }

    return data["feedbacks"];
  }


  /// ================= SUBMIT FEEDBACK =================
  Future<void> submitFeedback(String productId, double rating, String review) async {
    final token = await _api.getToken();

    print("TOKEN FROM STORAGE: $token"); // 👈 ADD THIS

    if (token == null || token.isEmpty) {
      throw Exception("User token missing. Please login again.");
    }

    final response = await http.post(
      Uri.parse("https://astro-nexus-new-6.onrender.com/api/feedback"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "productId": productId,
        "rating": rating,
        "description": review,
      }),
    );

    print("SUBMIT STATUS: ${response.statusCode}");
    print("SUBMIT BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(data["message"] ?? "Failed to submit review");
    }
  }


}
