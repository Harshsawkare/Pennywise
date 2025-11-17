import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// App theme configuration
/// Centralizes theme settings for consistent styling
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration matching the design specifications
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.whiteColor,
      colorScheme: const ColorScheme.light(
        primary: AppColors.blackColor,
        surface: AppColors.whiteColor,
        background: AppColors.whiteColor,
      ),
      textTheme: const TextTheme(
        // Headline style for titles
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.blackColor,
        ),
        // Body style for regular text
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.blackColor,
        ),
        // Body medium for secondary text
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.lightGreyColor,
        ),
      ),
    );
  }
}

