// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';
//
// class OBESheetController extends GetxController {
//   // Reactive variables
//   var quizzes = 0.obs;
//   var mids = 0.obs;
//   var finals = 0.obs;
//   var practicals = 0.obs;
//   var excelFileName = ''.obs;
//   var excelFileBytes = <int>[].obs;
//   var dataFilled = false.obs;
//   var isLoading = false.obs;
//   var extractedData = <Map<String, dynamic>>[].obs;
//
//   // File picker with actual file handling
//   Future<void> pickExcelFile() async {
//     try {
//       isLoading(true);
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['xlsx', 'xls'],
//       );
//
//       if (result != null) {
//         PlatformFile file = result.files.first;
//         excelFileName.value = file.name;
//         excelFileBytes.value = file.bytes!;
//
//         // Try to parse the file immediately to verify it's valid
//         await _parseExcelFile(file.bytes!);
//
//         Fluttertoast.showToast(
//           msg: "Excel uploaded and validated successfully!",
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//       } else {
//         Fluttertoast.showToast(
//           msg: "No file selected",
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       excelFileName.value = '';
//       excelFileBytes.value = [];
//       Fluttertoast.showToast(
//         msg: "Error: ${e.toString()}",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   // Parse the Excel file
//   Future<void> _parseExcelFile(List<int> bytes) async {
//     try {
//       final excel = Excel.decodeBytes(bytes);
//
//       // Clear previous data
//       extractedData.clear();
//
//       // Get first sheet (you might want to make this configurable)
//       final sheet = excel.tables.keys.first;
//       final rows = excel.tables[sheet]!.rows;
//
//       // Assuming first row is headers
//       final headers = rows.first.map((cell) => cell?.value.toString()).toList();
//
//       // Process data rows
//       for (int i = 1; i < rows.length; i++) {
//         final row = rows[i];
//         final rowData = <String, dynamic>{};
//
//         for (int j = 0; j < row.length; j++) {
//           if (j < headers.length && headers[j] != null) {
//             rowData[headers[j]!] = row[j]?.value;
//           }
//         }
//
//         if (rowData.isNotEmpty) {
//           extractedData.add(rowData);
//         }
//       }
//
//       // Print first few rows for debugging
//       if (extractedData.isNotEmpty) {
//         debugPrint("Extracted ${extractedData.length} rows from Excel");
//         for (int i = 0; i < min(3, extractedData.length); i++) {
//           debugPrint("Row $i: ${extractedData[i]}");
//         }
//       }
//     } catch (e) {
//       throw Exception("Failed to parse Excel file: ${e.toString()}");
//     }
//   }
//
//
//
//
//   // Save the Excel file temporarily
//   Future<File> _saveFilePermanently(List<int> bytes) async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/$excelFileName');
//       await file.writeAsBytes(bytes);
//       return file;
//     } catch (e) {
//       throw Exception("Failed to save file: ${e.toString()}");
//     }
//   }
//
//   // Validate and save form
//   void saveForm({
//     required String quizValue,
//     required String midValue,
//     required String finalValue,
//     required String practicalValue,
//   }) {
//     if (excelFileName.isEmpty || excelFileBytes.isEmpty) {
//       Fluttertoast.showToast(
//         msg: "Please upload a valid Excel file first",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     try {
//       quizzes.value = int.parse(quizValue);
//       mids.value = int.parse(midValue);
//       finals.value = int.parse(finalValue);
//       practicals.value = int.parse(practicalValue);
//
//       dataFilled.value = true;
//       Get.back(); // Close the bottom sheet
//
//       Fluttertoast.showToast(
//         msg: "Data saved successfully!",
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//       );
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Please enter valid numbers",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }
//
//   // Generate OBE sheet with actual processing
//   Future<void> generateOBESheet() async {
//     if (!dataFilled.value) {
//       Fluttertoast.showToast(
//         msg: "Please fill all required fields first",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     try {
//       isLoading(true);
//
//       // Process the Excel data with the provided parameters
//       final processedData = await _processOBEData(
//         quizzes: quizzes.value,
//         mids: mids.value,
//         finals: finals.value,
//         practicals: practicals.value,
//       );
//
//       // Navigate to preview with all data
//       Get.toNamed('/obe-preview', arguments: {
//         'excelFileName': excelFileName.value,
//         'quizzes': quizzes.value,
//         'mids': mids.value,
//         'finals': finals.value,
//         'practicals': practicals.value,
//         'extractedData': extractedData.toList(),
//         'processedData': processedData,
//       });
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error processing OBE data: ${e.toString()}",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   // Process OBE data according to parameters
//   Future<List<Map<String, dynamic>>> _processOBEData({
//     required int quizzes,
//     required int mids,
//     required int finals,
//     required int practicals,
//   }) async {
//     // Here you would implement your actual OBE processing logic
//     // This is just a placeholder example
//
//     final processedData = <Map<String, dynamic>>[];
//
//     for (final row in extractedData) {
//       // Example processing - calculate total marks
//       double total = 0;
//       final processedRow = Map<String, dynamic>.from(row);
//
//       // Process quizzes (assuming columns named Quiz1, Quiz2, etc.)
//       double quizTotal = 0;
//       for (int i = 1; i <= quizzes; i++) {
//         final quizKey = 'Quiz$i';
//         if (row.containsKey(quizKey)) {
//           quizTotal += double.tryParse(row[quizKey].toString()) ?? 0;
//         }
//       }
//       processedRow['QuizTotal'] = quizTotal;
//       total += quizTotal * 0.2; // Assuming quizzes are 20% of total
//
//       // Process mids (similar logic)
//       // ... add your processing logic here
//
//       processedRow['Total'] = total;
//       processedData.add(processedRow);
//     }
//
//     return processedData;
//   }
// }

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class OBESheetController extends GetxController {
  // Reactive variables
  var quizzes = 0.obs;
  var mids = 0.obs;
  var finals = 0.obs;
  var practicals = 0.obs;
  var excelFileName = ''.obs;
  var excelFileBytes = <int>[].obs;
  var dataFilled = false.obs;
  var isLoading = false.obs;
  var extractedData = <Map<String, dynamic>>[].obs;

  // Pick Excel File
  Future<void> pickExcelFile() async {
    try {
      isLoading(true);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true, // Critical for accessing file.bytes
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        if (file.bytes == null) throw Exception("File bytes are null.");

        excelFileName.value = file.name;
        excelFileBytes.value = file.bytes!;

        await _parseExcelFile(file.bytes!);

        Fluttertoast.showToast(
          msg: "Excel uploaded and validated successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "No file selected",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      excelFileName.value = '';
      excelFileBytes.clear();
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Parse Excel File
  Future<void> _parseExcelFile(List<int> bytes) async {
    try {
      final excel = Excel.decodeBytes(bytes);

      if (excel.tables.isEmpty) {
        throw Exception("Excel file has no sheets.");
      }

      final sheetKey = excel.tables.keys.first;
      final table = excel.tables[sheetKey];
      final rows = table?.rows ?? [];

      if (rows.isEmpty) {
        throw Exception("Excel sheet is empty.");
      }

      final headers = rows.first.map((cell) => cell?.value?.toString()).toList();

      if (headers.isEmpty || headers.every((h) => h == null || h!.trim().isEmpty)) {
        throw Exception("Excel sheet has no valid headers.");
      }

      extractedData.clear();

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        final rowData = <String, dynamic>{};

        for (int j = 0; j < row.length; j++) {
          if (j < headers.length && headers[j] != null) {
            rowData[headers[j]!] = row[j]?.value;
          }
        }

        if (rowData.isNotEmpty) {
          extractedData.add(rowData);
        }
      }

      if (extractedData.isNotEmpty) {
        debugPrint("Extracted ${extractedData.length} rows from Excel");
        for (int i = 0; i < min(3, extractedData.length); i++) {
          debugPrint("Row $i: ${extractedData[i]}");
        }
      }
    } catch (e) {
      throw Exception("Failed to parse Excel file: ${e.toString()}");
    }
  }

  // Save File Permanently
  Future<File> _saveFilePermanently(List<int> bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$excelFileName');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      throw Exception("Failed to save file: ${e.toString()}");
    }
  }

  // Validate and Save Form Inputs
  void saveForm({
    required String quizValue,
    required String midValue,
    required String finalValue,
    required String practicalValue,
  }) {
    if (excelFileName.isEmpty || excelFileBytes.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please upload a valid Excel file first",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      quizzes.value = int.parse(quizValue);
      mids.value = int.parse(midValue);
      finals.value = int.parse(finalValue);
      practicals.value = int.parse(practicalValue);

      dataFilled.value = true;
      Get.back(); // Close the sheet

      Fluttertoast.showToast(
        msg: "Data saved successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Please enter valid numbers",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Generate OBE Sheet
  Future<void> generateOBESheet() async {
    if (!dataFilled.value) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields first",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      final processedData = await _processOBEData(
        quizzes: quizzes.value,
        mids: mids.value,
        finals: finals.value,
        practicals: practicals.value,
      );

      Get.toNamed('/obe-preview', arguments: {
        'excelFileName': excelFileName.value,
        'quizzes': quizzes.value,
        'mids': mids.value,
        'finals': finals.value,
        'practicals': practicals.value,
        'extractedData': extractedData.toList(),
        'processedData': processedData,
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error processing OBE data: ${e.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Sample Logic for OBE Processing (to be customized)
  Future<List<Map<String, dynamic>>> _processOBEData({
    required int quizzes,
    required int mids,
    required int finals,
    required int practicals,
  }) async {
    final processedData = <Map<String, dynamic>>[];

    for (final row in extractedData) {
      double total = 0;
      final processedRow = Map<String, dynamic>.from(row);

      // Quiz Processing
      double quizTotal = 0;
      for (int i = 1; i <= quizzes; i++) {
        final key = 'Quiz$i';
        quizTotal += double.tryParse(row[key]?.toString() ?? '0') ?? 0;
      }
      processedRow['QuizTotal'] = quizTotal;
      total += quizTotal * 0.2; // Assume 20% weight

      // TODO: Add logic for mids, finals, practicals as needed

      processedRow['Total'] = total;
      processedData.add(processedRow);
    }

    return processedData;
  }
}
