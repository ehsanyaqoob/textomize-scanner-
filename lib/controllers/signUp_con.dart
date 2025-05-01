import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';

class SignUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool termsAccepted = false.obs;

  // Function to validate the email format
  bool isValidEmail(String email) {
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  // Function to validate password strength (example: minimum 8 characters)
  bool isValidPassword(String password) {
    return password.length >= 8;
  }

  void signUp() async {
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (!termsAccepted.value) {
      Get.snackbar(
        'Error',
        'You must accept the terms and conditions',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (!isValidEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (!isValidPassword(passwordController.text)) {
      Get.snackbar(
        'Error',
        'Password should be at least 8 characters',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true; // Show loader

    // Simulate API Call
    await Future.delayed(Duration(seconds: 2));

    isLoading.value = false; // Hide loader
    Get.snackbar(
      'Success',
      'Account created successfully!',
      snackPosition: SnackPosition.TOP,
    );

    // Navigate to login or desired screen
    Get.offAll(SignInView());
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
