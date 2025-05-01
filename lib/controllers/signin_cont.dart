import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // Import fluttertoast
import 'package:textomize/core/storage_services.dart';
import '../modules/features/home/navbar/NavBar.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  void signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!_isValidEmail(email)) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid email address',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return;
    }

    if (password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Password cannot be empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return;
    }

    if (password.length < 6) {
      Fluttertoast.showToast(
        msg: 'Password must be at least 6 characters long',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return;
    }

    isLoading.value = true;

    // Simulate API Call
    await Future.delayed(Duration(seconds: 2), () async {
      isLoading.value = false;

      // If login is successful, store the user session and their preference (rememberMe)
      if (rememberMe.value) {
        // Save login status if 'Remember Me' is checked
        await StorageService.setLoggedIn(true);
      }

      Fluttertoast.showToast(
        msg: 'You have successfully signed in!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      // Navigate to the NavBar screen
      Get.to(() => NavBarNavigation());
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
