import 'package:textomize/core/exports.dart';
import 'package:textomize/core/storage_services.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';
import 'package:textomize/modules/features/home/navbar/NavBar.dart';
import 'package:textomize/modules/features/onboarding/boarding.dart';

class SplashController extends GetxController {
  var showLogo = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimationAndNavigation();
  }
void startAnimationAndNavigation() async {
  await Future.delayed(Duration(seconds: 1));
  showLogo.value = true;

  isLoading.value = true;
  await Future.delayed(Duration(seconds: 2));

  await StorageService.init();

  final isLoggedIn = await StorageService.isLoggedIn();  // NOW async ✅
  final seenOnboarding = await StorageService.hasSeenOnboarding();  // NOW async ✅

  print('DEBUG: isLoggedIn=$isLoggedIn, seenOnboarding=$seenOnboarding');

  isLoading.value = false;
  await Future.delayed(Duration(milliseconds: 300));

  if (isLoggedIn) {
    Get.offAll(() => NavBarNavigation());
  } else if (seenOnboarding) {
    Get.offAll(() => SignInView());
  } else {
    Get.offAll(() => Boarding());
  }
}
}