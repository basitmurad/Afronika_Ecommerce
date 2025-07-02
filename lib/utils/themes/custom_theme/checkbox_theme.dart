import 'package:flutter/material.dart';

import '../../constant/colors.dart';
import '../../constant/sizes.dart';

class TCheckBoxTheme {
  TCheckBoxTheme._();

  /// Customizable Light Checkbox Theme
  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ASizes.xs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AColors.lightGray100; // Check color for selected state
      } else {
        return AColors.lightGray700; // Check color for unselected state
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AColors.primary; // Fill color for selected state
      } else {
        return Colors.transparent; // Transparent for unselected state
      }
    }),
  );

  /// Customizable Dark Checkbox Theme
  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ASizes.xs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AColors.lightGray100; // Check color for selected state
      } else {
        return AColors.darkGray300; // Check color for unselected state
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AColors.primary; // Fill color for selected state
      } else {
        return Colors.transparent; // Transparent for unselected state
      }
    }),
  );
}
