import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MenuItemWidget.dart';

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
    HapticFeedback.selectionClick();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Menu title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.apps,
                  color: Colors.teal,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Menu items
          MenuItemWidget(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              Navigator.pop(context);
              onPrivacyPolicyTap();
            },
          ),
          MenuItemWidget(
            icon: Icons.info,
            title: 'About App',
            subtitle: 'Learn about Afronika',
            onTap: () {
              Navigator.pop(context);
              onAboutAppTap();
            },
          ),
          MenuItemWidget(
            icon: Icons.contact_support,
            title: 'Contact',
            subtitle: 'Get in touch with us',
            onTap: () {
              Navigator.pop(context);
              onContactTap();
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
