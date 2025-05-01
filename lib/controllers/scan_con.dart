// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:textomize/modules/features/home/navbar/obe/scan_results_view.dart';
// import 'package:translator/translator.dart';
// import '../core/exports.dart';
// import '../screens/scanned_doc_view.dart';
// class ScanDocumentController extends GetxController {
//   final ImagePicker _picker = ImagePicker();

//   Rx<File?> selectedImage = Rx<File?>(null);
//   RxBool isProcessing = false.obs;

//   Future<void> pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       selectedImage.value = File(pickedFile.path);
//     }
//   }

//   void clearImage() {
//     selectedImage.value = null;
//   }

//   void processImageAndNavigate() {
//     if (selectedImage.value != null) {
//       isProcessing.value = true;
//       // Simulate a delay or processing
//       Future.delayed(Duration(seconds: 2), () {
//         isProcessing.value = false;
//         // Get.toNamed('/scanResult', arguments: selectedImage.value);
//         Get.to(ScanResultView());
//       });
//     }
//   }
// }

// class TranslateTextController extends GetxController {
//   var scannedDocument = Rx<File?>(null);
//   var extractedText = ''.obs; // Store recognized text
//   var translatedText = ''.obs; // Store translated text
//   final TextRecognizer textRecognizer = TextRecognizer(); // Keep single instance

//   /// Open Camera to capture image
//   Future<void> openCamera() async => await _pickImage(ImageSource.camera);

//   /// Pick Image from Gallery
//   Future<void> pickGalleryImage() async => await _pickImage(ImageSource.gallery);

//   /// Pick an image and process text extraction
//   Future<void> _pickImage(ImageSource source) async {
//     final ImagePicker picker = ImagePicker();
//     Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

//     try {
//       final XFile? photo = await picker.pickImage(source: source);
//       if (photo != null) {
//         scannedDocument.value = File(photo.path);

//         // Extract text from image before navigating
//         await _extractTextFromImage(scannedDocument.value!);

//         // Navigate to ScannedDocumentView only if text extraction is successful
//         if (extractedText.value.isNotEmpty) {
//           Get.off(() => ScannedDocumentView());
//         } else {
//           Get.snackbar("Error", "No text found in the image!");
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to pick image: $e");
//     } finally {
//       Get.back(); // Remove loading indicator
//     }
//   }

//   /// Extract text from an image using Google ML Kit
//   Future<void> _extractTextFromImage(File imageFile) async {
//     try {
//       final inputImage = InputImage.fromFile(imageFile);
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

//       extractedText.value = recognizedText.text.trim(); // Trim extra spaces
//     } catch (e) {
//       Get.snackbar("Error", "Failed to extract text: $e");
//     }
//   }

//   /// Translate the extracted text
//   Future<void> translateText(String targetLanguage) async {
//     if (extractedText.value.isNotEmpty) {
//       try {
//         final translator = GoogleTranslator();
//         final translation = await translator.translate(extractedText.value, to: targetLanguage);
//         translatedText.value = translation.text;
//       } catch (e) {
//         Get.snackbar("Error", "Translation failed: $e");
//       }
//     } else {
//       Get.snackbar("Error", "No text available for translation.");
//     }
//   }

//   /// Clean up resources
//   @override
//   void onClose() {
//     textRecognizer.close();
//     super.onClose();
//   }
// }
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/screens/scanned_doc_view.dart';
import 'package:translator/translator.dart';
import 'package:docx_template/docx_template.dart';
import 'package:pdf/widgets.dart' as pw;

class ScanDocumentController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer textRecognizer = TextRecognizer();
  final translator = GoogleTranslator();

  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isProcessing = false.obs;
  RxBool isSaving = false.obs;
  RxString extractedText = ''.obs;
  RxString translatedText = ''.obs;
  RxString scannedDocument = ''.obs;
  final isEditing = false.obs;
  final textController = TextEditingController();

  void toggleEditMode() {
    if (isEditing.value) {
      // Save edited text
      scannedDocument.value = textController.text;
    } else {
      // Enter edit mode
      textController.text = scannedDocument.value;
    }
    isEditing.toggle();
  }

  void editDocument() {
    // Example: You can navigate to an editor page or open a dialog
    Get.defaultDialog(
      title: "Edit Document",
      content: TextField(
        controller: TextEditingController(text: scannedDocument.value),
        maxLines: 8,
        onChanged: (value) => scannedDocument.value = value,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () => Get.back(),
    );
  }

  void shareDocument() {
    // Example: Implement using `share_plus` package
    final text = scannedDocument.value;
    if (text.isNotEmpty) {
      Share.share(text); // import 'package:share_plus/share_plus.dart';
    }
  }

// Future<void> scanWithTesseract() async {
//   final picker = ImagePicker();
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedFile != null) {
//     final text = await TesseractOcr.extractText(pickedFile.path);
//     print("Extracted Text: $text");
//     // You can now show this on the next screen
//   } else {
//     print("No image selected.");
//   }
// }

//   /// Translate the extracted text
  Future<void> translateText(String targetLanguage) async {
    if (extractedText.value.isNotEmpty) {
      try {
        final translator = GoogleTranslator();
        final translation =
            await translator.translate(extractedText.value, to: targetLanguage);
        translatedText.value = translation.text;
      } catch (e) {
        Get.snackbar("Error", "Translation failed: $e");
      }
    } else {
      Get.snackbar("Error", "No text available for translation.");
    }
  }

  /// Pick Image from Camera or Gallery
  Future<void> pickImage(ImageSource source) async {
     // clearScannedData(); 
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        extractedText.value = '';
        translatedText.value = '';
        scannedDocument.value =
            ''; // Clear the scanned document when a new image is selected
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  /// Clear selected image and reset states  
  void clearImage() {
    selectedImage.value = null;
    extractedText.value = '';
    translatedText.value = '';
    scannedDocument.value = ''; // Clear scanned document when reset
  }

  /// Start processing image -> Extract text -> Navigate
  Future<void> processImageAndNavigate() async {
    if (selectedImage.value != null) {
      isProcessing.value = true;
      try {
        final inputImage = InputImage.fromFile(selectedImage.value!);
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);

        // Extract text from the recognized data
        extractedText.value = recognizedText.text.trim();

        if (extractedText.value.isNotEmpty) {
          scannedDocument.value =
              extractedText.value; // Set the scanned document here

          // Navigate only after text extraction is successful
          Get.to(() => ScannedDocumentView());
        } else {
          Get.snackbar("No Text Found", "Please try with a clearer image.");
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to extract text: $e");
      } finally {
        isProcessing.value = false;
      }
    } else {
      Get.snackbar("Error", "No image selected.");
    }
  }

  @override
  void onClose() {
    textRecognizer.close();
    super.onClose();
  }
  
  void clearScannedData() {
    scannedDocument.value = '';
    translatedText.value = '';
    textController.clear();
    isEditing.value = false;
  }

 
  /// Save the extracted text as PDF
  Future<void> saveAsPDF() async {
    isSaving.value = true;

    final status = await Permission.storage.request();
    if (!status.isGranted) {
      isSaving.value = false;
      Get.snackbar('Permission Denied', 'Storage permission is required');
      return;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Text(extractedText.value, style: pw.TextStyle(fontSize: 14)),
      ),
    );

    final dir = await getExternalStorageDirectory();
    final path =
        '${dir!.path}/scan_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    isSaving.value = false;
    Get.snackbar('Saved', 'PDF saved at $path');
  }

  /// Save the extracted text as DOCX
  Future<void> saveAsDocx() async {
    isSaving.value = true;

    final status = await Permission.storage.request();
    if (!status.isGranted) {
      isSaving.value = false;
      Get.snackbar('Permission Denied', 'Storage permission is required');
      return;
    }

    final sample = await rootBundle.load('assets/template.docx');
    final docx = await DocxTemplate.fromBytes(sample.buffer.asUint8List());

    Content c = Content();
    c.add(TextContent("body", extractedText.value));

    final generated = await docx.generate(c);
    final dir = await getExternalStorageDirectory();
    final path =
        '${dir!.path}/scan_${DateTime.now().millisecondsSinceEpoch}.docx';
    final file = File(path);
    await file.writeAsBytes(generated!);

    isSaving.value = false;
    Get.snackbar('Saved', 'Word file saved at $path');
  }
}
