import 'dart:async';

import 'package:textomize/core/exports.dart';

class CustomSuccessLockDialog extends StatefulWidget {
  final String message;
  final VoidCallback onClose;

  const CustomSuccessLockDialog({
    Key? key,
    required this.message,
    required this.onClose,
  }) : super(key: key);

  @override
  _CustomSuccessLockDialogState createState() =>
      _CustomSuccessLockDialogState();
}

class _CustomSuccessLockDialogState extends State<CustomSuccessLockDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showProgressIndicator = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();

    // Timer to stop the CircularProgressIndicator after 3 seconds
    Timer(Duration(seconds: 3), () {
      setState(() {
        _showProgressIndicator = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
            bottomLeft: Radius.circular(160),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lock Icon
              ScaleTransition(
                scale: _animation,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock,
                    color: AppColors.primaryColor,
                    size: 80,
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Message Text
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              // Circular Loader
              if (_showProgressIndicator)
                CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 6,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
