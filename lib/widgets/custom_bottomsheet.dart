import 'package:textomize/core/exports.dart';


class TextomizeBottomSheet extends StatelessWidget {
  final String title;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const TextomizeBottomSheet({
    Key? key,
    required this.title,
    required this.options,
    required this.onChanged,
    this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (context) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: AppColors.primaryColor,
                  ),
                  child: CustomText(
                    text: title,
                    textAlign: TextAlign.center,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                // Options
                ...options.map(
                  (option) => ListTile(
                    title: Text(option),
                    onTap: () => Navigator.pop(context, option),
                  ),
                ),
              ],
            ),
          ),
        );
        if (result != null) {
          onChanged(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValue ?? "Select $title",
              style: TextStyle(
                fontSize: 16,
                color: selectedValue == null
                    ? AppColors.greyColor
                    : AppColors.black,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.greyColor),
          ],
        ),
      ),
    );
  }
}
