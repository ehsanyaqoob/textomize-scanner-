import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textomize/controllers/obe_controller.dart';
import '../../../../core/exports.dart';

class OBESheetView extends GetView<OBESheetController> {
  OBESheetView({Key? key}) : super(key: key);

  final OBESheetController controller = Get.put(OBESheetController());
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: CustomAppBar(
  //       title: 'OBE Sheet',
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.info_outline, color: AppColors.white),
  //           onPressed: () {
  //             Get.defaultDialog(
  //               title: "OBE Sheet Help",
  //               content: const Text(
  //                 "Upload your Excel file and specify the number of each assessment type. "
  //                 "The system will process the data according to OBE standards.",
  //               ),
  //               textConfirm: "OK",
  //               onConfirm: () => Get.back(),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //     body: Obx(() {
  //       if (controller.isLoading.value) {
  //         return const Center(child: CustomLoader());
  //       }
  //
  //       return SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             children: [
  //               CustomText(
  //                 textAlign: TextAlign.center,
  //                 text: 'Choose the OBE sheet you want to work on',
  //                 fontSize: 24.sp,
  //                 fontWeight: FontWeight.bold,
  //                 color: AppColors.primaryColor,
  //               ),
  //               10.height,
  //               CustomButton(
  //                 title: 'Create New OBE Sheet',
  //                 fillColor: true,
  //                 onTap: _openBottomSheet,
  //                 topMargin: 100,
  //               ),
  //               10.height,
  //               CustomButton(
  //                 title: 'Create Existing OBE Sheet',
  //                 fillColor: true,
  //                 onTap: () {
  //                   Fluttertoast.showToast(
  //                     msg: "Feature not implemented yet.",
  //                     backgroundColor: Colors.redAccent,
  //                   );
  //                 },
  //               ),
  //               20.height,
  //
  //               // Show details if filled
  //               if (controller.dataFilled.value) ...[
  //                 const Divider(),
  //                 CustomText(
  //                   text: "Excel File: ${controller.excelFileName.value}",
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //                 8.height,
  //                 CustomText(text: "Quizzes: ${controller.quizzes.value}"),
  //                 CustomText(text: "Mid Exams: ${controller.mids.value}"),
  //                 CustomText(text: "Final Exams: ${controller.finals.value}"),
  //                 CustomText(text: "Practicals: ${controller.practicals.value}"),
  //                 if (controller.extractedData.isNotEmpty) ...[
  //                   8.height,
  //                   CustomText(
  //                     text: "Data Rows: ${controller.extractedData.length}",
  //                     fontSize: 14.sp,
  //                     color: AppColors.greyColor,
  //                   ),
  //                 ],
  //                 20.height,
  //                 CustomButton(
  //                   title: "Generate OBE Sheet",
  //                   fillColor: true,
  //                   onTap: controller.generateOBESheet,
  //                 ),
  //               ]
  //             ],
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'OBE Sheet',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.white),
            onPressed: () {
              Get.defaultDialog(
                title: "OBE Sheet Help",
                content: const Text(
                  "Upload your Excel file and specify the number of each assessment type. "
                  "The system will process the data according to OBE standards.",
                ),
                textConfirm: "OK",
                onConfirm: () => Get.back(),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoader());
        }

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // OBE GIF or Icon
                Container(
                  width: 220.w,
                  height: 220.0.h,
                  decoration: BoxDecoration(
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
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Image.asset(
                      'assets/png/obe.png', // Replace with your actual GIF path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Centered headline
                CustomText(
                  textAlign: TextAlign.center,
                  text: 'Choose the OBE sheet you want to work on',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 30),

                // Buttons
                CustomButton(
                  title: 'Create New OBE Sheet',
                  fillColor: true,
                  onTap: _openBottomSheet,
                ),
                10.height,
                CustomButton(
                  title: 'Create Existing OBE Sheet',
                  fillColor: true,
                  onTap: () {
                    Fluttertoast.showToast(
                      msg: "Feature not implemented yet.",
                      backgroundColor: Colors.redAccent,
                    );
                  },
                ),
                20.height,

                // If data filled, show summary and generate button
                if (controller.dataFilled.value) ...[
                  const Divider(),
                  CustomText(
                    text: "Excel File: ${controller.excelFileName.value}",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  8.height,
                  CustomText(text: "Quizzes: ${controller.quizzes.value}"),
                  CustomText(text: "Mid Exams: ${controller.mids.value}"),
                  CustomText(text: "Final Exams: ${controller.finals.value}"),
                  CustomText(
                      text: "Practicals: ${controller.practicals.value}"),
                  if (controller.extractedData.isNotEmpty) ...[
                    8.height,
                    CustomText(
                      text: "Data Rows: ${controller.extractedData.length}",
                      fontSize: 14.sp,
                      color: AppColors.greyColor,
                    ),
                  ],
                  20.height,
                  CustomButton(
                    title: "Generate OBE Sheet",
                    fillColor: true,
                    onTap: controller.generateOBESheet,
                  ),
                ]
              ],
            ),
          ),
        );
      }),
    );
  }

  void _openBottomSheet() {
    Get.bottomSheet(
      OBEBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}

class OBEBottomSheet extends GetView<OBESheetController> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController quizzesController = TextEditingController();
  final TextEditingController midsController = TextEditingController();
  final TextEditingController finalsController = TextEditingController();
  final TextEditingController practicalsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Upload OBE Sheet",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Column(
                  children: [
                    CustomButton(
                      title: controller.excelFileName.isEmpty
                          ? "Upload Excel File"
                          : "Re-upload Excel File",
                      fillColor: true,
                      onTap: controller.pickExcelFile,
                    ),
                    if (controller.excelFileName.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Selected: ${controller.excelFileName.value}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (controller.extractedData.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          "${controller.extractedData.length} rows detected",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ],
                  ],
                );
              }),
              const SizedBox(height: 20),
              Text(
                "Assessment Configuration",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                hint: "Number of Quizzes",
                controller: quizzesController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of quizzes';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                hint: "Number of Mid Exams",
                controller: midsController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of mid exams';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                hint: "Number of Final Exams",
                controller: finalsController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of final exams';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                hint: "Number of Practical Exams",
                controller: practicalsController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of practical exams';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Obx(() {
                return CustomButton(
                  title: "Submit Configuration",
                  fillColor: true,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.saveForm(
                        quizValue: quizzesController.text,
                        midValue: midsController.text,
                        finalValue: finalsController.text,
                        practicalValue: practicalsController.text,
                      );
                    }
                  },
                  isLoading: controller.isLoading.value,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class OBEPreviewView extends StatelessWidget {
  const OBEPreviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final extractedData = args['extractedData'] as List<Map<String, dynamic>>;
    final processedData = args['processedData'] as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'OBE Sheet Preview',
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.white),
            onPressed: () {
              // Implement download functionality
              Fluttertoast.showToast(
                msg: "Exporting processed data...",
                backgroundColor: Colors.green,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "File: ${args['excelFileName']}",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "Quizzes: ${args['quizzes']}"),
                              CustomText(text: "Mid Exams: ${args['mids']}"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "Finals: ${args['finals']}"),
                              CustomText(
                                  text: "Practicals: ${args['practicals']}"),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      CustomText(
                        text: "Data Summary",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              text: "Original Rows: ${extractedData.length}"),
                          CustomText(
                              text: "Processed Rows: ${processedData.length}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              20.height,

              // Data Preview Section
              CustomText(
                text: "Processed Data Preview",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              10.height,

              // Show a sample of the processed data
              if (processedData.isNotEmpty) ...[
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns:
                            _buildColumns(processedData.first.keys.toList()),
                        rows: _buildRows(processedData.take(5).toList()),
                      ),
                    ),
                  ),
                ),
                10.height,
                CustomText(
                  text: "Showing first 5 of ${processedData.length} rows",
                  fontSize: 12.sp,
                  color: AppColors.greyColor,
                ),
              ],

              20.height,
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: "Export Results",
                      fillColor: true,
                      onTap: () {
                        // Implement export functionality
                        Fluttertoast.showToast(
                          msg: "Export feature coming soon!",
                          backgroundColor: Colors.blue,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      title: "Analyze Data",
                      fillColor: false,
                      onTap: () {
                        Get.toNamed('/obe-analysis', arguments: args);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(List<String> keys) {
    return keys.map((key) {
      return DataColumn(
        label: Text(
          key,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  List<DataRow> _buildRows(List<Map<String, dynamic>> data) {
    return data.map((row) {
      return DataRow(
        cells: row.keys.map((key) {
          return DataCell(Text(row[key]?.toString() ?? ''));
        }).toList(),
      );
    }).toList();
  }
}
