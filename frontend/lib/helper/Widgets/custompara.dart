import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';


class Custompara extends StatelessWidget {
  const Custompara({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,fontStyle: FontStyle.normal,color: Color(0xffFFFFFF),),textAlign: TextAlign.center,);
  }
}
