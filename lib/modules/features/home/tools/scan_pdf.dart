import 'package:textomize/core/exports.dart';
class ScanPDFView extends StatefulWidget {
  const ScanPDFView({super.key});

  @override
  State<ScanPDFView> createState() => _ScanPDFViewState();
}

class _ScanPDFViewState extends State<ScanPDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dumy'),),
    );
  }
}