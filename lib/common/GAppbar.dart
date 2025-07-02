

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constant/colors.dart';
import '../utils/device/device_utility.dart';


class Aappbar extends StatelessWidget implements PreferredSizeWidget {
  const Aappbar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
    this.showDivider = true,
  });

  final Widget? title;
  final bool showBackArrow;
  final Widget? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isDark = ADeviceUtils.isDarkMode(context);
    final backgroundColor = isDark ?  Colors.black: Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark, // Icon color
        statusBarBrightness:
        isDark ? Brightness.dark : Brightness.light, // iOS only
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: showDivider
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 3),
                blurRadius: 6,
              ),
            ]
                : [],
          ),
          child: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            titleSpacing: 0,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: showBackArrow
                ? IconButton(
              onPressed: leadingOnPressed,
              icon: Icon(
                Icons.arrow_back,
                color: AColors.primary,
                size: 16,
              ),
            )
                : leadingIcon,
            title: title,
            actions: actions,
          ),
        ),

        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     AppBar(
        //       backgroundColor: backgroundColor,
        //       elevation: 0,
        //
        //       titleSpacing: 0,
        //       shadowColor: isDark ? Colors.black45 : Colors.black26,
        //       // Define shadow color
        //       surfaceTintColor: Colors.transparent,
        //       // For Material 3, remove surface tint
        //       scrolledUnderElevation: 0,
        //       centerTitle: true,
        //       automaticallyImplyLeading: false,
        //
        //       leading: showBackArrow
        //           ? IconButton(
        //               onPressed: leadingOnPressed,
        //               icon: Icon(
        //                 Icons.arrow_back,
        //                 color: JAppColors.primary,
        //                 size: 16,
        //               ),
        //             )
        //           : leadingIcon,
        //       title: title,
        //       actions: actions,
        //     ),
        //   ],
        // ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(ADeviceUtils.getAppBarHeight());
}
