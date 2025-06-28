import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/core/storage_services.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';
import 'package:textomize/screens/help_support.dart';
import 'package:textomize/screens/notify_view.dart';

class AccountController extends GetxController {
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxBool isLoading = true.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      final userData = await StorageService.getUserData();
      
      name.value = userData?['name'] ?? 'Guest User';
      email.value = userData?['email'] ?? 'No email provided';
      
      final imagePath = userData?['profileImage'];
      if (imagePath != null) {
        profileImage.value = File(imagePath);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        await StorageService.saveUserProfileImagePath(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> updateProfile(String newName, String newEmail) async {
    try {
      isLoading.value = true;
      await StorageService.saveUserName(newName);
      await StorageService.saveUserEmail(newEmail);
      
      name.value = newName;
      email.value = newEmail;
      
      Get.snackbar('Success', 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    StorageService.logOut();
    Get.offAll(() => SignInView());
  }
}

class SettingsView extends StatefulWidget {
  SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      _nameController.text = controller.name.value;
      _emailController.text = controller.email.value;

      return Scaffold(
        
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() => CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: controller.profileImage.value != null
                              ? FileImage(controller.profileImage.value!)
                              : const AssetImage('assets/png/Ellipse.png')
                                  as ImageProvider,
                        )),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(Icons.camera_alt,
                              size: 20.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // Personal Info Section
              Text('Personal Information',
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),

              CustomTextFormField(
                controller: _nameController,
                hint: 'Full Name',
                 prefix: Icon(Icons.person),
              ),
              SizedBox(height: 16.h),

              CustomTextFormField(
                controller: _emailController,
                hint: 'Email Address',
                prefix: Icon(Icons.email_outlined),
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24.h),

              // Account Settings Section
              Text('Account Settings',
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),

              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () => Get.to(() => NotificationsView()),
              ),
              SizedBox(height: 12.h),

              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => Get.to(() => HelpSupportView()),
              ),
              SizedBox(height: 12.h),

              _SettingsTile(
                icon: Icons.logout,
                title: 'Sign Out',
                isSignOut: true,
                onTap: controller.logout,
              ),
              SizedBox(height: 30.h),

              // Save Button
              Center(
                child: CustomButton(
                  onTap: () => controller.updateProfile(
                    _nameController.text.trim(),
                    _emailController.text.trim(),
                  ),
                  title: "Save Changes",
                  isLoading: controller.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSignOut;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSignOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: isSignOut ? Colors.red : Colors.blue, size: 24.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isSignOut ? Colors.red : Colors.black,
                  ),
                ),
              ),
              Icon(Icons.chevron_right,
                  color: isSignOut ? Colors.red : Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}