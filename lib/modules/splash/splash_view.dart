import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textomize/core/exports.dart';
import '../../core/constatnts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/png/LogoWhite.png',
              height: 100.h,
            ),
            SizedBox(height: 20.h),
            Obx(
              () => splashController.isVisible.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SpinKitFadingCircle(
                          color: AppColors.white,
                          size: 40.h,
                        ),
                        SizedBox(height: 8.h),
                        CustomText(
                          text: AppConstants.pleaseWait,
                          textAlign: TextAlign.center,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
