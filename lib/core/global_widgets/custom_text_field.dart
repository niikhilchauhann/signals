import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../export.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool isPara;
  final int? maxChars;
  final TextInputType keyboardType;
  // final ValueChanged<String>? onSubmitted;
  final void Function(String)? onSubmit;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;

  final bool isSpaced;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool isEditable;
  final String? initialValue;
  final TextEditingController? controller;
  final FormFieldValidator<String>? customValidator;
  final bool? isPassword;
  final double? radius;
  final EdgeInsets? padding;
  final bool disableBorder;
  final Color fillColor;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.isPara = false,
    this.maxChars,
    this.keyboardType = TextInputType.text,
    // this.onSubmitted,
    this.onChanged,
    this.onTapOutside,
    this.onEditingComplete,
    this.prefixIcon,
    this.suffixIcon,
    this.customValidator,
    this.isPassword,
    this.initialValue,
    this.focusNode,
    this.nextFocus,
    this.isSpaced = false,
    this.onSubmit,
    this.isEditable = true,
    this.controller,
    this.radius,
    this.padding,
    this.disableBorder = false,
    this.inputFormatters,
    this.fillColor = Colors.white10,
  });

  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text(labelText!, style: AppTextTheme.size14Normal).pOnly(bottom: 12),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _isVisible,
              builder:
                  (context, obscureText, _) => TextFormField(
                    readOnly: !isEditable,
                    focusNode: focusNode,
                    inputFormatters: inputFormatters,
                    maxLength: maxChars,
                    validator: customValidator,
                    keyboardType: keyboardType,
                    controller: controller,
                    style: AppTextTheme.size14Normal,
                    onChanged: (value) {
                      onChanged?.call(value);
                    },
                    onTapOutside: onTapOutside,
                    onEditingComplete: onEditingComplete,
                    maxLines: (isPara ? 5 : 1),
                    obscureText: isPassword != null ? obscureText : false,
                    onFieldSubmitted: (v) {
                      nextFocus?.requestFocus();
                      if (onSubmit != null) {
                        onSubmit!(v);
                      }
                    },

                    // onFieldSubmitted: (v) {
                    //   nextFocus?.requestFocus();
                    //   onSubmit != null ? onSubmit!(v) : ();
                    // },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey, width: 2),
                        borderRadius: BorderRadius.circular(radius ?? 12),
                      ),
                      contentPadding:
                          padding ??
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      hintText: hintText,

                      hintStyle: AppTextTheme.size14Normal.copyWith(
                        color: AppColors.darkGrey.withValues(alpha: 0.7),
                      ),
                      prefixIcon: prefixIcon,
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      suffixIcon:
                          isPassword != null
                              ? IconButton(
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 18,
                                ),
                                onPressed:
                                    () => _isVisible.value = !obscureText,
                              )
                              : suffixIcon,
                      // border: OutlineInputBorder(
                      //   borderSide: BorderSide(color: AppColors.lightGreen),
                      //   borderRadius: BorderRadius.all(Radius.circular(12)),
                      //   // borderSide: BorderSide.none,
                      // ),
                      focusedBorder:
                          disableBorder
                              ? null
                              : OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primaryPurple,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                // borderSide: BorderSide.none,
                              ),
                      errorBorder:
                          disableBorder
                              ? null
                              : OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                // borderSide: BorderSide.none,
                              ),
                      // focusedErrorBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: AppColors.lightGreen),
                      //   borderRadius: BorderRadius.all(Radius.circular(12)),
                      //   // borderSide: BorderSide.none,
                      // ),
                      // disabledBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: AppColors.lightGreen),
                      //   borderRadius: BorderRadius.all(Radius.circular(12)),
                      //   // borderSide: BorderSide.none,
                      // ),
                    ),
                  ),
            ).pOnly(bottom: isSpaced ? 14 : 0),
          ],
        ),
      ],
    );
  }
}
