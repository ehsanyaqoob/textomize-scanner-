import 'package:textomize/core/exports.dart';

import 'core/storage_services.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init(); 
  runApp( AppView());
}
