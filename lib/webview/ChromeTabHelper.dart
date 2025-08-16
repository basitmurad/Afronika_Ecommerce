// chrome_tab_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:url_launcher/url_launcher.dart' hide launchUrl;

class ChromeTabHelper {

  /// Launch Google Sign-In in Chrome Custom Tab
  static Future<void> launchGoogleSignIn({
    required String url,
    required BuildContext context,
  }) async {
    try {
      await _launchInCustomTab(
        url: url,
        context: context,
        title: 'Sign in with Google',
        primaryColor: Colors.blue,
      );
    } catch (e) {
      print('Error launching Google Sign-In: $e');
      // Fallback to regular browser
      await _launchInBrowser(url);
    }
  }

  /// Launch any URL in Chrome Custom Tab with custom styling
  static Future<void> _launchInCustomTab({
    required String url,
    required BuildContext context,
    String? title,
    Color? primaryColor,
  }) async {
    final theme = Theme.of(context);

    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: primaryColor ?? theme.primaryColor,
            navigationBarColor: primaryColor ?? theme.primaryColor,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
          browser: const CustomTabsBrowserConfiguration(
            headers: {
              'User-Agent': 'AfronikaMobile/1.0',
            },
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: primaryColor ?? theme.primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      print('Custom tab launch failed: $e');
      // Fallback to regular browser
      await _launchInBrowser(url);
    }
  }

  /// Fallback method to launch in external browser
  static Future<void> _launchInBrowser(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
      );
    } catch (e) {
      print('Browser launch failed: $e');
    }
  }

  /// Check if the URL is a Google authentication URL
  static bool isGoogleAuthUrl(String url) {
    return url.contains('accounts.google.com') ||
        url.contains('oauth.google.com') ||
        url.contains('googleapis.com/oauth') ||
        url.contains('google.com/oauth') ||
        url.contains('accounts.youtube.com') ||
        url.startsWith('https://accounts.google.com/signin') ||
        url.startsWith('https://accounts.google.com/oauth');
  }

  /// Check if the URL is a sign-up/sign-in related URL
  static bool isAuthUrl(String url) {
    final authKeywords = [
      'signin', 'signup', 'login', 'register', 'auth', 'oauth',
      'sso', 'account', 'authentication'
    ];

    final lowercaseUrl = url.toLowerCase();
    return authKeywords.any((keyword) => lowercaseUrl.contains(keyword));
  }
}