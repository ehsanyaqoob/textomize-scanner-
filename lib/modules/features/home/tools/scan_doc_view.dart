import 'package:textomize/controllers/scan_con.dart';
import 'package:textomize/core/exports.dart';

class ScanDocumentView extends StatelessWidget {
  final ScanDocumentController controller = Get.put(ScanDocumentController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Scan Document'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Obx(() {
          return Column(
            children: [
              CustomText(
                text: 'Scan Document to proceed',
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                  image: controller.selectedImage.value != null
                      ? DecorationImage(
                          image: FileImage(controller.selectedImage.value!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: controller.selectedImage.value == null
                    ? Center(
                        child: Icon(Icons.camera_alt,
                            size: 50.sp, color: AppColors.primaryColor),
                      )
                    : null,
              ),
              SizedBox(height: 20),
              CustomText(
                text: controller.selectedImage.value == null
                    ? 'Align the Document inside the frame to scan.'
                    : 'Preview - Retake or Process',
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
              SizedBox(height: 30.h),
              if (controller.selectedImage.value == null)
                CustomButton(
                  title: 'Start Scanning',
                  onTap: () => _showImageSourceSheet(context),
                  fillColor: true,
                )
              else if (controller.isProcessing.value)
                CircularProgressIndicator()
              else
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: 'Retake',
                        onTap: () => _showImageSourceSheet(context),
                        fillColor: false,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomButton(
                        title: 'Clear',
                        onTap: controller.clearImage,
                        fillColor: false,
                      ),
                    ),

                  ],
                ),
                                    SizedBox(height: 16.h),
                    CustomButton(
                      title: 'Start Processing',
                      onTap: controller.processImageAndNavigate,
                      fillColor: true,
                    ),
            ],
          );
        }),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
