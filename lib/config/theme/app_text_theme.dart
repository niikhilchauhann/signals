import 'package:flutter/material.dart';
import '../../core/export.dart';

/// Centralized typography for the app.
/// All styles follow the Gilroy font + dating-app color palette.
abstract class AppTextTheme {
  // ─────────────────────────────────────────
  // Display / Headings
  // ─────────────────────────────────────────

  static const TextStyle size36Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle size32Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle size28Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle size24Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle size20Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle size20Normal = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle size18Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );


  // ─────────────────────────────────────────
  // Body Text
  // ─────────────────────────────────────────

  static const TextStyle size16Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle size16Normal = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle size14Normal = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle size14Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );


  // ─────────────────────────────────────────
  // Small Text
  // ─────────────────────────────────────────

  static const TextStyle size12Normal = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle size12Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle size10Normal = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );


  // ─────────────────────────────────────────
  // Accent Variants (Optional)
  // For purple-themed UI elements
  // ─────────────────────────────────────────

  static const TextStyle accent16Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryPurple,
  );

  static const TextStyle accent14Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryPurple,
  );

  static const TextStyle accent12Bold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryPurple,
  );
}
