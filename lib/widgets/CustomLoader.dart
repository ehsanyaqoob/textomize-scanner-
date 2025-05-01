import 'package:textomize/core/exports.dart';

class CustomLoader extends StatelessWidget {

  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD8AF69)),
        ),
      ),
    );
  }
}