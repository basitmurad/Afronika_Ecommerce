import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/device/device_utility.dart';

// Custom drawer item for PNG/JPG icons only
class DrawerItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const DrawerItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ADeviceUtils.isDarkMode(context);

    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 24,
        height: 24,
        color: iconColor,
      ),
      title: Text(
        title,
        style: AappTextStyle.roboto(
          fontSize: ASizes.fontSizeSm,
          weight: FontWeight.w500,
          color: textColor ?? (isDark ? AColors.darkGray100 : AColors.lightGray800),
        ),
      ),
      onTap: onTap,
    );
  }
}

