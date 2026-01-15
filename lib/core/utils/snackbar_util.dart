import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Utility class for displaying snackbars throughout the application
/// Centralizes snackbar logic and styling for consistency
class SnackbarUtil {
  // Private constructor to prevent instantiation
  SnackbarUtil._();

  /// Shows a snackbar with consistent dark theme
  /// [context] - BuildContext to show the snackbar
  /// [message] - Message to display
  static void show(BuildContext? context, String message) {
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.blackColor),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.blackColor, width: 1,)
        ),
        backgroundColor: AppColors.whiteColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

