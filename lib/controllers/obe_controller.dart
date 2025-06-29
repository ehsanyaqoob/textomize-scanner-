import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
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

  // Debug utility
  void _debugPrint(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final stackTrace = StackTrace.current.toString().split('\n')[1].trim();
    debugPrint('[$timestamp][${tag ?? 'DEBUG'}] $stackTrace - $message');
  }

  @override
  void onInit() {
    _debugPrint('Controller initialization started');
    super.onInit();
    
    assessmentWeights.value = {
      'Quiz 1': 0.1,
      'Quiz 2': 0.1,
      'Assignment 1': 0.15,
      'Assignment 2': 0.15,
      'Mid Term': 0.2,
      'Final Term': 0.3,
    };
    _debugPrint('Default assessment weights set: $assessmentWeights');
    _debugPrint('Controller initialization completed');
  }

  Future<Map<String, dynamic>> processScannedPaper(File imageFile) async {
    _debugPrint('Starting scanned paper processing', tag: 'OCR');
    try {
      _debugPrint('Image path: ${imageFile.path}', tag: 'OCR');
      _debugPrint('Image size: ${await imageFile.length()} bytes', tag: 'OCR');

      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      _debugPrint('Text recognizer initialized', tag: 'OCR');

      _debugPrint('Starting text recognition...', tag: 'OCR');
      final RecognizedText recognisedText = await textRecognizer.processImage(inputImage);
      _debugPrint('OCR completed. Found ${recognisedText.blocks.length} text blocks', tag: 'OCR');

      String regNo = '';
      double marks = 0;
      bool foundRegNo = false;
      bool foundMarks = false;

      // Debug: Log all recognized text
      for (int i = 0; i < recognisedText.blocks.length; i++) {
        _debugPrint('Block $i text: ${recognisedText.blocks[i].text}', tag: 'OCR-DETAIL');
      }

      // First pass: Look for clear patterns
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text.toLowerCase().trim();
          _debugPrint('Processing line: $text', tag: 'OCR-LINE');

          // Registration number detection
          if (!foundRegNo) {
            if (text.contains('reg') || text.contains('id') || text.contains('arid')) {
              _debugPrint('Found potential RegNo keyword in line', tag: 'OCR-REGNO');
              regNo = line.text.trim();
              foundRegNo = true;
              _debugPrint('Initial RegNo candidate: $regNo', tag: 'OCR-REGNO');
            }

            final regExp = RegExp(r'(\d{1,2}-[a-zA-Z]{3,4}-\d{3})');
            if (regExp.hasMatch(text)) {
              regNo = regExp.firstMatch(text)!.group(1)!;
              foundRegNo = true;
              _debugPrint('RegEx matched RegNo: $regNo', tag: 'OCR-REGNO');
            }
          }

          // Marks detection
          if (!foundMarks) {
            if (text.contains('marks') || text.contains('score') || text.contains('total') || text.contains('obtained')) {
              _debugPrint('Found potential marks keyword in line', tag: 'OCR-MARKS');
              final numbers = RegExp(r'(\d{1,3}(?:\.\d{1,2})?)').allMatches(line.text);
              if (numbers.isNotEmpty) {
                marks = double.tryParse(numbers.first.group(0) ?? '') ?? 0;
                foundMarks = marks > 0;
                _debugPrint('Extracted marks: $marks', tag: 'OCR-MARKS');
              }
            }
          }
        }
      }

      // Second pass if needed
      if (!foundRegNo || !foundMarks) {
        _debugPrint('Starting second pass for ${!foundRegNo ? 'RegNo' : ''} ${!foundMarks ? 'Marks' : ''}', tag: 'OCR');
        
        for (TextBlock block in recognisedText.blocks) {
          for (TextLine line in block.lines) {
            final text = line.text.trim();

            if (!foundRegNo) {
              final regExp = RegExp(r'(\d{1,2}-[a-zA-Z]{3,4}-\d{3})');
              if (regExp.hasMatch(text)) {
                regNo = regExp.firstMatch(text)!.group(1)!;
                foundRegNo = true;
                _debugPrint('Second pass found RegNo: $regNo', tag: 'OCR-REGNO');
              }
            }

            if (!foundMarks) {
              final numbers = RegExp(r'(\d{1,3}(?:\.\d{1,2})?)$').allMatches(text);
              if (numbers.isNotEmpty) {
                final potentialMark = double.tryParse(numbers.first.group(0) ?? '') ?? 0;
                if (potentialMark >= 0 && potentialMark <= 100) {
                  marks = potentialMark;
                  foundMarks = true;
                  _debugPrint('Second pass found marks: $marks', tag: 'OCR-MARKS');
                }
              }
            }
          }
        }
      }

      await textRecognizer.close();
      _debugPrint('Text recognizer closed', tag: 'OCR');

      if (!foundRegNo || !foundMarks) {
        _debugPrint('Failed to extract complete data. RegNo: $foundRegNo, Marks: $foundMarks', tag: 'OCR-ERROR');
        throw Exception("Could not extract required data");
      }

      _debugPrint('Successfully extracted data - RegNo: $regNo, Marks: $marks', tag: 'OCR-SUCCESS');
      return {
        'regNo': regNo,
        'marks': marks,
        'confidence': (foundRegNo && foundMarks) ? 1.0 : 0.5
      };
    } catch (e, stack) {
      _debugPrint('OCR Processing failed: $e', tag: 'OCR-ERROR');
      _debugPrint('Stack trace: $stack', tag: 'OCR-ERROR');
      throw Exception("Failed to process scanned paper: ${e.toString()}");
    }
  }
  void updateStudentMarks(String scannedRegNo, double scannedMarks, BuildContext context) {
    _debugPrint('Updating marks for $scannedRegNo with $scannedMarks', tag: 'DATA');
    try {
      if (selectedAssessmentType.value.isEmpty) {
        _debugPrint('No assessment type selected', tag: 'DATA-ERROR');
        throw Exception("No assessment type selected");
      }

      _debugPrint('Looking for student: $scannedRegNo', tag: 'DATA');
      final student = studentRecords.firstWhere(
            (s) => s.regNo.trim().toLowerCase() == scannedRegNo.trim().toLowerCase(),
        orElse: () => StudentRecord(),
      );

      if (student.regNo.isEmpty) {
        _debugPrint('Student not found: $scannedRegNo', tag: 'DATA-ERROR');
        throw Exception("Student not found: $scannedRegNo");
      }

      final assessment = selectedAssessmentType.value;
      final weight = assessmentWeights[assessment] ?? 1.0;
      final weightedMarks = scannedMarks * weight;
      _debugPrint('Assessment: $assessment, Weight: $weight, Weighted Marks: $weightedMarks', tag: 'DATA');

      if (assessment.toLowerCase().contains('quiz')) {
        student.quizScores[assessment] = weightedMarks;
        _debugPrint('Updated quiz scores: ${student.quizScores}', tag: 'DATA');
      } else if (assessment.toLowerCase().contains('assignment')) {
        student.assignmentScores[assessment] = weightedMarks;
        _debugPrint('Updated assignment scores: ${student.assignmentScores}', tag: 'DATA');
      } else {
        student.examScores[assessment] = weightedMarks;
        _debugPrint('Updated exam scores: ${student.examScores}', tag: 'DATA');
      }

      studentPreviewData.assignAll(studentRecords);
      studentRecords.refresh();
      _debugPrint('Student records updated successfully', tag: 'DATA');
      showSuccess("Marks updated for $scannedRegNo");

      // After showing the success message, pop the current screen
      Navigator.pop(context); // This will navigate back to the parent screen

    } catch (e, stack) {
      _debugPrint('Error updating marks: $e', tag: 'DATA-ERROR');
      _debugPrint('Stack trace: $stack', tag: 'DATA-ERROR');
      showError(e.toString());
    }
  }

  // void updateStudentMarks(String scannedRegNo, double scannedMarks) {
  //   _debugPrint('Updating marks for $scannedRegNo with $scannedMarks', tag: 'DATA');
  //   try {
  //     if (selectedAssessmentType.value.isEmpty) {
  //       _debugPrint('No assessment type selected', tag: 'DATA-ERROR');
  //       throw Exception("No assessment type selected");
  //     }
  //
  //     _debugPrint('Looking for student: $scannedRegNo', tag: 'DATA');
  //     final student = studentRecords.firstWhere(
  //       (s) => s.regNo.trim().toLowerCase() == scannedRegNo.trim().toLowerCase(),
  //       orElse: () => StudentRecord(),
  //     );
  //
  //     if (student.regNo.isEmpty) {
  //       _debugPrint('Student not found: $scannedRegNo', tag: 'DATA-ERROR');
  //       throw Exception("Student not found: $scannedRegNo");
  //     }
  //
  //     final assessment = selectedAssessmentType.value;
  //     final weight = assessmentWeights[assessment] ?? 1.0;
  //     final weightedMarks = scannedMarks * weight;
  //     _debugPrint('Assessment: $assessment, Weight: $weight, Weighted Marks: $weightedMarks', tag: 'DATA');
  //
  //     if (assessment.toLowerCase().contains('quiz')) {
  //       student.quizScores[assessment] = weightedMarks;
  //       _debugPrint('Updated quiz scores: ${student.quizScores}', tag: 'DATA');
  //     } else if (assessment.toLowerCase().contains('assignment')) {
  //       student.assignmentScores[assessment] = weightedMarks;
  //       _debugPrint('Updated assignment scores: ${student.assignmentScores}', tag: 'DATA');
  //     } else {
  //       student.examScores[assessment] = weightedMarks;
  //       _debugPrint('Updated exam scores: ${student.examScores}', tag: 'DATA');
  //     }
  //
  //     studentPreviewData.assignAll(studentRecords);
  //     studentRecords.refresh();
  //     _debugPrint('Student records updated successfully', tag: 'DATA');
  //     showSuccess("Marks updated for $scannedRegNo");
  //   } catch (e, stack) {
  //     _debugPrint('Error updating marks: $e', tag: 'DATA-ERROR');
  //     _debugPrint('Stack trace: $stack', tag: 'DATA-ERROR');
  //     showError(e.toString());
  //   }
  // }

  Future<void> loadAssessmentData(FilePickerResult result) async {
    _debugPrint('Loading assessment data started', tag: 'FILE');
    try {
      isLoading(true);
      excelBytes = result.files.first.bytes;
      excelFileName.value = result.files.first.name;
      _debugPrint('File selected: ${excelFileName.value}', tag: 'FILE');
      _debugPrint('File size: ${excelBytes?.length} bytes', tag: 'FILE');

      final excel = Excel.decodeBytes(excelBytes!);
      _debugPrint('Excel decoded. Sheet count: ${excel.tables.length}', tag: 'FILE');

      if (excel.tables.isEmpty) {
        _debugPrint('No sheets found in Excel file', tag: 'FILE-ERROR');
        throw Exception("No sheets found in Excel file");
      }

      final sheet = excel.tables.values.first;
      _debugPrint('Processing sheet', tag: 'FILE');
      _debugPrint('Row count: ${sheet.rows.length}', tag: 'FILE');

      final headers = sheet.rows.first.map((cell) => cell?.value?.toString()?.trim()).toList();
      _debugPrint('Headers found: $headers', tag: 'FILE');

      studentRecords.assignAll(_parseStudentRecords(sheet.rows.sublist(1), headers));
      _debugPrint('Parsed ${studentRecords.length} student records', tag: 'FILE');

      // Log sample records
      for (int i = 0; i < (studentRecords.length > 3 ? 3 : studentRecords.length); i++) {
        _debugPrint('Sample record $i: ${studentRecords[i]}', tag: 'FILE-DATA');
      }

      dataReady.value = true;
      _debugPrint('Data loading completed successfully', tag: 'FILE');
      showSuccess("File loaded successfully with ${studentRecords.length} students");
    } catch (e, stack) {
      _debugPrint('Error loading assessment data: $e', tag: 'FILE-ERROR');
      _debugPrint('Stack trace: $stack', tag: 'FILE-ERROR');
      showError("Failed to load Excel file: ${e.toString()}");
      dataReady.value = false;
    } finally {
      isLoading(false);
    }
  }

  List<StudentRecord> _parseStudentRecords(List<List<Data?>> rows, List<String?> headers) {
    _debugPrint('Parsing student records from ${rows.length} rows', tag: 'PARSER');
    final records = <StudentRecord>[];

    for (int i = 0; i < rows.length; i++) {
      try {
        _debugPrint('Processing row $i', tag: 'PARSER-ROW');
        final row = rows[i];
        final record = StudentRecord();

        for (int j = 0; j < headers.length; j++) {
          final header = headers[j]?.trim() ?? '';
          final value = row.length > j ? row[j]?.value?.toString()?.trim() : '';
          _debugPrint('Cell[$i,$j] - Header: "$header", Value: "$value"', tag: 'PARSER-CELL');

          if (header.isEmpty) continue;

          if (header.toLowerCase().contains('regno')) {
            record.regNo = value?.isNotEmpty == true ? value! : 'ID_${i + 1}';
            _debugPrint('Set regNo: ${record.regNo}', tag: 'PARSER-REGNO');
          } else if (header.toLowerCase().contains('name')) {
            record.name = value?.isNotEmpty == true ? value! : 'Student ${i + 1}';
            _debugPrint('Set name: ${record.name}', tag: 'PARSER-NAME');
          } else if (header.toLowerCase().contains('quiz')) {
            final marks = double.tryParse(value ?? '0') ?? 0;
            record.quizScores[header] = marks;
            _debugPrint('Set quiz $header: $marks', tag: 'PARSER-QUIZ');
          } else if (header.toLowerCase().contains('assignment')) {
            final marks = double.tryParse(value ?? '0') ?? 0;
            record.assignmentScores[header] = marks;
            _debugPrint('Set assignment $header: $marks', tag: 'PARSER-ASSIGNMENT');
          } else if (header.toLowerCase().contains('mid') || header.toLowerCase().contains('final')) {
            final marks = double.tryParse(value ?? '0') ?? 0;
            record.examScores[header] = marks;
            _debugPrint('Set exam $header: $marks', tag: 'PARSER-EXAM');
          }
        }

        if (record.regNo.isNotEmpty) {
          records.add(record);
          _debugPrint('Added valid record: ${record.regNo}', tag: 'PARSER-RECORD');
        }
      } catch (e) {
        _debugPrint('Error parsing row $i: $e', tag: 'PARSER-ERROR');
      }
    }

    _debugPrint('Completed parsing. Total valid records: ${records.length}', tag: 'PARSER');
    return records;
  }

  void selectAssessmentType(String type) {
    _debugPrint('Selected assessment type: $type', tag: 'UI');
    selectedAssessmentType.value = type;
  }

  Future<void> editUploadedFile() async {
    _debugPrint('Edit uploaded file initiated', tag: 'FILE');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result != null) {
        _debugPrint('New file selected for editing', tag: 'FILE');
        await loadAssessmentData(result);
      } else {
        _debugPrint('File selection cancelled', tag: 'FILE');
      }
    } catch (e, stack) {
      _debugPrint('Error editing file: $e', tag: 'FILE-ERROR');
      _debugPrint('Stack trace: $stack', tag: 'FILE-ERROR');
      showError("Failed to edit file: ${e.toString()}");
    }
  }

  Future<File?> exportUpdatedSheet() async {
    _debugPrint('Exporting updated sheet started', tag: 'EXPORT');
    try {
      if (excelBytes == null) {
        _debugPrint('No Excel file loaded', tag: 'EXPORT-ERROR');
        showError("No Excel file loaded");
        return null;
      }

      isLoading(true);
      final excel = Excel.decodeBytes(excelBytes!);
      final sheet = excel.tables.values.first;
      _debugPrint('Original sheet loaded', tag: 'EXPORT');

      final headers = sheet.rows.first.map((cell) => cell?.value?.toString()).toList();
      _debugPrint('Original headers: $headers', tag: 'EXPORT');

      int regNoIndex = headers.indexWhere((h) => h?.toLowerCase().contains('regno') ?? false);
      if (regNoIndex == -1) {
        _debugPrint('RegNo column not found', tag: 'EXPORT-ERROR');
        throw Exception("RegNo column not found in original sheet");
      }

      final assessmentType = selectedAssessmentType.value;
      _debugPrint('Processing assessment type: $assessmentType', tag: 'EXPORT');

      if (!headers.contains(assessmentType)) {
        _debugPrint('Adding new assessment column: $assessmentType', tag: 'EXPORT');
        headers.add(assessmentType);
        sheet.rows[0] = headers.map((h) => TextCellValue(h ?? '')).cast<Data?>().toList();
        for (int i = 1; i < sheet.rows.length; i++) {
          sheet.rows[i].add(TextCellValue('') as Data?);
        }
      }

      int assessmentIndex = headers.indexOf(assessmentType);
      _debugPrint('Assessment column index: $assessmentIndex', tag: 'EXPORT');

      _debugPrint('Updating marks for ${sheet.rows.length - 1} students', tag: 'EXPORT');
      for (int i = 1; i < sheet.rows.length; i++) {
        final regCell = sheet.rows[i][regNoIndex];
        final regNo = regCell?.value?.toString() ?? '';
        final marks = getStudentMarks(regNo);

        if (marks != null) {
          sheet.rows[i][assessmentIndex] = DoubleCellValue(marks) as Data?;
          _debugPrint('Updated marks for $regNo: $marks', tag: 'EXPORT-UPDATE');
        }
      }

      final file = await _saveExcelFile(excel.encode()!);
      _debugPrint('File exported successfully: ${file.path}', tag: 'EXPORT');
      return file;
    } catch (e, stack) {
      _debugPrint('Error exporting sheet: $e', tag: 'EXPORT-ERROR');
      _debugPrint('Stack trace: $stack', tag: 'EXPORT-ERROR');
      showError("Failed to export sheet: ${e.toString()}");
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<void> generateOBESheet() async {
    _debugPrint('Generating OBE sheet started', tag: 'GENERATE');
    try {
      isLoading(true);
      
      if (courseCode.value.isEmpty || courseName.value.isEmpty) {
        _debugPrint('Missing course information', tag: 'GENERATE-ERROR');
        throw Exception("Course information not complete");
      }

      if (studentRecords.isEmpty) {
        _debugPrint('No student data available', tag: 'GENERATE-ERROR');
        throw Exception("No student data available");
      }

      final excel = Excel.createExcel();
      _debugPrint('New Excel workbook created', tag: 'GENERATE');

      _createCLOAnalysisSheet(excel);
      _createStudentReportSheet(excel);
      _createSummarySheet(excel);

      final bytes = excel.encode();
      if (bytes == null) {
        _debugPrint('Failed to encode Excel', tag: 'GENERATE-ERROR');
        throw Exception("Failed to encode Excel file");
      }

      final file = await _saveExcelFile(bytes);
      studentPreviewData.assignAll(studentRecords);
      _debugPrint('OBE Report generated successfully: ${file.path}', tag: 'GENERATE');
      showSuccess("OBE Report generated: ${file.path}");
    } catch (e, stack) {
      _debugPrint('Error generating report: $e', tag: 'GENERATE-ERROR');
      _debugPrint('Stack trace: $stack', tag: 'GENERATE-ERROR');
      showError("Report generation failed: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  void _createCLOAnalysisSheet(Excel excel) {
    _debugPrint('Creating CLO Analysis sheet', tag: 'GENERATE-CLO');
    final sheet = excel['CLO Analysis'];
    
    sheet.appendRow([
      TextCellValue('CLO Code'),
      TextCellValue('Description'),
      TextCellValue('Target %'),
      TextCellValue('Achieved %'),
      TextCellValue('Status'),
    ]);
    _debugPrint('Added CLO headers', tag: 'GENERATE-CLO');

    final sampleClos = [
      CLO(code: 'CLO1', description: 'Understand concepts', target: 70, weight: 0.3),
      CLO(code: 'CLO2', description: 'Apply knowledge', target: 65, weight: 0.4),
      CLO(code: 'CLO3', description: 'Analyze problems', target: 60, weight: 0.3),
    ];

    for (final clo in sampleClos) {
      final achieved = 65.0;
      final status = achieved >= clo.target ? 'Achieved' : 'Not Achieved';
      sheet.appendRow([
        TextCellValue(clo.code),
        TextCellValue(clo.description),
        DoubleCellValue(clo.target),
        DoubleCellValue(achieved),
        TextCellValue(status),
      ]);
      _debugPrint('Added CLO: ${clo.code}', tag: 'GENERATE-CLO');
    }
  }

  void _createStudentReportSheet(Excel excel) {
    _debugPrint('Creating Student Report sheet', tag: 'GENERATE-REPORT');
    final sheet = excel['Student Report'];
    
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
    _debugPrint('Added student report headers', tag: 'GENERATE-REPORT');

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
      _debugPrint('Added student: ${student.regNo}', tag: 'GENERATE-REPORT');
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
    _debugPrint('Creating Summary sheet', tag: 'GENERATE-SUMMARY');
    final sheet = excel['Summary'];
    
    sheet.appendRow([TextCellValue('Course: ${courseCode.value} - ${courseName.value}')]);
    sheet.appendRow([TextCellValue('Generated on: ${DateTime.now()}')]);
    sheet.appendRow([]);
    _debugPrint('Added course info', tag: 'GENERATE-SUMMARY');

    sheet.appendRow([TextCellValue('Assessment Weights:')]);
    assessmentWeights.forEach((key, value) {
      sheet.appendRow([
        TextCellValue(key),
        DoubleCellValue(value * 100),
        TextCellValue('%'),
      ]);
    });
    _debugPrint('Added assessment weights', tag: 'GENERATE-SUMMARY');
    sheet.appendRow([]);

    sheet.appendRow([TextCellValue('CLO Achievement Summary:')]);
    sheet.appendRow([
      TextCellValue('CLO Code'),
      TextCellValue('Target'),
      TextCellValue('Achieved'),
      TextCellValue('Status'),
    ]);
    _debugPrint('Added CLO summary headers', tag: 'GENERATE-SUMMARY');

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
    _debugPrint('Added CLO summary data', tag: 'GENERATE-SUMMARY');
  }

  Future<File> _saveExcelFile(List<int> bytes) async {
    _debugPrint('Saving Excel file started', tag: 'FILE-SAVE');
    try {
      final dir = Directory('/storage/emulated/0/Download');
      _debugPrint('Target directory: ${dir.path}', tag: 'FILE-SAVE');

      if (!await dir.exists()) {
        _debugPrint('Creating download directory', tag: 'FILE-SAVE');
        await dir.create(recursive: true);
      }

      final filename = 'OBE_${courseCode.value}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File('${dir.path}/$filename');
      _debugPrint('Full file path: ${file.path}', tag: 'FILE-SAVE');

      await file.writeAsBytes(bytes);
      _debugPrint('File saved successfully. Size: ${bytes.length} bytes', tag: 'FILE-SAVE');

      // Verify file
      if (await file.exists()) {
        final stats = await file.stat();
        _debugPrint('File verification passed. Size: ${stats.size} bytes', tag: 'FILE-SAVE');
      } else {
        _debugPrint('File verification failed - file not found', tag: 'FILE-SAVE-ERROR');
      }

      return file;
    } catch (e, stack) {
      _debugPrint('Error saving file: $e', tag: 'FILE-SAVE-ERROR');
      _debugPrint('Stack trace: $stack', tag: 'FILE-SAVE-ERROR');
      rethrow;
    }
  }

  double? getStudentMarks(String regNo) {
    _debugPrint('Getting marks for $regNo', tag: 'DATA');
    final student = studentRecords.firstWhere(
      (s) => s.regNo.trim().toLowerCase() == regNo.trim().toLowerCase(),
      orElse: () => StudentRecord(),
    );

    if (student.regNo.isEmpty || selectedAssessmentType.value.isEmpty) {
      _debugPrint('Student or assessment type not found', tag: 'DATA-ERROR');
      return null;
    }

    final selected = selectedAssessmentType.value;
    if (selected.toLowerCase().contains('quiz')) {
      _debugPrint('Returning quiz marks: ${student.quizScores[selected]}', tag: 'DATA');
      return student.quizScores[selected];
    } else if (selected.toLowerCase().contains('assignment')) {
      _debugPrint('Returning assignment marks: ${student.assignmentScores[selected]}', tag: 'DATA');
      return student.assignmentScores[selected];
    } else {
      _debugPrint('Returning exam marks: ${student.examScores[selected]}', tag: 'DATA');
      return student.examScores[selected];
    }
  }

  void showError(String message) {
    _debugPrint('Showing error: $message', tag: 'UI-ERROR');
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void showSuccess(String message) {
    _debugPrint('Showing success: $message', tag: 'UI-SUCCESS');
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