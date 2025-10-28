import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../webview/AfronikaBrowserHelper.dart';

/// Handles navigation logic and back button behavior
/// during and outside of payment flows.
class PaymentNavigationHelper {
  /// Handles back navigation when payment is in progress.
  static Future<bool> handleWillPop({
    required BuildContext context,
    required bool isInPaymentFlow,
    required VoidCallback resetPaymentFlow,
    required String currentUrl,
    required InAppWebViewController webViewController,
    required void Function(bool isLoading, String url) onStateUpdate,
  }) async {
    if (isInPaymentFlow) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment in Progress'),
          content: const Text(
            'You are currently in a payment process. Are you sure you want to go back?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                resetPaymentFlow();
                Navigator.of(context).pop(true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );

      if (shouldExit == true) {
        resetPaymentFlow();
      }

      return shouldExit ?? false;
    }

    // Default browser back handling when not in payment flow
    return await AfronikaBrowserHelper.handleWillPop(
      context: context,
      currentUrl: currentUrl,
      webViewController: webViewController,
      onStateUpdate: onStateUpdate,
    );
  }
}
