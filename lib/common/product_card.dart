import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';

import '../utils/constant/app_test_style.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final bool isDark;

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 180,
          width: 180,
          image: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AappTextStyle.roboto(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16.0,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: AappTextStyle.roboto(
                color: isDark ? AColors.primary : Colors.black,
                fontSize: 14.0,
                weight: FontWeight.w400,
              ),
            ),
          ],
        )
      ],
    );
  }
}
