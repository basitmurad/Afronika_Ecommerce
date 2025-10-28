import 'package:flutter/foundation.dart';

/// A helper class to detect payment status based on URL patterns.
class PaymentStatusChecker {
  /// Common URL indicators for successful payments.
  static final List<String> _successPatterns = [
    'success',
    'complete',
    'confirmed',
    'thank',
    'receipt',
    'confirmation',
  ];

  /// Common URL indicators for failed or cancelled payments.
  static final List<String> _failurePatterns = [
    'cancel',
    'failed',
    'error',
    'declined',
    'timeout',
    'abort',
  ];

  /// Checks whether a given URL indicates a successful payment.
  static bool isPaymentSuccess(String url) {
    final lowerUrl = url.toLowerCase();
    final result = _successPatterns.any((pattern) => lowerUrl.contains(pattern));

    if (kDebugMode && result) {
      debugPrint('✅ Payment success detected in URL: $url');
    }

    return result;
  }

  /// Checks whether a given URL indicates a failed or cancelled payment.
  static bool isPaymentFailure(String url) {
    final lowerUrl = url.toLowerCase();
    final result = _failurePatterns.any((pattern) => lowerUrl.contains(pattern));

    if (kDebugMode && result) {
      debugPrint('❌ Payment failure detected in URL: $url');
    }

    return result;
  }

  /// Checks if the user has returned to the main page after payment.
  static bool isReturnUrl(String url, String? returnUrl) {
    if (returnUrl == null) return false;
    final result = url.contains(returnUrl);

    if (kDebugMode && result) {
      debugPrint('↩️ Return URL detected: $url');
    }

    return result;
  }
}
