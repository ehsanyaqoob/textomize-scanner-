
import '../core/exports.dart';
import '../models/doc_model.dart';class DocumentController extends GetxController {
  RxList<DocumentModel> recentDocuments = <DocumentModel>[
    DocumentModel(title: 'Resume.pdf', size: '150 KB', dateTime: DateTime.now().subtract(Duration(hours: 1))),
    DocumentModel(title: 'Invoice_001.xlsx', size: '75 KB', dateTime: DateTime.now().subtract(Duration(days: 1))),
    DocumentModel(title: 'Photo_ID.png', size: '1.2 MB', dateTime: DateTime.now().subtract(Duration(days: 2))),
  ].obs;

  void deleteDocument(int index) {
    recentDocuments.removeAt(index);
  }
}
