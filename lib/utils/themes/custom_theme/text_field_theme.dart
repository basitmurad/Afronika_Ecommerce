import 'package:flutter/material.dart';
import '../../constant/colors.dart';
import '../../constant/sizes.dart';

class TTextFieldTheme {
  TTextFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    suffixIconColor: AColors.darkGray400,
    labelStyle: const TextStyle().copyWith(fontSize: ASizes.fontSizeMd, color: AColors.lightGray900),
    hintStyle: const TextStyle().copyWith(fontSize: ASizes.fontSizeSm, color: AColors.lightGray600),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: AColors.lightGray700.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AColors.lightGray500),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AColors.lightGray500),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AColors.lightGray100),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AColors.error500),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: AColors.error500),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: AColors.darkGray400,
    suffixIconColor: AColors.darkGray400,
    labelStyle: const TextStyle().copyWith(fontSize: ASizes.fontSizeMd, color: AColors.lightGray100),
    hintStyle: const TextStyle().copyWith(fontSize: ASizes.fontSizeSm, color: AColors.lightGray500),
    floatingLabelStyle: const TextStyle().copyWith(color: AColors.lightGray200.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AColors.darkGray500),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AColors.darkGray500),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AColors.lightGray100),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AColors.error500),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ASizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: AColors.error500),
    ),
  );
}
