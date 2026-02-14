import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 📱 Phone Input Field Decoration as Container Style
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_mobile_field/intl_mobile_field.dart';

/// 📱 Phone Input Field using IntlMobileField (adjusted)
Widget intlPhoneInput({
  required String initialCountryCode,
  required Function(String) onChanged,
  String hint = "Enter phone number",
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white, // White background
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
      border: Border.all(
        color: Colors.grey.withOpacity(0.3), // Optional border
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: IntlMobileField(
      initialCountryCode: initialCountryCode,
      style: GoogleFonts.dmSans(
        color: Colors.black,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.dmSans(color: Colors.black54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 18), // Increased vertical padding
      ),
      onChanged: (value) {
        onChanged(value.completeNumber);
      },
    ),
  );
}


/// ⚡ OR Divider
Widget orDivider() {
  return Row(
    children: [
      const Expanded(
        child: Divider(color: Colors.white24, thickness: 1.2),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          "OR",
          style: GoogleFonts.dmSans(
            color: Colors.white54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const Expanded(
        child: Divider(color: Colors.white24, thickness: 1.2),
      ),
    ],
  );
}
