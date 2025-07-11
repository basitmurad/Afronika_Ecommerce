import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSliderWidget extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/one.png',
    'assets/images/three.png',
    'assets/seven.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          viewportFraction: 1.0,
          enlargeCenterPage: false,
        ),
        items: imagePaths.map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: 270,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
