import 'package:get/get.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/core/storage_services.dart';

class NewsFeedController extends GetxController {
  var userName = ''.obs;
  var userId = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      
      // Ensure StorageService is initialized
      await StorageService.ensureInitialized();

      // Get user data - using the new async methods
      final name = await StorageService.getUserName();
      final id = await StorageService.getUserId();

      // Update observables
      userName.value = name ?? 'Guest'; // Provide default if null
      userId.value = id ?? '';

      // For debugging
      await StorageService.printAllStoredData();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load user data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Example of how to use this in your view:
  // FutureBuilder(
  //   future: controller.loadUserData(),
  //   builder: (context, snapshot) {
  //     if (controller.isLoading.value) {
  //       return CircularProgressIndicator();
  //     }
  //     return Text('Welcome ${controller.userName.value}');
  //   },
  // )
}