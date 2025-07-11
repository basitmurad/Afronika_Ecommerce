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

  // Update email verification status
  Future<void> updateEmailVerificationStatus(bool isVerified) async {
    await init();
    await _prefs!.setBool(_emailVerifiedKey, isVerified);

    // Update user data as well
    String? userDataString = _prefs!.getString(_userDataKey);
    if (userDataString != null) {
      Map<String, dynamic> userData = json.decode(userDataString);
      userData['emailVerified'] = isVerified;
      await _prefs!.setString(_userDataKey, json.encode(userData));
    }

    print("📧 Email verification status updated: $isVerified");
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

  // Get last login time
  Future<DateTime?> getLastLoginTime() async {
    await init();
    String? lastLoginString = _prefs!.getString(_lastLoginKey);
    if (lastLoginString != null) {
      return DateTime.parse(lastLoginString);
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

  // Debug: Print all saved data
  Future<void> debugPrintSavedData() async {
    await init();
    print("=== USER SERVICE DEBUG ===");
    print("Is Logged In: ${await isUserLoggedIn()}");
    print("Email Verified: ${await isEmailVerified()}");
    print("User Data: ${await getSavedUserData()}");
    print("Last Login: ${await getLastLoginTime()}");
    print("========================");
  }
}

enum UserAuthStatus {
  notLoggedIn,
  authenticatedButNotVerified,
  authenticatedAndVerified,
}