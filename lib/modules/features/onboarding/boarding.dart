
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';


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
      title: 'Scan Anything, Anytime',
      subtitle:
          'Our advanced OCR technology lets you scan and extract text from documents, images, and more, instantly and accurately.',
    ),
    OnboardItem(
      image: 'assets/png/women.jpg',
      title: 'Your Documents, Digitized',
      subtitle:
          'Transform physical documents into editable, searchable digital files with just a snap of your camera.',
    ),
    OnboardItem(
      image: 'assets/png/women.jpg',
      title: 'Speed and Accuracy Combined',
      subtitle:
          'Our OCR technology processes text quickly and accurately, saving you time while ensuring precision.',
    ),
    OnboardItem(
      image: 'assets/png/women.jpg',
      title: 'Scan Multiple Languages',
      subtitle:
          'Whether it’s English, Spanish, Arabic, or more, our OCR system can recognize and process text in a variety of languages.',
    ),
    OnboardItem(
      image: 'assets/png/women.jpg',
      title: 'Intelligent Text Extraction',
      subtitle:
          'Automatically extract relevant information, like dates, addresses, and names, from your scanned documents.',
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
                    Get.to(() => SignInView());
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
