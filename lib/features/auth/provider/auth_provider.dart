import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../services/UserService.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  authenticating,
  emailVerificationPending
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final UserService _userService = UserService.instance;

  AuthStatus _status = AuthStatus.uninitialized;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isEmailVerified => _user?.emailVerified ?? false;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _updateAuthStatus();
    });
  }

  // Save user data to Realtime Database
  Future<void> _saveUserToRealtimeDB({
    required User user,
    String? phoneNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      DatabaseReference userRef = _database.ref('users/${user.uid}');

      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'createdAt': ServerValue.timestamp,
        'lastUpdated': ServerValue.timestamp,
        'isOnline': false,
        'lastSeen': ServerValue.timestamp,
        'accountType': 'email',
        'signupMethod': 'email_password',
        ...?additionalData,
      };

      // Add phone number if provided
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        userData['phoneNumber'] = phoneNumber;
      }

      // Remove null values
      userData.removeWhere((key, value) => value == null);

      await userRef.set(userData);
      print("✅ User data saved to Realtime Database");

      // Also update UserService
      await _userService.updateUserData(userData);
      print("✅ User data saved to UserService");

    } catch (e) {
      print("❌ Error saving user to Realtime DB: $e");
      throw Exception('Failed to save user data: $e');
    }
  }

  // Update user data in Realtime Database
  Future<void> _updateUserInRealtimeDB(Map<String, dynamic> updates) async {
    if (_user != null) {
      try {
        DatabaseReference userRef = _database.ref('users/${_user!.uid}');

        updates['lastUpdated'] = ServerValue.timestamp;

        await userRef.update(updates);
        print("✅ User data updated in Realtime Database: ${updates.keys.join(', ')}");

        // Also update UserService
        await _userService.updateUserData(updates);

      } catch (e) {
        print("❌ Error updating user in Realtime DB: $e");
      }
    }
  }

  void _updateAuthStatus() async {
    if (_user != null) {
      if (_user!.emailVerified) {
        _status = AuthStatus.authenticated;
        print("user is verified");

        // Save login state when user is authenticated and verified
        await _userService.saveUserLogin(
          user: _user!,
          isEmailVerified: true,
        );

        // Update verification status in Realtime DB
        await _updateUserInRealtimeDB({
          'emailVerified': true,
          'isOnline': true,
        });
      } else {
        _status = AuthStatus.emailVerificationPending;
        print("user is verification pending");

        // Save login state but mark email as not verified
        await _userService.saveUserLogin(
          user: _user!,
          isEmailVerified: false,
        );

        // Update verification status in Realtime DB
        await _updateUserInRealtimeDB({
          'emailVerified': false,
        });
      }
    } else {
      _status = AuthStatus.unauthenticated;
      print("user is not authenticated");

      // Clear login state when user is not authenticated
      await _userService.clearUserLogin();
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Sign Up with Email and Password - UPDATED WITH REALTIME DB
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {try {
      _setLoading(true);
      _setError(null);
      _status = AuthStatus.authenticating;
      notifyListeners();

      // Step 1: Create user account
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Step 2: Update user profile with name
        await result.user!.updateDisplayName(name);

        // Refresh user to get updated info
        await result.user!.reload();
        _user = _auth.currentUser;

        // Step 3: Save user data to Realtime Database BEFORE sending verification
        await _saveUserToRealtimeDB(
          user: _user!,
          phoneNumber: phoneNumber,
          additionalData: {
            'registrationComplete': false,
            'emailVerificationSent': false,
          },
        );

        // Step 4: Send email verification
        await sendEmailVerification();

        // Step 5: Update that verification email was sent
        await _updateUserInRealtimeDB({
          'emailVerificationSent': true,
          'verificationEmailSentAt': ServerValue.timestamp,
        });

        _status = AuthStatus.emailVerificationPending;

        // Step 6: Save user login state in UserService
        await _userService.saveUserLogin(
          user: _user!,
          isEmailVerified: false,
        );

        _setLoading(false);
        print("🎉 Signup successful - User data saved to Realtime DB");
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e));
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
      print("❌ Signup error: $e");
      return false;
    }
  }

  // Sign In with Email and Password
  Future<bool> signInWithEmailAndPassword({required String email, required String password,}) async {try {
      _setLoading(true);
      _setError(null);
      _status = AuthStatus.authenticating;
      notifyListeners();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        _user = result.user;
        if (result.user!.emailVerified) {
          _status = AuthStatus.authenticated;

          // Save authenticated user login state
          await _userService.saveUserLogin(
            user: _user!,
            isEmailVerified: true,
          );

          // Update login info in Realtime DB
          await _updateUserInRealtimeDB({
            'lastLoginAt': ServerValue.timestamp,
            'isOnline': true,
            'emailVerified': true,
          });
        } else {
          _status = AuthStatus.emailVerificationPending;

          // Save login state but not verified
          await _userService.saveUserLogin(
            user: _user!,
            isEmailVerified: false,
          );

          // Update login info in Realtime DB
          await _updateUserInRealtimeDB({
            'lastLoginAt': ServerValue.timestamp,
            'emailVerified': false,
          });
        }
        _setLoading(false);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e));
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        // Update Realtime DB that verification email was sent
        await _updateUserInRealtimeDB({
          'emailVerificationSent': true,
          'verificationEmailSentAt': ServerValue.timestamp,
        });

        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to send verification email. Please try again.');
      return false;
    }
  }

  // Check Email Verification Status - UPDATED VERSION
  Future<bool> checkEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reload(); // Force refresh from Firebase
        user = FirebaseAuth.instance.currentUser; // Get updated info

        if (user!.emailVerified) {
          print("✅ Email is verified");
          // Update the local user and status
          _user = user;
          _status = AuthStatus.authenticated;

          // Update UserService with verified status
          await _userService.updateEmailVerificationStatus(true);

          // Update Realtime DB with verification status
          await _updateUserInRealtimeDB({
            'emailVerified': true,
            'emailVerifiedAt': ServerValue.timestamp,
            'registrationComplete': true,
            'isOnline': true,
          });

          notifyListeners();
          return true;
        } else {
          print("❌ Email is NOT verified");
          // Keep status as emailVerificationPending
          _user = user;
          _status = AuthStatus.emailVerificationPending;

          // Update UserService with unverified status
          await _userService.updateEmailVerificationStatus(false);

          // Update Realtime DB
          await _updateUserInRealtimeDB({
            'emailVerified': false,
          });

          notifyListeners();
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Error checking email verification: $e");
      _setError('Failed to check email verification status.');
      return false;
    }
  }

  // Auto-login check for app startup
  Future<void> checkSavedLoginState() async {
    try {
      _setLoading(true);

      UserAuthStatus savedStatus = await _userService.getUserAuthStatus();

      switch (savedStatus) {
        case UserAuthStatus.authenticatedAndVerified:
        // User was logged in and verified - check if still valid with Firebase
          User? currentUser = _auth.currentUser;
          if (currentUser != null) {
            _user = currentUser;
            _status = AuthStatus.authenticated;

            // Update user presence in Realtime DB
            await _updateUserInRealtimeDB({
              'isOnline': true,
              'lastSeen': ServerValue.timestamp,
            });

            print("🔄 Auto-login: User authenticated and verified");
          } else {
            // Firebase session expired, clear saved state
            await _userService.clearUserLogin();
            _status = AuthStatus.unauthenticated;
          }
          break;

        case UserAuthStatus.authenticatedButNotVerified:
        // User was logged in but not verified
          User? currentUser = _auth.currentUser;
          if (currentUser != null) {
            _user = currentUser;
            _status = AuthStatus.emailVerificationPending;

            // Update presence but keep verification status
            await _updateUserInRealtimeDB({
              'lastSeen': ServerValue.timestamp,
            });

            print("🔄 Auto-login: User authenticated but not verified");
          } else {
            // Firebase session expired, clear saved state
            await _userService.clearUserLogin();
            _status = AuthStatus.unauthenticated;
          }
          break;

        case UserAuthStatus.notLoggedIn:
        default:
          _status = AuthStatus.unauthenticated;
          print("🔄 Auto-login: No saved login state");
          break;
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      print("Error checking saved login state: $e");
      _setLoading(false);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      await _auth.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Failed to send password reset email. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      // Update user as offline in Realtime DB before signing out
      if (_user != null) {
        await _updateUserInRealtimeDB({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });
      }

      await _auth.signOut();
      await _userService.clearUserLogin(); // Clear saved login state
      _user = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      print("🚪 User signed out and login state cleared");
      notifyListeners();
    } catch (e) {
      _setError('Failed to sign out. Please try again.');
    }
  }


  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'invalid-credential':
        return 'Invalid credentials provided.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}