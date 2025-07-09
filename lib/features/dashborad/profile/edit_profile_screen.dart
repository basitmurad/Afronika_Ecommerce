import 'package:afronika/common/GButton.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/sizes.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

// Profile Edit Screen (Image 1)
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController nameController = TextEditingController(text: 'Meshanii');
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController(text: 'meshanii123@gmail.com');
  final TextEditingController phoneController = TextEditingController(text: '+1 (555) XXX-000');

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

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
        actions: [
          TextButton(
            onPressed: () {
              // Save profile changes
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: AappTextStyle.roboto(
                color: Colors.blue,
                fontSize: 16,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                    child: const CircleAvatar(
                      radius: 58,
                      backgroundImage: AssetImage('assets/images/profile_avatar.png'),
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
                        color: Colors.blue,
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
                'Change Photo',
                style: AappTextStyle.roboto(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  weight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              // Name Field
              TextInputWidget(
                headerText: 'Name',
                hintText: 'Enter your name',
                controller: nameController,
                dark: isDark,
              ),

              SizedBox(height: ASizes.spaceBtwInputFields),


              // Email Field
              TextInputWidget(
                headerText: 'Email',
                hintText: 'Enter your email',
                controller: emailController,
                dark: isDark,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: ASizes.spaceBtwInputFields),

              // Phone Field
              TextInputWidget(
                headerText: 'Phone',
                hintText: 'Enter your phone number',
                controller: phoneController,
                dark: isDark,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

