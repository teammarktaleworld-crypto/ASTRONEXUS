import 'package:flutter/material.dart';


import 'custompara.dart';
import 'customtext.dart';

class Screen extends StatelessWidget {
  const Screen({
    super.key,
    required this.text,
    required this.bg,

    required this.ontap, required this.paratext,
  });

  final String text;
  final Color bg;
  final VoidCallback ontap;
  final String paratext;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 328,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Center(child: Customtext(text: text,color: Color(0xffFFB200),)),
          const SizedBox(height: 20),
          Center(
            child: Custompara(
              text:
              paratext

            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(width: 140,),
              const Customtext(text: 'skip',color: Color(0xffFFB200),),
              const SizedBox(width: 8),
              const Icon(Icons.double_arrow_rounded,color: Color(0xffFFB400),),
              SizedBox(width: 70,),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                child: InkWell(
                  onTap: ontap,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffFF7D00),
                          Color(0xffFFB400),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],

          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
