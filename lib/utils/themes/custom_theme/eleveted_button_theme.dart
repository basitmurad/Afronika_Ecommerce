import 'package:flutter/material.dart';
import '../../constant/colors.dart';
import '../../constant/sizes.dart';

/// Light and dark elevated button themes
class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AColors.lightGray100,  // Light foreground color
      backgroundColor: AColors.primary,       // Primary background color
      disabledForegroundColor: AColors.lightGray500,  // Disabled foreground color
      disabledBackgroundColor: AColors.lightGray300,  // Disabled background color
      side: const BorderSide(color: AColors.primary), // Border color
      padding: const EdgeInsets.symmetric(vertical: ASizes.buttonHeight),
      textStyle: const TextStyle(
        fontSize: 16,
        color: AColors.lightGray100,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ASizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AColors.lightGray100,  // Light foreground color
      backgroundColor: AColors.primary,       // Primary background color
      disabledForegroundColor: AColors.darkGray500,  // Disabled foreground color
      disabledBackgroundColor: AColors.darkGray300,  // Disabled background
      side: const BorderSide(color: AColors.primary), // Border color
      padding: const EdgeInsets.symmetric(vertical: ASizes.buttonHeight),
      textStyle: const TextStyle(
        fontSize: 16,
        color: AColors.lightGray100,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ASizes.buttonRadius)),
    ),
  );
}
