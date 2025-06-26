import 'package:get/get.dart';
import 'package:textomize/core/storage_services.dart';

class NewsFeedController extends GetxController {
  var userName = ''.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    userName.value = StorageService.getUserName() ?? '';
    userId.value = StorageService.getUserId() ?? '';
  }
}
