import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: RichText(
            text: TextSpan(
              style: AappTextStyle.roboto(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 52,
                weight: FontWeight.bold,
              ),

              children: [
                TextSpan(
                  text: 'Afr',
                  style: TextStyle(color: Colors.red[800]),
                ),
                TextSpan(
                  text: 'o',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                TextSpan(
                  text: 'n',
                  style: TextStyle(color: Colors.amber[700]),
                ),
                TextSpan(
                  text: 'ika',
                  style: TextStyle(color: Colors.lightBlue[300]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
