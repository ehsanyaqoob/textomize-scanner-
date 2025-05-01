import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/core/storage_services.dart';
import '../modules/splash/splash_view.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: AppColors.appPrimary,
          ),
          title: 'Textomize',
          initialBinding: BindingsBuilder(() {
            Get.put(StorageService());
          }),
          home: SplashView(),
        );
      },
    );
  }
}
