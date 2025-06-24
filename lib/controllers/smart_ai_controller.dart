import 'package:lucide_icons/lucide_icons.dart';
import 'package:textomize/models/ai_services.dart';

import '../core/exports.dart';

class SmartAiController extends GetxController {
  final services = <AiService>[].obs;

  @override
  void onInit() {
    services.addAll([
      AiService(
        title: "CNIC Scanner",
        description: "Scan and extract info from CNICs using AI.",
        icon: LucideIcons.badgeHelp,
        onTap: () => Get.to(CnicScannerView()),
        isPremium: true,
      ),
      AiService(
        title: "Document Reader",
        description: "Understand documents with AI-based OCR.",
        icon: LucideIcons.fileText,
        onTap: () => Get.to(CnicScannerView()),
        isPremium: true,
      ),
      AiService(
        title: "Text Summarizer",
        description: "Summarize long text using Smart AI.",
        icon: LucideIcons.alignJustify,
        onTap: () => Get.to(CnicScannerView()),
        isPremium: true,

      ),
      AiService(
        title: "QR/Barcode Scanner",
        description: "Read and analyze codes with intelligence.",
        icon: LucideIcons.qrCode,
        onTap: () => Get.to(CnicScannerView()),
        isPremium:true,

      ),
      AiService(
        title: "Chat Assistant",
        description: "Ask anything from your personal assistant.",
        icon: LucideIcons.messageCircle,
        onTap: () => Get.to(CnicScannerView()),
        isPremium:true,

      ),
    ]);
    super.onInit();
  }
}


class CnicScannerView extends StatefulWidget {
  const CnicScannerView({super.key});

  @override
  State<CnicScannerView> createState() => _CnicScannerViewState();
}

class _CnicScannerViewState extends State<CnicScannerView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}