import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogHelper {
  /// Show exit confirmation dialog
  static Future<bool?> showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.exit_to_app, color: Colors.red),
            SizedBox(width: 8),
            Text('Exit App'),
          ],
        ),
        content: const Text('Are you sure you want to exit Afronika?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              HapticFeedback.lightImpact();
            },
            child: const Text(
              'Stay',
              style: TextStyle(color: Colors.teal),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              HapticFeedback.mediumImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
