import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButtonsRow extends StatelessWidget {
  const SocialButtonsRow({super.key});

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: FontAwesomeIcons.instagram,
          color: Colors.red,
          onTap: () {
            _launchUrl('https://www.instagram.com/myafronika');

            debugPrint("Google button pressed");
          },
        ),
        _buildSocialButton(
          icon: FontAwesomeIcons.facebook,
          color: Colors.blue,
          onTap: () {
            _launchUrl('https://www.facebook.com/afronikahome');
            debugPrint("Facebook button pressed");
          },
        ),
        _buildSocialButton(
          icon: FontAwesomeIcons.twitter,
          color: Colors.lightBlue,
          onTap: () {
            _launchUrl('https://x.com/myafronika');
            debugPrint("Twitter button pressed");
          },
        ),
        _buildSocialButton(
          icon: FontAwesomeIcons.tiktok,
          color: Colors.black,
          onTap: () {

            _launchUrl('https://www.tiktok.com/@myafronika');

            debugPrint("GitHub button pressed");
          },
        ),
      ],
    );
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

}
