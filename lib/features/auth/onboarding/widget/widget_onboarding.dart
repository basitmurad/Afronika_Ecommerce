import 'package:flutter/material.dart';

class OnboardingPage {
  final String title;
  final String description;
  final dynamic image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 40),
        Container(
          height: 360,
          width: 359,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(40),
          ),
          child: Image.asset(page.image),
        ),

        SizedBox(height: 40),
        Text(
          page.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: dark? Colors.white: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Text(
          page.description,
          style: TextStyle(fontSize: 16, color: dark? Colors.white: Colors.black54, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
