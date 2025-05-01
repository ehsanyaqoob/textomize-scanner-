
import 'package:textomize/core/exports.dart';
import '../../../../../controllers/smart_ai_controller.dart';

class SmartAiView extends StatelessWidget {
  SmartAiView({super.key});
  final SmartAiController controller = Get.put(SmartAiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GridView.builder(
            itemCount: controller.services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return GestureDetector(
                onTap: service.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        spreadRadius: 2,
                        color: Colors.black12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                        child: Icon(
                          service.icon,
                          size: 30,
                          color: AppColors.primaryColor,
                        ),
                      ),
                                       CustomText(
                        text: 
                        service.title,
                        textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        
                      ),
6.height,                      CustomText(
  text: 
                        service.description,
                        textAlign: TextAlign.center,
                          fontSize: 10.sp,
                        
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
