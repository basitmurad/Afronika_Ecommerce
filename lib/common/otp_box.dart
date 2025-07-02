import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constant/app_test_style.dart';


class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final int index;
  final void Function(String value) onChanged;
  final VoidCallback onTap;

  const OtpBox({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.index,
    required this.onChanged,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 71,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        cursorColor: Colors.blue,
        style: AappTextStyle.roboto(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 44.0,
          weight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: controller.text.isNotEmpty
                  ? Colors.blue.shade300
                  : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: controller.text.isNotEmpty
              ? (isDark ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50)
              : (isDark ? Colors.grey.shade900 : Colors.grey.shade50),
        ),
        onChanged: onChanged,
        onTap: onTap,
      ),
    );
  }
}
