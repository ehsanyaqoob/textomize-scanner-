import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textomize/core/storage_services.dart';
import '../modules/features/home/navbar/NavBar.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pinController = TextEditingController();  // Optional: if you're using a PIN

  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  /// SIGN IN FUNCTION (Simulated Login)
  void signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!_isValidEmail(email)) {
      _showErrorToast('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      _showErrorToast('Password cannot be empty');
      return;
    }

    if (password.length < 6) {
      _showErrorToast('Password must be at least 6 characters long');
      return;
    }

    isLoading.value = true;

    // Simulate API Call Delay
    await Future.delayed(Duration(seconds: 2), () async {
      isLoading.value = false;

      if (rememberMe.value) {
        await StorageService.setLoggedIn(true);
        await StorageService.saveUserName("Demo User");
        await StorageService.saveUserEmail(email);
        await StorageService.saveUserId("123");  // Simulated user ID
      }

      _showSuccessToast('You have successfully signed in!');
      Get.offAll(() => NavBarNavigation());
    });
  }
Future<void> signInWithMock() async {
  final email = emailController.text.trim();
  final pin = pinController.text.trim();

  if (email.isEmpty || !_isValidEmail(email)) {
    _showErrorToast('Enter a valid email address.');
    return;
  }

  if (pin.isEmpty) {
    _showErrorToast('Enter your password.');
    return;
  }

  isLoading.value = true;

  try {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // ✔️ Only save when user successfully signs in (no dummy data)
    await StorageService.setLoggedIn(true);
    await StorageService.saveUserToken('token_${DateTime.now().millisecondsSinceEpoch}');
    await StorageService.saveUserName(email.split('@').first.capitalizeFirst ?? 'User');  // Name from email
    await StorageService.saveUserEmail(email);
    // Id optional: you can skip or generate dynamically if needed
    await StorageService.saveUserId(DateTime.now().millisecondsSinceEpoch.toString());

    isLoading.value = false;

    _showSuccessToast('Welcome, ${email.split('@').first.capitalizeFirst}!');
    Get.offAll(() => NavBarNavigation());
  } catch (e) {
    isLoading.value = false;
    _showErrorToast('Something went wrong. Please try again.');
    debugPrint('Login Error: $e');
  }
}

  /// Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Show error toast
  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,  // 👈 better UX than TOP
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show success toast
  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,  // 👈 better UX than TOP
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Dispose controllers
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    pinController.dispose();
    super.onClose();
  }
}
