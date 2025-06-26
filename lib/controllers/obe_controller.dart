import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

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
  
  // Data Storage
  var assessmentWeights = <String, double>{}.obs;
  var cloData = <CLO>[].obs;
  var studentRecords = <StudentRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default weights
    assessmentWeights.value = {
      'Quiz': 0.2,
      'Mid': 0.3,
      'Final': 0.4,
      'Practical': 0.1,
    };
  }

  Future<void> loadAssessmentData(FilePickerResult? result) async {
    if (result == null) {
      showError("No file selected");
      return;
    }

    try {
      isLoading(true);
      final file = result.files.first;
      if (file.bytes == null) throw Exception("Empty file");

      excelFileName.value = file.name;
      excelBytes = file.bytes;
      await _parseExcelData(file.bytes!);

      dataReady.value = validateDataIntegrity();

      if (dataReady.value) {
        showSuccess("Data loaded successfully");
      } else {
        showError("Missing required data fields");
      }
    } catch (e) {
      clearData();
      showError("Error parsing file: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadAssessmentDataFromBytes(Uint8List bytes) async {
    try {
      isLoading(true);
      await _parseExcelData(bytes);
      dataReady.value = validateDataIntegrity();
    } catch (e) {
      clearData();
      showError("Error parsing file: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  bool validateDataIntegrity() {
  // Auto-normalize weights if sum ≠ 1
  final totalWeight = assessmentWeights.values.fold(0.0, (a, b) => a + b);
  if (totalWeight > 0 && (totalWeight - 1.0).abs() > 0.001) {
    final factor = 1.0 / totalWeight;
    assessmentWeights.updateAll((key, value) => value * factor);
  }
  
  // If no weights specified, create default equal distribution
  if (assessmentWeights.isEmpty && cloData.isNotEmpty) {
    final weight = 1.0 / cloData.length;
    for (final clo in cloData) {
      assessmentWeights[clo.code] = weight;
    }
  }

  return courseName.value.isNotEmpty && 
         courseCode.value.isNotEmpty && 
         (cloData.isNotEmpty || studentRecords.isNotEmpty);
}

  Future<void> _parseExcelData(Uint8List bytes) async {
    try {
      final excel = Excel.decodeBytes(bytes);
      if (excel.tables.isEmpty) throw Exception("No sheets found");

      final sheet = excel.tables.values.firstWhere(
        (table) => table.rows.length > 1,
        orElse: () => throw Exception("No valid data sheet found"),
      );

      final headers = sheet.rows.first.map((cell) => cell?.value?.toString().trim()).toList();
      _validateRequiredColumns(headers);
      _parseCLOsFromHeaders(headers);
      studentRecords.assignAll(_parseStudentRecords(sheet.rows.sublist(1), headers));
    } catch (e) {
      throw Exception("Failed to parse Excel data: ${e.toString()}");
    }
  }


void _validateRequiredColumns(List<String?> headers) {
  final cleaned = headers.map((e) => e?.trim().toLowerCase()).toList();
  
  // Make regno and name optional with default values
  if (!cleaned.contains('regno')) {
    debugPrint("Warning: 'regno' column not found - will generate placeholder IDs");
  }
  if (!cleaned.contains('name')) {
    debugPrint("Warning: 'name' column not found - will use placeholder names");
  }

  // Check for at least one assessment column (CLO or other)
  final hasAssessmentColumns = cleaned.any((h) => 
      h?.startsWith('clo') ?? false || 
      ['quiz', 'mid', 'final', 'practical'].any((a) => h?.contains(a) ?? false));
  
  if (!hasAssessmentColumns) {
    throw Exception("No assessment columns found (expected CLOs or assessment types)");
  }
}


 void _parseCLOsFromHeaders(List<String?> headers) {
  cloData.clear();
  final cloHeaders = headers.where((h) => h?.toLowerCase().trim().startsWith('clo') ?? false);

  for (final header in cloHeaders) {
    if (header != null) {
      cloData.add(CLO(
        code: header.trim(),
        description: '',
        target: 70.0,
        weight: 1.0 / cloHeaders.length,
      ));
    }
  }
}

List<StudentRecord> _parseStudentRecords(List<List<Data?>> rows, List<String?> headers) {
  return rows.asMap().entries.map((entry) {
    final index = entry.key;
    final row = entry.value;
    final record = StudentRecord();
    
    try {
      for (int i = 0; i < headers.length; i++) {
        final headerRaw = headers[i];
        final value = row.length > i ? row[i]?.value : null;
        if (headerRaw == null) continue;

        final header = headerRaw.trim();
        final lowerHeader = header.toLowerCase();
        final stringVal = value?.toString().trim() ?? '';

        // Flexible column handling
        if (lowerHeader.contains('regno') ){
          record.regNo = stringVal.isNotEmpty ? stringVal : 'ID_${index + 1}';
        } else if (lowerHeader.contains('name')) {
          record.name = stringVal.isNotEmpty ? stringVal : 'Student ${index + 1}';
        } else if (lowerHeader.startsWith('clo')) {
          record.cloScores[header] = double.tryParse(stringVal) ?? 0;
        } else {
          // Auto-detect assessment types
          if (lowerHeader.contains('quiz') || 
              lowerHeader.contains('mid') || 
              lowerHeader.contains('final') || 
              lowerHeader.contains('practical')) {
            record.quizScores[header] = double.tryParse(stringVal) ?? 0;
            // Auto-add to weights if not present
            final type = _detectAssessmentType(header);
            assessmentWeights.putIfAbsent(type, () => 0.0);
          }
        }
      }

      return record;
    } catch (e) {
      debugPrint("Row error: ${e.toString()}");
      return StudentRecord()..regNo = 'ID_${index + 1}';
    }
  }).where((s) => s.regNo.isNotEmpty).toList();
}

String _detectAssessmentType(String header) {
  final lowerHeader = header.toLowerCase();
  if (lowerHeader.contains('quiz')) return 'Quiz';
  if (lowerHeader.contains('mid')) return 'Mid';
  if (lowerHeader.contains('final')) return 'Final';
  if (lowerHeader.contains('practical')) return 'Practical';
  return 'Other';
}
  Future<void> editUploadedFile() async {
    if (excelFileName.isEmpty) {
      showError("No file uploaded to edit");
      return;
    }

    try {
      isLoading(true);
      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );
      
      if (result == null) return;
      
      await loadAssessmentData(result);
      
      showSuccess("File edited successfully");
    } catch (e) {
      showError("Error editing file: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addNewColumns(List<String> newColumns) async {
    if (excelBytes == null) {
      showError("No file data available");
      return;
    }

    try {
      isLoading(true);
      
      final excel = Excel.decodeBytes(excelBytes!);
      final sheet = excel.tables.values.first;
      
      final headers = sheet.rows.first.map((c) => c?.value?.toString()).toList();
      headers.addAll(newColumns);
      sheet.rows.first = headers.map((h) => TextCellValue(h ?? '')).cast<Data?>().toList();
      
      for (int i = 1; i < sheet.rows.length; i++) {
        for (var _ in newColumns) {
          sheet.rows[i].add(TextCellValue('') as Data?);
        }
      }
      
      excelBytes = excel.encode() as Uint8List?;
      await loadAssessmentDataFromBytes(excelBytes!);
      
      showSuccess("${newColumns.length} new columns added successfully");
    } catch (e) {
      showError("Error adding columns: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  Future<void> generateOBESheet() async {
    if (!dataReady.value) {
      showError("Complete all data requirements first");
      return;
    }

    try {
      isLoading(true);
      normalizeWeights();
      
      if (!validateDataIntegrity()) {
        throw Exception("Data validation failed. Please check your inputs.");
      }

      final excel = Excel.createExcel();
      _createCLOAnalysisSheet(excel);
      _createStudentReportSheet(excel);
      _createSummarySheet(excel);

      if (excel.tables.isEmpty) {
        throw Exception("No sheets were created in the Excel file");
      }

      final bytes = excel.encode();
      if (bytes == null || bytes.isEmpty) {
        throw Exception("Failed to generate Excel file");
      }

      final file = await _saveExcelFile(bytes);
      showSuccess("OBE Report generated successfully: ${file.path}");
      
    } catch (e) {
      showError("Report generation failed: ${e.toString()}");
      debugPrint(e.toString());
      debugPrintStack(stackTrace: StackTrace.current);
    } finally {
      isLoading(false);
    }
  }

  void normalizeWeights() {
    final totalWeight = assessmentWeights.values.fold(0.0, (a, b) => a + b);
    
    if (totalWeight == 0) {
      assessmentWeights.value = {
        'Quiz': 0.2,
        'Mid': 0.3,
        'Final': 0.4,
        'Practical': 0.1,
      };
    } else if ((totalWeight - 1.0).abs() > 0.001) {
      final normalizedWeights = Map<String, double>.from(assessmentWeights)
        ..updateAll((key, value) => value / totalWeight);
      assessmentWeights.value = normalizedWeights;
    }
  }
void _createCLOAnalysisSheet(Excel excel) {
  final sheet = excel['CLO Analysis'];
  
  // Dynamic headers based on available data
  final headers = ['CLO Code', 'Description', 'Target %', 'Achieved %'];
  if (assessmentWeights.isNotEmpty) {
    headers.add('Weight');
  }
  headers.addAll(['Gap', 'Status']);
  
  sheet.appendRow(headers.map(TextCellValue.new).toList());
  
  for (final clo in cloData) {
    final achieved = calculateCLOAchievement(clo.code);
    final gap = achieved - clo.target;
    
    final row = [
      TextCellValue(clo.code),
      TextCellValue(clo.description),
      DoubleCellValue(clo.target),
      DoubleCellValue(achieved),
    ];
    
    if (assessmentWeights.isNotEmpty) {
      row.add(DoubleCellValue(assessmentWeights[clo.code] ?? 0));
    }
    
    row.addAll([
      DoubleCellValue(gap),
      TextCellValue(gap >= 0 ? 'Achieved' : 'Not Achieved'),
    ]);
    
    sheet.appendRow(row);
  }
}

  void _createStudentReportSheet(Excel excel) {
    final sheet = excel['Student Reports'];
    
    final headers = ['RegNo', 'Name', ...cloData.map((e) => e.code)];
    sheet.appendRow(headers.map(TextCellValue.new).toList());
    
    for (final student in studentRecords) {
      final row = [
        TextCellValue(student.regNo),
        TextCellValue(student.name),
        ...cloData.map((clo) => DoubleCellValue(student.cloScores[clo.code] ?? 0))
      ];
      sheet.appendRow(row);
    }
  }

  void _createSummarySheet(Excel excel) {
    final sheet = excel['Summary'];
    
    sheet.appendRow([TextCellValue('Course: $courseCode - $courseName')]);
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('D1'));
    
    sheet.appendRow([
      'CLO', 'Target', 'Achieved', 'Status'
    ].map(TextCellValue.new).toList());
    
    for (final clo in cloData) {
      final achieved = calculateCLOAchievement(clo.code);
      sheet.appendRow([
        TextCellValue(clo.code),
        DoubleCellValue(clo.target),
        DoubleCellValue(achieved),
        TextCellValue(achieved >= clo.target ? '✓' : '✗'),
      ]);
    }
  }

 // In your OBECLOSheetController class
double calculateCLOAchievement(String cloCode) {  // Changed from _calculateCLOAchievement to calculateCLOAchievement
  try {
    final validScores = studentRecords
        .map((s) => s.cloScores[cloCode] ?? 0)
        .where((s) => s >= 0 && s <= 100)
        .toList();
    
    if (validScores.isEmpty) return 0;
    
    if (assessmentWeights.isNotEmpty) {
      double weightedSum = 0;
      double totalWeight = 0;
      
      for (final student in studentRecords) {
        final score = student.cloScores[cloCode] ?? 0;
        final studentWeight = _calculateStudentWeight(student);
        weightedSum += score * studentWeight;
        totalWeight += studentWeight;
      }
      
      return totalWeight > 0 ? weightedSum / totalWeight : 0;
    }
    
    return validScores.reduce((a, b) => a + b) / validScores.length;
  } catch (e) {
    showError("Error calculating CLO achievement: ${e.toString()}");
    return 0;
  }
}

  double _calculateStudentWeight(StudentRecord student) {
    double weight = 0;
    
    for (final assessment in assessmentWeights.keys) {
      if (student.quizScores.containsKey(assessment)) {
        weight += assessmentWeights[assessment] ?? 0;
      }
    }
    
    return weight > 0 ? weight : 1.0;
  }

  Future<File> _saveExcelFile(List<int> bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = 'OBE_${courseCode}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  void clearData() {
    courseName.value = '';
    courseCode.value = '';
    assessmentWeights.clear();
    cloData.clear();
    studentRecords.clear();
    excelFileName.value = '';
    excelBytes = null;
    dataReady.value = false;
  }

  void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
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

class StudentRecord {
  String regNo = '';
  String name = '';
  Map<String, double> quizScores = {};
  Map<String, double> assignmentScores = {};
  Map<String, double> examScores = {};
  Map<String, double> cloScores = {};
}