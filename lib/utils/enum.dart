import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error, info, warning }

void showAppSnackBar(BuildContext context, String message, {SnackBarType type = SnackBarType.info}) {
  Color backgroundColor;
  Icon icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = const Icon(Icons.check_circle, color: Colors.white, size: 20);
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      icon = const Icon(Icons.error, color: Colors.white, size: 20);
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange;
      icon = const Icon(Icons.warning, color: Colors.white, size: 20);
      break;
    case SnackBarType.info:
    default:
      backgroundColor = Colors.blue;
      icon = const Icon(Icons.info, color: Colors.white, size: 20);
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}
