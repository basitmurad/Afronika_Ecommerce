import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onTap;

  const BackButtonWidget({
    super.key,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white : Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}
