import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

abstract class AppTheme {
  // ------------------------------
  // Light Theme
  // ------------------------------
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryPurple,
      onPrimary: AppColors.white,
      secondary: AppColors.secondaryViolet,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.black,
      error: AppColors.red,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: 'Gilroy',

      // App bar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryPurple,
        contentTextStyle: TextStyle(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: AppColors.white,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondaryViolet,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.grey,
        showUnselectedLabels: true,
        elevation: 8,
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryPurple),
        ),
        hintStyle: TextStyle(color: AppColors.grey),
        labelStyle: TextStyle(color: AppColors.darkGrey),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        margin: const EdgeInsets.all(8),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.black,
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: AppColors.black,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.black, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.darkGrey, fontSize: 14),
        labelLarge: TextStyle(
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ------------------------------
  // Dark Theme
  // ------------------------------
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryPurple,
      onPrimary: AppColors.white,
      secondary: AppColors.secondaryViolet,
      onSecondary: AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.white,
      // surface: Color(0xFF0B0B0D),
      // onSurface: AppColors.white,
      error: AppColors.red,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: 'Gilroy',

      // App bar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.secondaryViolet,
        contentTextStyle: TextStyle(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: AppColors.white,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondaryViolet,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.grey,
        showUnselectedLabels: true,
        elevation: 8,
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF111114),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryPurple),
        ),
        hintStyle: TextStyle(color: AppColors.grey),
        labelStyle: TextStyle(color: AppColors.grey),
      ),

      // Card
      cardTheme: CardThemeData(
        color: Color(0xFF0E0E10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        margin: const EdgeInsets.all(8),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.white,
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.white, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.grey, fontSize: 14),
        labelLarge: TextStyle(
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
