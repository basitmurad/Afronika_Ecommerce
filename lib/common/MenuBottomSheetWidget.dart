import 'package:flutter/material.dart';

class MenuBottomSheetWidget extends StatelessWidget {
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onAboutAppTap;
  final VoidCallback onContactTap;

  const MenuBottomSheetWidget({
    super.key,
    required this.onPrivacyPolicyTap,
    required this.onAboutAppTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          _buildMenuButton(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: onPrivacyPolicyTap,
          ),
          _buildMenuButton(
            icon: Icons.info,
            title: 'About App',
            onTap: onAboutAppTap,
          ),
          _buildMenuButton(
            icon: Icons.contact_support,
            title: 'Contact Us',
            onTap: onContactTap,
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}


