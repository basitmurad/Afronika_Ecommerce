import 'package:flutter/material.dart';

import 'GButton.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorDialog({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.orange),
          SizedBox(width: 8),
          Text('Connection Error'),
        ],
      ),
      content: Text(
        errorMessage.isNotEmpty
            ? errorMessage
            : 'Unable to load the page.',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: [
        // Cancel button
        AButton(
          buttonType: AButtonType.outlined,
          text: "Cancel",
          onPressed: () => Navigator.of(context).pop(),
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
