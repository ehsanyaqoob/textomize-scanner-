import 'package:flutter_svg/flutter_svg.dart';
import 'package:textomize/core/assets.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/core/storage_services.dart';
import 'package:textomize/modules/features/home/navbar/account_view.dart';
import 'package:textomize/modules/features/home/navbar/home_view.dart';
import 'package:textomize/modules/features/home/navbar/mydoc/mydoc_view.dart';
import 'package:textomize/modules/features/home/navbar/smart_ai/smart_ai.dart';
import 'package:textomize/widgets/home_appbar.dart';

class NavBarController extends GetxController {
  final RxInt currentIndex = 0.obs;
  DateTime? lastPressedTime;

  final List<Widget> pages = [
    HomeView(),
    MyDocView(),
    SmartAiView(),
    SettingsView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<bool> onWillPop() async {
    final now = DateTime.now();
    if (lastPressedTime == null ||
        now.difference(lastPressedTime!) > const Duration(seconds: 2)) {
      lastPressedTime = now;
      Get.snackbar(
        'Exit App',
        'Press back again to exit',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return false;
    }
    return true;
  }
}

class NavBarNavigation extends StatefulWidget {
  NavBarNavigation({super.key}) {
    Get.put(NavBarController());
  }

  @override
  State<NavBarNavigation> createState() => _NavBarNavigationState();
}

class _NavBarNavigationState extends State<NavBarNavigation> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavBarController>();

    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Obx(() => Scaffold(
            extendBody: true,
            appBar: controller.currentIndex.value == 0
                ? AppBar(
                    title: FutureBuilder<String?>(
                      future: Future.value(StorageService.getUserName()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading...");
                        }
                        return HomeAppBar(userName: snapshot.data ?? 'Guest');
                      },
                    ),
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  )
                : null,
            body: SafeArea(
              bottom: false,
              child: controller.pages[controller.currentIndex.value],
            ),
            bottomNavigationBar: _BottomNavBar(),
          )),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final List<NavItem> navItems = [
    NavItem(icon: Assets.home, label: "Home"),
    NavItem(icon: Assets.ocr, label: "MyDoc"),
    NavItem(icon: Assets.network, label: "Smart Ai"),
    NavItem(icon: Assets.settings, label: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavBarController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = controller.currentIndex.value == index;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.changePage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: isSelected
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        )
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        item.icon,
                        height: isSelected ? 26.0.h : 22.0.h, // Active icon is larger
                        width: isSelected ? 26.0.w : 22.0.w, // Maintain aspect ratio
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Text(
                          item.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}

class NavItem {
  final String icon;
  final String label;

  NavItem({required this.icon, required this.label});
}