import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColouredContainer extends StatelessWidget{
  const ColouredContainer({super.key,required this.colors,required this.text});
  final List<Color> colors;
  final String text;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(colors: colors)
        ),
        child:Text(text,
          style:GoogleFonts.inriaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 255, 250, 235)
          ) ,) ,
      ),
    );
  }
}