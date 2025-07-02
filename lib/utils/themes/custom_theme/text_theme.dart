import 'package:flutter/material.dart';

import '../../constant/colors.dart';


class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: AColors.lightGray900),
    headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: AColors.lightGray900),
    headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: AColors.lightGray900),

    titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: AColors.lightGray900),
    titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: AColors.lightGray900),
    titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: AColors.lightGray900),

    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: AColors.lightGray900),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: AColors.textDarkColor),
    bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: AColors.lightGray900.withOpacity(0.5)),

    labelLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: AColors.lightGray900),
    labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: AColors.lightGray900.withOpacity(0.5)),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: AColors.darkGray100),
    headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: AColors.darkGray100),
    headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: AColors.darkGray100),

    titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: AColors.darkGray100),
    titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: AColors.darkGray100),
    titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: AColors.darkGray100),

    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: AColors.darkGray100),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: AColors.darkGray100),
    bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: AColors.darkGray100.withOpacity(0.5)),

    labelLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: AColors.darkGray100),
    labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: AColors.darkGray100.withOpacity(0.5)),
  );
}
