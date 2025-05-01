import 'package:textomize/core/exports.dart';

class PremiumFeatureCard extends StatelessWidget {
  final String title;
  final String description;

  const PremiumFeatureCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.document_scanner,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: description,
                  fontSize: 10.sp,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
