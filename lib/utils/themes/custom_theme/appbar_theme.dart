import 'package:flutter/material.dart';

import '../../constant/colors.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static var lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AColors.lightGray100,  // Light background color
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: AColors.darkGray900,  // Icon color for light mode
      size: 24.0,
    ),
    actionsIconTheme: IconThemeData(
      color: AColors.darkGray900,  // Icon color for actions in light mode
      size: 24.0,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AColors.lightGray800,  // Title text color for light mode
    ),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AColors.darkGray900,  // Dark background color
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: AColors.lightGray100,  // Icon color for dark mode
      size: 24.0,
    ),
    actionsIconTheme: IconThemeData(
      color: AColors.lightGray100,  // Icon color for actions in dark mode
      size: 24.0,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AColors.lightGray100,  // Title text color for dark mode
    ),
  );
}
