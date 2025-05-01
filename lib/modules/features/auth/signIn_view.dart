import 'package:flutter/gestures.dart';
import 'package:textomize/core/exports.dart';
import '../../../controllers/signin_cont.dart';
import '../forgot/forgot_view.dart';
import 'signUp_view.dart';

class SignInView extends StatefulWidget {
  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final SignInController signInController = Get.put(SignInController());
  final RxBool visiblePassword = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Sign In",
        centerTitle: true,
      ),
      body: Obx(() {
        if (signInController.isLoading.value) {
          return CustomLoader();
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
               CustomText(
                text: 
                "Hello There!",
              
                  fontSize: 30.sp,
                  color: AppColors.greyColor,
                  fontWeight: FontWeight.w400,
              
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: 
                "Sign in to continue",
              
                  fontSize: 16.sp,
                  color: AppColors.greyColor,
                  fontWeight: FontWeight.w400,
              
              ),
              CustomTextFormField(
                controller: signInController.emailController,
                hint: "Enter your email",
                title: 'Email',
                inputType: TextInputType.emailAddress,
                prefix: Icon(Icons.mail_outline, size: 22.sp),
              ),
              Obx(() {
                return CustomTextFormField(
                  controller: signInController.passwordController,
                  hint: "Enter your password",
                  title: 'Password',
                  isObscure: !visiblePassword.value,
                  prefix: Icon(Icons.lock_outline, size: 22.sp),
                  suffix: IconButton(
                    icon: Icon(
                      visiblePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 22.sp,
                      color: AppColors.greyColor,
                    ),
                    onPressed: () {
                      visiblePassword.value = !visiblePassword.value;
                    },
                  ),
                );
              }),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return Row(
                      children: [
                        CustomCheckbox(
                          value: signInController.rememberMe.value,
                          onChanged: (val) => signInController.rememberMe.value = val ?? false,
                          activeColor: AppColors.primaryColor,
                        ),
                        CustomText(
                          text: 
                          "Remember Me",
                        fontSize: 14.sp
                        ),
                      ],
                    );
                  }),
                  GestureDetector(
                    onTap: () => Get.to(ForgotPassword()),
                    child: CustomText(
                      text: 
                      "Forgot Password?",
                 
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              CustomButton(
                title: "Sign In",
                onTap: () => signInController.signIn(),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.greyColor)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child:CustomText(
                      text: 
                      "or continue with",
                      fontSize: 14.sp, color: AppColors.greyColor),
                    
                  ),
                  Expanded(child: Divider(color: AppColors.greyColor)),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialIconButton(assetPath: 'assets/png/google.png'),
                  SocialIconButton(assetPath: 'assets/png/apple.png'),
                  SocialIconButton(assetPath: 'assets/png/facebook.png'),
                ],
              ),
              SizedBox(height: 30.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(fontSize: 14.sp, color: AppColors.greyColor),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(SignUpView()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}


class SocialIconButton extends StatelessWidget {
  final String assetPath;

  const SocialIconButton({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add social login functionality here
      },
      child: Container(
        height: 60.h,
        width: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(assetPath),
        ),
      ),
    );
  }
}
