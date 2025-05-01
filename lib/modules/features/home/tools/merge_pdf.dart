import 'package:textomize/core/exports.dart';

class MergePDFView extends StatefulWidget {
  const MergePDFView({super.key});

  @override
  State<MergePDFView> createState() => _MergePDFViewState();
}

class _MergePDFViewState extends State<MergePDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Merge PDFs',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Merge multiple PDF files into one document',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 220.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Icon(
                  Icons.merge_type,
                  size: 60.0,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            CustomText(
              text: 'Upload your PDFs to merge them.',
              fontSize: 16.0,
                           color: AppColors.greyColor,
            ),
            SizedBox(height: 30.0),
            CustomButton(
              title: 'Upload PDFs',
              onTap: () {
                // Add your logic here
              },
              fillColor: true,
            ),
            SizedBox(height: 25.0),
            CustomText(
              text: 'You can rearrange pages and select order.',
              fontSize: 14.0,
                           color: AppColors.greyColor,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.reorder,
                  size: 20.0,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 5.0),
                CustomText(
                  text: 'Rearrange Pages',
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
