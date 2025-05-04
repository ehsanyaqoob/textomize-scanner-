// import 'package:textomize/core/exports.dart';
// import '../../../../../controllers/smart_ai_controller.dart';
//
// class SmartAiView extends StatelessWidget {
//   SmartAiView({super.key});
//   final SmartAiController controller = Get.put(SmartAiController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: Obx(
//         () => Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: GridView.builder(
//             itemCount: controller.services.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 20,
//               mainAxisSpacing: 20,
//               childAspectRatio: 0.95,
//             ),
//             itemBuilder: (context, index) {
//               final service = controller.services[index];
//               return GestureDetector(
//                 onTap: service.onTap,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.white.withOpacity(0.7),
//                         Colors.white.withOpacity(0.3),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.white.withOpacity(0.2)),
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 12,
//                         spreadRadius: 2,
//                         color: Colors.black12,
//                         offset: Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 32,
//                         backgroundColor:
//                             AppColors.primaryColor.withOpacity(0.1),
//                         child: Icon(
//                           service.icon,
//                           size: 30,
//                           color: AppColors.primaryColor,
//                         ),
//                       ),
//                       CustomText(
//                         text: service.title,
//                         textAlign: TextAlign.center,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12.sp,
//                       ),
//                       6.height,
//                       CustomText(
//                         text: service.description,
//                         textAlign: TextAlign.center,
//                         fontSize: 10.sp,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textomize/core/exports.dart'; // Ensure this exports CustomText, AppColors, etc.
import '../../../../../controllers/smart_ai_controller.dart';

class SmartAiView extends StatelessWidget {
  SmartAiView({super.key});
  final SmartAiController controller = Get.put(SmartAiController());

  void _showPremiumPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                const Text(
                  "Go Premium",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Unlock all smart AI features,\npriority support, and unlimited usage.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to premium screen or perform action
                  },
                  child: Text(
                    "Upgrade Now",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Maybe later",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Obx(
            () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GridView.builder(
            itemCount: controller.services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return GestureDetector(
                onTap: () {
                  _showPremiumPopup(context);
                  // if (service.isPremium == true) {
                  //   _showPremiumPopup(context);
                  // } else {
                  //   service.onTap();
                  // }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 12,
                        spreadRadius: 2,
                        color: Colors.black12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                        child: Icon(
                          service.icon,
                          size: 30,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      CustomText(
                        text: service.title,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                      6.height,
                      CustomText(
                        text: service.description,
                        textAlign: TextAlign.center,
                        fontSize: 10.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
