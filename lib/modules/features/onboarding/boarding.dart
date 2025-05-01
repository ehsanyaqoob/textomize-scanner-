import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:textomize/modules/features/onboarding/initialpage.dart';

import '../../../core/exports.dart';
class OnboardItem {
  final String image;
  final String title;
  final String subtitle;

  OnboardItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
class Boarding extends StatefulWidget {
  const Boarding({super.key});

  @override
  State<Boarding> createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  final PageController _controller = PageController();
  final List<OnboardItem> _pages = [
  OnboardItem(
    image: 'assets/png/women.jpg',
    title: 'Learn & Practice',
    subtitle:
        'Access a wide range of quizzes for public and private sector tests. Practice anytime, anywhere at your own pace.',
  ),
  OnboardItem(
    image: 'assets/png/kids.jpg',
    title: 'Job Prep Made Easy',
    subtitle:
        'Stay ahead with our up-to-date material designed for FPSC, PPSC, NTS, and other job-related exams.',
  ),
  OnboardItem(
    image: 'assets/png/painting.jpg',
    title: 'Mock Tests & Results',
    subtitle:
        'Take full-length mock tests and get instant results with detailed explanations to improve your performance.',
  ),
  OnboardItem(
    image: 'assets/png/grandpa.jpg',
    title: 'All Categories Covered',
    subtitle:
        'From general knowledge to subject-specific quizzes — we’ve got every topic covered under one roof.',
  ),
  OnboardItem(
    image: 'assets/png/painting.jpg',
    title: 'Your Progress, Tracked',
    subtitle:
        'Track your scores, revisit weak areas, and stay motivated with your personal learning dashboard.',
  ),
];


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime? lastPressed;
        if (lastPressed == null || DateTime.now().difference(lastPressed) > const Duration(seconds: 2)) {
          lastPressed = DateTime.now();
          Get.snackbar(
            'Exit',
            'Press back again to exit',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 20),
            snackStyle: SnackStyle.FLOATING,
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return OnboardPage(item: _pages[index]);
              },
            ),

            /// 🔹 Skip
            Positioned(
              top: 40,
              right: 24,
              child: GestureDetector(
                onTap: () {
                  _controller.jumpToPage(_pages.length - 1);
                },
                child: InkWell(
                  onTap: () {
                    Get.to(() => Initialpage());
                  },
                  child: CustomText(
                    text: "Skip",
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            /// 🔹 Page Indicator
            Positioned(
              bottom: 30,
              left: 24,
              child: SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.white30,
                  dotHeight: 10,
                  dotWidth: 18,
                  spacing: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final OnboardItem item;

  const OnboardPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        /// 🔹 Background Image
        Image.asset(
          item.image,
          fit: BoxFit.cover,
        ),

        /// 🔹 Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        /// 🔹 Text Content
        Positioned(
          bottom: 80,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
