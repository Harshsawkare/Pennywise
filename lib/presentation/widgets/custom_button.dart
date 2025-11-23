import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Custom button widget matching the design specifications
/// Supports both primary (filled) and secondary (outlined) button styles
class CustomButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Whether this is a primary button (filled) or secondary (outlined)
  final bool isPrimary;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether button is disabled
  final bool isEnabled;

  /// Custom border color (optional, overrides default)
  final Color? borderColor;

  /// Custom text color (optional, overrides default)
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    this.isPrimary = true,
    this.onPressed,
    this.isEnabled = true,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppColors.blackColor
              : AppColors.whiteColor,
          foregroundColor: textColor ??
              (isPrimary
                  ? AppColors.whiteColor
                  : AppColors.blackColor),
          side: isPrimary
              ? null
              : BorderSide(
                  color: borderColor ?? AppColors.blackColor,
                  width: 1.0,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          elevation: 0,
          disabledBackgroundColor: AppColors.lightGreyColor,
          disabledForegroundColor: AppColors.whiteColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

