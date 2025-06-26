import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:textomize/core/exports.dart';
import 'core/storage_services.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
await StorageService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isFirstLaunch = await StorageService.getFirstLaunchStatus();
  if (isFirstLaunch) {
    runApp(const PermissionHandlerApp());
  } else {
    runApp(const AppView());
  }
}

/// A temporary widget that handles permission requests and launches the main app after.
class PermissionHandlerApp extends StatelessWidget {
  const PermissionHandlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: _handlePermissionsAndProceed(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox
                .shrink(); // No UI after permission flow, it jumps to AppView
          },
        ),
      ),
    );
  }

  /// Handles permission requests and launches the main app.
  Future<void> _handlePermissionsAndProceed() async {
    await requestAllPermissions(); // no need to pass context
    await StorageService.setFirstLaunchStatus(false);

    // Short delay before launching main app
    await Future.delayed(const Duration(milliseconds: 200));

    runApp(const AppView());
  }
}

/// Requests all necessary permissions using system dialogs only.
Future<void> requestAllPermissions() async {
  final List<Permission> permissions = [
    Permission.camera,
    Permission.microphone,
    Permission.storage,
    Permission.manageExternalStorage,
  ];

  // Add iOS-specific permission if applicable 
  if (Platform.isIOS) {
    permissions.add(Permission.photos);
  }

  for (var permission in permissions) {
    final status = await permission.status;
    if (!status.isGranted) {
      await permission.request(); // This shows the system permission dialog
    }
  }
}

 

