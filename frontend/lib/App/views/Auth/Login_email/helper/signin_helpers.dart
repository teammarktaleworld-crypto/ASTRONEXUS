import 'package:flutter/material.dart';

InputDecoration authInput(String hint, IconData icon) {
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

Widget orDivider() {
  return Row(
    children: const [
      Expanded(child: Divider(color: Colors.white24)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("OR", style: TextStyle(color: Colors.white70)),
      ),
      Expanded(child: Divider(color: Colors.white24)),
    ],
  );
}
