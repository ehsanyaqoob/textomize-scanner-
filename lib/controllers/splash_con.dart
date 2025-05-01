import 'package:textomize/core/exports.dart';
import 'package:textomize/core/storage_services.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';
import 'package:textomize/modules/features/home/navbar/NavBar.dart';

class SplashController extends GetxController {
  var showLogo = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimationAndNavigation();
  }

  void startAnimationAndNavigation() async {
    // Step 1: Delay before showing logo
    await Future.delayed(const Duration(seconds: 1));
    showLogo.value = true;

    // Step 2: Show loader for splash effect
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    // Step 3: Initialize persistent storage
    await StorageService.init();

    // Step 4: Retrieve stored flag
    final isLoggedIn = await StorageService.isLoggedIn(); // Returns true if token exists

    // Step 5: Final delay before navigating
    isLoading.value = false;
    await Future.delayed(const Duration(milliseconds: 300));

    // Step 6: Route based on session
    if (isLoggedIn) {
      Get.offAll(() => NavBarNavigation());
    } else {
      Get.offAll(() => SignInView());
    }
  }
}

class FacebookProgressIndicator extends StatefulWidget {
  const FacebookProgressIndicator({super.key});

  @override
  State<FacebookProgressIndicator> createState() =>
      _FacebookProgressIndicatorState();
}

class _FacebookProgressIndicatorState extends State<FacebookProgressIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _a1, _a2, _a3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _a1 = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _a2 = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    _a3 = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_dot(_a1), _dot(_a2), _dot(_a3)],
    );
  }
}
