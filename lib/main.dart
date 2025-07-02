import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                'Hello, Roboto!',
                style: AappTextStyle.roboto(
                  fontSize: 24,
                  color: Colors.black, weight: FontWeight.w900,
                ),
              ),
              Text(
                'Hello, Roboto!',
                style: AappTextStyle.roboto(
                  fontSize: 24,
                  color: Colors.black, weight: FontWeight.w800,
                ),
              ),

              Text(
                'Hello, Roboto!',
                style: AappTextStyle.roboto(
                  fontSize: 24,
                  color: Colors.black, weight: FontWeight.w700,
                ),
              ),              Text(
                'Hello, Roboto!',
                style: AappTextStyle.roboto(
                  fontSize: 24,
                  color: Colors.black, weight: FontWeight.w600,
                ),
              ),

              Text(
                'Hello, Roboto!',
                style: AappTextStyle.roboto(
                  fontSize: 24,
                  color: Colors.black, weight: FontWeight.w500,
                ),
              ),

              Text(
                'Hello, Roboto!',
                style: AappTextStyle.roboto(
                  fontSize: 24,
                  color: Colors.black, weight: FontWeight.w400,
                ),
              ),

              Text(
                'Hello, Roboto!',
                style: AappTextStyle.roboto(
                  fontSize: 24,
                  color: Colors.black, weight: FontWeight.w300,
                ),
              ),





            ],
          ),
        ),
      ),
    );
  }
}
