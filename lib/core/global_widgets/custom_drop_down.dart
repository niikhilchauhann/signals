import 'package:flutter/material.dart';

import '../export.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.list,
    this.value,
    this.onChanged,
    this.validator,
    this.disableAllBorder = false,
    this.hint,
    this.contentPadding,
    this.labelText,
    this.isRequired = false,
    this.floatingLabel,
    this.fillColor,
    this.isSpaced = false,
    this.prefixIcon,
  });

  final List<String> list;
  final String? value;
  final String? labelText;
  final bool isRequired;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final bool disableAllBorder;
  final String? hint;
  final EdgeInsets? contentPadding;
  final String? floatingLabel;
  final Color? fillColor;
  final bool isSpaced;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (labelText != null)
        Text(labelText!, style: AppTextTheme.size14Normal).pOnly(bottom: 12),
      DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: Colors.white10,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
            // borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
            // borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
        hint:
            hint == null
                ? null
                : Text(hint ?? "", style: AppTextTheme.size14Normal),
        icon: const Icon(Icons.keyboard_arrow_down),
        items:
            list
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: AppTextTheme.size14Normal),
                  ),
                )
                .toList(),
        initialValue: value,
        style: AppTextTheme.size14Normal,

        onChanged: onChanged,
        iconDisabledColor: Colors.black,
      ).pOnly(bottom: isSpaced ? 14 : 0),
    ],
  );
}
