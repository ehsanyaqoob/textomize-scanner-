import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:textomize/controllers/obe_controller.dart';
import 'package:textomize/core/exports.dart';

class OBECLOView extends GetView<OBECLOSheetController> {
  OBECLOView({Key? key}) : super(key: key);
  final controller = Get.put(OBECLOSheetController());

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
                _buildAssessmentConfiguration(),
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
                SizedBox(width: 8),
                CustomText(
                  text: 'Course Information',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: 15),
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
            SizedBox(height: 15),
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
                    onPressed: () => _showEditOptions(),
                  ),
              ],
            ),
            SizedBox(height: 15),
            Obx(() {
              return Column(
                children: [
                  CustomButton(
                    title: controller.excelFileName.isEmpty
                        ? 'Select Excel File'
                        : 'Replace File (${controller.excelFileName.value})',
                    icon: Icons.upload_file,
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx', 'xls'],
                        withData: true,
                      );
                      if (result != null) {
                        controller.excelBytes = result.files.first.bytes;
                        controller.loadAssessmentData(result);
                      }
                    },
                  ),
                  if (controller.excelFileName.isNotEmpty) ...[
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 8),
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

  Widget _buildAssessmentConfiguration() {
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
                Icon(Icons.assessment, color: AppColors.primaryColor),
                SizedBox(width: 8),
                CustomText(
                  text: 'Assessment Weights',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: 15),
            CustomText(
              text: 'Configure weights for each assessment component:',
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            ...controller.assessmentWeights.keys.map((key) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            text: key,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SliderTheme(
                            data: SliderTheme.of(Get.context!).copyWith(
                              activeTrackColor: AppColors.primaryColor,
                              thumbColor: AppColors.primaryColor,
                              valueIndicatorColor: AppColors.primaryColor,
                            ),
                            child: Slider(
                              value: controller.assessmentWeights[key] ?? 0,
                              min: 0,
                              max: 1,
                              divisions: 10,
                              label: '${((controller.assessmentWeights[key] ?? 0) * 100).toStringAsFixed(0)}%',
                              onChanged: (value) {
                                controller.assessmentWeights[key] = value;
                                controller.assessmentWeights.refresh();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 50,
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: CustomText(
                              text: '${((controller.assessmentWeights[key] ?? 0) * 100).toStringAsFixed(0)}%',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: controller.assessmentWeights[key] ?? 0,
                      backgroundColor: Colors.grey[200],
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 10),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Total Weight:',
                  fontWeight: FontWeight.bold,
                ),
                Obx(() {
                  final total = controller.assessmentWeights.values.fold(0.0, (a, b) => a + b);
                  return CustomText(
                    text: '${(total * 100).toStringAsFixed(0)}%',
                    fontWeight: FontWeight.bold,
                    color: (total - 1.0).abs() < 0.01 ? Colors.green : Colors.red,
                  );
                }),
              ],
            ),
            if ((controller.assessmentWeights.values.fold(0.0, (a, b) => a + b) - 1.0).abs() > 0.01)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: CustomText(
                  text: 'Weights must sum to 100%',
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Obx(() {
      final totalWeight = controller.assessmentWeights.values.fold(0.0, (a, b) => a + b);
      final isValid = (totalWeight - 1.0).abs() < 0.01;
      
      return Column(
        children: [
          CustomButton(
            title: 'Generate OBE CLO Report',
            icon: Icons.file_download,
            onTap: isValid ? controller.generateOBESheet : null,
            // backgroundColor: isValid ? AppColors.primaryColor : Colors.grey,
          ),
          if (!isValid)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Flexible(
                    child: CustomText(
                      text: 'Adjust weights to total 100%',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPreviewSection() {
    return Obx(() {
      if (!controller.dataReady.value) return const SizedBox();

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
                  Icon(Icons.preview, color: AppColors.primaryColor),
                  SizedBox(width: 8),
                  CustomText(
                    text: 'Data Preview',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.school,
                    label: 'Course',
                    value: '${controller.courseCode.value} - ${controller.courseName.value}',
                  ),
                  SizedBox(width: 10),
                  _buildInfoChip(
                    icon: Icons.people,
                    label: 'Students',
                    value: '${controller.studentRecords.length}',
                  ),
                  SizedBox(width: 10),
                  _buildInfoChip(
                    icon: Icons.list_alt,
                    label: 'CLOs',
                    value: '${controller.cloData.length}',
                  ),
                ],
              ),
              SizedBox(height: 20),
              ExpansionTile(
                title: CustomText(
                  text: 'View CLO Details',
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('CLO Code', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Target %', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Weight', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: controller.cloData.map((clo) {
                        final achieved = controller.calculateCLOAchievement(clo.code);
                        final status = achieved >= clo.target ? 'Achieved' : 'Not Achieved';
                        return DataRow(
                          cells: [
                            DataCell(Text(clo.code)),
                            DataCell(Text('${clo.target.toStringAsFixed(1)}%')),
                            DataCell(Text('${(clo.weight * 100).toStringAsFixed(1)}%')),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: status == 'Achieved' 
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: status == 'Achieved' ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
Widget _buildInfoChip({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Chip(
    avatar: CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Icon(icon, size: 16, color: AppColors.primaryColor),
    ),
    label: RichText(
      text: flutter.TextSpan(
        style: flutter.TextStyle(color: Colors.black),
        children: [
          flutter.TextSpan(
            text: '$label: ',
            style: const flutter.TextStyle(fontWeight: FontWeight.w600),
          ),
          flutter.TextSpan(
            text: value,
            style: const flutter.TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.grey.shade100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  );
}


  void _showEditOptions() {
    final newColumnController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: CustomText(text: 'Edit Options', fontWeight: FontWeight.bold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit_document, color: AppColors.primaryColor),
              title: CustomText(text: 'Edit Uploaded File'),
              onTap: () {
                Get.back();
                controller.editUploadedFile();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_box, color: AppColors.primaryColor),
              title: CustomText(text: 'Add New Columns'),
              onTap: () => _showAddColumnsDialog(newColumnController),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CustomText(text: 'Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddColumnsDialog(TextEditingController controller) {
    final columns = <String>[];
    
    Get.dialog(
      AlertDialog(
        title: CustomText(text: 'Add New Columns', fontWeight: FontWeight.bold),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Column Name',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (controller.text.trim().isNotEmpty) {
                                setState(() {
                                  columns.add(controller.text.trim());
                                  controller.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (columns.isNotEmpty) ...[
                  CustomText(text: 'Columns to add:', fontWeight: FontWeight.w500),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: columns.map((col) => Chip(
                      label: Text(col),
                      deleteIcon: Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => columns.remove(col)),
                    )).toList(),
                  ),
                ],
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CustomText(text: 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (columns.isNotEmpty) {
                Get.back();
                this.controller.addNewColumns(columns);
              }
            },
            child: CustomText(text: 'Add Columns'),
          ),
        ],
      ),
    );
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
              SizedBox(height: 10),
              _buildHelpStep(1, 'Enter your course information (code and name)'),
              _buildHelpStep(2, 'Upload student assessment data in Excel format'),
              _buildHelpStep(3, 'Edit the file or add new columns if needed'),
              _buildHelpStep(4, 'Configure assessment weights (must total 100%)'),
              _buildHelpStep(5, 'Generate comprehensive OBE report'),
              SizedBox(height: 15),
              Divider(),
              CustomText(
                text: 'The system will analyze Course Learning Outcomes (CLOs) against student performance.',
              ),
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
          SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
