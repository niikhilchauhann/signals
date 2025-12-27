import '/core/export.dart';
import 'package:flutter/material.dart';

class CustomIconRow extends StatelessWidget {
  final String val;
  final String title;
  final String icon;
  const CustomIconRow({
    super.key,
    required this.val,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/icons/$icon.png', height: 34),
        8.widthBox,
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: '$val\n'),
              TextSpan(
                text: title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
