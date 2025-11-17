import 'package:flutter/material.dart';

/// App color constants following the design specifications
/// Centralizes all color definitions for maintainability
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  /// Primary black color for text and buttons
  static const int black = 0xFF000000;

  /// Primary white color for backgrounds
  static const int white = 0xFFFFFFFF;

  /// Light grey color for borders, placeholders, and separators
  static const int lightGrey = 0xFFE0E0E0;

  /// Teal color for accent dot (used in titles)
  static const int teal = 0xFF008080;

  // Material Color objects for easy use with Flutter widgets
  static const blackColor = Color(black);
  static const whiteColor = Color(white);
  static const lightGreyColor = Color(lightGrey);
  static const tealColor = Color(teal);
}
