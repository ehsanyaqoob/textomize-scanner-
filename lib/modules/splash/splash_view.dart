import 'package:flutter_svg/svg.dart';
import 'package:textomize/core/assets.dart';
import 'package:textomize/core/exports.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.3),
                radius: 1.5,
                colors: [
               AppColors.primaryColor,
                  AppColors.primaryColor,
                   AppColors.primaryColor,
                ],
              ),
            ),
          ),

          // Animated bubbles or particles (subtle)
          Positioned.fill(
            child: Opacity(
              opacity: 0.08, // ⬆️ Slightly more visible
              child: Image.asset(
                Assets.particles,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Obx(() => AnimatedOpacity(
                    opacity: controller.showLogo.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    child: AnimatedScale(
                      scale: controller.showLogo.value ? 1.0 : 0.7,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Glowing logo container with subtle pulse
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 1.0, end: 1.05),
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            onEnd: () {
                              // Reverse pulse loop
                              controller.showLogo.value = !controller.showLogo.value;
                            },
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.secondaryColor.withOpacity(0.15),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(0.35),
                                    blurRadius: 50,
                                    spreadRadius: 15,
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                Assets.applogo,
                                width: 100.w,
                                height: 100.h,
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // Optional tagline
                          CustomText(
                            text: 'AI-powered text transformation',
                            fontSize: 16.sp,
                            color: AppColors.white,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40.h),

                          // Progress indicator
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: FacebookProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
