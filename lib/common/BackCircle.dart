import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/constant/colors.dart';


class BackCircle extends StatelessWidget {
  const BackCircle({super.key, this.onTap, this.isDark});
  final VoidCallback? onTap;
  final bool?  isDark;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(

            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: AColors.darkGray400, width: 1),


          ),
          child: Icon(
            size: 18,
            weight: 700,
            Iconsax.arrow_left_2,  // Using Iconsax's back arrow icon
            color: isDark! ? AColors.lightGray100 :AColors.darkGray800,
          ),
        ),
      ),
    );
  }
}
