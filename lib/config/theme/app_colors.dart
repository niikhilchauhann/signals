import 'package:flutter/material.dart';

abstract class AppColors {
  // ─────────────────────────────────────────
  // Primary Brand Colors
  // ─────────────────────────────────────────

  /// Primary Purple — main brand color
  static const Color primaryPurple = Color(0xFFA066FF);

  /// Secondary Violet — gradients, highlights
  static const Color secondaryViolet = Color(0xFF7B4DFF);


  // ─────────────────────────────────────────
  // Accent Colors
  // ─────────────────────────────────────────

  /// Hot Pink — likes, notifications, CTA accents
  static const Color hotPink = Color(0xFFFF4FCE);

  /// Warm Peach — soft gradients and portraits
  static const Color peachGlow = Color(0xFFFFBFAE);


  // ─────────────────────────────────────────
  // Backgrounds & Surfaces
  // ─────────────────────────────────────────

  /// Light lavender background used in cards/screens
  static const Color backgroundLight = Color(0xFFE7DAFF);

  /// Clean white surface
  static const Color white = Color(0xFFFFFFFF);

  /// Black for typography and icons
  static const Color black = Color(0xFF0F0F11);

  /// Neutral soft grey for borders and placeholder text
  static const Color grey = Color(0xFFB9B9C6);


  // ─────────────────────────────────────────
  // UI State Colors
  // ─────────────────────────────────────────

  /// Error or alert color
  static const Color red = Color(0xFFE8384D);
  static const Color redLight = Color(0xFFFF5064);


  /// Success or positive color
  static const Color green = Color(0xff05A06F);

  /// Yellow (optional badges / ratings)
  static const Color yellow = Color(0xFFFFB300);


  // Extra utility tones
  static const Color darkGrey = Color(0xFF4E5552);
  static const Color surface = Color(0xFF171717);


  // ─────────────────────────────────────────
  // Design System Surface Colors
  // ─────────────────────────────────────────

  /// Card border color — consistent across all screens
  static const Color cardBorder = Color(0xFFE3E7F3);

  /// Card fill — subtle light blue
  static const Color cardFill = Color(0xFFF3F6FF);

  /// Chip / pill background
  static const Color chipBackground = Color(0xFFEFF2FB);

  /// Background gradient start
  static const Color bgGradientStart = Color(0xFFF7F9FF);

  /// Background gradient end
  static const Color bgGradientEnd = Color(0xFFEFF2FF);
}
