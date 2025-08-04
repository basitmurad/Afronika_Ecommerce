import 'package:flutter/material.dart';

class AColors {
  AColors._();

  static const Color brand500 = Color(
    0xFFFDAE03,
  ); // Primary brand color updated

  // Legacy primary colors (keeping for backward compatibility)
  static const Color primary = brand500;

  // Light mode grays
  static const Color lightGray100 = Color(0xFFF2F4F7);

  static const Color darkGray900 = Color(0xFF161B26);
}
