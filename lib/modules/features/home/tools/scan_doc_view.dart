import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textomize/controllers/scan_con.dart';
import 'package:textomize/core/exports.dart';

class ScanDocumentView extends StatelessWidget {
  final ScanDocumentController controller = Get.put(ScanDocumentController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Scan Document',
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: AppColors.whiteColor),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              _buildHeaderSection(),
              SizedBox(height: 24.h),
              
              // Image Preview Section
              _buildImagePreviewSection(),
              SizedBox(height: 16.h),
              
              // Instructions Text
              _buildInstructionsText(),
              SizedBox(height: 32.h),
              
              // Action Buttons
              _buildActionButtons(context),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Icon(
          Icons.document_scanner,
          size: 40.sp,
          color: AppColors.primaryColor,
        ),
        SizedBox(height: 8.h),
        CustomText(
          text: 'Document Scanner',
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: 'Scan documents to extract text',
          fontSize: 14.sp,
          color: AppColors.greyColor,
        ),
      ],
    );
  }

  Widget _buildImagePreviewSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 280.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[100],
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: controller.selectedImage.value != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    controller.selectedImage.value!,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 50.sp,
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: 'No image selected',
                        fontSize: 14.sp,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
        ),
        if (controller.selectedImage.value != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: controller.clearImage,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInstructionsText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomText(
        text: controller.selectedImage.value == null
            ? 'Align your document properly within the frame for best results. Ensure good lighting and avoid shadows.'
            : 'Check the document preview. You can retake or process it.',
        fontSize: 13.sp,
        color: AppColors.greyColor,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (controller.selectedImage.value == null)
          CustomButton(
            title: 'Scan Document',
            onTap: () => _showImageSourceSheet(context),
            fillColor: true,
            icon: Icons.camera_alt,
            topMargin: 160,
          )
        else if (controller.isProcessing.value)
          Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: 'Processing document...',
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
            ],
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'Retake',
                      onTap: () => _showImageSourceSheet(context),
                      fillColor: false,
                      icon: Icons.refresh,
                      topMargin: 100,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomButton(
                      title: 'Process',
                      onTap: controller.processImageAndNavigate,
                      fillColor: true,
                      icon: Icons.check_circle_outline,
                      topMargin: 100,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              CustomButton(
                title: 'Scan Another',
                onTap: controller.clearImage,
                fillColor: false,
                icon: Icons.add,
              ),
            ],
          ),
      ],
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: 'Select Image Source',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    controller.pickImage(ImageSource.camera);
                    Get.back();
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    controller.pickImage(ImageSource.gallery);
                    Get.back();
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30.sp,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: CustomText(
          text: 'Scanning Tips',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpTip(
              icon: Icons.lightbulb_outline,
              text: 'Ensure good lighting conditions',
            ),
            SizedBox(height: 8.h),
            _buildHelpTip(
              icon: Icons.crop,
              text: 'Align document edges with the frame',
            ),
            SizedBox(height: 8.h),
            _buildHelpTip(
              icon: Icons.flash_off,
              text: 'Avoid flash reflections on glossy documents',
            ),
            SizedBox(height: 8.h),
            _buildHelpTip(
              icon: Icons.straighten,
              text: 'Hold your device parallel to the document',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpTip({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primaryColor),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}




// Widget _buildImagePreviewSection() {
//   return Column(
//     children: [
//       // Preview Container
//       Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             constraints: BoxConstraints(
//               maxHeight: 400.h,  // Maximum height but will respect aspect ratio
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               color: Colors.grey[100],
//               border: Border.all(
//                 color: AppColors.primaryColor.withOpacity(0.3),
//                 width: 2,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: controller.selectedImage.value != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(14),
//                     child: InteractiveViewer(
//                       panEnabled: true,
//                       minScale: 0.5,
//                       maxScale: 3.0,
//                       child: Image.file(
//                         controller.selectedImage.value!,
//                         fit: BoxFit.contain,  // Changed from cover to contain
//                       ),
//                     ),
//                   )
//                 : Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.camera_alt,
//                           size: 50.sp,
//                           color: AppColors.primaryColor.withOpacity(0.5),
//                         ),
//                         SizedBox(height: 8.h),
//                         CustomText(
//                           text: 'No image selected',
//                           fontSize: 14.sp,
//                           color: AppColors.greyColor,
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//           if (controller.selectedImage.value != null)
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Row(
//                 children: [
//                   // Edit Button
//                   GestureDetector(
//                     onTap: () => _showEditOptions(context),
//                     child: Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.edit,
//                         color: Colors.white,
//                         size: 20.sp,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   // Close Button
//                   GestureDetector(
//                     onTap: controller.clearImage,
//                     child: Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 20.sp,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//       // Edit Options (shown when image is selected)
//       if (controller.selectedImage.value != null)
//         Padding(
//           padding: EdgeInsets.only(top: 12.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildEditOptionButton(
//                 icon: Icons.crop,
//                 label: 'Crop',
//                 onTap: () => _cropImage(context),
//               ),
//               SizedBox(width: 16.w),
//               _buildEditOptionButton(
//                 icon: Icons.tune,
//                 label: 'Adjust',
//                 onTap: () => _adjustImage(context),
//               ),
//               SizedBox(width: 16.w),
//               _buildEditOptionButton(
//                 icon: Icons.rotate_90_degrees_ccw,
//                 label: 'Rotate',
//                 onTap: () => _rotateImage(context),
//               ),
//             ],
//           ),
//         ),
//     ],
//   );
// }

// // Helper widget for edit option buttons
// Widget _buildEditOptionButton({
//   required IconData icon,
//   required String label,
//   required VoidCallback onTap,
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColors.primaryColor.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             size: 20.sp,
//             color: AppColors.primaryColor,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12.sp,
//             color: AppColors.primaryColor,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Image editing functions
// Future<void> _cropImage(BuildContext context) async {
//   // You'll need to implement this using a package like image_cropper
//   // Example implementation:
//   /*
//   final croppedFile = await ImageCropper().cropImage(
//     sourcePath: controller.selectedImage.value!.path,
//     aspectRatioPresets: [
//       CropAspectRatioPreset.original,
//       CropAspectRatioPreset.square,
//       CropAspectRatioPreset.ratio3x2,
//       CropAspectRatioPreset.ratio4x3,
//       CropAspectRatioPreset.ratio16x9,
//     ],
//     uiSettings: [
//       AndroidUiSettings(
//         toolbarTitle: 'Crop Document',
//         toolbarColor: AppColors.primaryColor,
//         toolbarWidgetColor: Colors.white,
//         initAspectRatio: CropAspectRatioPreset.original,
//         lockAspectRatio: false,
//       ),
//       IOSUiSettings(
//         title: 'Crop Document',
//       ),
//     ],
//   );
  
//   if (croppedFile != null) {
//     controller.selectedImage.value = File(croppedFile.path);
//   }
//   */
//   Get.snackbar(
//     'Crop Feature',
//     'Image cropping would be implemented here',
//     snackPosition: SnackPosition.BOTTOM,
//   );
// }

// Future<void> _adjustImage(BuildContext context) async {
//   // You can use a package like photo_editor for this
//   Get.snackbar(
//     'Adjust Feature',
//     'Image adjustments would be implemented here',
//     snackPosition: SnackPosition.BOTTOM,
//   );
// }

// Future<void> _rotateImage(BuildContext context) async {
//   // You can use a package like image for this
//   /*
//   final image = img.decodeImage(await controller.selectedImage.value!.readAsBytes());
//   final rotated = img.copyRotate(image!, angle: 90);
//   final newPath = '${controller.selectedImage.value!.path}_rotated.jpg';
//   await File(newPath).writeAsBytes(img.encodeJpg(rotated));
//   controller.selectedImage.value = File(newPath);
//   */
//   Get.snackbar(
//     'Rotate Feature',
//     'Image rotation would be implemented here',
//     snackPosition: SnackPosition.BOTTOM,
//   );
// }

// void _showEditOptions(BuildContext context) {
//   Get.bottomSheet(
//     Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Edit Options',
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primaryColor,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildEditOptionButton(
//                 icon: Icons.crop,
//                 label: 'Crop',
//                 onTap: () {
//                   Get.back();
//                   _cropImage(context);
//                 },
//               ),
//               _buildEditOptionButton(
//                 icon: Icons.tune,
//                 label: 'Adjust',
//                 onTap: () {
//                   Get.back();
//                   _adjustImage(context);
//                 },
//               ),
//               _buildEditOptionButton(
//                 icon: Icons.rotate_90_degrees_ccw,
//                 label: 'Rotate',
//                 onTap: () {
//                   Get.back();
//                   _rotateImage(context);
//                 },
//               ),
//               _buildEditOptionButton(
//                 icon: Icons.filter_b_and_w,
//                 label: 'Filter',
//                 onTap: () {
//                   Get.back();
//                   // Implement filter functionality
//                 },
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//         ],
//       ),
//     ),
//   );
// }