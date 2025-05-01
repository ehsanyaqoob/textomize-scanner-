import '../../../../core/exports.dart';

class OBESheetView extends StatefulWidget {
  const OBESheetView({super.key});

  @override
  State<OBESheetView> createState() => _OBESheetViewState();
}

class _OBESheetViewState extends State<OBESheetView> {
  // Variables to hold user inputs
  int? quizzes;
  int? mids;
  int? finals;
  int? practicals;
  bool dataFilled = false;
  String? excelFileName;

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _OBEBottomSheet(
          onSubmit: (fileName, quiz, mid, finalExam, practical) {
            setState(() {
              excelFileName = fileName;
              quizzes = quiz;
              mids = mid;
              finals = finalExam;
              practicals = practical;
              dataFilled = true;
            });
          },
        );
      },
    );
  }

  void _goToNextPage() {
  if (dataFilled) {
    // You can pass the data to the next page using GetX
    // Example: Passing the data to another screen
    
    Get.to(
      NextPage(
        excelFileName: excelFileName,
        quizzes: quizzes,
        mids: mids,
        finals: finals,
        practicals: practicals,
      ),
    );
  } else {
    // If data is not filled, you can show a toast or an error message
    Fluttertoast.showToast(
      msg: "Please fill all required fields first.",
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'OBE Sheet',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomText(
                textAlign: TextAlign.center,
                text: 'Choose the OBE sheet you want to work on',
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              10.height,
              CustomButton(
                title: 'Create New OBE Sheet',
                fillColor: true,
                onTap: _openBottomSheet,
              ),
              10.height,
              CustomButton(
                title: 'Create Existing OBE Sheet',
                fillColor: true,
                onTap: () {
                  // Implement functionality to create an existing OBE sheet
                  Fluttertoast.showToast(
                    msg: "Feature not implemented yet.",
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT,
                  );

                },
              ),
              20.height,

              // Show details if filled
              if (dataFilled) ...[
                const Divider(),
                CustomText(
                  text: "Excel File: $excelFileName",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                8.height,
                CustomText(text: "Quizzes: $quizzes"),
                CustomText(text: "Mid Exams: $mids"),
                CustomText(text: "Final Exams: $finals"),
                CustomText(text: "Practicals: $practicals"),
                20.height,
                CustomButton(
                  title: "Generate",
                  fillColor: true,
                  onTap: _goToNextPage,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _OBEBottomSheet extends StatefulWidget {
  final Function(
          String fileName, int quizzes, int mids, int finals, int practicals)
      onSubmit;

  const _OBEBottomSheet({required this.onSubmit});

  @override
  State<_OBEBottomSheet> createState() => _OBEBottomSheetState();
}

class _OBEBottomSheetState extends State<_OBEBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String? fileName;
  final TextEditingController quizzesController = TextEditingController();
  final TextEditingController midsController = TextEditingController();
  final TextEditingController finalsController = TextEditingController();
  final TextEditingController practicalsController = TextEditingController();

  Future<void> _pickExcelFile() async {
    _showLoadingDialog(); // Show loader

    // Simulate delay for picking/uploading file
    await Future.delayed(const Duration(seconds: 2));

    // After picking
    Navigator.pop(context); // Close loader

    setState(() {
      fileName =
          "SampleExcel_${DateTime.now().millisecondsSinceEpoch}.xlsx"; // Example file
    });

    // Show success toast
    Fluttertoast.showToast(
      msg: "Excel uploaded successfully!",
      backgroundColor: Colors.green,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _showLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomLoader(),
            8.height,
            CustomText(
              text: "Uploading...",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate() && fileName != null) {
      widget.onSubmit(
        fileName!,
        int.parse(quizzesController.text),
        int.parse(midsController.text),
        int.parse(finalsController.text),
        int.parse(practicalsController.text),
      );
      Navigator.pop(context);
    } else if (fileName == null) {
      Fluttertoast.showToast(
        msg: "Please upload an Excel file first.",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Upload OBE Sheet",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                title: fileName == null ? "Upload Excel" : "Re-upload Excel",
                fillColor: true,
                onTap: _pickExcelFile,
              ),
              const SizedBox(height: 10),
              if (fileName != null)
                Center(
                  child: Text(
                    fileName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                "Enter Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hint: "Number of Quizzes",
                controller: quizzesController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hint: "Number of Mid Exams",
                controller: midsController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hint: "Number of Final Exams",
                controller: finalsController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hint: "Number of Practical Exams",
                controller: practicalsController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              CustomButton(
                title: "Submit",
                fillColor: true,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class NextPage extends StatelessWidget {
  final String? excelFileName;
  final int? quizzes;
  final int? mids;
  final int? finals;
  final int? practicals;

  const NextPage({
    super.key,
    this.excelFileName,
    this.quizzes,
    this.mids,
    this.finals,
    this.practicals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Excel File: $excelFileName'),
            Text('Quizzes: $quizzes'),
            Text('Mid Exams: $mids'),
            Text('Final Exams: $finals'),
            Text('Practicals: $practicals'),
          ],
        ),
      ),
    );
  }
}
