import 'package:textomize/controllers/newsfeed_controller.dart';
import 'package:textomize/core/exports.dart';

class InfoCard extends StatelessWidget {
  final controller = Get.put(NewsFeedController());

  final String username;
  final String fullName;

   InfoCard({
    Key? key,
    required this.username,
    required this.fullName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
            AppColors.secondaryColor.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 🔹 Left Section (Username)
          _buildInfoColumn("Username", username, Icons.person),

          /// 🔹 Vertical Divider
          Container(
            height: 40,
            width: 1.5,
            color: Colors.white.withOpacity(0.6),
          ),

          /// 🔹 Right Section (Full Name)
          _buildInfoColumn("Full Name", fullName, Icons.badge),
        ],
      ),
    );
  }

  /// 🔹 Modern Column with Icons
  Widget _buildInfoColumn(String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.white70),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: value,
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }
}
