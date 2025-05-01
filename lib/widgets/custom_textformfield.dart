import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textomize/core/exports.dart';
import '../App/app_fonts.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String title;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final bool? isObscure;
  final VoidCallback? onTap;
  final String? errorText;
  final bool? readOnly;
  final bool? autoFocus;
  final Widget? suffix;
  final double? topPadding;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode; 

  CustomTextFormField({
    Key? key,
    this.title = '',
    required this.hint,
    this.controller,
    this.inputType = TextInputType.text,
    this.inputFormatters,
    this.prefix,
    this.onChanged,
    this.isObscure,
    this.onTap,
    this.errorText,
    this.readOnly,
    this.autoFocus,
    this.suffix,
    this.topPadding,
    this.textAlign = TextAlign.left,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            CustomText(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          if (title.isNotEmpty) SizedBox(height: 4),
          TextFormField(
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            controller: controller,
            keyboardType: inputType ?? TextInputType.text,
            inputFormatters: inputFormatters ?? [],
            cursorColor: AppColors.black,
            autofocus: autoFocus ?? false,
            focusNode: focusNode, 
            textAlign: textAlign,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onFieldSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefix,
              suffixIcon: suffix,
              fillColor: AppColors.fieldColor,
              filled: true,
              errorText: errorText,
              hintStyle: TextStyle(
                color: AppColors.fieldFontColor,
                fontSize: 18,
                fontFamily: AppFonts.balsamiqSans,
                fontWeight: FontWeight.w400,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1.5, color: AppColors.deepPurple),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1.5, color: AppColors.appRed),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1.5, color: AppColors.appRed),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1.5, color: AppColors.white),
              ),
              isDense: true,
            ),
            readOnly: readOnly ?? false,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontFamily: AppFonts.balsamiqSans,
              fontWeight: FontWeight.w400,
            ),
            onChanged: onChanged,
            onTap: onTap,
            obscureText: isObscure ?? false,
          ),
        ],
      ),
    );
  }
}

class CustomField extends TextFormField {
  CustomField({
    Key? key,
    TextEditingController? controller,
    required String hint,
    TextInputType? inputType,
    List<TextInputFormatter>? inputFormatters,
    Widget? prefix,
    ValueChanged<String>? onChanged,
    bool? isObscure,
    VoidCallback? onTap,
    String? errorText,
    bool? readOnly,
    bool? autoFocus,
    Widget? suffix,
  })  : assert(controller != null, "Controller is required"),
        super(
          key: key,
          controller: controller!,
          keyboardType: inputType ?? TextInputType.text,
          inputFormatters: inputFormatters ?? [],
          cursorColor: AppColors.black,
          autofocus: autoFocus ?? false,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix,
            suffixIcon: suffix,
            fillColor: AppColors.fieldColor,
            filled: true,
            errorText: errorText,
            hintStyle: TextStyle(
              color: AppColors.fieldFontColor,
              fontSize: 18,
              fontFamily: AppFonts.balsamiqSans,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: AppColors.appRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: AppColors.appRed),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: AppColors.transparent),
            ),
            isDense: true,
          ),
          readOnly: readOnly ?? false,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontFamily: AppFonts.balsamiqSans,
            fontWeight: FontWeight.w600,
          ),
          obscureText: isObscure ?? false,
          onChanged: onChanged,
          onTap: onTap,
        );
}

class CustomText extends Text {
  CustomText({
    Key? key,
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    int? maxLines,
    TextDecoration? textDecoration,
    TextDecorationStyle? textDecorationStyle,
    Color? decorationColor,
  }) : super(
          text,
          key: key,
          textAlign: textAlign ?? TextAlign.left,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: color ?? AppColors.black,
            fontFamily: AppFonts.balsamiqSans,
            fontSize: fontSize ?? 9,
            fontWeight: fontWeight ?? FontWeight.normal,
            letterSpacing: letterSpacing,
            decoration: textDecoration,
            decorationStyle: textDecorationStyle,
            decorationColor: decorationColor,
          ),
        );

        
}


class TextFieldIcon extends StatelessWidget {
  String icon;
  Color color;
  TextFieldIcon({super.key, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      padding: EdgeInsets.all(12),
      child: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
