import 'package:textomize/core/exports.dart';
import '../App/app_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onLeadingPressed;
  final Color? backgroundColor;
  final double? elevation;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final bool? centerTitle;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool? automaticallyImplyLeading;
  final Widget? flexibleSpace;
  final double? titleSpacing;
  final double? toolbarHeight;
  final double? leadingWidth;
  final bool? excludeHeaderSemantics;
  final Brightness? brightness;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextTheme? textTheme;
  final bool? primary;

  CustomAppBar({
    Key? key,
    this.title,
    this.onLeadingPressed,
    this.backgroundColor,
    this.elevation,
    this.titleColor,
    this.titleStyle,
    this.centerTitle,
    this.actions,
    this.bottom,
    this.automaticallyImplyLeading,
    this.flexibleSpace,
    this.titleSpacing,
    this.toolbarHeight,
    this.leadingWidth,
    this.excludeHeaderSemantics,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: automaticallyImplyLeading ?? true
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.white,
              ),
              onPressed: onLeadingPressed ?? () => Navigator.pop(context),
            )
          : null,
       backgroundColor: backgroundColor ?? AppColors.primaryColor,
      elevation: elevation ?? 0.0,
      title: title != null
          ? CustomText(
             text:  title!,
             
                color: titleColor ?? AppColors.white,
                fontSize: 18.sp,
            
            )
          : null,
      centerTitle: centerTitle ?? true,
      actions: actions,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
      titleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      leadingWidth: leadingWidth,
      excludeHeaderSemantics: excludeHeaderSemantics ?? false,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary ?? true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight((toolbarHeight ?? kToolbarHeight) +
      (bottom?.preferredSize.height ?? 0.0));
}

// class ExamplePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Example Page', 
//         onLeadingPressed: () {
//           // Define your action when the leading icon is pressed
//           Navigator.pop(context);
//         },
//         backgroundColor: Colors.blue, // Custom background color
//         elevation: 4.0, // Custom elevation
//         titleColor: Colors.white, // Custom title color
//         titleStyle: TextStyle(
//           fontSize: 20, // Custom font size
//           fontWeight: FontWeight.w600, // Custom font weight
//         ),
//         centerTitle: true, // Center the title
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {
//               // Action for settings icon
//             },
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(50.0),
//           child: Container(
//             color: Colors.blueAccent,
//             height: 50.0,
//             child: Center(
//               child: Text('Bottom Widget'),
//             ),
//           ),
//         ),
//         flexibleSpace: Container(
//           color: Colors.blueGrey,
//         ),
//         titleSpacing: 20.0,
//         toolbarHeight: 80.0,
//         leadingWidth: 60.0,
//         excludeHeaderSemantics: false,
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//         actionsIconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//         textTheme: Theme.of(context).textTheme,
//         primary: true,
//       ),
//       body: Center(
//         child: Text('Hello, world!'),
//       ),
//     );
//   }
// }
