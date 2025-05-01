import 'package:textomize/core/exports.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double borderRadius;
  final double fontSize;
  final double iconSize;
  final VoidCallback? onTap;

  const CustomButtonWithIcon({
    Key? key,
    required this.text,
    required this.icon,
    this.height = 30.0,
    this.width = 120.0,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.borderRadius = 30.0,
    this.fontSize = 16.0,
    this.iconSize = 22.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
            SizedBox(width: 6),
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
