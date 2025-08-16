import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper class for handling external URL launches
/// Supports Facebook, social media, email, and phone links
class UrlLauncherHelper {

  /// Handle Facebook URLs specifically
  static Future<void> handleFacebookUrl(String url, BuildContext context) async {
    try {
      print('🔵 Handling Facebook URL: $url');

      final Uri uri = Uri.parse(url);

      // For Facebook links, always use external browser/app
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        _showSuccessSnackBar(
          context: context,
          message: 'Opening Facebook...',
          backgroundColor: Colors.blue,
        );
      }
    } catch (e) {
      print('❌ Error launching Facebook URL: $e');
      _showErrorSnackBar(
        context: context,
        message: 'Could not open Facebook link',
      );
    }
  }

  /// Handle social media URLs (Instagram, Twitter, LinkedIn, YouTube, TikTok, etc.)
  static Future<void> handleSocialMediaUrl(String url, BuildContext context) async {
    try {
      print('📱 Handling Social Media URL: $url');

      final Uri uri = Uri.parse(url);

      // For social media links, always use external browser/app
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        String platform = _getSocialMediaPlatform(url);
        _showSuccessSnackBar(
          context: context,
          message: 'Opening $platform...',
          backgroundColor: Colors.purple,
        );
      }
    } catch (e) {
      print('❌ Error launching Social Media URL: $e');
      _showErrorSnackBar(
        context: context,
        message: 'Could not open social media link',
      );
    }
  }

  /// Handle external URLs (email, phone, etc.)
  static Future<void> handleExternalUrl(String url, BuildContext context) async {
    try {
      print('🚀 Attempting to launch: $url');

      final Uri uri = Uri.parse(url);

      // Check if the URL can be launched first
      bool canLaunch = await canLaunchUrl(uri);
      print('📱 Can launch URL: $canLaunch');

      if (canLaunch) {
        // Use external application mode to ensure it opens in external apps
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        print('✅ Launch result: $launched');

        if (launched) {
          // Show success feedback
          String appType = uri.scheme == 'mailto' ? 'email app' : 'phone app';
          _showSuccessSnackBar(
            context: context,
            message: 'Opening $appType...',
            backgroundColor: Colors.green,
          );
        }
      } else {
        print('❌ Cannot launch URL: $url');

        // Try alternative launch modes
        try {
          await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
          print('✅ Launched with alternative mode');
        } catch (e2) {
          print('❌ Alternative launch failed: $e2');
          throw e2;
        }
      }
    } catch (e) {
      print('❌ Error launching URL: $e');
      _showErrorSnackBarWithCopy(
        context: context,
        url: url,
        error: e.toString(),
      );
    }
  }

  /// Generic method to handle any URL based on its type
  static Future<void> handleUrl(String url, BuildContext context) async {
    // Check URL type and route to appropriate handler
    if (isFacebookUrl(url)) {
      await handleFacebookUrl(url, context);
    } else if (isSocialMediaUrl(url)) {
      await handleSocialMediaUrl(url, context);
    } else if (isExternalUrl(url)) {
      await handleExternalUrl(url, context);
    } else {
      // Default handling for other URLs
      await handleExternalUrl(url, context);
    }
  }

  // Public helper methods for URL checking

  /// Check if URL is a Facebook URL
  static bool isFacebookUrl(String url) {
    return url.contains('facebook.com') ||
        url.contains('fb.com') ||
        url.contains('m.facebook.com');
  }

  /// Check if URL is a social media URL
  static bool isSocialMediaUrl(String url) {
    return url.contains('instagram.com') ||
        url.contains('twitter.com') ||
        url.contains('linkedin.com') ||
        url.contains('youtube.com') ||
        url.contains('tiktok.com') ||
        url.contains('snapchat.com');
  }

  /// Check if URL is an external URL (mailto, tel, etc.)
  static bool isExternalUrl(String url) {
    return url.startsWith('mailto:') || url.startsWith('tel:');
  }

  // Private helper methods

  /// Get social media platform name from URL
  static String _getSocialMediaPlatform(String url) {
    if (url.contains('instagram.com')) return 'Instagram';
    if (url.contains('twitter.com')) return 'Twitter';
    if (url.contains('linkedin.com')) return 'LinkedIn';
    if (url.contains('youtube.com')) return 'YouTube';
    if (url.contains('tiktok.com')) return 'TikTok';
    if (url.contains('snapchat.com')) return 'Snapchat';
    return 'social media';
  }

  /// Show success snackbar
  static void _showSuccessSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Show error snackbar
  static void _showErrorSnackBar({
    required BuildContext context,
    required String message,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Show error snackbar with copy URL option
  static void _showErrorSnackBarWithCopy({
    required BuildContext context,
    required String url,
    required String error,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open: $url\nError: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Copy URL',
            textColor: Colors.white,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('URL copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}