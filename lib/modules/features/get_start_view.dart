
import 'package:textomize/core/exports.dart';

import 'auth/signIn_view.dart';
import 'auth/signUp_view.dart';

class GetStartView extends StatefulWidget {

  @override
  State<GetStartView> createState() => _GetStartViewState();
}

class _GetStartViewState extends State<GetStartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/png/login.png',
                  height: 250.h,
                ),
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: "Let's you in",
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              SizedBox(height: 30.h),
              // Social Sign-In Buttons
              SocialSignInButton(
                title: 'Continue with Google',
                icon: 'assets/png/google.png',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  // Handle Google sign-in
                },
              ),
              SizedBox(height: 15.h),
              SocialSignInButton(
                title: 'Continue with Facebook',
                icon: 'assets/png/facebook.png',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  // Handle Facebook sign-in
                },
              ),
              SizedBox(height: 15.h),
              SocialSignInButton(
                title: 'Continue with Apple',
                icon: 'assets/png/apple.png',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  // Handle Apple sign-in
                },
              ),
              SizedBox(height: 20.h),
              // Separator with "or"
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomText(
                      text: "or",
                      color: Colors.grey,
                      fontSize: 18.sp,
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Sign-In with Password Button
              CustomButton(
                title: 'Sign in With Password',
                onTap: () {
                  Get.to(() => SignInView());
                },
              ),
              SizedBox(height: 10.h),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Don't have an account? ",
                    color: AppColors.primaryColor,
                    fontSize: 12.sp,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SignUpView());
                    },
                    child: CustomText(
                      text: "Sign Up",
                      color: AppColors.primaryColor,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialSignInButton extends StatelessWidget {
  final String title;
  final String icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const SocialSignInButton({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 30.h,
            ),
            SizedBox(width: 10.w),
            CustomText(
              text: title,
              fontSize: 16,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
