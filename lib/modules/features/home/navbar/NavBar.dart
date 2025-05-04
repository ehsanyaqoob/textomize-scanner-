import 'package:flutter_svg/flutter_svg.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/core/storage_services.dart';
import 'package:textomize/modules/features/home/navbar/account_view.dart';
import 'package:textomize/modules/features/home/navbar/home_view.dart';
import 'package:textomize/modules/features/home/navbar/smart_ai/smart_ai.dart';
import 'package:textomize/widgets/home_appbar.dart';
import 'package:textomize/modules/features/home/navbar/mydoc/mydoc_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../../core/assets.dart';

class NavBarNavigation extends StatefulWidget {
  @override
  State<NavBarNavigation> createState() => _NavBarNavigationState();
}

class _NavBarNavigationState extends State<NavBarNavigation> {
  int _currentIndex = 0;
  DateTime? _lastPressedTime;

  final List<Widget> _pages = [
    HomeView(),
    MyDocView(),
    SmartAiView(),
    SettingsView(),
    // home
    // mydoc
    // smart ai
    //settings
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastPressedTime == null ||
            now.difference(_lastPressedTime!) > Duration(seconds: 2)) {
          _lastPressedTime = now;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Press back again to exit"),
            duration: Duration(seconds: 2),
          ));
          return false;
        }
        SystemNavigator.pop(); // Close the app
        return true;
      },
      child: Scaffold(
        extendBody: true,
        appBar: _currentIndex == 0
            ? AppBar(
                title: FutureBuilder<String?>(
                  future: Future.value(StorageService.getUserName()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
        body: SafeArea(child: _pages[_currentIndex]),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            SalomonBottomBarItem(
              icon: SvgPicture.asset(Assets.home,
                  height: 24,
                  color: _currentIndex == 0
                      ? AppColors.primaryColor
                      : Colors.grey),
              title: Text("Home"),
              selectedColor: AppColors.primaryColor,
            ),
            SalomonBottomBarItem(
              icon: SvgPicture.asset(Assets.ocr,
                  height: 24,
                  color: _currentIndex == 1
                      ? AppColors.primaryColor
                      : Colors.grey),
              title: Text("MyDoc"),
              selectedColor: AppColors.primaryColor,
            ),
            SalomonBottomBarItem(
              icon: SvgPicture.asset(Assets.network,
                  height: 24,
                  color: _currentIndex == 2
                      ? AppColors.primaryColor
                      : Colors.grey),
              title: Text("Smart Ai"),
              selectedColor: AppColors.primaryColor,
            ),
            SalomonBottomBarItem(
              icon: SvgPicture.asset(Assets.settings,
                  height: 24,
                  color: _currentIndex == 3
                      ? AppColors.primaryColor
                      : Colors.grey),
              title: Text("Settings"),
              selectedColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
