import 'package:image_picker/image_picker.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/widgets/sizer.dart';

import '../../../core/assets.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = Get.put(EditProfileDataController());

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Section
            GestureDetector(
              onTap: () => Get.bottomSheet(
                _buildImagePickerSheet(controller),
                backgroundColor: Colors.white,
              ),
              child: Obx(
                () => Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: AppColors.white,
                      backgroundImage: controller.profileImage.value != null
                          ? FileImage(controller.profileImage.value!)
                          : AssetImage(Assets.ellipse) as ImageProvider,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 6.w,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 18.r,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Name Field
            Obx(() => _inputField(
                  label: "Full Name",
                  hintText: "Enter your name",
                  onChanged: controller.updateName,
                  errorText: controller.nameError.value,
                )),


            // Email Field
            Obx(() => _inputField(
                  label: "Email",
                  hintText: "Enter your email",
                  onChanged: controller.updateEmail,
                  errorText: controller.emailError.value,
                )),


            // Phone Field
            Obx(() => _inputField(
                  label: "Phone",
                  hintText: "Enter your phone number",
                  onChanged: controller.updatePhone,
                  errorText: controller.phoneError.value,
                )),

            20.height,

            // Save Button
            CustomButton(
              title: 'Save Changes',
              fillColor: true,
              onTap: () {
                controller.saveChanges();
              },
            )
          ],
        ),
      ),
    );
  }
  
  }

  /// Input field component
  Widget _inputField({
    required String label,
    required String hintText,
    required String? errorText,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          height: 15.h,
        ),
        CustomTextFormField(
          hint: hintText,
          onChanged: onChanged,
          errorText: errorText,
        ),
      ],
    );
  }

  /// Bottom sheet for image picker
  Widget _buildImagePickerSheet(EditProfileDataController controller) {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take a photo"),
            onTap: () {
              controller.pickImage(ImageSource.camera);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from gallery"),
            onTap: () {
              controller.pickImage(ImageSource.gallery);
              Get.back();
            },
          ),
          if (controller.profileImage.value != null)
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                "Delete picture",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                controller.deleteImage();
                Get.back();
              },
            ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text("Cancel"),
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
