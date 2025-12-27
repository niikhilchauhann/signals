import 'package:flutter/material.dart';

import '../export.dart';

class CouponDetailText extends StatelessWidget {
  final String title;
  final String? val;
  final Color? color;

  const CouponDetailText({
    super.key,
    required this.title,
    this.val,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor:
              color ??
              (val == null ? AppColors.primaryPurple : AppColors.red),
          radius: 3,
        ),
        6.widthBox,
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: val,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: AppColors.darkGrey,
                ),
              ),
              TextSpan(
                text: title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
