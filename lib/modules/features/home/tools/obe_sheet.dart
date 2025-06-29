
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:textomize/controllers/obe_controller.dart';
import 'package:textomize/core/exports.dart';

class OBECLOView extends GetView<OBECLOSheetController> {
  OBECLOView({Key? key}) : super(key: key);
  final controller = Get.put(OBECLOSheetController());
  Widget _buildAssessmentConfiguration() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Assessment Weights',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 15),
            ...controller.assessmentWeights.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(entry.key),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: entry.value.toStringAsFixed(2),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixText: '%',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          double? newValue = double.tryParse(value);
                          if (newValue != null) {
                            controller.assessmentWeights[entry.key] = newValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  Widget _buildAssessmentSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Select Assessment Type to Scan',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            'Quiz 1',
            'Quiz 2',
            'Assignment 1',
            'Assignment 2',
            'Mid Term',
            'Final Term'
          ]
              .map((type) => Obx(() {
            final isSelected =
                controller.selectedAssessmentType.value == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (_) => controller.selectAssessmentType(type),
              selectedColor: AppColors.primaryColor,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          }))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'OBE CLO Analysis',
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCourseInfoCard(),
              const SizedBox(height: 20),
              _buildDataUploadSection(),
              const SizedBox(height: 20),
              if (controller.dataReady.value) ...[
                _buildStudentList(),
                const SizedBox(height: 20),
                _buildAssessmentConfiguration(),
                const SizedBox(height: 20),
                _buildAssessmentSelector(),
                const SizedBox(height: 10),
                _buildScanButton(),
                // const SizedBox(height: 10),
                // _buildExportButton(),
                const SizedBox(height: 30),
                _buildGenerateButton(),
              ],
              const SizedBox(height: 20),
              _buildPreviewSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStudentList() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Student Records (${controller.studentRecords.length})',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            Obx(() {
              return Column(
                children: [
                  if (controller.studentRecords.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No student records found'),
                    )
                  else
                    ...controller.studentRecords.take(5).map((student) => ListTile(
                      title: Text(student.name),
                      subtitle: Text(student.regNo),
                      trailing: Text(
                        '${controller.getStudentMarks(student.regNo)?.toStringAsFixed(1) ?? '--'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                  if (controller.studentRecords.length > 5)
                    TextButton(
                      onPressed: () => _showAllStudentsDialog(),
                      child: const Text('View All Students'),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showAllStudentsDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('All Student Records'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.studentRecords.length,
            itemBuilder: (context, index) {
              final student = controller.studentRecords[index];
              return ListTile(
                title: Text(student.name),
                subtitle: Text(student.regNo),
                trailing: Text(
                  '${controller.getStudentMarks(student.regNo)?.toStringAsFixed(1) ?? '--'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                CustomText(
                  text: 'Course Information',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Course Code',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.code),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) => controller.courseCode.value = value,
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.class_),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) => controller.courseName.value = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataUploadSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Student Data',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                if (controller.excelFileName.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.primaryColor),
                    onPressed: () => controller.editUploadedFile(),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Obx(() {
              return Column(
                children: [
                  CustomButton(
                    title: controller.excelFileName.isEmpty
                        ? 'Select Excel File'
                        : 'Replace File (${controller.excelFileName.value})',
                    icon: Icons.upload_file,
                    onTap: () async {
                      try {
                        FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['xlsx', 'xls'],
                          withData: true,
                        );
                        if (result != null) {
                          await controller.loadAssessmentData(result);
                        }
                      } catch (e) {
                        controller.showError("File selection failed: $e");
                      }
                    },
                  ),
                  if (controller.excelFileName.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: CustomText(
                            text: 'Selected: ${controller.excelFileName.value}',
                            color: Colors.green,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
  Widget _buildScanButton() {
    return CustomButton(
      title: 'Scan Student Paper',
      icon: Icons.camera_alt,
      onTap: () async {
        if (controller.selectedAssessmentType.value.isEmpty) {
          controller.showError("Please select an assessment type first");
          return;
        }

        final XFile? imageFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 90,
        );

        if (imageFile == null) return;

        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        try {
          final scannedData = await controller.processScannedPaper(
              File(imageFile.path));
          controller.updateStudentMarks(
            scannedData['regNo'],
            scannedData['marks'],
            Get.context!, // Use Get.context to access the current context
          );
          await controller.exportUpdatedSheet();
          _showScanResultDialog(scannedData);
        } catch (e) {
          controller.showError("Scan failed: ${e.toString()}");
        } finally {
          Get.back();
        }
      },
    );
  }

  void _showScanResultDialog(Map<String, dynamic> data) {
    Get.dialog(
      AlertDialog(
        title: Text('Scan Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Registration No'),
              subtitle: Text(data['regNo']),
            ),
            ListTile(
              title: Text('Marks'),
              subtitle: Text(data['marks'].toString()),
            ),
            ListTile(
              title: Text('Assessment'),
              subtitle: Text(controller.selectedAssessmentType.value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return CustomButton(
      title: 'Export Updated Excel',
      icon: Icons.save_alt,
      onTap: () async {
        if (controller.selectedAssessmentType.value.isEmpty) {
          controller.showError("Please select an assessment type first");
          return;
        }

        final file = await controller.exportUpdatedSheet();
        if (file != null) {
          controller.showSuccess("File saved: ${file.path}");
        }
      },
    );
  }

  Widget _buildGenerateButton() {
    return CustomButton(
      title: 'Generate OBE CLO Report',
      icon: Icons.file_download,
      onTap: () async {
        if (controller.courseCode.value.isEmpty ||
            controller.courseName.value.isEmpty) {
          controller.showError("Please enter course information");
          return;
        }

        if (controller.studentRecords.isEmpty) {
          controller.showError("No student data available");
          return;
        }

        await controller.generateOBESheet();
      },
    );
  }

  Widget _buildPreviewSection() {
    return Obx(() {
      if (controller.studentPreviewData.isEmpty) {
        return Container();
      }

      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Preview Data',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              DataTable(
                columns: const [
                  DataColumn(label: Text('RegNo')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Marks')),
                ],
                rows: controller.studentPreviewData
                    .take(5)
                    .map(
                      (student) => DataRow(
                    cells: [
                      DataCell(Text(student.regNo)),
                      DataCell(Text(student.name)),
                      DataCell(Text(
                        controller
                            .getStudentMarks(student.regNo)
                            ?.toStringAsFixed(1) ?? '--',
                      )),
                    ],
                  ),
                )
                    .toList(),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showHelpDialog() {
    Get.dialog(
      AlertDialog(
        title: CustomText(
          text: 'OBE CLO Analysis Help',
          fontWeight: FontWeight.bold,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.info, color: AppColors.primaryColor),
                title: CustomText(text: 'How to use this tool:'),
              ),
              const SizedBox(height: 10),
              _buildHelpStep(1, 'Enter your course information (code and name)'),
              _buildHelpStep(2, 'Upload student assessment data in Excel format'),
              _buildHelpStep(3, 'Edit the file or add new columns if needed'),
              _buildHelpStep(4, 'Select an assessment type and scan the paper'),
              _buildHelpStep(5, 'Export updated Excel or generate final report'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CustomText(text: 'OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
