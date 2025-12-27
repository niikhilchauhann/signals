import 'package:flutter/material.dart';

import '../export.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? ontap;
  final String title;
  final double? textSize;
  final Color? textColor;
  final bool showUnderline;
  const CustomTextButton({
    super.key,
    required this.ontap,
    required this.title,
    this.textSize,
    this.textColor = AppColors.black,
    this.showUnderline = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(2),
      onTap: ontap,
      child: Text(
        title,
        style: AppTextTheme.size14Normal.copyWith(
          fontSize: textSize ?? 13,
          color: textColor,
          decoration:
              showUnderline ? TextDecoration.underline : TextDecoration.none,
          decorationColor: textColor,
        ),
      ).pAll(2),
    );
  }
}
