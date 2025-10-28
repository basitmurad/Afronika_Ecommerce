import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// A helper class to show consistent payment success/failure dialogs
/// and handle corresponding navigation actions.
class PaymentDialogHelper {
  /// Shows a payment success dialog
  static void showPaymentSuccessDialog({
    required BuildContext context,
    required VoidCallback onRefresh,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Payment Success'),
          ],
        ),
        content: const Text('Your payment has been processed successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Future.delayed(const Duration(milliseconds: 500), onRefresh);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows a payment failure dialog
  static void showPaymentFailureDialog({
    required BuildContext context,
    required InAppWebViewController webViewController,
    String? paymentReturnUrl,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('Payment Failed'),
          ],
        ),
        content: const Text(
          'Your payment could not be processed. Would you like to try again?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (paymentReturnUrl != null) {
                webViewController.loadUrl(
                  urlRequest: URLRequest(url: WebUri(paymentReturnUrl)),
                );
              }
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
