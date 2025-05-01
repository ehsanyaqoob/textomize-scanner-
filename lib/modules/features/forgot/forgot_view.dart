import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/auth/otp_view.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  // Initialize the controller using GetX
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Go Back',
        onLeadingPressed: () {
          Navigator.pop(context);
        },
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Create New password 🔑',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 30.h),
              CustomText(
                text: 'Please enter a new and strong password that will secure your account',
                fontSize: 12.sp,
              ),
              SizedBox(height: 30),

              // New Password Field
              CustomText(text: 'New password', fontSize: 20),
              Obx(() => CustomTextFormField(
                    controller: controller.newPasswordController,
                    hint: 'Password',
                    isObscure: !controller.isNewPasswordVisible.value,
                    prefix: Icon(Icons.lock, color: AppColors.greyColor, size: 25),
                    suffix: IconButton(
                      icon: Icon(
                        controller.isNewPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.greyColor,
                        size: 25,
                      ),
                      onPressed: controller.toggleNewPasswordVisibility,
                    ),
                  )),
              SizedBox(height: 20),

              // Confirm Password Field
              CustomText(text: 'Confirm new password', fontSize: 20),
              Obx(() => CustomTextFormField(
                    controller: controller.confirmNewPasswordController,
                    hint: 'Confirm Password',
                    isObscure: !controller.isConfirmPasswordVisible.value,
                    prefix: Icon(Icons.lock, color: AppColors.greyColor, size: 25),
                    suffix: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.greyColor,
                        size: 25,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  )),
              SizedBox(height: 40),

              // Continue Button
              CustomButton(
                title: 'Continue',
                onTap: () {
                  Get.to(OtpView());
                },
                topMargin: 30.0,
                fillColor: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
