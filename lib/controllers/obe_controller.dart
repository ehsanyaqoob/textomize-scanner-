// obe_clo_controller.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../core/exports.dart';

class OBECLOSheetController extends GetxController {
  // Course Information
  var courseName = ''.obs;
  var courseCode = ''.obs;

  // File Handling
  var excelFileName = ''.obs;
  Uint8List? excelBytes;
  var isLoading = false.obs;
  var dataReady = false.obs;
  var selectedAssessmentType = ''.obs;

  // Data Storage
  var assessmentWeights = <String, double>{}.obs;
  var cloData = <CLO>[].obs;
  var studentRecords = <StudentRecord>[].obs;
  var studentPreviewData = <StudentRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default weights
    assessmentWeights.value = {
      'Quiz 1': 0.1,
      'Quiz 2': 0.1,
      'Assignment 1': 0.15,
      'Assignment 2': 0.15,
      'Mid Term': 0.2,
      'Final Term': 0.3,
    };
  }

  // Load assessment data from Excel file
  Future<void> loadAssessmentData(FilePickerResult result) async {
    try {
      isLoading(true);
      excelBytes = result.files.first.bytes;
      excelFileName.value = result.files.first.name;

      debugPrint('Loading Excel file: ${excelFileName.value}');
      final excel = Excel.decodeBytes(excelBytes!);

      if (excel.tables.isEmpty) {
        throw Exception("No sheets found in Excel file");
      }
 
      final sheet = excel.tables.values.first;
      debugPrint('Found sheet with ${sheet.rows.length} rows');

      final headers = sheet.rows.first.map((cell) => cell?.value?.toString()?.trim()).toList();
      debugPrint('Headers: $headers');

      studentRecords.assignAll(_parseStudentRecords(sheet.rows.sublist(1), headers));
      debugPrint('Parsed ${studentRecords.length} student records');

      dataReady.value = true;
      showSuccess("File loaded successfully with ${studentRecords.length} students");
    } catch (e) {
      debugPrint('Error loading assessment data: $e');
      showError("Failed to load Excel file: ${e.toString()}");
      dataReady.value = false;
    } finally {
      isLoading(false);
    }
  }

  List<StudentRecord> _parseStudentRecords(List<List<Data?>> rows, List<String?> headers) {
    debugPrint('Parsing student records...');
    final records = <StudentRecord>[];

    for (int i = 0; i < rows.length; i++) {
      try {
        final row = rows[i];
        final record = StudentRecord();

        for (int j = 0; j < headers.length; j++) {
          final header = headers[j]?.trim() ?? '';
          final value = row.length > j ? row[j]?.value?.toString()?.trim() : '';

          if (header.isEmpty) continue;

          if (header.toLowerCase().contains('regno')) {
            record.regNo = value?.isNotEmpty == true ? value! : 'ID_${i + 1}';
          } else if (header.toLowerCase().contains('name')) {
            record.name = value?.isNotEmpty == true ? value! : 'Student ${i + 1}';
          } else if (header.toLowerCase().contains('quiz')) {
            final marks = double.tryParse(value ?? '0') ?? 0;
            record.quizScores[header] = marks;
          } else if (header.toLowerCase().contains('assignment')) {
            final marks = double.tryParse(value ?? '0') ?? 0;
            record.assignmentScores[header] = marks;
          } else if (header.toLowerCase().contains('mid') || 
                     header.toLowerCase().contains('final')) {
            final marks = double.tryParse(value ?? '0') ?? 0;
            record.examScores[header] = marks;
          }
        }

        if (record.regNo.isNotEmpty) {
          records.add(record);
        }
      } catch (e) {
        debugPrint('Error parsing row $i: $e');
      }
    }

    return records;
  }

  // Select assessment type
  void selectAssessmentType(String type) {
    debugPrint('Selected assessment type: $type');
    selectedAssessmentType.value = type;
  }

  // Edit uploaded file
  Future<void> editUploadedFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result != null) {
        await loadAssessmentData(result);
      }
    } catch (e) {
      debugPrint('Error editing file: $e');
      showError("Failed to edit file: ${e.toString()}");
    }
  }

  // Export updated sheet
  Future<File?> exportUpdatedSheet() async {
    try {
      if (excelBytes == null) {
        showError("No Excel file loaded");
        return null;
      }

      isLoading(true);
      debugPrint('Exporting updated sheet...');

      final excel = Excel.decodeBytes(excelBytes!);
      final sheet = excel.tables.values.first;

      final headers = sheet.rows.first.map((cell) => cell?.value?.toString()).toList();
      debugPrint('Original headers: $headers');

      int regNoIndex = headers.indexWhere((h) => h?.toLowerCase().contains('regno') ?? false);
      if (regNoIndex == -1) {
        throw Exception("RegNo column not found in original sheet");
      }

      // Add new assessment column if it doesn't exist
      final assessmentType = selectedAssessmentType.value;
      if (!headers.contains(assessmentType)) {
        headers.add(assessmentType);
        sheet.rows[0] = headers.map((h) => TextCellValue(h ?? '')).cast<Data?>().toList();
        for (int i = 1; i < sheet.rows.length; i++) {
          sheet.rows[i].add(TextCellValue('') as Data?);
        }
      }

      int assessmentIndex = headers.indexOf(assessmentType);

      // Update marks for each student
      for (int i = 1; i < sheet.rows.length; i++) {
        final regCell = sheet.rows[i][regNoIndex];
        final regNo = regCell?.value?.toString() ?? '';
        final marks = getStudentMarks(regNo);

        if (marks != null) {
          sheet.rows[i][assessmentIndex] = DoubleCellValue(marks) as Data?;
          debugPrint('Updated marks for $regNo: $marks');
        }
      }

      final file = await _saveExcelFile(excel.encode()!);
      debugPrint('File exported successfully: ${file.path}');
      return file;
    } catch (e) {
      debugPrint('Error exporting sheet: $e');
      showError("Failed to export sheet: ${e.toString()}");
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Update student marks
  void updateStudentMarks(String scannedRegNo, double scannedMarks) {
    try {
      if (selectedAssessmentType.value.isEmpty) {
        throw Exception("No assessment type selected");
      }

      final student = studentRecords.firstWhere(
        (s) => s.regNo.trim().toLowerCase() == scannedRegNo.trim().toLowerCase(),
        orElse: () => StudentRecord(),
      );

      if (student.regNo.isEmpty) {
        throw Exception("Student not found: $scannedRegNo");
      }

      final assessment = selectedAssessmentType.value;
      if (assessment.toLowerCase().contains('quiz')) {
        student.quizScores[assessment] = scannedMarks;
      } else if (assessment.toLowerCase().contains('assignment')) {
        student.assignmentScores[assessment] = scannedMarks;
      } else {
        student.examScores[assessment] = scannedMarks;
      }

      studentRecords.refresh();
      debugPrint('Updated marks for $scannedRegNo in $assessment: $scannedMarks');
      showSuccess("Marks updated for $scannedRegNo");
    } catch (e) {
      debugPrint('Error updating marks: $e');
      showError(e.toString());
    }
  }

  // Generate OBE sheet
  Future<void> generateOBESheet() async {
    try {
      isLoading(true);
      debugPrint('Generating OBE CLO Report...');

      // Validate data
      if (courseCode.value.isEmpty || courseName.value.isEmpty) {
        throw Exception("Course information not complete");
      }

      if (studentRecords.isEmpty) {
        throw Exception("No student data available");
      }

      final excel = Excel.createExcel();
      debugPrint('Created new Excel workbook');

      // Create sheets
      _createCLOAnalysisSheet(excel);
      _createStudentReportSheet(excel);
      _createSummarySheet(excel);

      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception("Failed to encode Excel file");
      }

      final file = await _saveExcelFile(bytes);
      studentPreviewData.assignAll(studentRecords);
      debugPrint('OBE Report generated successfully');
      showSuccess("OBE Report generated: ${file.path}");
    } catch (e) {
      debugPrint('Error generating report: $e');
      showError("Report generation failed: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  void _createCLOAnalysisSheet(Excel excel) {
    final sheet = excel['CLO Analysis'];
    debugPrint('Creating CLO Analysis sheet...');

    // Headers
    sheet.appendRow([
      TextCellValue('CLO Code'),
      TextCellValue('Description'),
      TextCellValue('Target %'),
      TextCellValue('Achieved %'),
      TextCellValue('Status'),
    ]);

    // Sample CLO data - in real app, this would come from user input
    final sampleClos = [
      CLO(code: 'CLO1', description: 'Understand concepts', target: 70, weight: 0.3),
      CLO(code: 'CLO2', description: 'Apply knowledge', target: 65, weight: 0.4),
      CLO(code: 'CLO3', description: 'Analyze problems', target: 60, weight: 0.3),
    ];

    for (final clo in sampleClos) {
      final achieved = 65.0; // This would be calculated from student data
      final status = achieved >= clo.target ? 'Achieved' : 'Not Achieved';
      
      sheet.appendRow([
        TextCellValue(clo.code),
        TextCellValue(clo.description),
        DoubleCellValue(clo.target),
        DoubleCellValue(achieved),
        TextCellValue(status),
      ]);
    }
  }

  void _createStudentReportSheet(Excel excel) {
    final sheet = excel['Student Report'];
    debugPrint('Creating Student Report sheet...');

    // Headers
    sheet.appendRow([
      TextCellValue('RegNo'),
      TextCellValue('Name'),
      TextCellValue('Quiz 1'),
      TextCellValue('Quiz 2'),
      TextCellValue('Assignment 1'),
      TextCellValue('Assignment 2'),
      TextCellValue('Mid Term'),
      TextCellValue('Final Term'),
      TextCellValue('Total'),
      TextCellValue('Grade'),
    ]);

    // Student data
    for (final student in studentRecords) {
      final quiz1 = student.quizScores['Quiz 1'] ?? 0;
      final quiz2 = student.quizScores['Quiz 2'] ?? 0;
      final assignment1 = student.assignmentScores['Assignment 1'] ?? 0;
      final assignment2 = student.assignmentScores['Assignment 2'] ?? 0;
      final mid = student.examScores['Mid Term'] ?? 0;
      final finalExam = student.examScores['Final Term'] ?? 0;

      final total = (quiz1 * assessmentWeights['Quiz 1']!) +
          (quiz2 * assessmentWeights['Quiz 2']!) +
          (assignment1 * assessmentWeights['Assignment 1']!) +
          (assignment2 * assessmentWeights['Assignment 2']!) +
          (mid * assessmentWeights['Mid Term']!) +
          (finalExam * assessmentWeights['Final Term']!);

      final grade = _calculateGrade(total);

      sheet.appendRow([
        TextCellValue(student.regNo),
        TextCellValue(student.name),
        DoubleCellValue(quiz1),
        DoubleCellValue(quiz2),
        DoubleCellValue(assignment1),
        DoubleCellValue(assignment2),
        DoubleCellValue(mid),
        DoubleCellValue(finalExam),
        DoubleCellValue(total),
        TextCellValue(grade),
      ]);
    }
  }

  String _calculateGrade(double marks) {
    if (marks >= 85) return 'A';
    if (marks >= 75) return 'B';
    if (marks >= 65) return 'C';
    if (marks >= 55) return 'D';
    return 'F';
  }

  void _createSummarySheet(Excel excel) {
    final sheet = excel['Summary'];
    debugPrint('Creating Summary sheet...');

    // Course info
    sheet.appendRow([TextCellValue('Course: ${courseCode.value} - ${courseName.value}')]);
    sheet.appendRow([TextCellValue('Generated on: ${DateTime.now()}')]);
    sheet.appendRow([]);

    // Assessment weights
    sheet.appendRow([TextCellValue('Assessment Weights:')]);
    assessmentWeights.forEach((key, value) {
      sheet.appendRow([
        TextCellValue(key),
        DoubleCellValue(value * 100),
        TextCellValue('%'),
      ]);
    });
    sheet.appendRow([]);

    // CLO summary
    sheet.appendRow([TextCellValue('CLO Achievement Summary:')]);
    sheet.appendRow([
      TextCellValue('CLO Code'),
      TextCellValue('Target'),
      TextCellValue('Achieved'),
      TextCellValue('Status'),
    ]);

    // Sample CLO data
    sheet.appendRow([
      TextCellValue('CLO1'),
      DoubleCellValue(70),
      DoubleCellValue(68),
      TextCellValue('Not Achieved'),
    ]);
    sheet.appendRow([
      TextCellValue('CLO2'),
      DoubleCellValue(65),
      DoubleCellValue(72),
      TextCellValue('Achieved'),
    ]);
    sheet.appendRow([
      TextCellValue('CLO3'),
      DoubleCellValue(60),
      DoubleCellValue(63),
      TextCellValue('Achieved'),
    ]);
  }

  Future<File> _saveExcelFile(List<int> bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = 'OBE_${courseCode.value}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  // Get student marks
  double? getStudentMarks(String regNo) {
    final student = studentRecords.firstWhere(
      (s) => s.regNo.trim().toLowerCase() == regNo.trim().toLowerCase(),
      orElse: () => StudentRecord(),
    );

    if (student.regNo.isEmpty || selectedAssessmentType.value.isEmpty) return null;

    final selected = selectedAssessmentType.value;
    if (selected.toLowerCase().contains('quiz')) {
      return student.quizScores[selected];
    } else if (selected.toLowerCase().contains('assignment')) {
      return student.assignmentScores[selected];
    } else {
      return student.examScores[selected];
    }
  }

  // Show error message
  void showError(String message) {
    debugPrint('Error: $message');
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  // Show success message
  void showSuccess(String message) {
    debugPrint('Success: $message');
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}

class StudentRecord {
  String regNo = '';
  String name = '';
  Map<String, double> quizScores = {};
  Map<String, double> assignmentScores = {};
  Map<String, double> examScores = {};

  @override
  String toString() => 'StudentRecord(regNo: $regNo, name: $name)';
}

class CLO {
  final String code;
  final String description;
  final double target;
  final double weight;

  CLO({
    required this.code,
    required this.description,
    required this.target,
    required this.weight,
  });
}