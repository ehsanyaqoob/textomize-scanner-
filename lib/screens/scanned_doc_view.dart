import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textomize/core/exports.dart';
import '../controllers/scan_con.dart';

class ScannedDocumentView extends StatelessWidget {
  const ScannedDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanDocumentController controller = Get.find<ScanDocumentController>();

    return WillPopScope(
      onWillPop: () async {
        controller.clearScannedData();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Scanned Document', centerTitle: true),
        body: Obx(() {
          return controller.selectedImage.value == null
              ? const Center(child: Text("No image selected"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Image Display Section
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.greyColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: controller.isEditing.value
                              ? TextField(
                                  controller: controller.textController,
                                  maxLines: null,
                                  expands: true,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Courier',
                                    color: Colors.black87,
                                  ),
                                  decoration: const InputDecoration.collapsed(
                                    hintText: "Edit your document...",
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: SelectableText(
                                    controller.scannedDocument.value.isNotEmpty
                                        ? controller.scannedDocument.value
                                        : "No document found",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Courier',
                                      color: controller.scannedDocument.value.isNotEmpty
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Action Buttons (Edit, Save, Share)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(
                            icon: controller.isEditing.value ? Icons.check : Icons.edit,
                            label: controller.isEditing.value ? "Done" : "Edit",
                            onTap: controller.toggleEditMode,
                          ),
                          _ActionButton(
                            icon: Icons.save_alt,
                            label: "Save",
                            onTap: () {
                              Get.bottomSheet(
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.picture_as_pdf),
                                        title: const Text("Save as PDF"),
                                        onTap: () {
                                          Get.back();
                                          controller.saveAsPDF();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.description),
                                        title: const Text("Save as Word (DOCX)"),
                                        onTap: () {
                                          Get.back();
                                          controller.saveAsDocx();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          _ActionButton(
                            icon: Icons.share,
                            label: "Share",
                            onTap: controller.shareDocument,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}

// Reusable Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
