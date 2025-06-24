// import 'package:textomize/core/assets.dart';
// import 'package:textomize/core/exports.dart';
//
// class SplashView extends StatelessWidget {
//   const SplashView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final SplashController controller = Get.put(SplashController());
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               AppColors.primaryColor,
//               AppColors.primaryColor.withOpacity(0.9),
//               AppColors.secondaryColor,
//             ],
//             stops: const [0.0, 0.5, 1.0],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Scanner animation effect in background
//             Positioned.fill(
//               child: CustomPaint(
//                 painter: _ScannerLinesPainter(
//                     animationValue: controller.animationValue.value),
//               ),
//             ),
//
//             // Centered Content
//             Align(
//               alignment: Alignment.center,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16.0, vertical: 40.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Animated Logo with scanner-like elements
//                     Obx(() => Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             AnimatedOpacity(
//                               opacity: controller.showLogo.value ? 1.0 : 0.0,
//                               duration: const Duration(seconds: 1),
//                               child: AnimatedScale(
//                                 scale: controller.showLogo.value ? 1.0 : 0.8,
//                                 duration: const Duration(milliseconds: 800),
//                                 child: Image.asset(
//                                   Assets.splashLogo,
//                                   width: 150.w,
//                                   height: 150.h,
//                                 ),
//                               ),
//                             ),
//                             if (controller.showScannerEffect.value)
//                               Positioned(
//                                 top: 0,
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 1500),
//                                   curve: Curves.easeInOut,
//                                   width: 150.w,
//                                   height: 3.h,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.white.withOpacity(0.8),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: AppColors.secondaryColor
//                                             .withOpacity(0.5),
//                                         blurRadius: 8,
//                                         spreadRadius: 2,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         )),
//
//                     SizedBox(height: 30.h),
//
//                     // App name with typography that suggests scanning
//                     Obx(() => AnimatedOpacity(
//                           opacity: controller.showText.value ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 800),
//                           child: Text(
//                             'Textomize',
//                             style: TextStyle(
//                               fontSize: 28.sp,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.white,
//                               letterSpacing: 1.5,
//                               shadows: [
//                                 Shadow(
//                                   blurRadius: 10,
//                                   color:
//                                       AppColors.secondaryColor.withOpacity(0.7),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )),
//
//                     SizedBox(height: 10.h),
//
//                     // Tagline
//                     Obx(() => AnimatedOpacity(
//                           opacity: controller.showText.value ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 1000),
//                           child: Text(
//                             'Smart Document Scanner',
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: AppColors.white.withOpacity(0.9),
//                               letterSpacing: 1.2,
//                             ),
//                           ),
//                         )),
//
//                     SizedBox(height: 40.h),
//
//                     // Scanner-style loading indicator
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Obx(() => AnimatedContainer(
//                               duration: const Duration(milliseconds: 500),
//                               width: 200.w,
//                               height: 4.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     AppColors.secondaryColor.withOpacity(
//                                         controller.loadingValue.value),
//                                     AppColors.white,
//                                     AppColors.secondaryColor.withOpacity(
//                                         controller.loadingValue.value),
//                                   ],
//                                   stops: const [0.0, 0.5, 1.0],
//                                 ),
//                               ),
//                             )),
//                         SizedBox(height: 15.h),
//                         Obx(() => Text(
//                               'Initializing scanner... ${(controller.loadingValue.value * 100).toInt()}%',
//                               style: TextStyle(
//                                 color: AppColors.white.withOpacity(0.8),
//                                 fontSize: 12.sp,
//                               ),
//                             )),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ScannerLinesPainter extends CustomPainter {
//   final double animationValue;
//
//   _ScannerLinesPainter({required this.animationValue});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppColors.white.withOpacity(0.05)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     // Draw horizontal scanner lines
//     for (double i = 0; i < size.height; i += 15) {
//       canvas.drawLine(
//         Offset(0, i + (animationValue * 30)),
//         Offset(size.width, i + (animationValue * 30)),
//         paint,
//       );
//     }
//
//     // Draw subtle grid pattern
//     final gridPaint = Paint()
//       ..color = AppColors.white.withOpacity(0.03)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 0.5;
//
//     for (double i = 0; i < size.width; i += 30) {
//       canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

import 'package:textomize/core/assets.dart';
import 'package:textomize/core/exports.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor,
              AppColors.secondaryColor,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Logo
                Obx(() => AnimatedOpacity(
                  opacity: controller.showLogo.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1000),
                  child: AnimatedScale(
                    scale: controller.showLogo.value ? 1.0 : 0.9,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    child: Image.asset(
                      Assets.splashLogo,
                      width: 120.w,
                      height: 120.h,
                    ),
                  ),
                )),

                // const SizedBox(height: 30),

                // App Title
                // Obx(() => AnimatedOpacity(
                //   opacity: controller.showText.value ? 1.0 : 0.0,
                //   duration: const Duration(milliseconds: 900),
                //   child: Text(
                //     'Textomize',
                //     style: TextStyle(
                //       fontSize: 26.sp,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //       letterSpacing: 1.2,
                //     ),
                //   ),
                // )),
                //
                // const SizedBox(height: 10),

                // Tagline
                Obx(() => AnimatedOpacity(
                  opacity: controller.showText.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1000),
                  child: Text(
                    'Smart Document Scanner',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )),

                const SizedBox(height: 40),

                // Loading Bar
                Obx(() => Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      width: 180.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor.withOpacity(
                                controller.loadingValue.value),
                            Colors.white,
                            AppColors.secondaryColor.withOpacity(
                                controller.loadingValue.value),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Loading... ${(controller.loadingValue.value * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
