
import 'package:textomize/core/exports.dart';
class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color checkColor;
  final double size;
  final BorderRadius? borderRadius;

  CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.lime,
    this.checkColor = Colors.white,
    this.size = 24.0,
    this.borderRadius,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : Colors.transparent,
          border: Border.all(
            color: widget.value ? widget.activeColor : Colors.grey,
            width: 2.0,
          ),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
        child: widget.value
            ? Icon(
                Icons.check,
                size: widget.size * 0.8,
                color: widget.checkColor,
              )
            : null,
      ),
    );
  }
}
