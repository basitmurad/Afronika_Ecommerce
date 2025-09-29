// import 'package:flutter/animation.dart' show AnimationController;
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide WebResourceError;
// import 'package:webview_flutter/webview_flutter.dart';
//
// class AfronikaBrowserHelper {
//   static Future<Map<String, bool>> checkCookieConsent() async {
//     // Simulate checking stored consent
//     await Future.delayed(Duration(milliseconds: 100));
//     return {'showCookieBanner': true, 'cookiesAccepted': false};
//   }
//
//   static Future<void> handleCookieConsent({
//     required bool accept,
//     required InAppWebViewController webViewController,
//     required AnimationController bannerAnimationController,
//     required Function(bool, bool) onStateUpdate,
//   }) async {
//     // Animate banner out
//     await bannerAnimationController.reverse();
//
//     // Update state after animation
//     await Future.delayed(Duration(milliseconds: 300));
//     onStateUpdate(accept, false);
//
//     // Reload page with new consent
//     await webViewController.reload();
//   }
//
//   static void updateNavigationHistory(String url) {
//     // Implement navigation history tracking if needed
//   }
//
//   static String getErrorMessage(WebResourceError error, String message) {
//     switch (error.errorCode) {
//       case 1: // WebViewError.CONNECT
//         return "Internet connection failed. Please check your connectivity.";
//       case 2: // WebViewError.HTTP
//         return "Server error occurred. Please try again later.";
//       case 3: // WebViewError.SSL
//         return "Security certificate error. Please check the website URL.";
//       case 4: // WebViewError.TIMEOUT
//         return "Request timed out. Please check your internet connection.";
//       case 5: // WebViewError.UNSUPPORTED_SCHEME
//         return "Unsupported URL scheme.";
//       default:
//         return "An error occurred: ${error.description}";
//     }
//   }
//
//   static void showErrorDialog({
//     required BuildContext context,
//     required String errorMessage,
//     required VoidCallback onRetry,
//   }) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red),
//             SizedBox(width: 8),
//             Text('Connection Error'),
//           ],
//         ),
//         content: Text(errorMessage),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               onRetry();
//             },
//             child: Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static Future<void> loadInitialUrl({
//     required BuildContext context,
//     required WebViewController webViewController,
//     required String initialUrl,
//   }) async {
//     try {
//       await webViewController.loadRequest(Uri.parse(initialUrl));
//     } catch (e) {
//       showErrorDialog(
//         context: context,
//         errorMessage: "Failed to load the website: $e",
//         onRetry: () => loadInitialUrl(
//           context: context,
//           webViewController: webViewController,
//           initialUrl: initialUrl,
//         ),
//       );
//     }
//   }
//
//   static Future<void> refreshPage({
//     required BuildContext context,
//     required InAppWebViewController webViewController,
//     required Function(bool, bool, String) onStateUpdate,
//   }) async {
//     onStateUpdate(true, false, "");
//     try {
//       await webViewController.reload();
//     } catch (e) {
//       onStateUpdate(false, true, "Refresh failed: $e");
//     }
//   }
//
//   static Future<bool> handleWillPop({
//     required BuildContext context,
//     required String currentUrl,
//     required InAppWebViewController webViewController,
//     required Function(bool, String) onStateUpdate,
//   }) async {
//     if (await webViewController.canGoBack()) {
//       await webViewController.goBack();
//       final newUrl = await webViewController.getUrl() ?? currentUrl;
//       onStateUpdate(false, newUrl.toString());
//       return false;
//     } else {
//       final shouldExit = await showDialog<bool>(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Exit App?'),
//           content: Text('Are you sure you want to exit the application?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: Text('Exit'),
//             ),
//           ],
//         ),
//       );
//       return shouldExit ?? false;
//     }
//   }
// }
//


import 'package:flutter/animation.dart' show AnimationController;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide WebResourceError;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AfronikaBrowserHelper {
  static const String _cookieConsentKey = 'cookie_consent_accepted';
  static const String _cookieConsentSetKey = 'cookie_consent_set';

  static Future<Map<String, bool>> checkCookieConsent() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user has already made a choice
      final bool consentSet = prefs.getBool(_cookieConsentSetKey) ?? false;
      final bool cookiesAccepted = prefs.getBool(_cookieConsentKey) ?? false;

      return {
        'showCookieBanner': !consentSet, // Show banner only if consent not set
        'cookiesAccepted': cookiesAccepted,
      };
    } catch (e) {
      debugPrint('Error checking cookie consent: $e');
      // Default to showing banner if there's an error
      return {'showCookieBanner': true, 'cookiesAccepted': false};
    }
  }

  static Future<void> handleCookieConsent({
    required bool accept,
    required InAppWebViewController webViewController,
    required AnimationController bannerAnimationController,
    required Function(bool, bool) onStateUpdate,
  }) async {
    try {
      // Store the user's choice persistently
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_cookieConsentKey, accept);
      await prefs.setBool(_cookieConsentSetKey, true);

      debugPrint('Cookie consent stored: $accept');

      // Animate banner out
      await bannerAnimationController.reverse();

      // Update state after animation
      await Future.delayed(Duration(milliseconds: 300));
      onStateUpdate(accept, false); // cookies accepted, don't show banner

      // Reload page with new consent
      await webViewController.reload();
    } catch (e) {
      debugPrint('Error handling cookie consent: $e');
      // Still update UI even if storage fails
      await bannerAnimationController.reverse();
      await Future.delayed(Duration(milliseconds: 300));
      onStateUpdate(accept, false);
      await webViewController.reload();
    }
  }

  // Method to reset cookie consent (useful for testing or settings)
  static Future<void> resetCookieConsent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cookieConsentKey);
      await prefs.remove(_cookieConsentSetKey);
      debugPrint('Cookie consent reset');
    } catch (e) {
      debugPrint('Error resetting cookie consent: $e');
    }
  }

  // Method to get current cookie consent status
  static Future<bool?> getCookieConsentStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool consentSet = prefs.getBool(_cookieConsentSetKey) ?? false;

      if (!consentSet) return null; // No choice made yet

      return prefs.getBool(_cookieConsentKey) ?? false;
    } catch (e) {
      debugPrint('Error getting cookie consent status: $e');
      return null;
    }
  }

  static void updateNavigationHistory(String url) {
    // Implement navigation history tracking if needed
    debugPrint('Navigation history updated: $url');
  }

  static String getErrorMessage(WebResourceError error, String message) {
    switch (error.errorCode) {
      case 1: // WebViewError.CONNECT
        return "Internet connection failed. Please check your connectivity.";
      case 2: // WebViewError.HTTP
        return "Server error occurred. Please try again later.";
      case 3: // WebViewError.SSL
        return "Security certificate error. Please check the website URL.";
      case 4: // WebViewError.TIMEOUT
        return "Request timed out. Please check your internet connection.";
      case 5: // WebViewError.UNSUPPORTED_SCHEME
        return "Unsupported URL scheme.";
      default:
        return "An error occurred: ${error.description}";
    }
  }

  static void showErrorDialog({
    required BuildContext context,
    required String errorMessage,
    required VoidCallback onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Connection Error'),
          ],
        ),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  static Future<void> loadInitialUrl({
    required BuildContext context,
    required WebViewController webViewController,
    required String initialUrl,
  }) async {
    try {
      await webViewController.loadRequest(Uri.parse(initialUrl));
    } catch (e) {
      showErrorDialog(
        context: context,
        errorMessage: "Failed to load the website: $e",
        onRetry: () => loadInitialUrl(
          context: context,
          webViewController: webViewController,
          initialUrl: initialUrl,
        ),
      );
    }
  }

  static Future<void> refreshPage({
    required BuildContext context,
    required InAppWebViewController webViewController,
    required Function(bool, bool, String) onStateUpdate,
  }) async {
    onStateUpdate(true, false, "");
    try {
      await webViewController.reload();
    } catch (e) {
      onStateUpdate(false, true, "Refresh failed: $e");
    }
  }

  static Future<bool> handleWillPop({
    required BuildContext context,
    required String currentUrl,
    required InAppWebViewController webViewController,
    required Function(bool, String) onStateUpdate,
  }) async {
    if (await webViewController.canGoBack()) {
      await webViewController.goBack();
      final newUrl = await webViewController.getUrl() ?? currentUrl;
      onStateUpdate(false, newUrl.toString());
      return false;
    } else {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App?'),
          content: Text('Are you sure you want to exit the application?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Exit'),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    }
  }
}