import 'package:textomize/core/exports.dart';

class EditPDFView extends StatefulWidget {
  const EditPDFView({super.key});

  @override
  State<EditPDFView> createState() => _EditPDFViewState();
}

class _EditPDFViewState extends State<EditPDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit PDF',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Edit your PDF files with ease',
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
                  Icons.edit,
                  size: 60.0,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            CustomText(
              text: 'Upload your PDF to start editing.',
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
              text: 'Make changes such as text editing, adding annotations, and more.',
              fontSize: 14.0,
                           color: AppColors.greyColor,

            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.text_fields,
                  size: 20.0,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 5.0),
                CustomText(
                  text: 'Text Editing',
                  fontSize: 14.0,
                           color: AppColors.greyColor,
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insert_comment,
                  size: 20.0,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 5.0),
                CustomText(
                  text: 'Add Annotations',
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
