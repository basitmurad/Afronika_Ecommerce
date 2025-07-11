import 'package:afronika/common/GButton.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/constant/sizes.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/UserService.dart';
import 'edit_profile_screen.dart';

// Profile View Screen with UserService Integration
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService.instance;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await _userService.getSavedUserData();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Profile Picture
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 58,
                    backgroundImage: userData?['photoURL'] != null
                        ? NetworkImage(userData!['photoURL'])
                        :  AssetImage('${GImagePath.image1}') as ImageProvider,
                    backgroundColor: Colors.grey,
                  ),
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  userData?['displayName'] ?? 'User Name',
                  style: AappTextStyle.roboto(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 24,
                    weight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                // Email
                Text(
                  userData?['email'] ?? 'user@example.com',
                  style: AappTextStyle.roboto(
                    color: Colors.grey,
                    fontSize: 16,
                    weight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 8),

                // Email Verification Status
                if (userData?['emailVerified'] == false)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Email not verified',
                          style: AappTextStyle.roboto(
                            color: Colors.orange,
                            fontSize: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Edit Profile Button
                AButton(
                  text: 'Edit Profile',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  textColor: isDark ? Colors.white : Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileEditScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  subtitle: 'View Your order history',
                  isDark: isDark,
                  onTap: () {
                    // Navigate to orders
                  },
                ),

                const SizedBox(height: 16),

                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'App preferences',
                  isDark: isDark,
                  onTap: () {
                    // Navigate to settings
                  },
                ),

                const SizedBox(height: 16),

                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Support & Help',
                  subtitle: '',
                  isDark: isDark,
                  onTap: () {
                    // Navigate to support
                  },
                ),

                const SizedBox(height: 16),

                _buildMenuItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: '',
                  isDark: isDark,
                  onTap: () {
                    // Navigate to privacy policy
                  },
                ),

                const SizedBox(height: 32),

                // Logout Button
                AButton(
                  text: 'Log Out',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: Colors.red,
                  buttonType: AButtonType.outlined,
                  onPressed: () {
                    _showLogoutDialog(context, isDark);
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required bool isDark,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AappTextStyle.roboto(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      weight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AappTextStyle.roboto(
                        color: Colors.grey,
                        fontSize: 14,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'Log Out',
            style: AappTextStyle.roboto(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              weight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: AappTextStyle.roboto(
              color: isDark ? Colors.grey[300]! : Colors.grey[700]!,
              fontSize: 16,
              weight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AappTextStyle.roboto(
                  color: Colors.grey,
                  fontSize: 16,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _handleLogout();
              },
              child: Text(
                'Log Out',
                style: AappTextStyle.roboto(
                  color: Colors.red,
                  fontSize: 16,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    try {
      // Clear user data from UserService
      await _userService.clearUserLogin();

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to login/onboarding screen
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          'onboardingScreen', // Replace with your actual route name
              (route) => false,
        );
      }
    } catch (e) {
      print('Error during logout: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}