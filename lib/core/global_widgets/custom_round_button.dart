import 'package:flutter/material.dart';

import '../export.dart';

class CustomRoundButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? ontap;
  final double? rad;
  final double? iconSize;
  final Color? btnColor;
  final Color? iconColor;

  const CustomRoundButton({
    super.key,
    this.icon,
    this.ontap,
    this.rad,
    this.iconSize,
    this.btnColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: ontap,
      child: CircleAvatar(
        radius: rad ?? 16,
        backgroundColor: btnColor ?? Colors.grey.shade200,
        child: Icon(
          icon ?? Icons.notifications,
          color: iconColor ?? AppColors.black,
          size: iconSize ?? 20,
        ),
      ),
    );
  }
}
