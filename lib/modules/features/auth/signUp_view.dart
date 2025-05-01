import 'package:flutter/gestures.dart';
import 'package:textomize/core/exports.dart';
import '../../../controllers/signUp_con.dart';
import 'signIn_view.dart';

class SignUpView extends StatefulWidget {
  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Create Account",
        centerTitle: true,
        onLeadingPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Welcome! ",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: "Please enter your information below to sign up.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: AppColors.greyColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /// Name
              CustomTextFormField(
                controller: signUpController.nameController,
                hint: "Full Name",
                title: 'Full Name',
                inputType: TextInputType.name,
                prefix: Icon(Icons.person_outline),
              ),

              /// Email
              CustomTextFormField(
                controller: signUpController.emailController,
                hint: "Email Address",
                title: 'Email',
                inputType: TextInputType.emailAddress,
                prefix: Icon(Icons.email_outlined),
              ),

              /// Phone
              CustomTextFormField(
                controller: signUpController.phoneNumberController,
                hint: "Phone Number",
                title: 'Phone',
                inputType: TextInputType.phone,
                prefix: Icon(Icons.phone_outlined),
              ),

              /// Password
              Obx(() => CustomTextFormField(
                    controller: signUpController.passwordController,
                    hint: "Create Password",
                    title: 'Password',
                    isObscure: !signUpController.isPasswordVisible.value,
                    prefix: Icon(Icons.lock_outline),
                    suffix: IconButton(
                      icon: Icon(
                        signUpController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.greyColor,
                      ),
                      onPressed: () => signUpController.isPasswordVisible.value =
                          !signUpController.isPasswordVisible.value,
                    ),
                  )),
              SizedBox(height: 16.h),

              /// Terms Checkbox
              Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCheckbox(
                        value: signUpController.termsAccepted.value,
                        onChanged: (bool value) =>
                            signUpController.termsAccepted.value = value,
                        activeColor: AppColors.primaryColor,
                        checkColor: Colors.white,
                        size: 30.0,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "I agree to the ",
                            style: TextStyle(
                                color: AppColors.greyColor, fontSize: 14.sp),
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 30.h),

              /// Sign Up Button
              Obx(() => CustomButton(
                    title: signUpController.isLoading.value
                        ? "Creating Account..."
                        : "Create Account",
                    onTap: signUpController.isLoading.value
                        ? null
                        : () => signUpController.signUp(),
                  )),
              SizedBox(height: 25.h),

              /// Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.greyColor)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      "or sign up with",
                      style:
                          TextStyle(fontSize: 14.sp, color: AppColors.greyColor),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.greyColor)),
                ],
              ),
              SizedBox(height: 20.h),

              /// Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialIconButton(assetPath: 'assets/png/google.png'),
                  SocialIconButton(assetPath: 'assets/png/apple.png'),
                  SocialIconButton(assetPath: 'assets/png/facebook.png'),
                ],
              ),
              SizedBox(height: 30.h),

              /// Already have account
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign In",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(SignInView()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        height: 50,
        width: 50,
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
