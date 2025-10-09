import 'package:flutter/material.dart';

class CookieBanner extends StatelessWidget {
  final Animation<double> animation;
  final Function(bool) onConsent;

  const CookieBanner({
    super.key,
    required this.animation,
    required this.onConsent,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizeTransition(
        sizeFactor: animation,
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.grey[900],
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cookie Consent',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We use cookies to enhance your browsing experience. By continuing to use this site, you consent to our use of cookies.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => onConsent(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white),
                        ),
                        child: Text('Reject'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => onConsent(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
