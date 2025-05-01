import 'package:textomize/core/exports.dart';
import 'package:textomize/modules/features/auth/signIn_view.dart';
class Initialpage extends StatefulWidget {
  const Initialpage({super.key});

  @override
  State<Initialpage> createState() => _InitialpageState();
}

class _InitialpageState extends State<Initialpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/png/grandpa.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Ensures the text and button are at the bottom
              children: [
                CustomText(
                  text:
                      'Learn, grow, and evolve — all in one place. From interactive quizzes to skill-building exams, enjoy a personalized learning journey designed for kids, adults, and everyone in between.',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  title: 'Get Started',
                  onTap: () {
                    Get.to(SignInView());
                  },
                ),
                //22537900070803
                //
                // const SizedBox(height: 20), 
                // CustomButton(
                //   title: 'Explore as Guest',
                //   onTap: () {
                //     Get.to(SparkNavBar());
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
