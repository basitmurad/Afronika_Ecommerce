import 'dart:async';
import 'package:flutter/material.dart';

import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        progress += 0.01;
        if (progress >= 1) {
          progress = 1;
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark? Colors.black: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'Afr',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: 'o',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'n',
                    style: TextStyle(color: Colors.amber),
                  ),
                  TextSpan(
                    text: 'ika',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 70),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double barWidth = constraints.maxWidth;
                double progressWidth = barWidth * progress;
                double textLeft = (progressWidth - 10).clamp(
                  0.0,
                  barWidth - 30,
                );
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 17,

                      width: 347,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    Container(
                      height: 17,
                      width: 347 * progress,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.tealAccent.shade400,
                      ),
                    ),

                    Container(
                      height: 17,
                      width: 347 * progress,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.tealAccent.shade400,
                      ),
                      alignment: Alignment.center,
                      // center the text inside the filled bar
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
