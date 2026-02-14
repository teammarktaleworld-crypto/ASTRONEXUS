import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Login_email/helper/signin_helpers.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;

  const PhoneInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.poppins(color: Colors.black87),
      decoration: authInput("Phone Number", Icons.phone),
    );
  }
}
