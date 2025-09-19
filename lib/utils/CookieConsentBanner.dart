import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookieConsentBanner extends StatefulWidget {
  const CookieConsentBanner({Key? key}) : super(key: key);

  @override
  State<CookieConsentBanner> createState() => _CookieConsentBannerState();
}

class _CookieConsentBannerState extends State<CookieConsentBanner> {
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  Future<void> _checkConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final consent = prefs.getBool("cookie_consent") ?? false;
    setState(() => _showBanner = !consent);
  }

  Future<void> _acceptConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("cookie_consent", true);
    setState(() => _showBanner = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "We use cookies to improve your experience. Do you accept?",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: _acceptConsent,
              child: const Text("Accept", style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
