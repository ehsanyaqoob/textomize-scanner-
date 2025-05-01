import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';
import '../../../widgets/custom_bottomsheet.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.put(ProfileController());
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController.text = profileController.name.value;
    phoneController.text = profileController.phone.value;
    dobController.text = profileController.dob.value;

    profileController.name.listen((value) => nameController.text = value);
    profileController.phone.listen((value) => phoneController.text = value);
    profileController.dob.listen((value) => dobController.text = value);
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      profileController.updateProfileImage(pickedFile.path);
    }
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20)), // Rounded top corners
        ),
        padding: EdgeInsets.symmetric(
            vertical: 16), // Add some padding for better UI
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text("Take a Photo"),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: Colors.green),
              title: Text("Choose from Gallery"),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent, // Makes the sheet edges blend well
      isScrollControlled: true, // Allows better visibility
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Complete Your Profile', centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            _buildProfilePictureSection(),
            SizedBox(height: 20.h),
            _buildProfileFormSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: GestureDetector(
        onTap: _showImagePickerOptions,
        child: Stack(
          children: [
            Obx(() {
              return CircleAvatar(
                radius: 60.r,
                backgroundColor: AppColors.greyColor,
                backgroundImage: profileController.profileImage.value.isNotEmpty
                    ? FileImage(File(profileController.profileImage.value))
                    : AssetImage('assets/png/Ellipse.png') as ImageProvider,
              );
            }),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileFormSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormHeader(),
            SizedBox(height: 24.h),
            _buildNameField(),
            SizedBox(height: 16.h),
            _buildPhoneField(),
            SizedBox(height: 16.h),
            _buildGenderDropdown(),
            SizedBox(height: 16.h),
            _buildDateOfBirthField(),
            SizedBox(height: 32.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Complete your profile',
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 8.h),
        CustomText(
          text: 'Only you can see your personal data.',
          fontSize: 14.sp,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return CustomTextFormField(
      controller: nameController,
      onChanged: profileController.updateName,
      title: 'Full Name',
      hint: 'Enter your full name',
    );
  }

  Widget _buildPhoneField() {
    return CustomTextFormField(
      controller: phoneController,
      onChanged: profileController.updatePhone,
      inputType: TextInputType.phone,
      title: 'Phone Number',
      hint: '+1 000 000 000',
    );
  }

  Widget _buildGenderDropdown() {
    return Obx(
      () => TextomizeBottomSheet(
        title: 'Gender',
        selectedValue: profileController.gender.value.isEmpty
            ? null
            : profileController.gender.value,
        options: ['Male', 'Female', 'Other'],
        onChanged: (value) {
          profileController.updateGender(value!);
        },
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
          profileController.updateDob(formattedDate);
        }
      },
      child: AbsorbPointer(
        child: CustomTextFormField(
          controller: dobController,
          title: 'Date of Birth',
          hint: 'MM/DD/YYYY',
          suffix: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onTap: () => Get.to(SignInView()),
            title: 'Skip',
            fillColor: true,
          ),
        ),
        SizedBox(width: 16.h),
        Expanded(
          child: CustomButton(
            onTap: () {
              if (profileController.isFormValid()) {
                Get.snackbar('Profile Completed',
                    'Your profile details have been saved!',
                    snackPosition: SnackPosition.TOP);
                Get.to(SignInView());
              } else {
                Get.snackbar('Incomplete Details',
                    'Please fill all fields before continuing.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white);
              }
            },
            title: 'Continue',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }
}
