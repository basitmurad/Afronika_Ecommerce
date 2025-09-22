import 'package:flutter/material.dart';

class CustomDialogWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final List<Widget> actions;
  final bool dismissible;

  const CustomDialogWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.actions,
    this.dismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: actions,
    );
  }
}
