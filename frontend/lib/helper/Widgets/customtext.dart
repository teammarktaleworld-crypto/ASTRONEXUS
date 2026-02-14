import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Customtext extends StatelessWidget {
  const Customtext({super.key, required this.text, required this.color,});
  final String text;
  final Color color;


  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.getFont("Poppins",fontWeight: FontWeight.w700,fontSize: 20,color: color),);
  }
}
