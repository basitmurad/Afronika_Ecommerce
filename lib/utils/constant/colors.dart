import 'package:flutter/material.dart';

class AColors {
  AColors._();

  static const Color brand500 = Color(0xFFFDAE03); // Primary brand color updated

  // Legacy primary colors (keeping for backward compatibility)
  static const Color primary = brand500;

  // Light mode grays
  static const Color lightGray100 = Color(0xFFF2F4F7);
  static const Color darkGray900 = Color(0xFF161B26);

  // 🔴 New colors
  static const Color hardRed1 = Color(0xFFB6041A);   // Strong red
  static const Color hardRed = Color(0xFFB10202);   // Strong red
  static const Color lightBlue = Color(0xFF01E5F6); // Standard light blue
}
