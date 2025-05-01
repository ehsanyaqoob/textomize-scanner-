// models/obe_sheet_model.dart

class OBESheetModel {
  String sheetName;
  List<String> clos;
  Map<String, double> marks; // e.g., { "Quiz 1": 10, "Mid": 30 }

  OBESheetModel({
    required this.sheetName,
    required this.clos,
    required this.marks,
  });
}
