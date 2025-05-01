import 'package:textomize/core/exports.dart';

import 'compress_pdf.dart';
import 'extract_view.dart';
import 'merge_pdf.dart';
import 'protect_pdf.dart';
import 'scan_doc_view.dart';
import 'obe_sheet.dart';
import 'translaet_view.dart';

class AllToolsView extends StatefulWidget {
  const AllToolsView({super.key});

  @override
  State<AllToolsView> createState() => _AllToolsViewState();
}

class _AllToolsViewState extends State<AllToolsView> {
  @override
  Widget build(BuildContext context) {
 final List<Map<String, dynamic>> tools = [
  {
    'label': 'Scan Doc',
    'icon': Icons.document_scanner,
    'view': () => ScanDocumentView(),
  },
  {
    'label': 'Scan QR',
    'icon': Icons.qr_code,
    'view': () => OBESheetView(),
  },
  {
    'label': 'Translate Text',
    'icon': Icons.translate,
    'view': () => TranslateTextView(),
  },
  {
    'label': 'Extract Text',
    'icon': Icons.splitscreen,
    'view': () => ExtractTextView(),
  },
  {
    'label': 'Merge PDF',
    'icon': Icons.merge_type,
    'view': () => MergePDFView(),
  },
  {
    'label': 'Protect PDF',
    'icon': Icons.lock,
    'view': () => ProtectPDFView(),
  },
  {
    'label': 'Compress PDF',
    'icon': Icons.compress,
    'view': () => CompressPDFView(),
  },
];

    return Scaffold(
      appBar: CustomAppBar(title: 'All Tools'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final tool = tools[index];

          return GestureDetector(
onTap: () => Get.to(tool['view']()), 
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(tool['icon'], size: 28, color: AppColors.primaryColor),
                  const SizedBox(width: 16),
                  CustomText(
                    text: tool['label'],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
