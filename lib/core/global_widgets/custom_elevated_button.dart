import 'package:flutter/material.dart';
import '../export.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? btnColor;
  final Color? iconColor;
  final Color? txtColor;
  final String? text;
  final VoidCallback? ontap;
  final bool hasBorder;
  final bool hasGradient;
  final bool isLoading;
  final double radius;
  final double height;
  final double textSize;
  final IconData? icon;
  const CustomElevatedButton({
    super.key,
    this.btnColor,
    this.text,
    this.ontap,
    this.txtColor,
    this.iconColor,
    this.icon,
    this.hasBorder = false,
    this.hasGradient = false,
    this.isLoading = false,
    this.radius = 30,
    this.textSize = 14,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          height: height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color:
                hasBorder
                    ? Colors.transparent
                    : (btnColor ?? AppColors.primaryPurple),
            gradient:
                hasGradient
                    ? LinearGradient(
                      colors: [AppColors.hotPink, AppColors.primaryPurple],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                    : null,
            border:
                hasBorder
                    ? Border.all(
                      color: btnColor ?? AppColors.primaryPurple,
                      width: 2,
                    )
                    : null,
          ),
          child: Center(
            child:
                isLoading
                    ? SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.white,
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null)
                          Icon(
                            icon,
                            size: 20,
                            color: iconColor ?? AppColors.white,
                          ).pOnly(right: 4),
                        Text(
                          text ?? 'Continue',
                          style: AppTextTheme.size14Bold.copyWith(
                            fontSize: textSize,
                            color:
                                hasBorder
                                    ? (txtColor ??
                                        btnColor ??
                                        AppColors.hotPink)
                                    : txtColor ?? AppColors.white,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
