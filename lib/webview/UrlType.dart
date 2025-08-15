import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

enum UrlType {
  email,
  phone,
  facebook,
  instagram,
  twitter,
  linkedin,
  youtube,
  tiktok,
  snapchat,
  socialMedia,
  external,
  web
}

class UrlLauncherHelper {
  static const Map<String, String> _platformNames = {
    'facebook.com': 'Facebook',
    'fb.com': 'Facebook',
    'm.facebook.com': 'Facebook',
    'instagram.com': 'Instagram',
    'twitter.com': 'Twitter',
    'x.com': 'X (Twitter)',
    'linkedin.com': 'LinkedIn',
    'youtube.com': 'YouTube',
    'tiktok.com': 'TikTok',
    'snapchat.com': 'Snapchat',
    'whatsapp.com': 'WhatsApp',
  };

  /// Determines the type of URL based on its content
  static UrlType _determineUrlType(String url) {
    final lowercaseUrl = url.toLowerCase();

    if (lowercaseUrl.startsWith('mailto:')) {
      return UrlType.email;
    } else if (lowercaseUrl.startsWith('tel:')) {
      return UrlType.phone;
    } else if (lowercaseUrl.contains('facebook.com') ||
        lowercaseUrl.contains('fb.com') ||
        lowercaseUrl.contains('m.facebook.com')) {
      return UrlType.facebook;
    } else if (lowercaseUrl.contains('instagram.com')) {
      return UrlType.instagram;
    } else if (lowercaseUrl.contains('twitter.com') || lowercaseUrl.contains('x.com')) {
      return UrlType.twitter;
    } else if (lowercaseUrl.contains('linkedin.com')) {
      return UrlType.linkedin;
    } else if (lowercaseUrl.contains('youtube.com') || lowercaseUrl.contains('youtu.be')) {
      return UrlType.youtube;
    } else if (lowercaseUrl.contains('tiktok.com')) {
      return UrlType.tiktok;
    } else if (lowercaseUrl.contains('snapchat.com')) {
      return UrlType.snapchat;
    } else if (_isSocialMediaUrl(lowercaseUrl)) {
      return UrlType.socialMedia;
    } else if (lowercaseUrl.startsWith('http')) {
      return UrlType.web;
    } else {
      return UrlType.external;
    }
  }

  /// Checks if URL is a social media platform
  static bool _isSocialMediaUrl(String url) {
    return _platformNames.keys.any((domain) => url.contains(domain));
  }

  /// Gets the platform name from URL
  static String _getPlatformName(String url) {
    final lowercaseUrl = url.toLowerCase();

    for (final entry in _platformNames.entries) {
      if (lowercaseUrl.contains(entry.key)) {
        return entry.value;
      }
    }

    final urlType = _determineUrlType(url);
    switch (urlType) {
      case UrlType.email:
        return 'Email';
      case UrlType.phone:
        return 'Phone';
      default:
        return 'App';
    }
  }

  /// Main method to launch any URL with proper handling
  static Future<bool> launchURL({
    required String url,
    BuildContext? context,
    bool showFeedback = true,
  }) async {
    try {
      print('🚀 Attempting to launch: $url');

      final Uri uri = Uri.parse(url);
      final UrlType urlType = _determineUrlType(url);
      final String platformName = _getPlatformName(url);

      // Check if the URL can be launched
      bool canLaunch = await canLaunchUrl(uri);
      print('📱 Can launch URL: $canLaunch for type: $urlType');

      if (!canLaunch) {
        print('❌ Cannot launch URL: $url');
        if (context != null && showFeedback) {
          _showErrorSnackBar(context, url, 'URL cannot be opened on this device');
        }
        return false;
      }

      // Determine launch mode based on URL type
      LaunchMode launchMode = _getLaunchMode(urlType);

      // Attempt to launch the URL
      bool launched = await launchUrl(uri, mode: launchMode);

      if (launched) {
        print('✅ Successfully launched: $url');
        if (context != null && showFeedback) {
          _showSuccessSnackBar(context, platformName, urlType);
        }
        return true;
      } else {
        // Try alternative launch modes if the first attempt fails
        return await _tryAlternativeLaunchModes(uri, url, context, platformName, showFeedback);
      }

    } catch (e) {
      print('❌ Error launching URL: $e');
      if (context != null && showFeedback) {
        _showErrorSnackBar(context, url, e.toString());
      }
      return false;
    }
  }

  /// Determines the appropriate launch mode for different URL types
  static LaunchMode _getLaunchMode(UrlType urlType) {
    switch (urlType) {
      case UrlType.email:
      case UrlType.phone:
        return LaunchMode.externalNonBrowserApplication;
      case UrlType.facebook:
      case UrlType.instagram:
      case UrlType.twitter:
      case UrlType.linkedin:
      case UrlType.youtube:
      case UrlType.tiktok:
      case UrlType.snapchat:
      case UrlType.socialMedia:
        return LaunchMode.externalApplication;
      case UrlType.web:
        return LaunchMode.externalApplication;
      default:
        return LaunchMode.externalApplication;
    }
  }

  /// Tries alternative launch modes if the primary mode fails
  static Future<bool> _tryAlternativeLaunchModes(
      Uri uri,
      String url,
      BuildContext? context,
      String platformName,
      bool showFeedback
      ) async {
    final List<LaunchMode> alternativeModes = [
      LaunchMode.externalApplication,
      LaunchMode.externalNonBrowserApplication,
      LaunchMode.inAppBrowserView,
      LaunchMode.platformDefault,
    ];

    for (final mode in alternativeModes) {
      try {
        print('🔄 Trying alternative launch mode: $mode');
        bool launched = await launchUrl(uri, mode: mode);
        if (launched) {
          print('✅ Successfully launched with mode: $mode');
          if (context != null && showFeedback) {
            _showSuccessSnackBar(context, platformName, _determineUrlType(url));
          }
          return true;
        }
      } catch (e) {
        print('❌ Alternative mode $mode failed: $e');
        continue;
      }
    }

    // If all modes fail, show error
    if (context != null && showFeedback) {
      _showErrorSnackBar(context, url, 'Could not open link with any available method');
    }
    return false;
  }

  /// Shows success feedback to user
  static void _showSuccessSnackBar(BuildContext context, String platformName, UrlType urlType) {
    Color backgroundColor;
    String message;

    switch (urlType) {
      case UrlType.facebook:
        backgroundColor = Colors.blue;
        message = 'Opening $platformName...';
        break;
      case UrlType.instagram:
        backgroundColor = Colors.purple;
        message = 'Opening $platformName...';
        break;
      case UrlType.twitter:
        backgroundColor = Colors.lightBlue;
        message = 'Opening $platformName...';
        break;
      case UrlType.linkedin:
        backgroundColor = Colors.indigo;
        message = 'Opening $platformName...';
        break;
      case UrlType.youtube:
        backgroundColor = Colors.red;
        message = 'Opening $platformName...';
        break;
      case UrlType.email:
        backgroundColor = Colors.green;
        message = 'Opening email app...';
        break;
      case UrlType.phone:
        backgroundColor = Colors.green;
        message = 'Opening phone app...';
        break;
      default:
        backgroundColor = Colors.teal;
        message = 'Opening $platformName...';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Shows error feedback to user with copy URL option
  static void _showErrorSnackBar(BuildContext context, String url, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not open link\n${error.length > 50 ? error.substring(0, 50) + '...' : error}'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Copy URL',
          textColor: Colors.white,
          onPressed: () {
            copyToClipboard(url, context);
          },
        ),
      ),
    );
  }

  /// Copies URL to clipboard with feedback
  static Future<void> copyToClipboard(String text, BuildContext? context) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      print('📋 Copied to clipboard: $text');

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('URL copied to clipboard'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Error copying to clipboard: $e');
    }
  }

  /// Convenience methods for specific URL types
  static Future<bool> launchEmail(String email, {BuildContext? context}) {
    return launchURL(url: 'mailto:$email', context: context);
  }

  static Future<bool> launchPhone(String phone, {BuildContext? context}) {
    return launchURL(url: 'tel:$phone', context: context);
  }

  static Future<bool> launchSMS(String phone, {String? message, BuildContext? context}) {
    final url = message != null ? 'sms:$phone?body=${Uri.encodeComponent(message)}' : 'sms:$phone';
    return launchURL(url: url, context: context);
  }

  static Future<bool> launchWhatsApp(String phone, {String? message, BuildContext? context}) {
    final url = message != null
        ? 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}'
        : 'https://wa.me/$phone';
    return launchURL(url: url, context: context);
  }

  /// Validates if a URL is properly formatted
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.hasAuthority || uri.scheme == 'mailto' || uri.scheme == 'tel');
    } catch (e) {
      return false;
    }
  }

  /// Validates if an email address is properly formatted
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validates if a phone number contains only valid characters
  static bool isValidPhone(String phone) {
    return RegExp(r'^[\d\s\-\+\(\)]+$').hasMatch(phone);
  }
}