import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/home/tools/edit_pdf.dart';
import 'package:textomize/modules/features/profile/edit_profile.dart';
import 'package:textomize/modules/screens/search_view.dart';
import 'package:textomize/screens/notify_view.dart';
import '../modules/features/profile/profile_view.dart';

class HomeAppBar extends StatelessWidget {
  final String userName;
  final bool showGreeting;

  const HomeAppBar({
    Key? key,
    required this.userName,
    this.showGreeting = true,
  }) : super(key: key);

  String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return "Good Morning! ☀️";
  } else if (hour >= 12 && hour < 17) {
    return "Good Afternoon! 🌤️";
  } else if (hour >= 17 && hour < 21) {
    return "Good Evening! 🌙";
  } else {
    return "Good Night! 🌛";
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 🔹 Left Side: Greeting Text
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Hello, ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (showGreeting)
                    TextSpan(
                      text: '\n${getGreeting()}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// 🔹 Right Side: Icons
          Row(
            children: [
              _buildIconButton(Icons.notifications_none, () => Get.to(NotificationsView())),
              _buildProfileIcon(),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Icon Button Builder
  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 22),
      ),
    );
  }

  /// 🔹 Profile Icon Avatar
  Widget _buildProfileIcon() {
    return GestureDetector(
      onTap: () => Get.to(EditProfile()),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.person, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
