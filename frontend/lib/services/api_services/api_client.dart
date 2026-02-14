import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../App/controller/Auth_Controller.dart';
import 'api_endpoints.dart';

class ApiClient {
  Future<dynamic> get(String path) async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: _headers(),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String path) async {
    final response = await http.delete(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: _headers(),
    );
    return _handleResponse(response);
  }

  Map<String, String> _headers() {
    final headers = {
      "Content-Type": "application/json",
    };

    if (AuthController.token.isNotEmpty) {
      headers["Authorization"] = "Bearer ${AuthController.token}";
      debugPrint("Sending token: ${AuthController.token}");
    } else {
      debugPrint("No token found in AuthController");
    }

    return headers;
  }


  dynamic _handleResponse(http.Response response) {
    debugPrint("API Response [${response.statusCode}]: ${response.body}");
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data["message"] ?? "API Error");
    }
  }
}
