import 'package:flutter/material.dart';

import '../../constant/colors.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: AColors.lightGray400.withOpacity(0.4), // Disabled color for light mode
    labelStyle: const TextStyle(color: AColors.lightGray700), // Label style for light mode
    selectedColor: AColors.primary, // Selected color
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12), // Padding for chips
    checkmarkColor: AColors.lightGray100, // Checkmark color for light mode
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: AColors.darkGray400, // Disabled color for dark mode
    labelStyle: TextStyle(color: AColors.lightGray100), // Label style for dark mode
    selectedColor: AColors.primary, // Selected color
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12), // Padding for chips
    checkmarkColor: AColors.lightGray100, // Checkmark color for dark mode
  );
}
