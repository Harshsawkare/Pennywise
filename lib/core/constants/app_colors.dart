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

  /// Red color for delete actions
  static const int red = 0xFFE53935;

  /// Light green color for income card background
  static const int lightGreen = 0xFFE8F5E9;

  /// Light red color for expense card background
  static const int lightRed = 0xFFFFEBEE;

  /// Purple gradient start color for total balance card
  static const int purpleStart = 0xFF9C27B0;

  /// Purple gradient end color for total balance card
  static const int purpleEnd = 0xFFE91E63;

  /// Yellow color for progress bars
  static const int yellow = 0xFFFFEB3B;

  /// Light teal color for progress bars
  static const int lightTeal = 0xFFB2DFDB;

  /// Light green for progress bars
  static const int lightGreenProgress = 0xFFC8E6C9;

  // Material Color objects for easy use with Flutter widgets
  static const blackColor = Color(black);
  static const whiteColor = Color(white);
  static const lightGreyColor = Color(lightGrey);
  static const tealColor = Color(teal);
  static const blueColor = Color(blue);
  static const orangeColor = Color(orange);
  static const greenColor = Color(green);
  static const mediumGreyColor = Color(mediumGrey);
  static const redColor = Color(red);
  static const lightGreenColor = Color(lightGreen);
  static const lightRedColor = Color(lightRed);
  static const tealStartColor = tealColor;
  static const tealEndColor = Color(lightTeal);
  static const yellowColor = Color(yellow);
  static const lightTealColor = Color(lightTeal);
  static const lightGreenProgressColor = Color(lightGreenProgress);
}
