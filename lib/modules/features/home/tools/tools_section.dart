import 'package:textomize/core/exports.dart';
import '../../../../models/tool_model.dart';

class ToolsSection extends StatelessWidget {
  final List<Tool> tools;

  final List<Color> containerColors = [
    Color(0xFFFFCDD2), // Light Red
    Color(0xFFC8E6C9), // Light Green
    Color(0xFFBBDEFB), // Light Blue
    Color(0xFFFFF9C4), // Light Yellow
    Color(0xFFE1BEE7), // Light Purple
    Color(0xFFB2EBF2), // Light Cyan
    Color(0xFFFFE0B2), // Light Orange
    Color(0xFFF0F4C3), // Light Lime
  ];

  final List<Color> iconColors = [
    Color(0xFFD32F2F), // Dark Red
    Color(0xFF388E3C), // Dark Green
    Color(0xFF1976D2), // Dark Blue
    Color(0xFFFBC02D), // Dark Yellow
    Color(0xFF7B1FA2), // Dark Purple
    Color(0xFF00838F), // Dark Cyan
    Color(0xFFF57C00), // Dark Orange
    Color(0xFFAFB42B), // Dark Lime
  ];

  ToolsSection({required this.tools});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Tools',
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        SizedBox(height: 12.0),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of items in a row
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8, // Adjust aspect ratio for balance
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => tool.view),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 70.0.w,
                    height: 70.0.h,
                    decoration: BoxDecoration(
                      color: containerColors[index % containerColors.length],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        tool.icon, // Access the icon directly from the tool model
                        color: iconColors[index % iconColors.length],
                        size: 32.0.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomText(
                    text: tool.label, // Access the label directly from the tool model
                    textAlign: TextAlign.center,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                           color: AppColors.greyColor,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
