import 'package:afronika/utils/constant/image_strings.dart';
import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final bool isDark;

  const CustomNavigationDrawer({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
      child: Column(
        children: [
          // Custom header with profile
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade400,
                  Colors.orange.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child:  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(GImagePath.googleImage), // Replace with your image
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // User Name
                const Text(
                  'Hi, Meshanii',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                // Email
                const Text(
                  'meshanii213@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Drawer content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Shop Section
                _buildSectionHeader('Shop'),
                _buildDrawerItem(
                  icon: Icons.checkroom,
                  title: 'Clothing',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.watch,
                  title: 'Smart Watches',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.phone_android,
                  title: 'Phones',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.laptop,
                  title: 'Laptops',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.tablet,
                  title: 'Tablests',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.tablet_mac,
                  title: 'Ipads',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_bag,
                  title: 'My Orders',
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(height: 16),

                // App Settings Section
                _buildSectionHeader('App Settings'),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItemWithTrailing(
                  icon: Icons.language,
                  title: 'Language',
                  trailing: 'English',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItemWithTrailing(
                  icon: Icons.brightness_6,
                  title: 'Theme',
                  trailing: 'Light',
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(height: 16),

                // Support Section
                _buildSectionHeader('Support'),
                _buildDrawerItem(
                  icon: Icons.contact_support,
                  title: 'Contact Us',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: 'FAQs',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.local_offer,
                  title: 'Discount',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.local_shipping,
                  title: 'Shipping & Returns',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItemWithTrailing(
                  icon: Icons.attach_money,
                  title: 'Currency',
                  trailing: 'USD',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Terms & Privacy Policy',
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(height: 16),

                // Logout
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
        color: iconColor ?? (isDark ? Colors.grey[300] : Colors.grey[700]),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor ?? (isDark ? Colors.grey[100] : Colors.grey[800]),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDrawerItemWithTrailing({
    required IconData icon,
    required String title,
    required String trailing,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
        color: iconColor ?? (isDark ? Colors.grey[300] : Colors.grey[700]),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor ?? (isDark ? Colors.grey[100] : Colors.grey[800]),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailing,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// Usage example in your main widget
