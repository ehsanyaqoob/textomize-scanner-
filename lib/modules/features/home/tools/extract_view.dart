import 'package:textomize/core/exports.dart';

class ExtractTextView extends StatefulWidget {
  const ExtractTextView({super.key});

  @override
  State<ExtractTextView> createState() => _ExtractTextViewState();
}

class _ExtractTextViewState extends State<ExtractTextView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ' Extract Text',
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: ' Extract Text from Image or PDF',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
              ),
              child: Center(
                child: Icon(
                  Icons.content_cut,
                  size: 80.0,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            CustomText(
              text: ' Extract text from an image or PDF document.',
              fontSize: 16.0,
                           color: AppColors.greyColor,
            ),
            SizedBox(height: 30.0),
            CustomButton(
              title: 'Upload PDF',
              onTap: () {
                // Add your logic here
              },
              fillColor: true,
            ),
            SizedBox(height: 25.0),
            CustomText(
              text: ' OR  ',
              fontSize: 14.0,
                           color: AppColors.greyColor,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pages,
                  size: 20.0,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 5.0),
                CustomText(
                  text: 'Select Page Ranges',
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
