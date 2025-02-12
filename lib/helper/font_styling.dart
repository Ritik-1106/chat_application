// this class  basically direct will help to change font or style in entire chat application
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyling {
  static TextStyle title01() {
    return 
       GoogleFonts.ibarraRealNova(
        fontSize: 25,
        color: Colors.white,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w600,
    );
  }

  static TextStyle button_text(Color color, double size) {
    return GoogleFonts.nunito(
        fontSize: size,
        color: color,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w400
      );
  }

  static TextStyle chating_text_style(Color color , double size){
    return 
      GoogleFonts.pathwayExtreme(
        fontSize: size,
        color: color,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w500
      );
  }
  
}
