import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:url_launcher/url_launcher.dart' hide launchUrl;

class UrlLauncherHelper {
  static bool isExternalUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    return !url.contains('afronika.com') &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  static bool isFacebookUrl(String url) {
    return url.contains('facebook.com') ||
        url.contains('fb.com') ||
        url.contains('fb.me');
  }

  static bool isSocialMediaUrl(String url) {
    final socialDomains = [
      'instagram.com', 'twitter.com', 'x.com', 'linkedin.com',
      'youtube.com', 'youtu.be', 'tiktok.com', 'snapchat.com',
      'pinterest.com', 'reddit.com', 'whatsapp.com'
    ];
    return socialDomains.any((domain) => url.contains(domain));
  }

  static Future<void> handleUrl(String url, BuildContext context) async {
    if (url.startsWith('tel:')) {
      await launchUrl(Uri.parse(url));
    } else if (url.startsWith('mailto:')) {
      await launchUrl(Uri.parse(url));
    } else if (isFacebookUrl(url)) {
      handleFacebookUrl(url, context);
    } else if (isSocialMediaUrl(url)) {
      handleSocialMediaUrl(url, context);
    } else {
      handleExternalUrl(url, context);
    }
  }

  static void handleFacebookUrl(String url, BuildContext context) {
    _launchExternalUrl(url, context, 'Facebook');
  }

  static void handleSocialMediaUrl(String url, BuildContext context) {
    _launchExternalUrl(url, context, 'Social Media');
  }

  static void handleExternalUrl(String url, BuildContext context) {
    _launchExternalUrl(url, context, 'External Link');
  }

  static Future<void> _launchExternalUrl(String url, BuildContext context, String type) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
        );
      } else {
        _showLaunchError(context, type);
      }
    } catch (e) {
      _showLaunchError(context, type);
    }
  }

  static void _showLaunchError(BuildContext context, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not open $type link'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
