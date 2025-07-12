import 'package:afronika/common/GButton.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/constant/sizes.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../services/UserService.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool isInitializing = true;
  Map<String, dynamic>? originalUserData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.getSavedUserData();
      if (userData != null) {
        setState(() {
          originalUserData = userData;
          nameController.text = userData['displayName'] ?? '';
          phoneController.text = userData['phoneNumber'] ?? '';
          isInitializing = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isInitializing = false;
      });
    }
  }

  // Add method to update Firebase Realtime Database
  Future<void> _updateUserInFirebase(Map<String, dynamic> updates) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DatabaseReference userRef = _database.ref('users/${user.uid}');

        // Create a new map to avoid modifying the original
        Map<String, dynamic> firebaseUpdates = Map<String, dynamic>.from(updates);

        // Add server timestamp for last update
        firebaseUpdates['lastUpdated'] = ServerValue.timestamp;

        await userRef.update(firebaseUpdates);
        print("✅ User data updated in Firebase Realtime Database: ${updates.keys.join(', ')}");
      } catch (e) {
        print("❌ Error updating user in Firebase Realtime DB: $e");
        throw Exception('Failed to update Firebase data: $e');
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorMessage('User not authenticated');
        return;
      }

      final String newName = nameController.text.trim();
      final String newPhone = phoneController.text.trim();

      // Step 1: Update display name in Firebase Auth
      await user.updateDisplayName(newName);

      // Step 2: Reload user to get updated info
      await user.reload();

      // Step 3: Prepare update data for UserService (without ServerValue.timestamp)
      final userServiceData = {
        'displayName': newName,
        'phoneNumber': newPhone,
      };

      // Step 4: Update user data in UserService (local storage)
      await _userService.updateUserData(userServiceData);

      // Step 5: Update user data in Firebase Realtime Database
      await _updateUserInFirebase(userServiceData);

      // Show success message
      _showSuccessMessage('Profile updated successfully!');

      // Go back to profile screen
      Navigator.pop(context, true); // Return true to indicate update success

    } catch (e) {
      print('Error updating profile: $e');
      String errorMessage = 'Failed to update profile';

      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Failed to update profile';
      } else if (e.toString().contains('Failed to update Firebase data')) {
        errorMessage = 'Failed to sync with server. Please try again.';
      }

      _showErrorMessage(errorMessage);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  bool _hasChanges() {
    return nameController.text.trim() != (originalUserData?['displayName'] ?? '') ||
        phoneController.text.trim() != (originalUserData?['phoneNumber'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    if (isInitializing) {
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Edit Profile',
            style: AappTextStyle.roboto(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              weight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: AappTextStyle.roboto(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            weight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Picture Section
                Stack(
                  children: [
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
                        backgroundImage: originalUserData?['photoURL'] != null
                            ? NetworkImage(originalUserData!['photoURL'])
                            : AssetImage(GImagePath.image1) as ImageProvider,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.black : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  'Photo update coming soon',
                  style: AappTextStyle.roboto(
                    color: Colors.grey,
                    fontSize: 14,
                    weight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 32),

                // Current Email Display (Read-only)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: AappTextStyle.roboto(
                          color: Colors.grey,
                          fontSize: 14,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              originalUserData?['email'] ?? 'No email',
                              style: AappTextStyle.roboto(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 16,
                                weight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email cannot be changed',
                        style: AappTextStyle.roboto(
                          color: Colors.grey,
                          fontSize: 12,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ASizes.spaceBtwInputFields),

                // Name Field
                TextInputWidget(
                  headerText: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: nameController,
                  dark: isDark,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: ASizes.spaceBtwInputFields),

                // Phone Field
                TextInputWidget(
                  headerText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  controller: phoneController,
                  dark: isDark,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 10) {
                        return 'Please enter a valid phone number';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 70),

                // Update Button
                AButton(
                  text: isLoading ? 'Updating...' : 'Update Profile',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: Colors.white,
                  onPressed: isLoading ? null : _updateProfile,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}