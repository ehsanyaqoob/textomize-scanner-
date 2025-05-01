import 'package:dotted_border/dotted_border.dart';
import '../../../../../controllers/my_doc_controller.dart';
import '../../../../../core/exports.dart';
import 'package:intl/intl.dart';

class MyDocView extends StatefulWidget {
  const MyDocView({super.key});

  @override
  State<MyDocView> createState() => _MyDocViewState();
}

class _MyDocViewState extends State<MyDocView> {
  final UploadController controller = Get.put(UploadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              20.height,
              Row(
                children: [
                  CustomText(
                    text: "My Documents",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: IconButton(
                      onPressed: () {
                        //  Get.to(() => SearchView());
                      },
                      icon: const Icon(Icons.search),
                      tooltip: 'Search',
                      splashRadius: 24.0,
                      color: Colors.black,
                      iconSize: 25.r,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                    ),
                  ),
                  10.width,
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Get.to(() => ProfileView());
                      },
                      icon: const Icon(Icons.person),
                      tooltip: 'Search',
                      splashRadius: 24.0,
                      color: Colors.black,
                      iconSize: 24.0,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
              20.height,
              UploadBox(), // ✅ Now functional
              20.height,
              Obx(() {
                if (controller.selectedFiles.isEmpty) {
                  return CustomText(
                    text: "No files selected.",
                    fontSize: 18.sp,
                  );
                } else {
                  return UploadProgressWidget(
                    images: controller.selectedFiles
                        .take(4)
                        .map((file) => FileImage(file) as ImageProvider)
                        .toList(),
                    totalFiles: controller.selectedFiles.length,
                    progress: controller.uploadProgress.value,
                    timeRemaining: controller.timeRemaining.value,
                    onPause: controller.pauseUpload,
                    onCancel: controller.cancelUpload,
                  );
                }
              }),
              20.height,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Recent Documents",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.to(() => AllDocumentsView());
                      // Navigate to All Documents View
                    },
                    child: CustomText(
                      text: "See All",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              GetBuilder<DocumentController>(
                init: DocumentController(),
                builder: (controller) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.recentDocuments.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final doc = controller.recentDocuments[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: doc.title,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomText(
                                text: doc.size,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    controller.deleteDocument(index),
                              ),
                            ],
                          ),
                          CustomText(
                            text: DateFormat.yMMMd()
                                .add_jm()
                                .format(doc.dateTime),
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadBox extends StatelessWidget {
  final VoidCallback? onTap;

  const UploadBox({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UploadController controller = Get.find();

    return GestureDetector(
      onTap: () {
        _showImageSourceSheet(context, controller);
        if (onTap != null) onTap!();
        Get.snackbar(
          'Tip',
          'Select up to 4 files to upload',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.shade50,
        );
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [6, 3],
        color: Colors.blue,
        strokeWidth: 1.5,
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_file, color: Colors.blue, size: 40),
              const SizedBox(height: 8),
              CustomText(
                text: "Upload your files here",
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: "Browse",
                textDecoration: TextDecoration.underline,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet(
      BuildContext context, UploadController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
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

class UploadProgressWidget extends StatelessWidget {
  final List<ImageProvider> images;
  final int totalFiles;
  final double progress;
  final String timeRemaining;
  final VoidCallback onPause;
  final VoidCallback onCancel;

  const UploadProgressWidget({
    super.key,
    required this.images,
    required this.totalFiles,
    required this.progress,
    required this.timeRemaining,
    required this.onPause,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Uploading $totalFiles files",
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          8.height,
          Row(
            children: images.map((image) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundImage: image,
                  radius: 20.r,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$timeRemaining remaining",
                style: TextStyle(fontSize: 12.sp),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.pause, size: 20.r),
                    onPressed: onPause,
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel, size: 20.r),
                    onPressed: onCancel,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
