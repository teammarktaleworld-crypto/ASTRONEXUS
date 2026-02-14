import 'package:flutter/material.dart';

InputDecoration signupInput(String hint, IconData icon) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hint,
    prefixIcon: Icon(icon, color: Colors.black54),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF585023), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFDBC33F), width: 2),
    ),
  );
}
