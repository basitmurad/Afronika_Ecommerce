import 'package:flutter/material.dart';

class AappTextStyle {
  static roboto({
    required Color color,
    required double fontSize,
    required FontWeight weight,
    double height = 1.0,
    bool shouldUnderline = false,
    double letterSpacing = 0.0, // 👈 Default letter spacing (normal)
  }) {
    return TextStyle(
      height: height,
      color: color,
      fontWeight: weight,
      fontSize: fontSize,
      fontFamily: AppFontFamilies.roboto,
      letterSpacing: letterSpacing, // 👈 Applied here
      decoration: shouldUnderline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: color,
    );
  }
}

class AppFontFamilies {
  static String roboto = 'Roboto';
}
