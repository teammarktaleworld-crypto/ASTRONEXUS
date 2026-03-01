import 'dart:convert';
import 'package:http/http.dart' as http;

import '../API/APIservice.dart';
import '../api_services/api_endpoints.dart';
import '../api_services/api_service.dart';

class FeedbackApi {
  final ApiService _api = ApiService();

  /// ================= GET PRODUCT FEEDBACK =================
  Future<List<dynamic>> getProductFeedback(String productId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseurl/api/feedback/$productId"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("FEEDBACK STATUS: ${response.statusCode}");
      print("FEEDBACK BODY: ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode != 200 || data["success"] != true) {
        throw Exception(data["message"] ?? "Failed to load feedback");
      }

      return data["feedbacks"] ?? [];
    } catch (e) {
      print("GET FEEDBACK ERROR: $e");
      rethrow;
    }
  }

  /// ================= SUBMIT FEEDBACK =================
  Future<void> submitFeedback({
    required String productId,
    required double rating,
    required String review,
  }) async {
    try {
      final token = await _api.getToken();

      print("TOKEN FROM STORAGE: $token");

      if (token == null || token.isEmpty) {
        throw Exception("User token missing. Please login again.");
      }

      final response = await http.post(
        Uri.parse("$baseurl/api/feedback"),
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

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode != 201 || data["success"] != true) {
        throw Exception(data["message"] ?? "Failed to submit review");
      }
    } catch (e) {
      print("SUBMIT FEEDBACK ERROR: $e");
      rethrow;
    }
  }
}