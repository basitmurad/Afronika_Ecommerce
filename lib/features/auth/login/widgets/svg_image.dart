import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;

  const SvgImage({required this.imagePath, this.height,this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: SvgPicture.asset(
          imagePath,
          height: (height != null) ? height : 60,
          width: (width != null) ? width : 60,
        ),
      ),
    );
  }
}
