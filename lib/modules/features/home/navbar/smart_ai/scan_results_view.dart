import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textomize/controllers/scan_con.dart';
import 'package:textomize/core/exports.dart';

class ScanResultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScanDocumentController controller = Get.find<ScanDocumentController>();

    return Scaffold(
      appBar:CustomAppBar(
        title: 'Scanned Document',  
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Display scanned document
            Obx(() {
              return controller.scannedDocument.value.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          controller.scannedDocument.value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : const Text("No document found", style: TextStyle(fontSize: 16));
            }),

            const SizedBox(height: 20),

            // Language selection dropdown
            DropdownButton<String>(
              hint: const Text("Select Language"),
              value: null, // Default to no selection
              items: [
                DropdownMenuItem(value: "en", child: Text("English")),
                DropdownMenuItem(value: "es", child: Text("Spanish")),
                DropdownMenuItem(value: "fr", child: Text("French")),
                DropdownMenuItem(value: "de", child: Text("German")),
                DropdownMenuItem(value: "ur", child: Text("Urdu")),
              ],
              onChanged: (selectedLanguage) {
                if (selectedLanguage != null) {
                  controller.translateText(selectedLanguage);
                }
              },
            ),

            const SizedBox(height: 20),

            // Display translated text
            Obx(() {
              return Text(
                controller.translatedText.value.isNotEmpty
                    ? "Translated Text:\n${controller.translatedText.value}"
                    : "Translation will appear here",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              );
            }),

            const SizedBox(height: 20),

            // Save as PDF Button
            ElevatedButton(
              onPressed: controller.saveAsPDF,
              child: const Text("Save as PDF"),
            ),

            const SizedBox(height: 20),

            // Save as DOCX Button
            ElevatedButton(
              onPressed: controller.saveAsDocx,
              child: const Text("Save as Word (DOCX)"),
            ),
          ],
        ),
      ),
    );
  }
}
