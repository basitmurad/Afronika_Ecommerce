import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import '../utils/constant/colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = ADeviceUtils.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: AappTextStyle.roboto(
              fontSize: 56,
              weight: FontWeight.bold,
              color: Colors.red,
            ),
            children: [
              TextSpan(
                text: 'Afr',
                style: AappTextStyle.roboto(
                  fontSize: 56,
                  weight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              TextSpan(
                text: 'o',
                style: AappTextStyle.roboto(
                  fontSize: 56,
                  weight: FontWeight.bold,
                  color: dark ?Colors.white :Colors.black,
                ),
              ),
              TextSpan(
                text: 'n',
                style: AappTextStyle.roboto(
                  fontSize: 56,
                  weight: FontWeight.bold,
                  color: AColors.primary,
                ),
              ),
              TextSpan(
                text: 'ika',
                style: AappTextStyle.roboto(
                  fontSize: 56,
                  weight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
