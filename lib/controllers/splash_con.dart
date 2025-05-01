import 'package:get/get.dart';
import 'package:textomize/core/storage_services.dart';
import '../modules/features/auth/signIn_view.dart';
import '../modules/features/onboarding/boarding.dart';
import '../modules/features/home/navbar/NavBar.dart';
class SplashController extends GetxController {
  final RxBool isVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    _startSplash();
  }

  void _startSplash() async {
    // Show loading spinner
    isVisible.value = true;

    await Future.delayed(const Duration(seconds: 2));  // Splash wait time

    // Initialize the Storage Service to get preferences
    await StorageService.init();

    bool isLoggedIn = StorageService.isLoggedIn(); // Check if logged in
    bool seenOnboarding = StorageService.hasSeenOnboarding(); // Check if onboarding is seen

    print('Is Logged In: $isLoggedIn');  // Debugging line
    print('Seen Onboarding: $seenOnboarding');  // Debugging line

    // Hide the loading spinner before navigating
    isVisible.value = false;

    await Future.delayed(const Duration(milliseconds: 200));  // Brief pause before navigation

    if (isLoggedIn) {
      // Scenario 3: Directly go to Home if logged in and session exists
      Get.offAll(() => NavBarNavigation());
    } else {
      if (seenOnboarding) {
        // Scenario 2: If not logged in but onboarding is seen, go to SignIn
        Get.offAll(() => SignInView());
      } else {
        // Scenario 1: If not logged in and onboarding hasn't been seen, go to Boarding
        Get.offAll(() => Boarding());  
      }
    }
  }
}
