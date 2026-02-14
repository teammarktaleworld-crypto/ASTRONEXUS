import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:astro_tale/services/API/APIservice.dart';
import '../../Sign_up/screens/astrology_signup_timeline_screen.dart';

class SignupController {
  static Future<void> signup({
    required BuildContext context,
    required TextEditingController name,
    required TextEditingController email,
    required TextEditingController phone,
    required TextEditingController password,
    required TextEditingController confirmPassword,
    required VoidCallback onStart,
    required VoidCallback onStop,
  }) async {
    if (password.text.trim() != confirmPassword.text.trim()) {
      _snack(context, "Passwords do not match");
      return;
    }

    onStart();

    try {
      final res = await http.post(
        Uri.parse("$baseurl/user/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name.text.trim(),
          "email": email.text.trim(),
          "phone": phone.text.trim(),
          "password": password.text.trim(),
          "confirmPassword": confirmPassword.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        _snack(context, data["message"] ?? "Account created");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AstrologySignupTimeline(),
          ),
        );
      } else {
        _snack(context, data["message"] ?? "Signup failed");
      }
    } catch (e) {
      _snack(context, e.toString());
    } finally {
      onStop();
    }
  }

  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
