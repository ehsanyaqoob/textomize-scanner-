import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class OcrController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxString extractedText = ''.obs;
  final RxString error = ''.obs;

  final textRecognizer = GoogleMlKit.vision.textRecognizer();

  /// Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        extractedText.value = '';
        await processImage(File(pickedFile.path));
      }
    } catch (e) {
      error.value = 'Failed to pick image: $e';
    }
  }

  /// Process the picked image and extract text
  Future<void> processImage(File image) async {
    try {
      isLoading.value = true;
      error.value = '';

      final inputImage = InputImage.fromFile(image);
      final RecognizedText result = await textRecognizer.processImage(inputImage);
      extractedText.value = result.text;

      if (result.text.isEmpty) {
        error.value = 'No text found in image.';
      }
    } catch (e) {
      error.value = 'Failed to extract text: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() {
    selectedImage.value = null;
    extractedText.value = '';
    error.value = '';
  }

  @override
  void onClose() {
    textRecognizer.close();
    super.onClose();
  }
}
