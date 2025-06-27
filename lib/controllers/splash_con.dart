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
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        animationValue.value = _animationController.value;
      });
    
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      isLoading.value = true;
      
      // Initialize StorageService
      await StorageService.ensureInitialized();
      
      // Start animations
      startAnimation();
    } catch (e) {
      debugPrint('Error initializing app: $e');
      Get.snackbar(
        'Error', 
        'Failed to initialize app',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Fallback navigation if initialization fails
      Get.offAll(() => SignInView());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  Future<void> startAnimation() async {
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
    
    await navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    try {
      // Check if it's the first launch
      final isFirstLaunch = await StorageService.getFirstLaunchStatus();
      
      if (isFirstLaunch) {
        debugPrint('First launch - showing onboarding');
        await StorageService.setFirstLaunchStatus(false);
        Get.offAll(() => const Boarding());
        return;
      }
      
      // Check authentication status
      final isLoggedIn = await StorageService.isLoggedIn();
      final userData = await StorageService.getUserData();
      
      debugPrint('User login status: $isLoggedIn');
      debugPrint('User data: $userData');
      
      if (isLoggedIn && userData != null) {
        debugPrint('User is logged in, navigating to home');
        Get.offAll(() => NavBarNavigation());
      } else {
        debugPrint('User not logged in, navigating to sign in');
        Get.offAll(() => SignInView());
      }
    } catch (e) {
      debugPrint('Error during navigation decision: $e');
      // Fallback to sign in view if something goes wrong
      Get.offAll(() => SignInView());
    }
  }
}