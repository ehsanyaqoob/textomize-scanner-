import 'package:textomize/core/exports.dart';
class OtpView extends StatefulWidget {
  // final String cnic;  // Get CNIC and Phone from the previous screen
  // final String phone;

  OtpView({
    // required this.cnic, required this.phone,
     Key? key}) : super(key: key);

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  final OtpTimerController otpTimerController = Get.put(OtpTimerController()); // Timer controller

  var isLoading = false.obs;  // To track loading state

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // // Function to handle OTP verification
  // Future<void> verifyOtp() async {
  //   isLoading.value = true;

  //   String otp = _controllers.map((controller) => controller.text).join('');  // Concatenate OTP fields

  //   if (otp.length == 6) {
  //     final Map<String, dynamic> requestBody = {
  //       "cnic": widget.cnic,
  //       "phone": widget.phone,
  //       "otp": otp,
  //     };

  //     try {
  //       final response = await http.post(
  //      //   Uri.parse(verifyOtpUrl),
  //       //  headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(requestBody),
  //       );

  //       if (response.statusCode == 200) {
  //         final Map<String, dynamic> responseData = jsonDecode(response.body);
  //         if (responseData['verified'] == true) {
  //          // Get.to(ResidenceView());  // Navigate to next screen if verified
  //         } else {
  //           Get.snackbar('Error', 'Invalid OTP');
  //         }
  //       } else {
  //         Get.snackbar('Error', 'OTP Verification Failed');
  //       }
  //     } catch (e) {
  //       Get.snackbar('Error', 'An error occurred: $e');
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   } else {
  //     Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
  //     isLoading.value = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        elevation: 0,
        onLeadingPressed: () {
          Get.back();
        },
        title: 'OTP',
        centerTitle: true,
      ),
      body: Obx(() {
        return isLoading.value
            ? Center(child: CircularProgressIndicator())  // Show loading indicator
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'OTP Code Verification 🔑',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 30),
                      CustomText(
                        text: 'Please enter the OTP code that has been sent to your phone or email.',
                        fontSize: 16,
                      ),
                      SizedBox(height: 20),
                      Obx(() {
                        return CustomText(
                          text: 'Resend OTP in: ${otpTimerController.secondsRemaining.value} seconds',
                          fontSize: 16,
                          color: AppColors.red,
                        );
                      }),
                      SizedBox(height: 20),
                      CustomText(text: 'OTP Fields', fontSize: 20),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return OTPInputField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            nextFocusNode: index < 5 ? _focusNodes[index + 1] : null,
                            previousFocusNode: index > 0 ? _focusNodes[index - 1] : null,
                            autoFocus: index == 0,
                          );
                        }),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: 'Verify OTP',
                              onTap: () {
                             //   verifyOtp();  // Call OTP verification function
                              },
                              topMargin: 30.0,
                              fillColor: true,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              title: 'Resend',
                              onTap: () {
                                otpTimerController.resetTimer();  // Logic to resend OTP
                              },
                              topMargin: 30.0,
                              fillColor: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

class OTPInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;

  OTPInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.previousFocusNode,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 60,
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.greyColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            focusNode.unfocus();
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          } else {
            if (previousFocusNode != null) {
              FocusScope.of(context).requestFocus(previousFocusNode);
            }
          }
        },
      ),
    );
  }
}