import 'package:flutter/material.dart';
import 'package:afronika/utils/constant/app_test_style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/profileScreen');
        },
        child: Center(
          child: Text(
            "Basit Murad",
            style: AappTextStyle.roboto(
              color: Colors.black,
              fontSize: 19.0,
              weight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
