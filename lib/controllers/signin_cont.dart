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

  /// SIGN IN FUNCTION (API Call Version - Uncomment when API is ready)
  /*
  Future<void> signIn() async {
    final email = emailController.text.trim();
    final pin = pinController.text.trim();

    if (!_isValidEmail(email)) {
      _showErrorToast('Please enter a valid email address.');
      return;
    }

    if (pin.isEmpty) {
      _showErrorToast('Password cannot be empty.');
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiService.signInEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': pin}),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final applicant = data['applicant'];

        final name = applicant['name'];
        final userEmail = applicant['email'];
        final userId = applicant['id']?.toString() ?? '';
        final userPhone = applicant['phone'] ?? '';

        if (userId.isEmpty) {
          debugPrint('Warning: User ID is empty in API response');
        }

        await StorageService.setLoggedIn(true);
        await StorageService.saveUserToken(token);
        await StorageService.saveUserName(name);
        await StorageService.saveUserEmail(userEmail);
        await StorageService.saveUserId(userId);
        // await StorageService.savePhoneNumber(userPhone);

        _showSuccessToast('Welcome, $name!');
        Get.offAll(() => NavBarNavigation());
      } else {
        final error = jsonDecode(response.body);
        _showErrorToast(error['message'] ?? 'Invalid credentials.');
      }
    } catch (e) {
      isLoading.value = false;
      _showErrorToast('Something went wrong. Please try again.');
      debugPrint('Login Error: $e');
    }
  }
  */

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
