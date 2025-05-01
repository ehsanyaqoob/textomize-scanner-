import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textomize/core/exports.dart';
import '../controllers/scan_con.dart';

class ScannedDocumentView extends StatelessWidget {
  const ScannedDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanDocumentController controller = Get.find<ScanDocumentController>();
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        controller.clearScannedData();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          
          title: 
        'Scanned Document', 
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.white),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => _showHelpDialog(context),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.selectedImage.value == null) {
            return _buildEmptyState(context);
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                // Document Preview Section
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: controller.isEditing.value
                          ? TextField(
                              controller: controller.textController,
                              maxLines: null,
                              expands: true,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'RobotoMono',
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Edit your extracted text...",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 16.sp,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: SelectableText(
                                controller.scannedDocument.value.isNotEmpty
                                    ? controller.scannedDocument.value
                                    : "No text content found in the document",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'RobotoMono',
                                  color: controller.scannedDocument.value.isNotEmpty
                                      ? Colors.black87
                                      : Colors.grey.shade500,
                                  height: 1.5,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                
                // Action Buttons Section
                _buildActionButtons(controller, context),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner,
            size: 64.sp,
            color: AppColors.primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            "No Document Scanned",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Scan a document to view its contents here",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
            label: Text("Go Back to Scanner"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ScanDocumentController controller, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: controller.isEditing.value ? Icons.check : Icons.edit_note,
            label: controller.isEditing.value ? "Save" : "Edit",
            onTap: controller.toggleEditMode,
            isActive: controller.isEditing.value,
          ),
          _ActionButton(
            icon: Icons.save_alt_rounded,
            label: "Export",
            onTap: () => _showExportOptions(controller, context),
          ),
          _ActionButton(
            icon: Icons.share_rounded,
            label: "Share",
            onTap: controller.shareDocument,
          ),
        ],
      ),
    );
  }

  void _showExportOptions(ScanDocumentController controller, BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(top: 16.h, bottom: 24.h, left: 16.w, right: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Export Document As",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            _ExportOptionTile(
              icon: Icons.picture_as_pdf,
              title: "PDF Document",
              subtitle: "Best for printing and sharing",
              onTap: () {
                Get.back();
                controller.saveAsPDF();
              },
            ),
            Divider(height: 1, thickness: 0.5),
            _ExportOptionTile(
              icon: Icons.description,
              title: "Word Document",
              subtitle: "Editable DOCX format",
              onTap: () {
                Get.back();
                controller.saveAsDocx();
              },
            ),
            Divider(height: 1, thickness: 0.5),
            // _ExportOptionTile(
            //   icon: Icons.text_snippet,
            //   title: "Plain Text",
            //   subtitle: "Simple TXT file",
            //   onTap: () {
            //     Get.back();
            //     controller.saveAsTxt();
            //   },
            // ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: TextStyle(fontSize: 16.sp)),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Document Viewer Help"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpItem(
              icon: Icons.edit_note,
              text: "Edit - Modify the extracted text before saving",
            ),
            SizedBox(height: 12.h),
            _HelpItem(
              icon: Icons.save_alt_rounded,
              text: "Export - Save in PDF, Word or Text format",
            ),
            SizedBox(height: 12.h),
            _HelpItem(
              icon: Icons.share_rounded,
              text: "Share - Send directly to other apps",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Got it!"),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: isActive 
                  ? AppColors.primaryColor.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24.sp,
              color: isActive ? AppColors.primaryColor : Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.primaryColor : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExportOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12.sp)),
      onTap: onTap,
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HelpItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primaryColor),
        SizedBox(width: 12.w),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14.sp))),
      ],
    );
  }
}