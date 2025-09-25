import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'GButton.dart';

class NoInternetDialog extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetDialog({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.red),
          SizedBox(width: 8),
          Text('No Internet Connection'),
        ],
      ),
      content: const Text(
        'Please check your internet connection and try again.',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: [
        // Exit button
        AButton(
          buttonType: AButtonType.outlined,
          text: "Exit",
          onPressed: () => SystemNavigator.pop(),
        ),

        const SizedBox(height: 12),

        // Retry button
        AButton(
          text: 'Retry',
          onPressed: () {
            Navigator.of(context).pop(); // close dialog
            onRetry(); // call retry callback
          },
        ),
      ],
    );
  }
}
