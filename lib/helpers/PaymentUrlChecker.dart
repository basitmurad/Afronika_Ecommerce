class PaymentUrlChecker {
  /// List of common payment-related URL patterns
  static final List<String> _paymentPatterns = [
    'payment',
    'checkout',
    'pay',
    'stripe',
    'paypal',
    'razorpay',
    'paytm',
    'gateway',
    '/cart/pay',
    '/payment/',
    '/checkout/',
    'billing',
    'purchase',
    'transaction',
  ];

  /// Checks if a given URL is related to payment processing
  static bool isPaymentUrl(String url) {
    final lowerUrl = url.toLowerCase();
    return _paymentPatterns.any((pattern) => lowerUrl.contains(pattern));
  }
}
