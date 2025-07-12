

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userDataKey = 'user_data';
  static const String _lastLoginKey = 'last_login';
  static const String _emailVerifiedKey = 'email_verified';

  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();

  UserService._();

  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save user login state
  Future<void> saveUserLogin({
    required User user,
    required bool isEmailVerified,
  }) async {
    await init();

    final userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': isEmailVerified,
    };

    await _prefs!.setBool(_isLoggedInKey, true);
    await _prefs!.setString(_userDataKey, json.encode(userData));
    await _prefs!.setBool(_emailVerifiedKey, isEmailVerified);
    await _prefs!.setString(_lastLoginKey, DateTime.now().toIso8601String());

    print("✅ User login state saved: ${user.email}");
  }

  // Update user data (NEW METHOD)
  Future<void> updateUserData(Map<String, dynamic> updates) async {
    await init();

    try {
      // Get existing user data
      Map<String, dynamic> currentUserData = {};
      String? userDataString = _prefs!.getString(_userDataKey);
      if (userDataString != null) {
        currentUserData = json.decode(userDataString);
      }

      // Merge updates with existing data
      currentUserData.addAll(updates);

      // Update last modified time
      currentUserData['lastModified'] = DateTime.now().toIso8601String();

      // Save updated data
      await _prefs!.setString(_userDataKey, json.encode(currentUserData));

      // Update specific keys if they exist in updates
      if (updates.containsKey('emailVerified')) {
        await _prefs!.setBool(_emailVerifiedKey, updates['emailVerified'] ?? false);
      }

      print("🔄 User data updated: ${updates.keys.join(', ')}");
      print("📋 Updated data: $currentUserData");

    } catch (e) {
      print("❌ Error updating user data: $e");
      throw Exception('Failed to update user data: $e');
    }
  }

  // Update specific user field (convenience method)
  Future<void> updateUserField(String field, dynamic value) async {
    await updateUserData({field: value});
  }

  // Update multiple user fields at once
  Future<void> updateUserFields(Map<String, dynamic> fields) async {
    await updateUserData(fields);
  }

  // Update email verification status
  Future<void> updateEmailVerificationStatus(bool isVerified) async {
    await updateUserData({'emailVerified': isVerified});
    print("📧 Email verification status updated: $isVerified");
  }

  // Update user profile from Firebase User object
  Future<void> updateUserFromFirebase(User user) async {
    await updateUserData({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
    });
    print("🔥 User data updated from Firebase");
  }

  // Sync user data with Firebase (useful after profile updates)
  Future<void> syncWithFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Refresh Firebase user data
      final refreshedUser = FirebaseAuth.instance.currentUser;
      if (refreshedUser != null) {
        await updateUserFromFirebase(refreshedUser);
      }
    }
  }

  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    await init();
    return _prefs!.getBool(_isLoggedInKey) ?? false;
  }

  // Check if email is verified
  Future<bool> isEmailVerified() async {
    await init();
    return _prefs!.getBool(_emailVerifiedKey) ?? false;
  }

  // Get saved user data
  Future<Map<String, dynamic>?> getSavedUserData() async {
    await init();
    String? userDataString = _prefs!.getString(_userDataKey);
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }

  // Get specific user field
  Future<dynamic> getUserField(String field) async {
    final userData = await getSavedUserData();
    return userData?[field];
  }

  // Get user display name
  Future<String?> getUserDisplayName() async {
    return await getUserField('displayName');
  }

  // Get user email
  Future<String?> getUserEmail() async {
    return await getUserField('email');
  }

  // Get user phone number
  Future<String?> getUserPhoneNumber() async {
    return await getUserField('phoneNumber');
  }

  // Get user photo URL
  Future<String?> getUserPhotoURL() async {
    return await getUserField('photoURL');
  }

  // Check if user data exists
  Future<bool> hasUserData() async {
    final userData = await getSavedUserData();
    return userData != null && userData.isNotEmpty;
  }

  // Get last login time
  Future<DateTime?> getLastLoginTime() async {
    await init();
    String? lastLoginString = _prefs!.getString(_lastLoginKey);
    if (lastLoginString != null) {
      return DateTime.parse(lastLoginString);
    }
    return null;
  }

  // Get last modified time
  Future<DateTime?> getLastModifiedTime() async {
    final userData = await getSavedUserData();
    if (userData != null && userData['lastModified'] != null) {
      return DateTime.parse(userData['lastModified']);
    }
    return null;
  }

  // Clear user login state (logout)
  Future<void> clearUserLogin() async {
    await init();
    await _prefs!.remove(_isLoggedInKey);
    await _prefs!.remove(_userDataKey);
    await _prefs!.remove(_lastLoginKey);
    await _prefs!.remove(_emailVerifiedKey);

    print("🚪 User login state cleared");
  }

  // Clear specific user field
  Future<void> clearUserField(String field) async {
    final userData = await getSavedUserData();
    if (userData != null) {
      userData.remove(field);
      await _prefs!.setString(_userDataKey, json.encode(userData));
      print("🗑️ User field '$field' cleared");
    }
  }

  // Check if login is still valid (optional: add expiry logic)
  Future<bool> isLoginValid() async {
    bool isLoggedIn = await isUserLoggedIn();
    if (!isLoggedIn) return false;

    DateTime? lastLogin = await getLastLoginTime();
    if (lastLogin == null) return false;

    // Optional: Check if login is older than 30 days
    Duration difference = DateTime.now().difference(lastLogin);
    if (difference.inDays > 30) {
      await clearUserLogin();
      return false;
    }

    return true;
  }

  // Get user authentication status
  Future<UserAuthStatus> getUserAuthStatus() async {
    bool isLoggedIn = await isLoginValid();
    if (!isLoggedIn) {
      return UserAuthStatus.notLoggedIn;
    }

    bool emailVerified = await isEmailVerified();
    if (emailVerified) {
      return UserAuthStatus.authenticatedAndVerified;
    } else {
      return UserAuthStatus.authenticatedButNotVerified;
    }
  }

  // Auto-login check for splash screen
  Future<String> getRedirectRoute() async {
    UserAuthStatus status = await getUserAuthStatus();

    switch (status) {
      case UserAuthStatus.authenticatedAndVerified:
        return 'navigationMenu'; // Replace with your actual route name
      case UserAuthStatus.authenticatedButNotVerified:
        return 'emailVerificationScreen'; // Replace with your actual route name
      case UserAuthStatus.notLoggedIn:
      default:
        return 'onboardingScreen'; // Replace with your actual route name
    }
  }

  // Validate user data integrity
  Future<bool> validateUserData() async {
    try {
      final userData = await getSavedUserData();
      if (userData == null) return false;

      // Check required fields
      return userData['uid'] != null && userData['email'] != null;
    } catch (e) {
      print("❌ Error validating user data: $e");
      return false;
    }
  }

  // Backup user data (returns JSON string)
  Future<String?> backupUserData() async {
    try {
      final userData = await getSavedUserData();
      if (userData != null) {
        return json.encode(userData);
      }
    } catch (e) {
      print("❌ Error backing up user data: $e");
    }
    return null;
  }

  // Restore user data from backup
  Future<bool> restoreUserData(String backupData) async {
    try {
      final userData = json.decode(backupData) as Map<String, dynamic>;
      await updateUserData(userData);
      return true;
    } catch (e) {
      print("❌ Error restoring user data: $e");
      return false;
    }
  }

  // Debug: Print all saved data
  Future<void> debugPrintSavedData() async {
    await init();
    print("=== USER SERVICE DEBUG ===");
    print("Is Logged In: ${await isUserLoggedIn()}");
    print("Email Verified: ${await isEmailVerified()}");
    print("User Data: ${await getSavedUserData()}");
    print("Last Login: ${await getLastLoginTime()}");
    print("Last Modified: ${await getLastModifiedTime()}");
    print("Data Valid: ${await validateUserData()}");
    print("========================");
  }
}

enum UserAuthStatus {
  notLoggedIn,
  authenticatedButNotVerified,
  authenticatedAndVerified,
}