import 'package:textomize/controllers/scan_con.dart';
import 'package:textomize/core/exports.dart';

class TranslateTextView extends StatelessWidget {
  // final TranslateTextController controller = Get.put(TranslateTextController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Translate Text',
        centerTitle: true,
        onLeadingPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(height: 20.0.h),
              CustomText(
                textAlign: TextAlign.center,
                text: 'Translate Text to your preferred language',
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ), SizedBox(height: 20.0.h),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 250.0.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.greenAccent.withOpacity(0.3),
                        Colors.green.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.green.withOpacity(0.8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.edit_document, size: 100.0, color: Colors.green),
                       SizedBox(height: 10.h),
                      CustomText(
                        text: "Ready to translate?",
                        fontSize: 18.0.sp,
                        fontWeight: FontWeight.bold,
                           color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
              ), SizedBox(height: 30.0.h),

              // Subheading
              CustomText(
                text: 'Choose one of the options below to continue.',
                fontSize: 16.0.sp,
                           color: AppColors.greyColor,
              ), SizedBox(height: 20.0.h),

              // Buttons
              CustomButton(
                title: 'Open Camera',
                topMargin: 10.0,
                fillColor: true,
              //  onTap: controller.openCamera,
              ),

               SizedBox(height: 15.0.h),

              CustomButton(
                title: 'Pick PDF from Gallery',
                topMargin: 10.0.sp,
                fillColor: true,
               // onTap: controller.pickGalleryImage, 
              ),

               SizedBox(height: 40.0.h),
              Center(
                child: Column(
                  children: [
                    CustomText(
                      text: 'Your documents are secure.',
                      fontSize: 14.0.sp,
                           color: AppColors.greyColor,
                    ),
                    const SizedBox(height: 5),
                    Icon(Icons.lock_rounded, size: 20.0, color: Colors.grey[500]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
