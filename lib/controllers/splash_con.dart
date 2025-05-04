import 'package:get/get.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/core/storage_services.dart';
import 'dart:math';
import '../modules/features/auth/signIn_view.dart';
import '../modules/features/home/navbar/NavBar.dart';
import '../modules/features/onboarding/boarding.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final RxBool showLogo = false.obs;
  final RxBool showText = false.obs;
  final RxBool showScannerEffect = false.obs;
  final RxDouble loadingValue = 0.0.obs;
  final RxDouble animationValue = 0.0.obs;
  late AnimationController _animationController;

  @override
  void onInit() async {
    super.onInit();
    
    // Initialize StorageService if not already done
    await StorageService.init();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        animationValue.value = _animationController.value;
      });
    
    startAnimation();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  void startAnimation() async {
    // Start the background scanner lines animation
    _animationController.repeat();
    
    // Initial delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Show logo with animation
    showLogo.value = true;
    
    // Show scanning laser effect after logo appears
    await Future.delayed(const Duration(milliseconds: 800));
    showScannerEffect.value = true;
    
    // Show text elements
    await Future.delayed(const Duration(milliseconds: 500));
    showText.value = true;
    
    // Animate loading progress
    const loadingDuration = 2500; // milliseconds
    const steps = 20;
    final stepDuration = loadingDuration ~/ steps;
    
    for (int i = 0; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: stepDuration));
      loadingValue.value = min(1.0, (i / steps) + Random().nextDouble() * 0.1);
    }
    
    // Ensure we reach 100%
    loadingValue.value = 1.0;
    
    // Hide scanning laser effect
    showScannerEffect.value = false;
    
    // Brief pause before navigation
    await Future.delayed(const Duration(milliseconds: 500));
    
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    // Check if it's the first launch (this will be true only once)
    final isFirstLaunch = await StorageService.getFirstLaunchStatus();
    
    if (isFirstLaunch) {
      // First time user - show onboarding and mark launch as complete
      debugPrint('First launch - showing onboarding');
      await StorageService.setFirstLaunchStatus(false);
      Get.offAll(() => const Boarding());
      return;
    }
    
    // For all subsequent launches, check authentication status directly
    final isLoggedIn = StorageService.isLoggedIn();
    
    if (isLoggedIn) {
      // User is authenticated - go to home
      debugPrint('User is logged in, navigating to home');
      debugPrint('User data: ${StorageService.getUserData()}');
      Get.offAll(() => NavBarNavigation());
    } else {
      // User needs to authenticate
      debugPrint('User not logged in, navigating to sign in');
      Get.offAll(() => SignInView());
    }
  }
}