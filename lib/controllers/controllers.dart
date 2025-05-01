import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/home/tools/obe_sheet.dart';
import 'dart:async';
import '../modules/features/home/tools/all_tools.dart';
import '../modules/features/home/tools/compress_pdf.dart';
import '../modules/features/home/tools/translaet_view.dart';
import '../modules/features/home/tools/merge_pdf.dart';
import '../modules/features/home/tools/protect_pdf.dart';
import '../modules/features/home/tools/scan_doc_view.dart';
import '../modules/features/home/tools/extract_view.dart';



class EditProfileDataController extends GetxController {
  // Observable fields for reactive updates
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var profileImage = Rxn<File>();

  // Validation error messages
  var nameError = RxnString();
  var emailError = RxnString();
  var phoneError = RxnString();

  // Update methods
  void updateName(String newName) {
    name.value = newName;
    nameError.value = null;
  }

  void updateEmail(String newEmail) {
    email.value = newEmail;
    emailError.value = null;
  }

  void updatePhone(String newPhone) {
    phone.value = newPhone;
    phoneError.value = null;
  }

  // Pick image
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // Delete image
  void deleteImage() {
    profileImage.value = null;
  }

  // Save user data with validation
  void saveChanges() {
    bool isValid = _validateInputs();

    if (!isValid) {
      Get.snackbar(
        'Validation Error',
        'Please fix the highlighted fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Simulate saving
    print("Saved Name: ${name.value}");
    print("Saved Email: ${email.value}");
    print("Saved Phone: ${phone.value}");
    print("Profile Image: ${profileImage.value?.path ?? 'None'}");

    Get.snackbar(
      'Success',
      'Your profile has been updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Internal validation logic
  bool _validateInputs() {
    bool isValid = true;

    if (name.value.trim().isEmpty) {
      nameError.value = "Name is required";
      isValid = false;
    }

    if (!GetUtils.isEmail(email.value)) {
      emailError.value = "Invalid email address";
      isValid = false;
    }

    if (phone.value.length < 10) {
      phoneError.value = "Phone number is too short";
      isValid = false;
    }

    return isValid;
  }
}

class ProfileController extends GetxController {
  var name = ''.obs;
  var phone = ''.obs;
  var dob = ''.obs;
  var gender = ''.obs;
  var profileImage = ''.obs; // Added profile image

  void updateName(String value) => name.value = value;
  void updatePhone(String value) => phone.value = value;
  void updateDob(String value) => dob.value = value;
  void updateGender(String value) => gender.value = value;
  void updateProfileImage(String path) =>
      profileImage.value = path; // Update profile image

  bool isFormValid() {
    return name.isNotEmpty &&
        phone.isNotEmpty &&
        dob.isNotEmpty &&
        gender.isNotEmpty;
  }
}

final List<Map<String, dynamic>> tools = [
  {'label': 'Scan Doc', 'icon': Icons.document_scanner, 'view': ScanDocumentView()},
  {'label': 'OBE Sheet ', 'icon': Icons.document_scanner_outlined, 'view': OBESheetView()},
  {'label': 'Translate Text', 'icon': Icons.translate, 'view': TranslateTextView()},
  {'label': 'Extract Text', 'icon': Icons.splitscreen, 'view': ExtractTextView()},
  {'label': 'Merge PDF', 'icon': Icons.merge_type, 'view': MergePDFView()},
  {'label': 'Protect PDF', 'icon': Icons.lock, 'view': ProtectPDFView()},
  {'label': 'Compress PDF', 'icon': Icons.compress, 'view': CompressPDFView()},
  {'label': 'All Tools', 'icon': Icons.grid_view, 'view': AllToolsView()},
];

// Scan document
// Scan QR code
// Translate document
// Extract Text

/// Checkbox state variables
bool rememberMe = false;
bool isSigningUp = false;

// Observable variables
var isSignedIn = false.obs;
var isLoading = false.obs;
bool isChecked = false;

class ForgotPasswordController extends GetxController {
  // Text controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility toggles
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Toggle password visibility
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  @override
  void onClose() {
    // Dispose of controllers to prevent memory leaks
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    resetPasswordController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

bool isConfirmPasswordVisible = false;

final TextEditingController resetPasswordController = TextEditingController();
final TextEditingController newPasswordController = TextEditingController();
final TextEditingController confirmNewPasswordController =
    TextEditingController();
final TextEditingController passwordController = TextEditingController();

final TextEditingController searchController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController CnicController = TextEditingController();
final TextEditingController resetEmailController = TextEditingController();

final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

final List<Color> appColors = [
  Color(0xFFE57373),
  Color(0xFF81C784),
  Color(0xFF64B5F6),
  Color(0xFFFFD54F),
  Color(0xFFBA68C8),
  Color(0xFF4DB6AC),
  Color(0xFFFF8A65),
  Color(0xFFAED581),
];

final List<Map<String, String>> recentFiles = [
  {
    'title': 'Job Application Letter',
    'date': '12/30/2023 09:41',
  },
  {
    'title': 'Requirements Document',
    'date': '12/29/2023 10:20',
  },
  {
    'title': 'Recommendation Letter',
    'date': '12/28/2023 14:56',
  },
];

final List<String> designationType = [
  'Inspecter',
  'Sub Insp',
  'ASI',
];

final List<String> departmentType = [
  'Sindth Police',
  'Lahore Police',
  'Islamabad Police',
];

final List<String> PayScaleType = [
  'Inspecter',
  'Sub Insp',
  'ASI',
];
final List<String> registrationTypes = [
  'Self',
  'Family',
  'Shuhada',
];

final List<String> optionTypes = [
  'Plot',
  'Flat',
];
final List<String> plotTypes = ['500', '250', '150', 'Flat'];
final List<String> currentmailingTypes = ['Islamabad', 'lahore', 'karachi'];
final List<String> permanentmailingTypes = ['Islamabad', 'lahore', 'karachi'];

final List<String> nomineeTypes = [
  'Self',
  'Wife',
  'Son',
  'Daughter',
  'Husband',
];

final List<String> payScaleOptions = [
  '16',
  '18',
  '20',
  '21',
  '22',
];

class UploadController extends GetxController {
  var selectedFiles = <File>[].obs;
  var uploadProgress = 0.0.obs;
  var timeRemaining = "30 sec.".obs;
  var isUploading = false.obs;

  Timer? _timer;

  /// Pick multiple images from file picker
  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      selectedFiles.value = result.paths.map((e) => File(e!)).toList();
      startUploading();
    }
  }

  /// Pick a single image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedFiles.add(File(pickedFile.path));
      startUploading();
    }
  }

  /// Start the upload simulation
  void startUploading() {
    if (selectedFiles.isEmpty) return;

    int total = 30; // total simulated seconds
    int seconds = 0;

    _timer?.cancel(); // reset if already running

    uploadProgress.value = 0.0;
    timeRemaining.value = "$total sec.";
    isUploading.value = true;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isUploading.value || seconds >= total) {
        timer.cancel();
        uploadProgress.value = 1.0;
        timeRemaining.value = "Done";
        isUploading.value = false;
      } else {
        seconds++;
        uploadProgress.value = seconds / total;
        timeRemaining.value = "${total - seconds} sec.";
      }
    });
  }

  /// Pause the upload
  void pauseUpload() {
    _timer?.cancel();
    isUploading.value = false;
  }

  /// Resume the upload from the paused state
  void resumeUpload() {
    if (uploadProgress.value < 1.0 && !isUploading.value) {
      isUploading.value = true;
      startUploading();
    }
  }

  /// Cancel upload and reset everything
  void cancelUpload() {
    _timer?.cancel();
    isUploading.value = false;
    selectedFiles.clear();
    uploadProgress.value = 0.0;
    timeRemaining.value = "0 sec.";
  }
}

class HomeController extends GetxController {
  bool hasShownShimmer = false;
}
class CustomBottomSheet extends StatelessWidget {
  final Widget? header;
  final Widget? content;
  final Widget? footer;

  const CustomBottomSheet({
    Key? key,
    this.header,
    this.content,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header!,
          if (content != null) content!,
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class OtpTimerController extends GetxController {
  RxInt secondsRemaining = 60.obs; // Countdown from 60 seconds
  Timer? _timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
        // Perform action when timer expires (e.g., re-send OTP)
      }
    });
  }

  void resetTimer() {
    secondsRemaining.value = 60;
    _timer?.cancel();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class PakistaniPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-numeric characters
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Ensure the number does not exceed 11 digits
    if (newText.length > 11) {
      newText = newText.substring(0, 11);
    }

    // Format the phone number: 03##-#######
    if (newText.length >= 4) {
      newText = newText.substring(0, 4) + '-' + newText.substring(4);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class CNICInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-numeric characters
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Format the CNIC: #####-#######-#
    if (newText.length > 5) {
      newText = newText.substring(0, 5) + '-' + newText.substring(5);
    }
    if (newText.length > 13) {
      newText = newText.substring(0, 13) + '-' + newText.substring(13, 14);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
