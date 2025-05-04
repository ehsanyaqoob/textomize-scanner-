import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/storage_services.dart';
import '../core/firebase/auth_service.dart';
import '../modules/features/home/navbar/NavBar.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SIGN IN FUNCTION using Firebase Auth & Firestore
  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    debugPrint('Attempting sign in user: $email');

    if (!_validateInputs(email, password)) {
      return;
    }

    isLoading.value = true;
    debugPrint('Starting authentication process');

    try {
      final userCredential = await _authService.signIn(email, password);
      final user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'Authentication failed - no user returned',
        );
      }

      debugPrint('User signed in successfully: ${user.uid}');
      debugPrint('User displayName: ${user.displayName}');
      debugPrint('User email: ${user.email}');

      // Fetch extra user details from Firestore
      final userData = await _fetchUserProfile(user.uid);

      // Save user details if 'Remember Me' is checked
      if (rememberMe.value) {
        await _saveUserDetails(user, userData);
      }

      _showSuccessToast('Welcome back!');
      _navigateToHome();

    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during sign in: ${e.code} - ${e.message}');
      _showErrorToast(e.message ?? 'Authentication failed');
    } catch (e) {
      debugPrint('Unexpected error during sign in: $e');
      _showErrorToast('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
      debugPrint('Sign in process completed');
    }
  }

  /// Fetches user profile data from Firestore
  Future<Map<String, dynamic>?> _fetchUserProfile(String uid) async {
    debugPrint('Fetching user profile from Firestore for UID: $uid');
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        debugPrint('User profile data found: ${doc.data()}');
        return doc.data();
      } else {
        debugPrint('User profile does not exist in Firestore.');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  /// Saves user details into SharedPreferences
  Future<void> _saveUserDetails(User user, Map<String, dynamic>? userData) async {
    debugPrint('Saving user details to SharedPreferences...');

    final userName = userData?['name'] ?? user.displayName ?? '';
    final userEmail = user.email ?? '';
    final userId = user.uid;
    final userRole = userData?['role'] ?? '';
    final userPhone = userData?['phone'] ?? '';

    debugPrint('UserName: $userName');
    debugPrint('UserEmail: $userEmail');
    debugPrint('UserId: $userId');
    debugPrint('UserRole: $userRole');
    debugPrint('UserPhone: $userPhone');

    await StorageService.setLoggedIn(true);
    await StorageService.saveUserName(userName);
    await StorageService.saveUserEmail(userEmail);
    await StorageService.saveUserId(userId);
    await StorageService.saveUserRole(userRole);      // You'll need to add this in StorageService
    await StorageService.saveUserPhone(userPhone);    // Add this too

    debugPrint('✅ All user details saved in SharedPreferences');
  }

  /// Navigates to the home screen
  void _navigateToHome() {
    debugPrint('Navigating to home screen...');
    Get.offAll(() => NavBarNavigation());
  }

  /// Validates email format
  bool _isValidEmail(String email) {
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);
    final isValid = regExp.hasMatch(email);
    if (!isValid) {
      debugPrint('Invalid email format: $email');
    }
    return isValid;
  }

  /// Validates the email and password inputs
  bool _validateInputs(String email, String password) {
    if (!_isValidEmail(email)) {
      _showErrorToast('Please enter a valid email address');
      return false;
    }

    if (password.isEmpty) {
      _showErrorToast('Password cannot be empty');
      return false;
    }

    if (password.length < 6) {
      _showErrorToast('Password must be at least 6 characters long');
      return false;
    }

    return true;
  }

  /// Displays an error toast message
  void _showErrorToast(String message) {
    debugPrint('Showing error toast: $message');
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red[700],
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Displays a success toast message
  void _showSuccessToast(String message) {
    debugPrint('Showing success toast: $message');
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green[700],
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    pinController.dispose();
    super.onClose();
  }
}
