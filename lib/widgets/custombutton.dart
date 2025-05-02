import 'package:textomize/core/exports.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
        required this.title,
        this.isLoading = false,
        this.onTap,
        this.topMargin = 0.0,
        this.fillColor = true, this.icon});

  final String title;
  final VoidCallback? onTap;
  final IconData? icon;
  final double topMargin;
  final bool fillColor;
  
  final dynamic isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: topMargin), 
        child: Container(
          height: 45.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.h/2),
            border: Border.all(
              color: AppColors.white,
            ),
            color: fillColor
                ? onTap == null
                ? Colors.grey
                : AppColors.buttonColor
                : Colors.white,
          ),
          child: Center(
            child: CustomText(
              text: title,
              textAlign: TextAlign.center,
              color: fillColor ? AppColors.white : AppColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}

