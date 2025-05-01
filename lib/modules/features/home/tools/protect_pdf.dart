import 'package:textomize/core/exports.dart';

class ProtectPDFView extends StatefulWidget {
  const ProtectPDFView({super.key});

  @override
  State<ProtectPDFView> createState() => _ProtectPDFViewState();
}

class _ProtectPDFViewState extends State<ProtectPDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Protect PDF',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Secure Your PDF Files with a Password!',
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 8.0,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.lock_outline,
                  size: 70.0,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            CustomText(
              text: 'Upload your PDF and set a password to protect it.',
              fontSize: 16.0,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 40.0),
            CustomButton(
              title: 'Choose PDF to Protect',
              onTap: () {
                // Add your file pick and password protection logic here
              },
              fillColor: true,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 24.0,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8.0),
                CustomText(
                  text: 'Max file size: 10MB',
                  fontSize: 14.0,
                  color: AppColors.greyColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
