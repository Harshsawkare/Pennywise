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

  /// Blue color for Food and Drinks category
  static const int blue = 0xFF2196F3;

  /// Orange color for Fun and Entertainment category
  static const int orange = 0xFFFF9800;

  /// Green color for Budget/Income category
  static const int green = 0xFF4CAF50;

  /// Medium grey color for backgrounds
  static const int mediumGrey = 0xFF9E9E9E;

  // Material Color objects for easy use with Flutter widgets
  static const blackColor = Color(black);
  static const whiteColor = Color(white);
  static const lightGreyColor = Color(lightGrey);
  static const tealColor = Color(teal);
  static const blueColor = Color(blue);
  static const orangeColor = Color(orange);
  static const greenColor = Color(green);
  static const mediumGreyColor = Color(mediumGrey);
}
