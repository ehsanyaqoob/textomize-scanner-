import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:textomize/core/assets.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';

class Boarding extends StatefulWidget {
  const Boarding({Key? key}) : super(key: key);

  @override
  State<Boarding> createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            /// Scanner-themed Header
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                    onPressed: () => Get.to(() => SignInView()),
                  ),
                  SizedBox(
                    height: 40,
                    child: Image.asset(Assets.splashLogo),
                  ),
                ],
              ),
            ),

            /// PageView with Scanner Features
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => onLastPage = (index == 2));
                },
                children: [
                  _buildScannerPage(
                      image: 'assets/svg/page1.svg',
                      title: 'Scan Any Document',
                      subtitle:
                          'Capture receipts, notes, or documents with perfect clarity using our advanced scanner'),
                  _buildScannerPage(
                      image: 'assets/svg/page2.svg',
                      title: 'Smart Text Recognition',
                      subtitle:
                          'Extract text from images instantly with our powerful OCR technology'),
                  _buildScannerPage(
                      image: 'assets/svg/page3.svg',
                      title: 'Organize Digitally',
                      subtitle:
                          'Save, search and manage all your scanned documents in one secure place'),
                ],
              ),
            ),

            /// Scanner-style Page Indicator
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ScrollingDotsEffect(
                activeDotColor: AppColors.primaryColor,
                dotColor: Colors.grey.shade300,
                dotHeight: 8,
                dotWidth: 30,
                spacing: 10,
                activeDotScale: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            /// Scanner-themed Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button on first pages
                  if (!onLastPage)
                    TextButton(
                      onPressed: () => Get.to(() => SignInView()),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80), // Placeholder for alignment

                  // Main action button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (onLastPage) {
                        Get.to(() => SignInView());
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon:
                        Icon(onLastPage ? Icons.scanner : Icons.arrow_forward),
                    label: Text(onLastPage ? "Start Scanning" : '  Next   '),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Scanner Feature Page Builder
  Widget _buildScannerPage({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Scanner animation placeholder
          Container(
            height: 250,
            margin: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: SvgPicture.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),

          // Scanner feature title
          CustomText(
            text: title,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Feature description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
