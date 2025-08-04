import 'package:flutter/material.dart';

import '../../../../utils/constant/app_test_style.dart';

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
  final bool dark;

  const OnboardingPageWidget({super.key, required this.page, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 330,
          width: 330,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(page.image,fit: BoxFit.fill,),
        ),

        SizedBox(height:32),
        Text(
          page.title,
          style: AappTextStyle.roboto(
            fontSize: 24,
            weight: FontWeight.bold,
            color: dark ?Colors.white :Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32 -20),
        Text(
          page.description,
          textAlign: TextAlign.center,
          style: AappTextStyle.roboto(
            fontSize: 16,
            weight: FontWeight.w400,
            color: dark ?Colors.white :Colors.black,
          ),

        ),
      ],
    );
  }
}
