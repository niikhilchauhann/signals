import 'package:flutter/material.dart';

import '../export.dart';

class CustomBadge extends StatelessWidget {
  final String? text;
  const CustomBadge({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(text != null ? 5 : 4),
      decoration: BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
      child:
          text != null
              ? Text(
                text!,
                style: AppTextTheme.size10Normal.copyWith(
                  color: AppColors.white,
                ),
              )
              : SizedBox(),
    );
  }
}
