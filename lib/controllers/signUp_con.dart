import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';
import '../core/firebase/auth_service.dart';
import '../core/storage_services.dart';

class SignUpController extends GetxController {
  // Controllers with late initialization
  late final TextEditingController nameController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool termsAccepted = false.obs;

  final AuthService _authService = AuthService();
  bool _controllersDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _controllersDisposed = false;
  }

  // Enhanced email validation
  bool isValidEmail(String email) {
    const pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      debugPrint('Invalid email format: $email');
      return false;
    }
    return true;
  }

  // Enhanced password validation
  bool isValidPassword(String password) {
    if (password.length < 8) {
      debugPrint('Password too short (${password.length} characters)');
      return false;
    }
    return true;
  }

  // Validate phone number
  bool isValidPhone(String phone) {
    if (phone.isEmpty || phone.length < 8) {
      debugPrint('Invalid phone number: $phone');
      return false;
    }
    return true;
  }

  // Validate name
  bool isValidName(String name) {
    if (name.isEmpty || name.length < 2) {
      debugPrint('Invalid name: $name');
      return false;
    }
    return true;
  }

  Future<void> signUp() async {
    if (_controllersDisposed) {
      debugPrint('Controllers were disposed, reinitializing');
      _initializeControllers();
    }

    final name = nameController.text.trim();
    final phone = phoneNumberController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    debugPrint('Starting sign up process...');
    debugPrint('Name: $name, Phone: $phone, Email: $email');

    if (!_validateFields(name, phone, email, password)) {
      return;
    }

    isLoading.value = true;

    try {
      final userCredential = await _authService.signUpAndSaveUser(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      await _saveUserData(name, phone, email, userCredential);
      await _authService.sendEmailVerification();

      _showSuccess(
        'Account created!',
        'A verification email has been sent. Please verify before signing in.',
      );

      await _navigateToSignIn();
      
    } on AuthException catch (e) {
      debugPrint('AuthException during sign up: ${e.code} - ${e.message}');
      _showError('Sign Up Failed', e.message);
    } catch (e) {
      debugPrint('Unexpected error during sign up: $e');
      _showError('Error', 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserData(String name, String phone, String email, UserCredential userCredential) async {
    await Future.wait([
      StorageService.saveUserName(name),
      StorageService.savePhoneNumber(phone),
      StorageService.saveUserEmail(email),
      StorageService.saveUserId(userCredential.user?.uid ?? ''),
    ]);
  }

  Future<void> _navigateToSignIn() async {
    // Clear form before navigation
    _clearForm();
    
    // Dispose controllers after navigation is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeDisposeControllers();
    });
    
    // Navigate using offAll with a new route
    Get.offAll(() => SignInView(), transition: Transition.noTransition);
  }

  void _safeDisposeControllers() {
    if (!_controllersDisposed) {
      nameController.dispose();
      phoneNumberController.dispose();
      emailController.dispose();
      passwordController.dispose();
      _controllersDisposed = true;
      debugPrint('Controllers safely disposed');
    }
  }

  bool _validateFields(String name, String phone, String email, String password) {
    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Error', 'Please fill in all fields');
      return false;
    }

    if (!isValidName(name)) {
      _showError('Error', 'Please enter a valid name');
      return false;
    }

    if (!isValidPhone(phone)) {
      _showError('Error', 'Please enter a valid phone number');
      return false;
    }

    if (!isValidEmail(email)) {
      _showError('Error', 'Please enter a valid email address');
      return false;
    }

    if (!isValidPassword(password)) {
      _showError('Error', 'Password should be at least 8 characters');
      return false;
    }

    if (!termsAccepted.value) {
      _showError('Error', 'You must accept the terms and conditions');
      return false;
    }

    return true;
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void _clearForm() {
    nameController.clear();
    phoneNumberController.clear();
    emailController.clear();
    passwordController.clear();
    termsAccepted.value = false;
  }

  @override
  void onClose() {
    _safeDisposeControllers();
    super.onClose();
  }
}