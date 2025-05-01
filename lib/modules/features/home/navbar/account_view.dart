import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';
import 'package:textomize/screens/help_support.dart';
import 'package:textomize/screens/notify_view.dart';
import 'dart:io';
import '../../../../core/storage_services.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController _emailController =
      TextEditingController(text: "john.doe@example.com");

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  final List<Map<String, dynamic>> accountOptions = [
    {
      'icon': Icons.notifications,
      'title': 'Notifications',
      'onTap': () {
       Get.to(NotificationsView());
      },
    },
    {
      'icon': Icons.help,
      'title': 'Help & Support',
      'onTap': () {
       Get.to(HelpSupportView());
      },
    },
    {
      'icon': Icons.logout,
      'title': 'Sign Out',
      'onTap': () {
        StorageService.logOut();
        Get.offAll(SignInView());
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            // Profile Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55.r,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage('assets/png/Ellipse.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt,
                            size: 18.sp, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Name Field
            CustomTextFormField(
              controller: _nameController,
              hint: 'Enter name',
              prefix: Icon(Icons.person),
            ),
            SizedBox(height: 16.h),

            // Email Field
            CustomTextFormField(
              controller: _emailController,
              hint: 'Enter email',
              prefix: Icon(Icons.email),
            ),
            SizedBox(height: 24.h),

            // Settings Tiles
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: accountOptions.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final option = accountOptions[index];
                return _SettingsTile(
                  icon: option['icon'],
                  title: option['title'],
                  onTap: () => option['onTap'](),
                );
              },
            ),

            SizedBox(height: 24.h),

            CustomButton(
              onTap: _saveProfile,
              title: "Save Profile",
              fillColor: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 24.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomText(
                  text: title,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
