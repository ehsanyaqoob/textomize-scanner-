import 'package:get_storage/get_storage.dart';
import 'package:textomize/core/exports.dart';

import 'core/storage_services.dart';

// void main() {
//   runApp(App());
// }

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init(); 
   await GetStorage.init(); // 👈 Required before using GetStorage
  runApp( App());
}
